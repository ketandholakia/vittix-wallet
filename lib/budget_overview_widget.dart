import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetOverviewWidget extends ConsumerWidget {
  const BudgetOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolloverMode = ref.watch(rolloverModeProvider);
    final budgetStatusStream =
        ref.watch(getBudgetStatusUseCaseProvider).call(DateTime.now(), rolloverMode);
    final currencyFormat = ref.watch(currencyFormatProvider);
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<List<Budget>>(
      stream: budgetStatusStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final budgets = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget Progress', style: textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      // Find the MainScreen's state to switch to Budget tab
                      // For simplicity, we just show a message; the user can tap the Budgets tab
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: budgets.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  final spent = budget.spentAmount;
                  final total = budget.totalLimit;
                  final remaining = budget.remainingAmount;
                  final progress =
                      total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;

                  Color progressColor;
                  if (progress >= 1.0) {
                    progressColor = Colors.red;
                  } else if (progress >= 0.8) {
                    progressColor = Colors.orange;
                  } else {
                    progressColor = Colors.green;
                  }

                  return Card(
                    child: Container(
                      width: 170,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(budget.category.icon,
                                  color: budget.category.color, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  budget.category.name,
                                  style: textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            color: progressColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            remaining >= 0
                                ? '${currencyFormat.format(remaining)} left'
                                : '${currencyFormat.format(remaining.abs())} over',
                            style: textTheme.bodySmall?.copyWith(
                              color: remaining < 0 ? Colors.red : null,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
