import 'package:expense_tracker/domain/entities/monthly_report.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends ConsumerWidget {
  final MonthlyReport report;

  const DashboardHeader({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savings = report.totalIncome - report.totalExpense;
    final currencyFormat = ref.watch(currencyFormatProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          Text(
            currencyFormat.format(report.balance),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoCard(context, 'Income', currencyFormat.format(report.totalIncome), Colors.green, Icons.arrow_upward),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoCard(context, 'Expense', currencyFormat.format(report.totalExpense), Colors.red, Icons.arrow_downward),
              ),
              const SizedBox(width: 8),
              // Only show savings card if screen is wide enough
              if (MediaQuery.of(context).size.width > 380)
                Expanded(
                  child: _buildInfoCard(context, 'Savings', currencyFormat.format(savings), Colors.blue, Icons.savings),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String amount, Color color, IconData icon) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            Text(amount, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}