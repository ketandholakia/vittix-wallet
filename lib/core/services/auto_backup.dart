import 'dart:io';

import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

/// User preferences for automatic backups.
class AutoBackupSettings {
  const AutoBackupSettings({
    this.enabled = false,
    this.intervalDays = 7,
    this.directoryPath,
    this.encrypt = false,
  });

  final bool enabled;

  /// How often a backup is written, in days.
  final int intervalDays;

  /// Folder the backups are written to. Null until the user picks one.
  final String? directoryPath;

  /// Whether backups are wrapped in the encrypted container.
  final bool encrypt;

  static const _enabledKey = 'auto_backup_enabled';
  static const _intervalKey = 'auto_backup_interval_days';
  static const _directoryKey = 'auto_backup_directory';
  static const _encryptKey = 'auto_backup_encrypt';

  static AutoBackupSettings load(SharedPreferences prefs) => AutoBackupSettings(
        enabled: prefs.getBool(_enabledKey) ?? false,
        intervalDays: prefs.getInt(_intervalKey) ?? 7,
        directoryPath: prefs.getString(_directoryKey),
        encrypt: prefs.getBool(_encryptKey) ?? false,
      );

  Future<void> save(SharedPreferences prefs) async {
    await prefs.setBool(_enabledKey, enabled);
    await prefs.setInt(_intervalKey, intervalDays);
    await prefs.setBool(_encryptKey, encrypt);
    final dir = directoryPath;
    if (dir == null || dir.isEmpty) {
      await prefs.remove(_directoryKey);
    } else {
      await prefs.setString(_directoryKey, dir);
    }
  }

  AutoBackupSettings copyWith({
    bool? enabled,
    int? intervalDays,
    String? directoryPath,
    bool? encrypt,
  }) {
    return AutoBackupSettings(
      enabled: enabled ?? this.enabled,
      intervalDays: intervalDays ?? this.intervalDays,
      directoryPath: directoryPath ?? this.directoryPath,
      encrypt: encrypt ?? this.encrypt,
    );
  }
}

/// Writes periodic backups into a user-chosen folder.
///
/// This runs when the app starts (there is no WorkManager dependency), which is
/// the pragmatic equivalent of a scheduled job: a backup is written at most
/// once per [AutoBackupSettings.intervalDays]. Older backups beyond
/// [keepCount] are pruned so the folder does not grow without bound.
class AutoBackupService {
  AutoBackupService(this._backupService, {FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _lastRunKey = 'auto_backup_last_run';
  static const _passphraseKey = 'auto_backup_passphrase';

  /// Number of backup files kept in the target folder.
  static const keepCount = 5;

  final BackupService _backupService;
  final FlutterSecureStorage _storage;

  static Future<void> setPassphrase(String passphrase) =>
      const FlutterSecureStorage().write(key: _passphraseKey, value: passphrase);

  Future<String?> readPassphrase() => _storage.read(key: _passphraseKey);

  /// Creates a backup when one is due. Returns the file written, or null when
  /// nothing was due / the configuration is incomplete.
  Future<File?> runIfDue({
    required AutoBackupSettings settings,
    required SharedPreferences prefs,
    DateTime? now,
  }) async {
    if (!settings.enabled) return null;
    final dirPath = settings.directoryPath;
    if (dirPath == null || dirPath.isEmpty) return null;

    final at = now ?? DateTime.now();
    final lastRun = prefs.getInt(_lastRunKey);
    if (lastRun != null) {
      final last = DateTime.fromMillisecondsSinceEpoch(lastRun);
      if (at.difference(last).inDays < settings.intervalDays) return null;
    }

    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final name = BackupService.timestampedBackupName(at);
    final File file;
    if (settings.encrypt) {
      final passphrase = await readPassphrase();
      if (passphrase == null || passphrase.isEmpty) return null;
      file = await _backupService.createEncryptedSnapshot(
        p.join(dir.path, '$name.enc'),
        passphrase,
      );
    } else {
      file = await _backupService.createSnapshot(p.join(dir.path, name));
    }

    await prefs.setInt(_lastRunKey, at.millisecondsSinceEpoch);
    await _prune(dir);
    return file;
  }

  /// Keeps only the [keepCount] most recent backups.
  Future<void> _prune(Directory dir) async {
    final backups = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path).startsWith('expense_backup_'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    while (backups.length > keepCount) {
      final oldest = backups.removeAt(0);
      try {
        await oldest.delete();
      } catch (_) {
        // Best effort: a locked file should not fail the whole run.
      }
    }
  }
}
