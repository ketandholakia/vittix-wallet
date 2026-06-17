import 'package:expense_tracker/usecase_providers.dart';
import 'package:expense_tracker/trend_data_point.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/empty_state_widget.dart';
import 'package:expense_tracker/error_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// State for the selected number of months
final trendPeriodProvider = StateProvider<int>((ref) => 6);

// Provider to fetch the trend data based on the selected period
final trendReportProvider = FutureProvider.autoDispose<List<TrendDataPoint>>((ref) {
  // Invalidate this provider if the use case changes, to force a refetch.
  final months = ref.watch(trendPeriodProvider);
  return ref.watch(getTrendReportUseCaseProvider).call(months);
});

class TrendReportScreen extends ConsumerWidget {
  const TrendReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendPeriod = ref.watch(trendPeriodProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider);
    final trendDataAsync = ref.watch(trendReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Trend'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 3, label: Text('3M')),
                ButtonSegment(value: 6, label: Text('6M')),
                ButtonSegment(value: 12, label: Text('12M')),
              ],
              selected: {trendPeriod},
              onSelectionChanged: (newSelection) {
                ref.read(trendPeriodProvider.notifier).state = newSelection.first;
              },
            ),
          ),
          Expanded(
            child: trendDataAsync.when(
              data: (data) {
                if (data.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.trending_down,
                    message: 'Not Enough Data',
                    subMessage: 'More transactions are needed to show a spending trend.',
                  );
                }

                // Ensure data is sorted by date for correct processing.
                data.sort((a, b) => a.date.compareTo(b.date));

                // Create a map for quick lookups of amounts by month.
                final dataMap = {
                  for (var point in data) DateTime(point.date.year, point.date.month): point.amount
                };

                // Generate a complete list of months for the selected period to fill any gaps.
                final now = DateTime.now();
                final allMonths = List.generate(trendPeriod, (index) {
                  return DateTime(now.year, now.month - (trendPeriod - 1) + index, 1);
                });

                // Create chart spots, using 0.0 for months with no data.
                final spots = allMonths.asMap().entries.map((entry) {
                  final index = entry.key;
                  final month = entry.value;
                  final amount = dataMap[month] ?? 0.0;
                  return FlSpot(index.toDouble(), amount);
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                currencyFormatter.format(spot.y),
                                TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              );
                            }).toList();
                          },
                          getTooltipColor: (touchedSpot) => Theme.of(context).primaryColor,
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= allMonths.length) return const SizedBox();
                              final date = allMonths[index];
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(DateFormat('MMM').format(date)),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 80,
                            getTitlesWidget: (value, meta) {
                              // Use compact number formatting for a cleaner look
                              return Text(
                                NumberFormat.compact().format(value),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()), // A simple loader is fine here
              error: (err, stack) => ErrorDisplayWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(trendReportProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}