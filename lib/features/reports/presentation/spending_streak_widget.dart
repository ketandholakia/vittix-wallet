// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Calculates how many consecutive days (ending today) the user
/// spent less than or equal to their daily budget average, or
/// had zero spending.
final spendingStreakProvider = FutureProvider.autoDispose<SpendingStreakData>((ref) async {
  final transactions = await ref.watch(recentTransactionsProvider.future);
  final report = await ref.watch(monthlyReportProvider.future);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Build a map of daily spending for the last 30 days
  final dailySpending = <DateTime, double>{};
  for (final tx in transactions) {
    if (tx.type == domain.TransactionType.expense) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      dailySpending[day] = (dailySpending[day] ?? 0) + tx.amount;
    }
  }

  // Calculate daily budget average from total monthly budget
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final dailyBudgetAvg = report.totalIncome > 0 ? report.totalIncome / daysInMonth : 0.0;

  // Count streak: consecutive days with spending ≤ daily average (or zero)
  int streak = 0;
  for (int i = 0; i < 30; i++) {
    final day = today.subtract(Duration(days: i));
    final spent = dailySpending[day] ?? 0;
    if (spent <= dailyBudgetAvg) {
      streak++;
    } else {
      break;
    }
  }

  // Determine streak type
  final todaySpent = dailySpending[today] ?? 0;
  final noSpendDays = List.generate(7, (i) => today.subtract(Duration(days: i)))
      .where((d) => (dailySpending[d] ?? 0) == 0)
      .length;

  return SpendingStreakData(
    streakDays: streak,
    todaySpent: todaySpent,
    dailyBudgetAvg: dailyBudgetAvg,
    noSpendDaysThisWeek: noSpendDays,
  );
});

class SpendingStreakData {
  final int streakDays;
  final double todaySpent;
  final double dailyBudgetAvg;
  final int noSpendDaysThisWeek;

  const SpendingStreakData({
    required this.streakDays,
    required this.todaySpent,
    required this.dailyBudgetAvg,
    required this.noSpendDaysThisWeek,
  });
}

class SpendingStreakWidget extends ConsumerWidget {
  const SpendingStreakWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(spendingStreakProvider);
    final currencyFormat = ref.watch(currencyFormatProvider);

    return streakAsync.when(
      data: (data) {
        if (data.streakDays == 0 && data.todaySpent == 0) {
          return const SizedBox.shrink();
        }

        final emoji = data.streakDays >= 7
            ? '🔥'
            : data.streakDays >= 3
                ? '💪'
                : '💰';
        final message = data.streakDays >= 1
            ? '$emoji ${data.streakDays} day${data.streakDays == 1 ? '' : 's'} under budget!'
            : 'Start your streak today!';

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: data.streakDays >= 3
                          ? Colors.orange.withValues(alpha: 0.15)
                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Today: ${currencyFormat.format(data.todaySpent)} · Avg: ${currencyFormat.format(data.dailyBudgetAvg)}/day',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

