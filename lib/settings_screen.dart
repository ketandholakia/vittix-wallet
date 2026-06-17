import 'dart:io';

import 'package:expense_tracker/account_screen.dart';
import 'package:expense_tracker/category_screen.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/csv_exporter.dart';
import 'package:expense_tracker/lock_screen.dart';
import 'package:expense_tracker/recurring_transactions_screen.dart';
import 'package:expense_tracker/sms/sms_import_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:expense_tracker/sync_service.dart';

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
    final syncToken = ref.watch(syncTokenProvider);

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
                Navigator.of(context).push(
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
                Navigator.of(context).push(
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
                Navigator.of(context).push(
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SmsImportScreen()),
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
                        ref.read(pinHashProvider.notifier).updatePinHash(hashed);
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
                        ref.read(pinHashProvider.notifier).updatePinHash(null);
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
                        ref.read(pinHashProvider.notifier).updatePinHash(hashed);
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
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    initialValue: syncUrl,
                    enabled: !isSimulated,
                    decoration: const InputDecoration(
                      labelText: 'Sync URL',
                      hintText: 'https://example.com/api/sync',
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
                    initialValue: syncToken,
                    enabled: !isSimulated,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Auth Token',
                      hintText: 'Bearer token',
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ref.read(syncTokenProvider.notifier).updateSyncToken(value);
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync completed successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (freshState.status == SyncStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
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

          Text('Backup & Restore', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Data'),
              subtitle: const Text('Save a backup of your database'),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final dbFile = ref.read(databaseFileProvider).value;
                if (dbFile == null) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Database file not found!')),
                  );
                  return;
                }

                final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
                final backupFileName = 'expense_backup_$timestamp.db';
                final tempDir = await getTemporaryDirectory();
                final backupFile = File(p.join(tempDir.path, backupFileName));

                try {
                  await dbFile.copy(backupFile.path);
                  await Share.shareXFiles([XFile(backupFile.path)], text: 'Expense Tracker Database Backup');
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
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Import Data?'),
                    content: const Text(
                      'This will overwrite all current data with the backup file. This action cannot be undone. The app will restart after import.',
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

                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['db', 'sqlite'],
                );

                if (result == null || result.files.single.path == null) return;

                final backupFile = File(result.files.single.path!);
                final appDbFile = ref.read(databaseFileProvider).value;

                if (appDbFile == null) {
                  scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Database file not found!')));
                  return;
                }

                try {
                  await ref.read(databaseProvider).close();
                  await backupFile.copy(appDbFile.path);

                  if (!context.mounted) return;

                  await showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Import Successful'),
                      content: const Text('Data has been restored. The app will now restart.'),
                      actions: [
                        TextButton(
                          onPressed: () => SystemNavigator.pop(), // Close the app
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error importing data: $e')),
                  );
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All data has been reset.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
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
