// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyFinancialSummaryWidget extends ConsumerWidget {
  const FamilyFinancialSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = ref.watch(currencyFormatProvider);
    final summaryAsync = ref.watch(familyFinancialSummaryProvider);
    return summaryAsync.when(
      data: (summary) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This Month', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(label: 'Income', value: currencyFormat.format(summary.income)),
                  _MetricCard(label: 'Expenses', value: currencyFormat.format(summary.expense)),
                  _MetricCard(label: 'Savings Rate', value: '${(summary.savingsRate * 100).toStringAsFixed(0)}%'),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

