import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';
import 'package:sqlite3/sqlite3.dart';

/// Thrown when the database is encrypted at rest but the app cannot obtain a
/// key that opens it.
///
/// Callers must treat this as a hard stop: the database file must never be
/// opened as plaintext and must never be overwritten or deleted automatically.
class DatabaseKeyUnavailableException implements Exception {
  const DatabaseKeyUnavailableException(this.message, {this.cause});

  final String message;

  /// Underlying failure (keystore error, failed integrity check, …), if any.
  final Object? cause;

  @override
  String toString() =>
      cause == null ? 'DatabaseKeyUnavailableException: $message'
          : 'DatabaseKeyUnavailableException: $message ($cause)';
}

/// How the database should be opened.
enum DatabaseOpenMode { encrypted, plaintext }

/// Result of resolving the encryption key for the on-device database.
class DatabaseOpenPlan {
  const DatabaseOpenPlan.encrypted(String this.base64Key)
      : mode = DatabaseOpenMode.encrypted,
        warning = null;

  const DatabaseOpenPlan.plaintext(String this.warning)
      : mode = DatabaseOpenMode.plaintext,
        base64Key = null;

  final DatabaseOpenMode mode;

  /// Raw base64 key; non-null exactly when [mode] is encrypted.
  final String? base64Key;

  /// Why the database is being opened unencrypted. Non-null exactly when
  /// [mode] is plaintext; surfaced in the UI as a persistent warning.
  final String? warning;

  bool get isPlaintext => mode == DatabaseOpenMode.plaintext;
}

/// Signature for the plaintext → encrypted migration, injectable in tests.
typedef DatabaseMigration = Future<bool> Function({
  required File file,
  required String base64Key,
});

/// Signature for "does this key open this file", injectable in tests.
typedef DatabaseKeyVerifier = Future<bool> Function(
  File file,
  String base64Key,
);

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
    } on FileSystemException {
      // An unreadable file cannot be confirmed as plaintext.
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

  /// Decides how [file] must be opened, failing closed.
  ///
  /// Rules:
  /// * An existing encrypted file is only ever opened with a key that proves it
  ///   can open it. If the keystore is unavailable or the key does not open the
  ///   file, throws [DatabaseKeyUnavailableException] — the file is neither
  ///   opened unencrypted nor overwritten.
  /// * A plaintext file is encrypted in place. If that cannot be done, the app
  ///   refuses to open it unencrypted.
  /// * A new (or empty) file is created encrypted.
  /// * Plaintext is only allowed when key creation itself failed, and then a
  ///   warning string is returned so the UI can show a persistent banner.
  static Future<DatabaseOpenPlan> resolveOpenPlan({
    required File file,
    required SecureKeyValueStore store,
    DatabaseMigration? migrate,
    DatabaseKeyVerifier? verify,
  }) async {
    final migrateFn = migrate ?? migrateToEncrypted;
    final verifyFn = verify ?? opensWithKey;

    final hasContent = await file.exists() && await file.length() > 0;
    final plaintext = hasContent && isPlaintextFile(file);
    final encrypted = hasContent && !plaintext;

    String? key;
    Object? keyError;
    try {
      key = await getOrCreateKey(store);
    } on Object catch (error) {
      keyError = error;
    }

    if (encrypted) {
      if (key == null) {
        throw DatabaseKeyUnavailableException(
          'The database is encrypted but its key could not be read from the '
          'platform keystore. Refusing to open it as plaintext.',
          cause: keyError,
        );
      }
      if (!await verifyFn(file, key)) {
        throw const DatabaseKeyUnavailableException(
          'The database is encrypted but the stored key cannot open it '
          '(the keystore may have been reset). Refusing to open it as plaintext.',
        );
      }
      // It opens fine with this key, so a leftover plaintext copy from an old
      // migration must not remain next to it.
      await purgePlaintextBackup(file);
      return DatabaseOpenPlan.encrypted(key);
    }

    // File is plaintext or new.
    if (key == null) {
      return DatabaseOpenPlan.plaintext(
        'Database encryption is unavailable on this device, so the database is '
        'stored unencrypted. Keep backups safe. (${keyError ?? 'no key'})',
      );
    }

    if (plaintext) {
      final migrated = await migrateFn(file: file, base64Key: key);
      if (!migrated) {
        throw const DatabaseKeyUnavailableException(
          'The existing plaintext database could not be encrypted in place. '
          'Refusing to open it unencrypted.',
        );
      }
    }

    return DatabaseOpenPlan.encrypted(key);
  }

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
    } on SqliteException catch (error) {
      AppLogger.warn('Encrypting the database failed', error);
      source?.dispose();
      if (await encrypted.exists()) await encrypted.delete();
      return false;
    } on FileSystemException catch (error) {
      AppLogger.warn('Encrypting the database failed', error);
      source?.dispose();
      if (await encrypted.exists()) await encrypted.delete();
      return false;
    } finally {
      source?.dispose();
    }

    // Prove the new file is usable before replacing anything.
    if (!await opensWithKey(encrypted, base64Key)) {
      if (await encrypted.exists()) await encrypted.delete();
      return false;
    }

    try {
      if (await backup.exists()) await backup.delete();
      await file.copy(backup.path);
      await encrypted.copy(file.path);
      await encrypted.delete();
      return true;
    } on FileSystemException catch (error) {
      AppLogger.warn('Swapping in the encrypted database failed', error);
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

  /// True when [file] opens with [base64Key] and passes an integrity check.
  static Future<bool> opensWithKey(File file, String base64Key) async {
    Database? db;
    try {
      db = sqlite3.open(file.path);
      db.execute(pragmaForKey(base64Key));
      final check = db.select('PRAGMA integrity_check');
      return check.isNotEmpty && check.first.values.first?.toString() == 'ok';
    } on SqliteException {
      // A wrong key or non-database file is expected here.
      return false;
    } finally {
      db?.dispose();
    }
  }
}
