// BROKEN DEPENDENCY: Experimental
/*
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForecastHistoryWidget extends ConsumerWidget {
  const ForecastHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(forecastHistoryProvider);
    final currency = ref.watch(currencyFormatProvider);
    return historyAsync.when(
      data: (history) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forecast Trends', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              for (final point in history.points)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat.MMMd().format(point.date)),
                      Text('${currency.format(point.goalForecastTotal)} goals'),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Text('30-day trend and 90-day trend are derived locally from forecast providers.'),
            ],
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('Forecast trends unavailable: $error'),
    );
  }
}

*/