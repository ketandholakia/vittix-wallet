import 'dart:io';

import 'package:expense_tracker/core/database/app_database.dart' hide Column;
import 'package:expense_tracker/core/database/database_encryption.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:expense_tracker/core/services/database_recovery_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shown at startup when the encrypted database cannot be unlocked.
///
/// Deliberately offers only non-destructive options: retry the same key, or
/// restore a backup. There is no "forget the database" button.
class DatabaseRecoveryScreen extends ConsumerStatefulWidget {
  const DatabaseRecoveryScreen({super.key, required this.error});

  final Object error;

  @override
  ConsumerState<DatabaseRecoveryScreen> createState() =>
      _DatabaseRecoveryScreenState();
}

class _DatabaseRecoveryScreenState
    extends ConsumerState<DatabaseRecoveryScreen> {
  bool _busy = false;
  String? _detail;

  String get _errorText {
    final error = widget.error;
    if (error is DatabaseKeyUnavailableException) return error.message;
    return error.toString();
  }

  Future<void> _retry() async {
    setState(() {
      _busy = true;
      _detail = null;
    });
    resetDatabaseOpenPlanCache();
    ref.invalidate(databaseOpenPlanProvider);
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _restoreFromBackup() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    final path = result?.files.single.path;
    if (path == null) return;

    final file = File(path);
    String? passphrase;
    if (BackupService.isEncryptedFile(file)) {
      passphrase = await _askPassphrase();
      if (passphrase == null) return;
    }

    setState(() {
      _busy = true;
      _detail = null;
    });

    try {
      await DatabaseRecoveryService.restoreFromBackup(
        backupFile: file,
        passphrase: passphrase,
      );
      resetDatabaseOpenPlanCache();
      ref.invalidate(databaseOpenPlanProvider);
    } on FormatException catch (error) {
      _detail = error.message;
    } on ArgumentError catch (error) {
      _detail = error.message?.toString() ?? 'Restore failed.';
    } on FileSystemException catch (error) {
      _detail = 'Restore failed: ${error.message}';
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<String?> _askPassphrase() async {
    final controller = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Backup passphrase'),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Passphrase',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Restore'),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: colors.error),
                  const SizedBox(height: 24),
                  Text(
                    'Your database is locked',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The encrypted database could not be unlocked. Your data has '
                    'not been opened, modified or deleted. Retry, or restore a '
                    'backup you trust.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _detail ?? _errorText,
                      style: TextStyle(color: colors.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _busy ? null : _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _restoreFromBackup,
                    icon: const Icon(Icons.restore),
                    label: const Text('Restore from backup'),
                  ),
                  if (_busy) ...[
                    const SizedBox(height: 24),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
