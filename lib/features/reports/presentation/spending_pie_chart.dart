import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingPieChart extends ConsumerStatefulWidget {
  final List<domain.Transaction> transactions;

  const SpendingPieChart({super.key, required this.transactions});

  @override
  ConsumerState<SpendingPieChart> createState() => _SpendingPieChartState();
}

class _SpendingPieChartState extends ConsumerState<SpendingPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final expenseTransactions = widget.transactions.where((tx) => tx.type == domain.TransactionType.expense).toList();

    if (expenseTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    final Map<Category, double> spendingByCategory = {};
    for (var tx in expenseTransactions) {
      spendingByCategory.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    final sortedSpending = spendingByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalSpending = expenseTransactions.fold<double>(0, (sum, item) => sum + item.amount);

    final pieChartSections = sortedSpending.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final isTouched = sortedSpending.indexOf(entry) == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final percentage = (amount / totalSpending) * 100;

      return PieChartSectionData(
        color: category.color,
        value: amount,
        title: '',
        radius: radius,
        badgeWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black87, blurRadius: 2)],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [Shadow(color: Colors.black87, blurRadius: 2)],
              ),
            ),
          ],
        ),
        badgePositionPercentageOffset: 0.55,
      );
    }).toList();

    final isWide = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Spending', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildChart(pieChartSections)),
                    Expanded(child: _buildLegend(sortedSpending, ref)),
                  ],
                )
              : Column(
                  children: [
                    _buildChart(pieChartSections),
                    const SizedBox(height: 24),
                    _buildLegend(sortedSpending, ref),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildChart(List<PieChartSectionData> sections) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: sections,
        ),
      ),
    );
  }

  Widget _buildLegend(List<MapEntry<Category, double>> sortedSpending, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedSpending.map((entry) {
        final currencyFormat = ref.watch(currencyFormatProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: entry.key.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(entry.key.name, style: Theme.of(context).textTheme.bodyLarge),
              ),
              Text(
                currencyFormat.format(entry.value),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
