import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/account_form_dialog.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/repository_providers.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final account = await showAccountFormDialog(context, ref);
    if (account == null || !context.mounted) return;

    await ref.read(addAccountUseCaseProvider).call(account);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account "${account.name}" added')),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, Account account) async {
    final updated = await showAccountFormDialog(context, ref, account: account);
    if (updated == null || !context.mounted) return;

    await ref.read(updateAccountUseCaseProvider).call(updated);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account "${updated.name}" updated')),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AccountWithBalance item,
  ) async {
    if (item.account.isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default accounts cannot be deleted.')),
      );
      return;
    }

    final txCount = await ref.read(accountRepositoryProvider).countTransactionsForAccount(item.account.id);
    if (!context.mounted) return;

    if (txCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot delete "${item.account.name}" — it has $txCount transaction(s).')),
      );
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Delete "${item.account.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(deleteAccountUseCaseProvider).call(item.account.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account "${item.account.name}" deleted')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsStream = ref.watch(watchAccountsWithBalanceUseCaseProvider).call();
    final currencyFormat = ref.watch(currencyFormatProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: StreamBuilder<List<AccountWithBalance>>(
        stream: accountsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final accounts = snapshot.data ?? [];
          if (accounts.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              message: 'No accounts yet',
              subMessage: 'Add a bank account, credit card, or cash wallet.',
              action: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Account'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final item = accounts[index];
              final account = item.account;
              final balanceLabel = account.type.isLiability ? 'Owed' : 'Balance';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: account.color.withValues(alpha: 0.2),
                  child: Icon(account.icon, color: account.color),
                ),
                title: Text(account.name, style: textTheme.bodyLarge),
                subtitle: Text('${account.type.label}${account.isDefault ? ' · Default' : ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(balanceLabel, style: textTheme.bodySmall),
                        Text(
                          currencyFormat.format(item.balance),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: account.type.isLiability && item.balance > 0
                                ? colorScheme.error
                                : colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showEditDialog(context, ref, account),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: colorScheme.error),
                      onPressed: account.isDefault
                          ? null
                          : () => _confirmDelete(context, ref, item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
