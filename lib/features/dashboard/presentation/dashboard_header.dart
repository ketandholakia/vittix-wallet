import 'package:expense_tracker/domain/entities/monthly_report.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardHeader extends ConsumerWidget {
  final MonthlyReport report;

  const DashboardHeader({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savings = report.totalIncome - report.totalExpense;
    final currencyFormat = ref.watch(currencyFormatProvider);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(report.balance),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
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
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            title, 
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.9))
          ),
          Text(
            amount, 
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), 
            overflow: TextOverflow.ellipsis
          ),
        ],
      ),
    );
  }
}