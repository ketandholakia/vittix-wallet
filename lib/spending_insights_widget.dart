import 'package:collection/collection.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingInsightsWidget extends ConsumerWidget {
  final List<domain.Transaction> transactions;

  const SpendingInsightsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseTransactions = transactions.where((tx) => tx.type == domain.TransactionType.expense).toList();

    if (expenseTransactions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No spending data available for insights.'),
        ),
      );
    }

    // Calculate insights
    final spendingByCategory = groupBy(expenseTransactions, (domain.Transaction tx) => tx.category)
        .map((category, txs) => MapEntry(category, txs.fold(0.0, (sum, tx) => sum + tx.amount)));

    final highestSpending = spendingByCategory.entries.sortedBy<num>((e) => e.value).lastOrNull;
    final lowestSpending = spendingByCategory.entries.sortedBy<num>((e) => e.value).firstOrNull;

    final totalSpending = expenseTransactions.fold<double>(0.0, (sum, tx) => sum + tx.amount);
    final daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    final averageDailyExpense = totalSpending / daysInMonth;

    final currencyFormat = ref.watch(currencyFormatProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (highestSpending != null)
              _buildInsightRow(
                context,
                Icons.arrow_circle_up,
                'Highest Spending',
                '${highestSpending.key.name} (${currencyFormat.format(highestSpending.value)})',
                Colors.red,
              ),
            const Divider(),
            if (lowestSpending != null && lowestSpending != highestSpending)
              _buildInsightRow(
                context,
                Icons.arrow_circle_down,
                'Lowest Spending',
                '${lowestSpending.key.name} (${currencyFormat.format(lowestSpending.value)})',
                Colors.green,
              ),
            if (lowestSpending != null && lowestSpending != highestSpending) const Divider(),
            _buildInsightRow(
              context,
              Icons.calculate,
              'Avg. Daily Expense',
              currencyFormat.format(averageDailyExpense),
              Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(BuildContext context, IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
