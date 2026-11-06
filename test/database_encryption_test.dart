import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/core/database/database_encryption.dart';
import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// A3 — database key management and plaintext detection.
///
/// The encryption itself needs SQLCipher, which is only present on device, so
/// the re-encryption path is covered by `integration_test` instead.
class _ThrowingKeyStore implements SecureKeyValueStore {
  const _ThrowingKeyStore();

  @override
  Future<String?> read(String key) async =>
      throw StateError('keystore unavailable');

  @override
  Future<void> write(String key, String value) async {}

  @override
  Future<void> delete(String key) async {}
}

bool _looksPlaintext(List<int> bytes) {
  const magic = 'SQLite format 3';
  if (bytes.length < magic.length) return false;
  return String.fromCharCodes(bytes.take(magic.length)) == magic;
}

void main() {
  late Directory dir;
  late InMemorySecureKeyValueStore store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vittix_dbkey_test');
    store = InMemorySecureKeyValueStore();
  });

  tearDown(() async {
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  group('DatabaseEncryption key management', () {
    test('generates a 256-bit key once and reuses it', () async {
      final first = await DatabaseEncryption.getOrCreateKey(store);
      final second = await DatabaseEncryption.getOrCreateKey(store);

      expect(first, equals(second), reason: 'key must be stable across opens');
      expect(base64.decode(first).length, DatabaseEncryption.keyLength);
    });

    test('two fresh stores get different keys', () async {
      final a = await DatabaseEncryption.getOrCreateKey(InMemorySecureKeyValueStore());
      final b = await DatabaseEncryption.getOrCreateKey(InMemorySecureKeyValueStore());
      expect(a, isNot(equals(b)));
    });

    test('hex key form is 64 lowercase hex chars', () async {
      final key = await DatabaseEncryption.getOrCreateKey(store);
      final hex = DatabaseEncryption.hexKeyFromBase64(key);
      expect(hex.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(hex), isTrue);
    });

    test('pragma uses the raw hex key form', () async {
      final key = await DatabaseEncryption.getOrCreateKey(store);
      final pragma = DatabaseEncryption.pragmaForKey(key);
      expect(pragma, startsWith('PRAGMA key = "x\''));
      expect(pragma, endsWith('\'"'));
    });
  });

  group('DatabaseEncryption plaintext detection', () {
    test('a missing file is not plaintext', () {
      expect(DatabaseEncryption.isPlaintextFile(File(p.join(dir.path, 'none.db'))), isFalse);
    });

    test('a SQLite header is detected as plaintext', () async {
      final file = File(p.join(dir.path, 'plain.db'));
      await file.writeAsBytes([...utf8.encode('SQLite format 3'), 0, ...List.filled(64, 7)]);
      expect(DatabaseEncryption.isPlaintextFile(file), isTrue);
    });

    test('random (encrypted-looking) bytes are not plaintext', () async {
      final file = File(p.join(dir.path, 'enc.db'));
      await file.writeAsBytes(List<int>.generate(128, (i) => (i * 31) % 256));
      expect(DatabaseEncryption.isPlaintextFile(file), isFalse);
    });

    test('an empty file is not treated as plaintext', () async {
      final file = File(p.join(dir.path, 'empty.db'));
      await file.writeAsBytes(const []);
      expect(DatabaseEncryption.isPlaintextFile(file), isFalse);
    });
  });

  group('DatabaseEncryption.resolveOpenPlan fails closed', () {
    File writeEncryptedFile(String name) {
      final file = File(p.join(dir.path, name));
      file.writeAsBytesSync(List<int>.generate(128, (i) => (i * 37 + 11) % 256));
      return file;
    }

    File writePlaintextFile(String name) {
      final file = File(p.join(dir.path, name));
      file.writeAsBytesSync([
        ...utf8.encode('SQLite format 3'),
        0,
        ...List.filled(64, 7),
      ]);
      return file;
    }

    Future<bool> migrateTrue({
      required File file,
      required String base64Key,
    }) async =>
        true;

    Future<bool> migrateFalse({
      required File file,
      required String base64Key,
    }) async =>
        false;

    test('encrypted file + keystore unavailable throws and never overwrites',
        () async {
      final file = writeEncryptedFile('encrypted.db');
      final before = file.readAsBytesSync();

      await expectLater(
        DatabaseEncryption.resolveOpenPlan(
          file: file,
          store: const _ThrowingKeyStore(),
          verify: (file, key) async => true,
        ),
        throwsA(isA<DatabaseKeyUnavailableException>()),
      );

      expect(file.existsSync(), isTrue);
      expect(file.readAsBytesSync(), equals(before),
          reason: 'the encrypted database must not be touched');
    });

    test('encrypted file + key that cannot open it throws', () async {
      final file = writeEncryptedFile('encrypted.db');
      final before = file.readAsBytesSync();

      await expectLater(
        DatabaseEncryption.resolveOpenPlan(
          file: file,
          store: InMemorySecureKeyValueStore(),
          verify: (file, key) async => false,
        ),
        throwsA(isA<DatabaseKeyUnavailableException>()),
      );

      expect(file.readAsBytesSync(), equals(before));
    });

    test('encrypted file + verified key opens encrypted and purges plaintext bak',
        () async {
      final file = writeEncryptedFile('encrypted.db');
      final bak = File('${file.path}.premigration.bak')
        ..writeAsStringSync('stale plaintext copy');

      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: InMemorySecureKeyValueStore(),
        verify: (file, key) async => true,
      );

      expect(plan.mode, DatabaseOpenMode.encrypted);
      expect(plan.base64Key, isNotNull);
      expect(plan.warning, isNull);
      expect(bak.existsSync(), isFalse);
    });

    test('new file is created encrypted when a key is available', () async {
      final file = File(p.join(dir.path, 'new.db'));

      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: InMemorySecureKeyValueStore(),
        verify: (file, key) async => true,
      );

      expect(plan.mode, DatabaseOpenMode.encrypted);
      expect(plan.base64Key, isNotNull);
      expect(file.existsSync(), isFalse,
          reason: 'resolution must not create the file itself');
    });

    test('new file + key creation failure falls back to plaintext with warning',
        () async {
      final file = File(p.join(dir.path, 'new.db'));

      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: const _ThrowingKeyStore(),
      );

      expect(plan.mode, DatabaseOpenMode.plaintext);
      expect(plan.isPlaintext, isTrue);
      expect(plan.warning, isNotNull);
      expect(plan.base64Key, isNull);
    });

    test('plaintext file + key creation failure falls back to plaintext',
        () async {
      final file = writePlaintextFile('plain.db');

      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: const _ThrowingKeyStore(),
      );

      expect(plan.mode, DatabaseOpenMode.plaintext);
      expect(plan.warning, isNotNull);
      expect(_looksPlaintext(file.readAsBytesSync()), isTrue);
    });

    test('plaintext file + working key migrates to encrypted', () async {
      final file = writePlaintextFile('plain.db');
      var migrated = false;

      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: InMemorySecureKeyValueStore(),
        migrate: ({
          required File file,
          required String base64Key,
        }) async {
          migrated = true;
          return true;
        },
      );

      expect(migrated, isTrue);
      expect(plan.mode, DatabaseOpenMode.encrypted);
      expect(plan.base64Key, isNotNull);
    });

    test('plaintext file + failed migration refuses to open unencrypted',
        () async {
      final file = writePlaintextFile('plain.db');

      await expectLater(
        DatabaseEncryption.resolveOpenPlan(
          file: file,
          store: InMemorySecureKeyValueStore(),
          migrate: migrateFalse,
        ),
        throwsA(isA<DatabaseKeyUnavailableException>()),
      );
    });

    test('migration helper that succeeds is used for plaintext files', () async {
      final file = writePlaintextFile('plain.db');
      final plan = await DatabaseEncryption.resolveOpenPlan(
        file: file,
        store: InMemorySecureKeyValueStore(),
        migrate: migrateTrue,
        verify: (file, key) async => true,
      );
      expect(plan.mode, DatabaseOpenMode.encrypted);
    });
  });

  group('DatabaseEncryption plaintext backup cleanup', () {
    test('purge removes a leftover migration backup', () async {
      final dbFile = File(p.join(dir.path, 'db.sqlite'))..writeAsStringSync('x');
      final backup = File('${dbFile.path}.premigration.bak')
        ..writeAsStringSync('plaintext database copy');

      expect(await backup.exists(), isTrue);
      await DatabaseEncryption.purgePlaintextBackup(dbFile);
      expect(await backup.exists(), isFalse,
          reason: 'an unencrypted copy must not survive next to the database');
    });

    test('purge is a no-op when there is nothing to remove', () async {
      final dbFile = File(p.join(dir.path, 'db.sqlite'));
      await DatabaseEncryption.purgePlaintextBackup(dbFile);
      expect(await dbFile.exists(), isFalse);
    });
  });
}
