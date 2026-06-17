import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/presentation/screens/reports/category_report_screen.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/presentation/screens/reports/trend_report_screen.dart';
import 'package:expense_tracker/presentation/screens/reports/widgets/spending_insights_widget.dart';
import 'package:expense_tracker/presentation/widgets/error_display_widget.dart';
import 'package:expense_tracker/dashboard_providers.dart';
import 'package:expense_tracker/category_report_screen.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:expense_tracker/trend_report_screen.dart';
import 'package:expense_tracker/account_report_screen.dart';
import 'package:expense_tracker/spending_insights_widget.dart';
import 'package:expense_tracker/error_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyReportAsync = ref.watch(monthlyReportProvider);
    final textTheme = Theme.of(context).textTheme;
    final currencyFormat = ref.watch(currencyFormatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Insights'),
      ),
      body: monthlyReportAsync.when(
        data: (report) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Monthly Report (TODO 8.1)
              Text('This Month\'s Summary', style: textTheme.titleLarge),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSummaryRow('Income', currencyFormat.format(report.totalIncome), Colors.green, textTheme),
                      const Divider(),
                      _buildSummaryRow('Expense', currencyFormat.format(report.totalExpense), Colors.red, textTheme),
                      const Divider(),
                      _buildSummaryRow('Savings', currencyFormat.format(report.balance), Theme.of(context).colorScheme.primary, textTheme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Spending Insights (TODO 8.4)
              Text('Spending Insights', style: textTheme.titleLarge),
              const SizedBox(height: 16),
              SpendingInsightsWidget(transactions: report.transactions),
              const SizedBox(height: 24),

              // Navigation to other reports
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Category Spending Report'),
                subtitle: const Text('View expenses by category for the month'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CategoryReportScreen(transactions: report.transactions),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Account Spending Report'),
                subtitle: const Text('View expenses by account for the month'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AccountReportScreen(transactions: report.transactions),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Spending Trend Report'),
                subtitle: const Text('Compare your spending over time'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const TrendReportScreen(),
                  ));
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(monthlyReportProvider),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, Color color, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textTheme.titleMedium),
          Text(amount, style: textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}