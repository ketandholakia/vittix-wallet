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
