import 'dart:io';

import 'package:vittix_wallet/core/database/app_database.dart';
import 'package:vittix_wallet/core/services/backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Restores a backup without needing an open [AppDatabase].
///
/// This exists for startup recovery: when an encrypted database cannot be
/// unlocked, the app cannot use [BackupService.restore] (it holds a live
/// database). The flow here is deliberately conservative: materialize the
/// candidate beside the live file, validate it, keep the current database as a
/// `.bak`, and only then rename the candidate into place.
class DatabaseRecoveryService {
  const DatabaseRecoveryService._();

  static Future<File> liveDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, kDatabaseFileName));
  }

  /// Replaces the live database with [backupFile].
  ///
  /// [passphrase] is required when [backupFile] is an encrypted container.
  /// Throws [FormatException] when the candidate is not a usable database and
  /// [ArgumentError] when an encrypted container is supplied without a
  /// passphrase.
  static Future<void> restoreFromBackup({
    required File backupFile,
    String? passphrase,
    String? databaseKey,
    int currentSchemaVersion = kCurrentSchemaVersion,
  }) async {
    final live = await liveDatabaseFile();
    final directory = live.parent;

    final materialized = File(
      p.join(directory.path, '$kDatabaseFileName.recovery.tmp'),
    );
    final staged = File(
      p.join(directory.path, '$kDatabaseFileName.restore.tmp'),
    );

    File candidate = backupFile;
    try {
      if (BackupService.isEncryptedFile(backupFile)) {
        if (passphrase == null || passphrase.isEmpty) {
          throw ArgumentError(
            'This backup is encrypted; a passphrase is required to restore it.',
          );
        }
        await BackupService.decryptToFile(
          backupFile,
          passphrase,
          materialized.path,
        );
        candidate = materialized;
      }

      final firstCheck = await BackupService.validate(
        candidate,
        currentSchemaVersion: currentSchemaVersion,
        databaseKey: databaseKey,
      );
      if (!firstCheck.isValid) {
        throw FormatException(firstCheck.error ?? 'Invalid backup file.');
      }

      if (candidate.path != staged.path) {
        await candidate.copy(staged.path);
      }
      final stagedCheck = await BackupService.validate(
        staged,
        currentSchemaVersion: currentSchemaVersion,
        databaseKey: databaseKey,
      );
      if (!stagedCheck.isValid) {
        throw FormatException(stagedCheck.error ?? 'Invalid backup file.');
      }

      // The candidate is known-good now. Keep the current database as `.bak`
      // and swap atomically. Sidecars are only touched once the swap succeeds.
      if (await live.exists()) {
        final backupOfLive = File('${live.path}.bak');
        if (await backupOfLive.exists()) {
          await backupOfLive.delete();
        }
        await live.rename(backupOfLive.path);
      }
      await staged.rename(live.path);

      for (final suffix in const ['-wal', '-shm']) {
        final sidecar = File('${live.path}$suffix');
        if (await sidecar.exists()) {
          await sidecar.delete();
        }
      }
    } finally {
      if (await materialized.exists()) {
        await materialized.delete();
      }
      if (await staged.exists()) {
        await staged.delete();
      }
    }
  }
}
