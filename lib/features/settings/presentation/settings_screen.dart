import 'dart:io';

import 'package:expense_tracker/features/accounts/presentation/account_screen.dart';
import 'package:expense_tracker/features/categories/presentation/category_screen.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:expense_tracker/features/settings/presentation/auto_backup_screen.dart';
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/utils/csv_exporter.dart';
import 'package:expense_tracker/features/security/presentation/lock_screen.dart';
import 'package:expense_tracker/features/recurring/presentation/recurring_transactions_screen.dart';
import 'package:expense_tracker/sms/sms_import_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:expense_tracker/features/sync/data/sync_service.dart';

/// Cloud sync is not release-ready yet: deleted records never propagate,
/// Nextcloud mode only performs GETs, and wallets are matched by local row ids.
/// The Settings UI is therefore hidden (backlog item A8). Flip to `true` to
/// re-enable the section for development, or delete it once sync is rebuilt.
const bool kCloudSyncEnabled = false;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _deviceSupportsBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricsSupport();
  }

  Future<void> _checkBiometricsSupport() async {
    final auth = LocalAuthentication();
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _deviceSupportsBiometrics = canCheck || isSupported;
        });
      }
    } catch (e) {
      debugPrint('Error checking biometrics support in settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isPinEnabled = ref.watch(pinLockEnabledProvider);
    final isBiometricsEnabled = ref.watch(biometricsEnabledProvider);

    final syncState = ref.watch(syncStateProvider);
    final lastSync = ref.watch(lastSyncTimeProvider);
    final isSimulated = ref.watch(isSimulatedSyncProvider);
    final syncUrl = ref.watch(syncUrlProvider);
    final syncUsername = ref.watch(nextcloudUsernameProvider);
    final syncPassword = ref.watch(nextcloudPasswordProvider);

    String syncStatusMessage;
    if (syncState.status == SyncStatus.syncing) {
      syncStatusMessage = 'Syncing...';
    } else if (lastSync == null) {
      syncStatusMessage = 'Never synchronized';
    } else {
      final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(lastSync.toLocal());
      syncStatusMessage = 'Last synced: $formatted';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Appearance', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          // Theme Settings
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              trailing: DropdownButton<ThemeMode>(
                value: ref.watch(themeModeProvider),
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).updateThemeMode(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text('General', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          // Currency Settings
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text('Currency'),
              trailing: DropdownButton<Currency>(
                value: ref.watch(currencyProvider),
                items: Currency.values.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(currencyProvider.notifier).updateCurrency(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Rollover Settings
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('Budget Rollover'),
              subtitle: const Text('Carry forward remaining amounts'),
              trailing: DropdownButton<RolloverMode>(
                value: ref.watch(rolloverModeProvider),
                items: const [
                  DropdownMenuItem(value: RolloverMode.disabled, child: Text('Disabled')),
                  DropdownMenuItem(value: RolloverMode.surplusOnly, child: Text('Surplus Only')),
                  DropdownMenuItem(value: RolloverMode.surplusAndDeficit, child: Text('Surplus & Deficit')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(rolloverModeProvider.notifier).updateRolloverMode(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Manage Accounts'),
              subtitle: const Text('Bank, credit card, loan, cash & income accounts'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (mounted) Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AccountScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('Manage Categories'),
              subtitle: const Text('Add, edit, or remove categories'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (mounted) Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.replay),
              title: const Text('Recurring Transactions'),
              subtitle: const Text('Manage templates for rent, subscriptions, salary, etc.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (mounted) Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RecurringTransactionsScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.sms_outlined),
              title: const Text('Import SMS'),
              subtitle: const Text('Scan inbox messages and review detected transactions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (mounted) Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('SMS Import')))),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          Text('Security', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline),
                  title: const Text('PIN Lock'),
                  subtitle: const Text('Require 4-digit PIN to open the app'),
                  value: isPinEnabled,
                  onChanged: (value) async {
                    if (value) {
                      final newPin = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => LockScreen(
                            mode: LockScreenMode.setup,
                            onCancel: () => Navigator.of(context).pop(),
                            onSuccess: (pin) => Navigator.of(context).pop(pin),
                          ),
                        ),
                      );
                      if (newPin != null && newPin.isNotEmpty) {
                        final hashed = hashPin(newPin);
                        // ref.read(pinHashProvider.notifier).updatePinHash(hashed);
                        ref.read(pinLockEnabledProvider.notifier).updatePinLockEnabled(true);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PIN Lock enabled successfully')),
                          );
                        }
                      }
                    } else {
                      final verifiedPin = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => LockScreen(
                            mode: LockScreenMode.verify,
                            onCancel: () => Navigator.of(context).pop(),
                            onSuccess: (pin) => Navigator.of(context).pop(pin),
                          ),
                        ),
                      );
                      if (verifiedPin != null) {
                        ref.read(pinLockEnabledProvider.notifier).updatePinLockEnabled(false);
                        // ref.read(pinHashProvider.notifier).updatePinHash(null);
                        ref.read(biometricsEnabledProvider.notifier).updateBiometricsEnabled(false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PIN Lock disabled')),
                          );
                        }
                      }
                    }
                  },
                ),
                if (isPinEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.pin),
                    title: const Text('Change PIN'),
                    subtitle: const Text('Update your 4-digit security PIN'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final verifiedPin = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => LockScreen(
                            mode: LockScreenMode.verify,
                            onCancel: () => Navigator.of(context).pop(),
                            onSuccess: (pin) => Navigator.of(context).pop(pin),
                          ),
                        ),
                      );
                      if (verifiedPin == null) return;

                      if (!mounted) return;
                      final newPin = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => LockScreen(
                            mode: LockScreenMode.setup,
                            onCancel: () => Navigator.of(context).pop(),
                            onSuccess: (pin) => Navigator.of(context).pop(pin),
                          ),
                        ),
                      );
                      if (newPin != null && newPin.isNotEmpty) {
                        final hashed = hashPin(newPin);
                        // ref.read(pinHashProvider.notifier).updatePinHash(hashed);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PIN changed successfully')),
                          );
                        }
                      }
                    },
                  ),
                  if (_deviceSupportsBiometrics) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: const Text('Biometric Unlock'),
                      subtitle: const Text('Unlock using fingerprint or face scan'),
                      value: isBiometricsEnabled,
                      onChanged: (value) {
                        ref.read(biometricsEnabledProvider.notifier).updateBiometricsEnabled(value);
                      },
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (kCloudSyncEnabled) ...[
            Text('Cloud Sync', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            _SettingsCard(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.cloud_sync_outlined),
                    title: const Text('Simulate Cloud Sync'),
                    subtitle: const Text('Test sync offline using local storage simulation'),
                    value: isSimulated,
                    onChanged: (value) {
                      ref.read(isSimulatedSyncProvider.notifier).updateIsSimulatedSync(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      initialValue: syncUrl,
                      enabled: !isSimulated,
                      decoration: const InputDecoration(
                        labelText: 'Nextcloud WebDAV URL',
                        hintText: 'https://[server]/remote.php/webdav/',
                        prefixIcon: Icon(Icons.link),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref.read(syncUrlProvider.notifier).updateSyncUrl(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      initialValue: syncUsername,
                      enabled: !isSimulated,
                      decoration: const InputDecoration(
                        labelText: 'Nextcloud Username',
                        hintText: 'e.g., john.doe',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref.read(nextcloudUsernameProvider.notifier).updateUsername(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      initialValue: syncPassword,
                      enabled: !isSimulated,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'App Password',
                        hintText: 'Generated in Nextcloud Settings > Security',
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref.read(nextcloudPasswordProvider.notifier).updatePassword(value);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Synchronize Now'),
                    subtitle: Text(syncStatusMessage),
                    trailing: syncState.status == SyncStatus.syncing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    onTap: syncState.status == SyncStatus.syncing
                        ? null
                        : () async {
                            final notifier = ref.read(syncStateProvider.notifier);
                            await notifier.performSync();
                            final freshState = ref.read(syncStateProvider);
                            if (!context.mounted) return;
                            if (freshState.status == SyncStatus.success) {
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sync completed successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (freshState.status == SyncStatus.error) {
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sync failed: ${freshState.errorMessage}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text('Backup & Restore', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Data'),
              subtitle: const Text('Save a backup of your database'),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final passController = TextEditingController();
                final passphrase = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Backup passphrase'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Optional. With a passphrase the backup is encrypted '
                          '(AES-256-GCM) and useless without it. Leave empty for '
                          'a plain database file.',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passController,
                          autofocus: true,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Passphrase (optional)',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(''),
                        child: const Text('No encryption'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(passController.text),
                        child: const Text('Create backup'),
                      ),
                    ],
                  ),
                );
                if (passphrase == null) return;

                try {
                  // VACUUM INTO gives a consistent snapshot while the DB is open.
                  final tempDir = await getTemporaryDirectory();
                  final name = BackupService.timestampedBackupName(DateTime.now());
                  final service = ref.read(backupServiceProvider);
                  final File snapshot;
                  if (passphrase.isEmpty) {
                    snapshot =
                        await service.createSnapshot(p.join(tempDir.path, name));
                  } else {
                    snapshot = await service.createEncryptedSnapshot(
                      p.join(tempDir.path, '$name.enc'),
                      passphrase,
                    );
                  }
                  await Share.shareXFiles(
                    [XFile(snapshot.path)],
                    text: passphrase.isEmpty
                        ? 'Vittix Wallet database backup'
                        : 'Vittix Wallet encrypted database backup',
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error saving backup: $e')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Automatic Backup'),
              subtitle: const Text('Scheduled snapshots with optional encryption'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AutoBackupScreen()),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.table_rows),
              title: const Text('Export to CSV'),
              subtitle: const Text('Save transaction history in spreadsheet format'),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  final transactions = await ref.read(transactionRepositoryProvider).watchAllTransactions().first;
                  if (transactions.isEmpty) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('No transactions to export.')),
                    );
                    return;
                  }

                  final categories = await ref.read(categoryRepositoryProvider).watchAllCategories().first;
                  final categoryMap = {for (var c in categories) c.id: c};

                  final currency = ref.read(currencyProvider);
                  final currencyCode = currency.name;

                  final csvString = generateCsv(
                    transactions: transactions,
                    categoryMap: categoryMap,
                    currencyCode: currencyCode,
                  );

                  final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
                  final fileName = 'expense_export_$timestamp.csv';
                  final tempDir = await getTemporaryDirectory();
                  final exportFile = File(p.join(tempDir.path, fileName));

                  await exportFile.writeAsString(csvString);
                  await Share.shareXFiles([XFile(exportFile.path)], text: 'Expense Tracker CSV Export');
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error exporting CSV: $e')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.download_for_offline, color: Theme.of(context).colorScheme.primary),
              title: Text('Import Data', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: const Text('Restore data from a backup file'),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                final result = await FilePicker.platform.pickFiles();
                if (result == null || result.files.single.path == null) return;

                final picked = File(result.files.single.path!);
                final liveDbFile = await ref.read(databaseFileProvider.future);

                Directory? scratch;
                try {
                  var candidate = picked;

                  // Encrypted backups are unreadable until decrypted.
                  if (BackupService.isEncryptedFile(picked)) {
                    final passController = TextEditingController();
                    final passphrase = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Encrypted backup'),
                        content: TextField(
                          controller: passController,
                          autofocus: true,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Passphrase'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(passController.text),
                            child: const Text('Decrypt'),
                          ),
                        ],
                      ),
                    );
                    if (passphrase == null || passphrase.isEmpty) return;

                    scratch = await Directory.systemTemp.createTemp('vittix_restore');
                    candidate = await BackupService.decryptToFile(
                      picked,
                      passphrase,
                      p.join(scratch.path, 'decrypted.sqlite'),
                    );
                  }

                  // Inspect the candidate (read-only) before asking the user to
                  // confirm: a junk file must never reach the swap step.
                  final validation = BackupService.validate(
                    candidate,
                    currentSchemaVersion:
                        ref.read(databaseProvider).schemaVersion,
                  );
                  if (!validation.isValid) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Not a usable backup: ${validation.error}'),
                      ),
                    );
                    return;
                  }

                  if (!context.mounted) return;
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Import Data?'),
                      content: const Text(
                        'This will overwrite all current data with the backup file. This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Import', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed != true) return;

                  await ref.read(backupServiceProvider).restore(
                        candidate,
                        liveDbFile: liveDbFile,
                      );

                  // Rebuild the database and every provider derived from it so
                  // the restored data shows up without restarting the app.
                  ref.invalidate(databaseProvider);

                  if (!context.mounted) return;
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Data restored from backup.')),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error importing data: $e')),
                  );
                } finally {
                  if (scratch != null && await scratch.exists()) {
                    await scratch.delete(recursive: true);
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          Text('Data Management', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          // Reset Data
          _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.delete_sweep, color: Theme.of(context).colorScheme.error),
              title: Text('Delete Current Wallet', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Current Wallet?'),
                    content: const Text(
                      'This will permanently delete the active wallet and all its transactions and accounts. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  try {
                    final walletId = ref.read(currentWalletIdProvider);
                    final db = ref.read(databaseProvider);
                    
                    await db.walletDao.deleteWallet(walletId);
                    await ref.read(currentWalletIdProvider.notifier).revalidate();
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wallet deleted.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error deleting wallet: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
              title: Text('Reset All Data', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset All Data?'),
                    content: const Text(
                      'This will permanently delete all your transactions, budgets, and custom categories. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  try {
                    await ref.read(databaseProvider).resetDatabase();
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All data has been reset.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error resetting data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}

