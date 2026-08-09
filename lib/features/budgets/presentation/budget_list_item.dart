import 'package:expense_tracker/features/budgets/presentation/budget_form_dialog.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetListItem extends ConsumerWidget {
  final Budget budget;

  const BudgetListItem({super.key, required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spent = budget.spentAmount;
    final currencyFormat = ref.watch(currencyFormatProvider);
    final total = budget.totalLimit;
    final remaining = budget.remainingAmount;
    final progress = total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;

    Color getProgressColor() {
      if (progress >= 1.0) {
        return Colors.red;
      } else if (progress >= 0.8) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await showBudgetFormDialog(context, ref, budget: budget);
          if (result != null) {
            await ref.read(updateBudgetUseCaseProvider).call(result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(budget.category.icon, color: budget.category.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(budget.category.name, style: Theme.of(context).textTheme.titleMedium),
                        if (budget.rolloverAmount != 0.0) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                budget.rolloverAmount > 0 ? Icons.trending_up : Icons.trending_down,
                                size: 12,
                                color: budget.rolloverAmount > 0 ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                budget.rolloverAmount > 0
                                    ? '${currencyFormat.format(budget.rolloverAmount)} rolled over'
                                    : '${currencyFormat.format(budget.rolloverAmount.abs())} deficit carried',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: budget.rolloverAmount > 0 ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 20),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Budget'),
                          content: Text(
                            'Are you sure you want to delete the budget for ${budget.category.name}?',
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
                        await ref.read(deleteBudgetUseCaseProvider).call(budget.id);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: getProgressColor(),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: ${currencyFormat.format(spent)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Limit: ${currencyFormat.format(total)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (budget.rolloverAmount != 0.0)
                        Text(
                          '(${currencyFormat.format(budget.amount)} base)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Remaining: ${currencyFormat.format(remaining)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: remaining < 0 ? Colors.red : null,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}