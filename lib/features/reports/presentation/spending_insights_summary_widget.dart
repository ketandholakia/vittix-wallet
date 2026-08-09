// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingInsightsSummaryWidget extends ConsumerWidget {
  const SpendingInsightsSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(spendingInsightsProvider);
    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) {
          return const SizedBox.shrink();
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spending Insights', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                for (final insight in insights.take(4))
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(insight.icon),
                    title: Text(insight.title),
                    subtitle: Text(insight.detail),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('Insights unavailable: $error'),
    );
  }
}

