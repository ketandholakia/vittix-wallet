import 'package:collection/collection.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CategoryReportScreen extends ConsumerWidget {
  final List<domain.Transaction> transactions;

  const CategoryReportScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseTransactions = transactions.where((tx) => tx.type == domain.TransactionType.expense).toList();
    final spendingByCategory = groupBy(expenseTransactions, (domain.Transaction tx) => tx.category)
        .map((category, txs) => MapEntry(category, txs.fold(0.0, (sum, tx) => sum + tx.amount)))
        .entries
        .sortedBy<num>((e) => e.value)
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Spending'),
      ),
      body: spendingByCategory.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.bar_chart_outlined,
              message: 'No Spending Data',
              subMessage: 'Expenses for this month will appear here.',
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: spendingByCategory.first.value * 1.2, // Add 20% padding to max Y
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final category = spendingByCategory[groupIndex].key;
                        final amount = spendingByCategory[groupIndex].value;
                        final currencyFormat = ref.watch(currencyFormatProvider);
                        return BarTooltipItem(
                          '${category.name}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: currencyFormat.format(amount),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final category = spendingByCategory[value.toInt()].key;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Icon(category.icon, color: category.color, size: 24),
                          );
                        },
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: spendingByCategory.mapIndexed((index, entry) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: entry.key.color,
                          width: 22,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}