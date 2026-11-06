import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide
        Transaction,
        Category,
        Account,
        TransactionType,
        AccountType,
        isNull,
        isNotNull;
import 'package:expense_tracker/core/database/database_encryption.dart';
import 'package:expense_tracker/core/database/sqlcipher_loader.dart';
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

/// Verifies the real SQLCipher backup behaviour on a device/emulator.
///
/// SQLCipher's `VACUUM INTO` keeps the source database key, so the snapshot is
/// encrypted, not a plain "SQLite format 3" file. This test proves that on the
/// real native library (unit tests run against plain SQLite on the host) and
/// exercises key-aware validation plus an atomic restore.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    useSqlCipher();
  });

  late Directory tmp;
  late File dbFile;
  late String databaseKey;
  late AppDatabase db;

  setUp(() async {
    final docs = await getApplicationDocumentsDirectory();
    tmp = Directory(
      p.join(
        docs.path,
        'cipher_backup_${DateTime.now().microsecondsSinceEpoch}',
      ),
    )..createSync(recursive: true);
    dbFile = File(p.join(tmp.path, 'encrypted.sqlite'));

    final random = Random.secure();
    databaseKey =
        base64.encode(List<int>.generate(32, (_) => random.nextInt(256)));

    db = AppDatabase.forTesting(
      NativeDatabase(
        dbFile,
        setup: (raw) => raw.execute(DatabaseEncryption.pragmaForKey(databaseKey)),
      ),
    );
    await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Cipher Wallet')));
  });

  tearDown(() async {
    try {
      await db.close();
    } on Object {
      // Already closed by restore().
    }
    if (await tmp.exists()) {
      await tmp.delete(recursive: true);
    }
  });

  test('VACUUM INTO snapshot of an encrypted DB is encrypted, not plaintext',
      () async {
    final service = BackupService(db);
    final snapshot = await service.createSnapshot(p.join(tmp.path, 'snap.db'));

    final raf = snapshot.openSync();
    final header = raf.readSync(16);
    raf.closeSync();

    // (a) The first 16 bytes are NOT the SQLite magic: the snapshot keeps the
    // SQLCipher key and is therefore encrypted.
    expect(String.fromCharCodes(header), isNot(startsWith('SQLite format 3')));
    expect(DatabaseEncryption.isPlaintextFile(snapshot), isFalse);

    // Validation is key-aware.
    final withoutKey = await BackupService.validate(
      snapshot,
      currentSchemaVersion: db.schemaVersion,
    );
    expect(withoutKey.isValid, isFalse,
        reason: 'an encrypted snapshot must not validate as plaintext');

    final withKey = await BackupService.validate(
      snapshot,
      currentSchemaVersion: db.schemaVersion,
      databaseKey: databaseKey,
    );
    expect(withKey.isValid, isTrue, reason: withKey.error);

    // (b) restore() followed by reopening the database works.
    final liveFile = File(p.join(tmp.path, 'live.sqlite'));
    await service.restore(
      snapshot,
      liveDbFile: liveFile,
      databaseKey: databaseKey,
    );

    final reopened = AppDatabase.forTesting(
      NativeDatabase(
        liveFile,
        setup: (raw) => raw.execute(DatabaseEncryption.pragmaForKey(databaseKey)),
      ),
    );
    final wallets = await reopened.select(reopened.wallets).get();
    await reopened.close();

    expect(wallets.map((w) => w.name), contains('Cipher Wallet'));
    expect(await File('${liveFile.path}.bak').exists(), isTrue,
        reason: 'the previous database must be kept as .bak');
  });

  test('passphrase container validation is key-aware on a real SQLCipher DB',
      () async {
    final service = BackupService(db);
    final container = await service.createEncryptedSnapshot(
      p.join(tmp.path, 'backup.db.enc'),
      'smoke-passphrase',
    );

    expect(BackupService.isEncryptedFile(container), isTrue);

    final result = await BackupService.validate(
      container,
      currentSchemaVersion: db.schemaVersion,
      passphrase: 'smoke-passphrase',
      databaseKey: databaseKey,
    );
    expect(result.isValid, isTrue, reason: result.error);

    final wrongPass = await BackupService.validate(
      container,
      currentSchemaVersion: db.schemaVersion,
      passphrase: 'not-the-passphrase',
      databaseKey: databaseKey,
    );
    expect(wrongPass.isValid, isFalse);
  });
}
