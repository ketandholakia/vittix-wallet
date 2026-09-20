import 'dart:io';

import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/services/auto_backup.dart';
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On-device smoke test for backup/restore (backlog item A1).
///
/// Runs on a real Android device/emulator so the platform pieces are exercised
/// for real: path_provider paths, the native sqlite3 library, SharedPreferences
/// and the keystore-backed secure storage used for the auto-backup passphrase.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late File dbFile;
  late AppDatabase db;

  setUp(() async {
    final docs = await getApplicationDocumentsDirectory();
    tmp = await Directory(p.join(docs.path, 'smoke_backup'))
      ..createSync(recursive: true);
    dbFile = File(p.join(tmp.path, 'smoke.sqlite'));
    db = AppDatabase.forTesting(NativeDatabase(dbFile));
    await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Smoke Wallet')));
  });

  tearDown(() async {
    try {
      await db.close();
    } catch (_) {
      // Already closed by the restore test.
    }
    if (await tmp.exists()) {
      await tmp.delete(recursive: true);
    }
  });

  test('encrypted backup round-trips on device', () async {
    final service = BackupService(db);
    final container = await service.createEncryptedSnapshot(
      p.join(tmp.path, 'backup.db.enc'),
      'smoke-passphrase',
    );

    expect(await container.exists(), isTrue);
    expect(BackupService.isEncryptedFile(container), isTrue);
    expect(
      BackupService.isEncryptedFile(dbFile),
      isFalse,
      reason: 'a plain database must not read as a container',
    );

    // A wrong passphrase must fail closed (GCM tag mismatch).
    await expectLater(
      BackupService.decryptToFile(
        container,
        'not-the-passphrase',
        p.join(tmp.path, 'wrong.sqlite'),
      ),
      throwsFormatException,
    );

    // The right passphrase yields a database that still validates.
    final plain = await BackupService.decryptToFile(
      container,
      'smoke-passphrase',
      p.join(tmp.path, 'decrypted.sqlite'),
    );
    final result = BackupService.validate(
      plain,
      currentSchemaVersion: db.schemaVersion,
    );
    expect(result.isValid, isTrue, reason: result.error);
  });

  test('automatic backup is due-aware and prunes on device', () async {
    final auto = AutoBackupService(BackupService(db));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auto_backup_last_run');

    final settings = AutoBackupSettings(
      enabled: true,
      intervalDays: 7,
      directoryPath: tmp.path,
    );

    final first = await auto.runIfDue(settings: settings, prefs: prefs);
    expect(first, isNotNull, reason: 'first run should back up');
    expect(await first!.exists(), isTrue);

    // A second run straight away is not due.
    expect(await auto.runIfDue(settings: settings, prefs: prefs), isNull);

    // A disabled configuration never writes.
    expect(
      await auto.runIfDue(
        settings: settings.copyWith(enabled: false),
        prefs: prefs,
        now: DateTime.now().add(const Duration(days: 90)),
      ),
      isNull,
    );

    // Force several due runs; only keepCount files may remain.
    final base = DateTime.now();
    for (var i = 1; i <= 8; i++) {
      await prefs.setInt(
        'auto_backup_last_run',
        base.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      );
      await auto.runIfDue(
        settings: settings,
        prefs: prefs,
        now: base.add(Duration(seconds: i)),
      );
    }

    final backups = Directory(tmp.path)
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path).startsWith('expense_backup_'))
        .toList();
    expect(backups.length, lessThanOrEqualTo(AutoBackupService.keepCount));
  });

  test('restore swaps the database file on device', () async {
    // Snapshot the current data.
    final snapshot = await BackupService(db).createSnapshot(
      p.join(tmp.path, 'source_backup.db'),
    );

    // Seed a different database at the "live" path.
    final liveFile = File(p.join(tmp.path, 'live.sqlite'));
    final live = AppDatabase.forTesting(NativeDatabase(liveFile));
    await live
        .into(live.wallets)
        .insert(const WalletsCompanion(name: Value('Old Wallet')));

    await BackupService(live).restore(snapshot, liveDbFile: liveFile);

    final reopened = AppDatabase.forTesting(NativeDatabase(liveFile));
    final wallets = await reopened.select(reopened.wallets).get();
    await reopened.close();

    final names = wallets.map((w) => w.name).toList();
    expect(names, contains('Smoke Wallet'));
    expect(names, isNot(contains('Old Wallet')));
  });
}
