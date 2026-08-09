// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:flutter/material.dart';

class QuickAddWidget extends StatelessWidget {
  const QuickAddWidget({super.key});

  void _openTransaction(BuildContext context, domain.TransactionType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(initialType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Quick Add',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  'Tap to create',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _openTransaction(context, domain.TransactionType.expense),
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('Expense'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _openTransaction(context, domain.TransactionType.income),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Income'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

