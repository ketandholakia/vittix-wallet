import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';
import 'package:sqlite3/sqlite3.dart';

/// Key management and plaintext → encrypted migration for the on-device
/// database (backlog item A3, option (a)).
///
/// A random 256-bit key is generated once and kept in the platform keystore
/// (the same place the PIN hash lives). The PIN remains a UI gate: it is *not*
/// used to derive this key, which is what lets a user reset their PIN without
/// losing data. The trade-off is that anyone who can read the keystore can read
/// the database — that is a deliberate v1 decision.
class DatabaseEncryption {
  static const keyEntryName = 'db_encryption_key';
  static const keyLength = 32;

  /// SQLite files start with this; SQLCipher files do not.
  static const sqliteMagic = 'SQLite format 3';

  /// True when [file] exists and still looks like an unencrypted SQLite file.
  static bool isPlaintextFile(File file) {
    if (!file.existsSync()) return false;
    RandomAccessFile? raf;
    try {
      raf = file.openSync();
      final header = String.fromCharCodes(raf.readSync(16));
      return header.startsWith(sqliteMagic);
    } catch (_) {
      return false;
    } finally {
      raf?.closeSync();
    }
  }

  /// Returns the existing key, generating and storing one on first use.
  static Future<String> getOrCreateKey(SecureKeyValueStore store) async {
    final existing = await store.read(keyEntryName);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(keyLength, (_) => random.nextInt(256));
    final key = base64.encode(bytes);
    await store.write(keyEntryName, key);
    return key;
  }

  /// Raw hex form expected by `PRAGMA key = "x'…'"`.
  static String hexKeyFromBase64(String base64Key) {
    final bytes = base64.decode(base64Key);
    final buffer = StringBuffer();
    for (final b in bytes) {
      buffer.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  /// The pragma that unlocks the database.
  static String pragmaForKey(String base64Key) =>
      "PRAGMA key = \"x'${hexKeyFromBase64(base64Key)}'\"";

  /// Re-encrypts a plaintext database in place.
  ///
  /// Writes a side-by-side encrypted copy, proves it opens with [base64Key],
  /// keeps a `.premigration.bak` of the original, and only then swaps. Returns
  /// false (leaving the plaintext file untouched) when anything goes wrong, so
  /// a failure can never cost the user their data.
  static Future<bool> migrateToEncrypted({
    required File file,
    required String base64Key,
  }) async {
    if (!isPlaintextFile(file)) return false;

    final encryptedPath = '${file.path}.encrypted.tmp';
    final encrypted = File(encryptedPath);
    final backup = File('${file.path}.premigration.bak');

    Database? source;
    try {
      if (await encrypted.exists()) await encrypted.delete();

      source = sqlite3.open(file.path);
      final hex = hexKeyFromBase64(base64Key);
      source.execute("ATTACH DATABASE '$encryptedPath' AS encrypted KEY \"x'$hex'\"");
      source.select("SELECT sqlcipher_export('encrypted')");
      source.execute('DETACH DATABASE encrypted');
    } catch (_) {
      source?.dispose();
      if (await encrypted.exists()) await encrypted.delete();
      return false;
    } finally {
      source?.dispose();
    }

    // Prove the new file is usable before replacing anything.
    if (!await _opensWithKey(encrypted, base64Key)) {
      if (await encrypted.exists()) await encrypted.delete();
      return false;
    }

    try {
      if (await backup.exists()) await backup.delete();
      await file.copy(backup.path);
      await encrypted.copy(file.path);
      await encrypted.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Removes the plaintext `.premigration.bak` written by an earlier migration.
  ///
  /// The encrypted database has since been opened successfully, so leaving an
  /// unencrypted copy beside it would defeat at-rest encryption. Called on every
  /// ordinary open, so the plaintext window lasts at most until the next launch.
  static Future<void> purgePlaintextBackup(File file) async {
    final backup = File('${file.path}.premigration.bak');
    if (await backup.exists()) {
      await backup.delete();
    }
  }

  static Future<bool> _opensWithKey(File file, String base64Key) async {
    Database? db;
    try {
      db = sqlite3.open(file.path);
      db.execute(pragmaForKey(base64Key));
      final check = db.select('PRAGMA integrity_check');
      return check.isNotEmpty && check.first.values.first?.toString() == 'ok';
    } catch (_) {
      return false;
    } finally {
      db?.dispose();
    }
  }
}
