import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// Outcome of inspecting a candidate backup file.
class BackupValidationResult {
  const BackupValidationResult({
    required this.isValid,
    this.error,
    this.schemaVersion,
  });

  final bool isValid;

  /// Human-readable reason when [isValid] is false.
  final String? error;

  /// `PRAGMA user_version` of the candidate, when it could be read.
  final int? schemaVersion;
}

/// Backup and restore for the on-device SQLite database.
///
/// Backup uses `VACUUM INTO`, which produces a consistent single-file snapshot
/// while the database is open. Copying the live file (what this used to do) can
/// capture a torn WAL state and yields a corrupt or stale backup.
///
/// A snapshot can optionally be wrapped in a passphrase-encrypted container
/// (`createEncryptedSnapshot`): PBKDF2-HMAC-SHA256 derives a key from the
/// passphrase and AES-256-GCM encrypts the snapshot, so the file is useless
/// without the passphrase.
///
/// Restore is deliberately defensive: the candidate is validated first
/// (SQLite header, `integrity_check`, schema version) and only then swapped in.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  /// SQLite files start with this 16-byte string.
  static const _sqliteMagic = 'SQLite format 3';

  // ---------------------------------------------------------------- container
  /// Magic prefix of the encrypted container format.
  static final List<int> _containerMagic = ascii.encode('VITTIXENC1');
  static const int _containerVersion = 1;
  static const int _defaultIterations = 50000;
  static const int _saltLength = 16;
  static const int _nonceLength = 12;
  static const int _macLength = 16;
  static const int _headerLength =
      10 /*magic*/ + 1 /*version*/ + 4 /*iterations*/ + _saltLength + _nonceLength + _macLength;

  static final Cipher _cipher = AesGcm.with256bits();

  static Pbkdf2 _kdf(int iterations) => Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: 256,
      );

  // ------------------------------------------------------------------ backup
  /// Writes a consistent snapshot of the live database to [targetPath].
  Future<File> createSnapshot(String targetPath) async {
    final target = File(targetPath);
    if (await target.exists()) {
      await target.delete();
    }
    // VACUUM INTO takes a string literal, not a bound parameter.
    final escaped = targetPath.replaceAll("'", "''");
    await _db.customStatement("VACUUM INTO '$escaped'");
    return target;
  }

  /// Convenience wrapper: snapshot into [directory] using a timestamped name.
  Future<File> createTimestampedSnapshot(String directory, DateTime now) {
    return createSnapshot('$directory/${timestampedBackupName(now)}');
  }

  /// Snapshot encrypted with [passphrase].
  ///
  /// The plaintext snapshot is written to a temporary file, encrypted, and the
  /// temporary file is removed so only the encrypted container remains.
  Future<File> createEncryptedSnapshot(
    String targetPath,
    String passphrase,
  ) async {
    if (passphrase.isEmpty) {
      throw ArgumentError('Passphrase must not be empty');
    }
    final scratchPath = '$targetPath.plain.tmp';
    final plain = await createSnapshot(scratchPath);
    try {
      final clearBytes = await plain.readAsBytes();
      final container = await encryptBytes(clearBytes, passphrase);
      final target = File(targetPath);
      await target.writeAsBytes(container, flush: true);
      return target;
    } finally {
      if (await plain.exists()) {
        await plain.delete();
      }
    }
  }

  /// `expense_backup_<timestamp>.db`. Callers append `.enc` for encrypted ones.
  static String timestampedBackupName(DateTime now) {
    final stamp = '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    return 'expense_backup_$stamp.db';
  }

  // -------------------------------------------------------------- encryption
  /// Encrypts [clearBytes] into the container format.
  static Future<Uint8List> encryptBytes(
    List<int> clearBytes,
    String passphrase, {
    int iterations = _defaultIterations,
  }) async {
    final salt = _randomBytes(_saltLength);
    final nonce = _cipher.newNonce();
    final key = await _kdf(iterations).deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
    final box = await _cipher.encrypt(clearBytes, secretKey: key, nonce: nonce);

    final out = BytesBuilder();
    out.add(_containerMagic);
    out.addByte(_containerVersion);
    out.add(_uint32(iterations));
    out.add(salt);
    out.add(nonce);
    out.add(box.mac.bytes);
    out.add(box.cipherText);
    return out.toBytes();
  }

  /// Decrypts a container produced by [encryptBytes].
  ///
  /// Throws [FormatException] for a wrong passphrase, truncation or corruption.
  static Future<Uint8List> decryptBytes(
    List<int> container,
    String passphrase,
  ) async {
    if (container.length < _headerLength) {
      throw const FormatException('Backup file is truncated');
    }
    if (!_startsWith(container, _containerMagic)) {
      throw const FormatException('Not an encrypted Vittix backup');
    }

    var offset = _containerMagic.length;
    final version = container[offset];
    offset += 1;
    if (version != _containerVersion) {
      throw FormatException('Unsupported backup version $version');
    }
    final iterations = _readUint32(container, offset);
    offset += 4;
    final salt = container.sublist(offset, offset + _saltLength);
    offset += _saltLength;
    final nonce = container.sublist(offset, offset + _nonceLength);
    offset += _nonceLength;
    final mac = container.sublist(offset, offset + _macLength);
    offset += _macLength;
    final cipherText = container.sublist(offset);

    final key = await _kdf(iterations).deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
    final box = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));
    try {
      final clear = await _cipher.decrypt(box, secretKey: key);
      return Uint8List.fromList(clear);
    } on SecretBoxAuthenticationError {
      throw const FormatException('Wrong passphrase or corrupted backup');
    }
  }

  /// True when [file] looks like an encrypted Vittix backup container.
  static bool isEncryptedFile(File file) {
    if (!file.existsSync()) return false;
    RandomAccessFile? raf;
    try {
      raf = file.openSync();
      return _startsWith(
        raf.readSync(_containerMagic.length),
        _containerMagic,
      );
    } catch (_) {
      return false;
    } finally {
      raf?.closeSync();
    }
  }

  /// Decrypts [container] to [targetPath], returning the plaintext file.
  static Future<File> decryptToFile(
    File container,
    String passphrase,
    String targetPath,
  ) async {
    final bytes = await container.readAsBytes();
    final clear = await decryptBytes(bytes, passphrase);
    final out = File(targetPath);
    await out.writeAsBytes(clear, flush: true);
    return out;
  }

  // -------------------------------------------------------------- validation
  /// Inspects [file] without modifying it.
  ///
  /// [currentSchemaVersion] is the schema version this build understands; a
  /// backup written by a newer build is rejected rather than half-read.
  static BackupValidationResult validate(
    File file, {
    required int currentSchemaVersion,
  }) {
    if (!file.existsSync()) {
      return const BackupValidationResult(
        isValid: false,
        error: 'File not found',
      );
    }

    final header = _readHeader(file);
    if (header == null || !header.startsWith(_sqliteMagic)) {
      return const BackupValidationResult(
        isValid: false,
        error: 'Not a SQLite database file',
      );
    }

    Database? db;
    try {
      db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final integrity = db.select('PRAGMA integrity_check');
      final verdict =
          integrity.isEmpty ? null : integrity.first.values.first?.toString();
      if (verdict != 'ok') {
        return BackupValidationResult(
          isValid: false,
          error: 'Integrity check failed: ${verdict ?? 'no result'}',
        );
      }

      final versionRows = db.select('PRAGMA user_version');
      final version = versionRows.isEmpty
          ? 0
          : (versionRows.first.values.first as int? ?? 0);

      if (version > currentSchemaVersion) {
        return BackupValidationResult(
          isValid: false,
          error: 'Backup is from a newer app version (schema $version > '
              '$currentSchemaVersion)',
          schemaVersion: version,
        );
      }

      return BackupValidationResult(isValid: true, schemaVersion: version);
    } catch (e) {
      return BackupValidationResult(isValid: false, error: e.toString());
    } finally {
      db?.dispose();
    }
  }

  // ----------------------------------------------------------------- restore
  /// Replaces the live database with [backupFile].
  ///
  /// The database is closed first (required to release the file handle), stale
  /// WAL/SHM sidecars are removed, and only then is the file swapped in.
  Future<void> restore(
    File backupFile, {
    required File liveDbFile,
  }) async {
    if (backupFile.path == liveDbFile.path) {
      throw ArgumentError('Backup file and live database are the same file.');
    }

    await _db.close();

    for (final suffix in const ['-wal', '-shm']) {
      final sidecar = File('${liveDbFile.path}$suffix');
      if (await sidecar.exists()) {
        await sidecar.delete();
      }
    }

    await backupFile.copy(liveDbFile.path);
  }

  // ------------------------------------------------------------------ helpers
  static List<int> _randomBytes(int count) {
    final random = Random.secure();
    return List<int>.generate(count, (_) => random.nextInt(256));
  }

  static List<int> _uint32(int value) => <int>[
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      ];

  static int _readUint32(List<int> bytes, int offset) =>
      (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];

  static bool _startsWith(List<int> bytes, List<int> prefix) {
    if (bytes.length < prefix.length) return false;
    for (var i = 0; i < prefix.length; i++) {
      if (bytes[i] != prefix[i]) return false;
    }
    return true;
  }

  static String? _readHeader(File file) {
    RandomAccessFile? raf;
    try {
      raf = file.openSync();
      return String.fromCharCodes(raf.readSync(16));
    } catch (_) {
      return null;
    } finally {
      raf?.closeSync();
    }
  }
}
