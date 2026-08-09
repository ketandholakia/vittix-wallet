import 'package:collection/collection.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountReportScreen extends ConsumerWidget {
  final List<domain.Transaction> transactions;

  const AccountReportScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseTransactions = transactions.where((tx) => tx.type == domain.TransactionType.expense).toList();
    final spendingByAccount = groupBy(expenseTransactions, (domain.Transaction tx) => tx.account)
        .map((account, txs) => MapEntry(account, txs.fold(0.0, (sum, tx) => sum + tx.amount)))
        .entries
        .sortedBy<num>((e) => e.value)
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Spending'),
      ),
      body: spendingByAccount.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              message: 'No Spending Data',
              subMessage: 'Expenses for this month will appear here.',
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: spendingByAccount.first.value * 1.2, // Add 20% padding to max Y
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final account = spendingByAccount[groupIndex].key;
                        final amount = spendingByAccount[groupIndex].value;
                        final currencyFormat = ref.watch(currencyFormatProvider);
                        return BarTooltipItem(
                          '${account.name}\n',
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
                          final account = spendingByAccount[value.toInt()].key;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Icon(account.icon, color: account.color, size: 24),
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
                  barGroups: spendingByAccount.mapIndexed((index, entry) {
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
