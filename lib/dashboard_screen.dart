import 'package:expense_tracker/accounts_overview_widget.dart';
import 'package:expense_tracker/budget_overview_widget.dart';
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/dashboard_header.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/dashboard_shimmer.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/recent_transactions_list.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/spending_pie_chart.dart';
import 'package:expense_tracker/presentation/widgets/error_display_widget.dart';
import 'package:expense_tracker/dashboard_providers.dart';
import 'package:expense_tracker/dashboard_header.dart';
import 'package:expense_tracker/dashboard_shimmer.dart';
import 'package:expense_tracker/recent_transactions_list.dart';
import 'package:expense_tracker/spending_pie_chart.dart';
import 'package:expense_tracker/error_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/debts_overview_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _showSecondarySections = false;
  final Stopwatch _buildTimer = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (kDebugMode) {
        debugPrint('Dashboard first frame built in ${_buildTimer.elapsedMilliseconds}ms');
      }
      setState(() {
        _showSecondarySections = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyReportAsync = ref.watch(monthlyReportProvider);
    final monthlyTransactionsAsync = ref.watch(monthlyTransactionsProvider);
    final recentTransactionsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(monthlyReportProvider);
          ref.invalidate(recentTransactionsProvider);
        },
        child: ListView(
          children: [
            monthlyReportAsync.when(
              data: (report) => Column(
                children: [
                  DashboardHeader(report: report)
                      .animate()
                      .fade(duration: 400.ms)
                      .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                  if (_showSecondarySections) ...[
                    const AccountsOverviewWidget()
                        .animate()
                        .fade(duration: 400.ms, delay: 50.ms)
                        .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                    const BudgetOverviewWidget()
                        .animate()
                        .fade(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                    const DebtsOverviewWidget()
                        .animate()
                        .fade(duration: 400.ms, delay: 150.ms)
                        .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                    monthlyTransactionsAsync.when(
                      data: (transactions) => SpendingPieChart(transactions: transactions)
                          .animate()
                          .fade(duration: 400.ms, delay: 200.ms)
                          .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => Center(child: Text('Error loading chart data: $err')),
                    ),
                    recentTransactionsAsync.when(
                      data: (transactions) => RecentTransactionsList(transactions: transactions)
                          .animate()
                          .fade(duration: 400.ms, delay: 250.ms)
                          .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => Center(child: Text('Error loading recent transactions: $err')),
                    ),
                  ] else ...[
                    const SizedBox(height: 24),
                    const DashboardShimmer(),
                  ],
                ],
              ),
              loading: () => const SizedBox(height: 200, child: DashboardShimmer()),
              error: (err, stack) => ErrorDisplayWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(monthlyReportProvider),
              ),
            ),

            const SizedBox(height: 20), // Some padding at the bottom
          ],
        ),
      ),
    );
  }
}
