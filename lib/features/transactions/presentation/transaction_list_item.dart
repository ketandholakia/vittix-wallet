// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.red : Colors.green;
    final amountPrefix = isExpense ? '-' : '+';
    final currencyFormat = ref.watch(currencyFormatProvider);
    
    final isTransfer = transaction.note != null && transaction.note!.startsWith('[Transfer]');

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isTransfer 
            ? Colors.grey.withValues(alpha: 0.2) 
            : transaction.category.color.withValues(alpha: 0.2),
        child: Icon(
          isTransfer ? Symbols.swap_horiz : transaction.category.icon, 
          color: isTransfer ? Colors.grey : transaction.category.color, 
          size: 20,
        ),
      ),
      title: Text(isTransfer ? transaction.note! : transaction.category.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTransfer 
                ? '${transaction.account.name} · ${DateFormat.yMMMd().format(transaction.date)}'
                : '${transaction.account.name} · ${DateFormat.yMMMd().format(transaction.date)}${transaction.note != null ? ' · ${transaction.note}' : ''}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (transaction.payee != null || transaction.tags.isNotEmpty || transaction.attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  if (transaction.payee != null) ...[
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(transaction.payee!.name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 8),
                  ],
                  if (transaction.tags.isNotEmpty) ...[
                    const Icon(Icons.label, size: 14, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(transaction.tags.map((t) => t.name).join(', '), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 8),
                  ],
                  if (transaction.attachments.isNotEmpty) ...[
                    const Icon(Icons.attachment, size: 14, color: Colors.grey),
                  ],
                ],
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$amountPrefix${currencyFormat.format(transaction.amount)}',
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text('Are you sure you want to delete this transaction?'),
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
                await ref.read(deleteTransactionUseCaseProvider).call(transaction.id);
              }
            },
          ),
        ],
      ),
      onTap: isTransfer
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transfers cannot be edited. Please delete and recreate if needed.'),
                ),
              );
            }
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddTransactionScreen(existingTransaction: transaction),
                ),
              );
            },
    );
  }
}
