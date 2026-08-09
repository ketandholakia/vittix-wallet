// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/settings/presentation/guided_onboarding_screen.dart' as expense_tracker_guided_onboarding;
import 'package:expense_tracker/features/accounts/presentation/accounts_overview_widget.dart';
import 'package:expense_tracker/core/domain/attention_needed_widget.dart';
import 'package:expense_tracker/features/settings/presentation/beta_metrics_widget.dart';
import 'package:expense_tracker/core/domain/brand_assets.dart';
import 'package:expense_tracker/features/budgets/presentation/budget_overview_widget.dart';
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/core/presentation/dashboard_shimmer.dart';
import 'package:expense_tracker/features/family/domain/family_automation_dashboard.dart';
import 'package:expense_tracker/features/family/presentation/family_financial_summary_widget.dart';
import 'package:expense_tracker/features/family/presentation/family_goal_summary_widget.dart';
import 'package:expense_tracker/core/domain/forecast_history_widget.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/dashboard_header.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/recent_transactions_list.dart';
import 'package:expense_tracker/presentation/screens/dashboard/widgets/assets_overview_widget.dart';
import 'package:expense_tracker/presentation/screens/dashboard/customize_dashboard_screen.dart';
import 'package:expense_tracker/presentation/widgets/error_display_widget.dart';
import 'package:expense_tracker/features/reports/presentation/spending_insights_summary_widget.dart';
import 'package:expense_tracker/features/transactions/presentation/quick_add_widget.dart';
import 'package:expense_tracker/features/reports/presentation/spending_streak_widget.dart';
import 'package:expense_tracker/features/family/domain/wallet_activity_feed.dart';
import 'package:expense_tracker/features/family/presentation/wallet_member_summary_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/presentation/app_drawer.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _showSecondarySections = false;
  bool _showMore = false;
  final Stopwatch _buildTimer = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (kDebugMode) {
        debugPrint('Dashboard first frame built in ${_buildTimer.elapsedMilliseconds}ms');
      }
      setState(() => _showSecondarySections = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyReportAsync = ref.watch(monthlyReportProvider);
    final recentTransactionsAsync = ref.watch(recentTransactionsProvider);
    final currentWalletAsync = ref.watch(currentWalletProvider);
    final walletsAsync = ref.watch(availableWalletsProvider);
    final currentWalletId = ref.watch(currentWalletIdProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandLogo(size: 28, showWordmark: true),
        actions: [
          walletsAsync.when(
            data: (wallets) => currentWalletAsync.when(
              data: (wallet) => PopupMenuButton<int>(
                tooltip: 'Switch wallet',
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(
                        wallet?.name ?? 'Select wallet',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
                onSelected: (value) {
                  if (value == -1) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const expense_tracker_guided_onboarding.GuidedOnboardingScreen()));
                  } else {
                    ref.read(currentWalletIdProvider.notifier).selectWallet(value);
                  }
                },
                itemBuilder: (context) {
                  final items = wallets
                      .map(
                        (walletItem) => PopupMenuItem<int>(
                          value: walletItem.id,
                          child: Row(
                            children: [
                              Expanded(child: Text(walletItem.name)),
                              if (walletItem.id == currentWalletId) const Icon(Icons.check, size: 18),
                            ],
                          ),
                        ),
                      )
                      .toList();
                  items.add(
                    const PopupMenuItem<int>(
                      value: -1,
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text('Create new wallet'),
                        ],
                      ),
                    ),
                  );
                  return items;
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(monthlyReportProvider);
          ref.invalidate(recentTransactionsProvider);
        },
        child: ListView(
          children: [
            walletsAsync.when(
              data: (wallets) => wallets.length <= 1
                  ? Card(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: ListTile(
                        leading: const Icon(Icons.wallet_outlined),
                        title: const Text('Your wallet is the home base'),
                        subtitle: const Text(
                          'A wallet keeps one set of transactions, budgets, goals, and family data together.',
                        ),
                        trailing: TextButton(
                          onPressed: () => setState(() => _showMore = true),
                          child: const Text('Continue'),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            monthlyReportAsync.when(
              data: (report) {
                final widgetsOrder = ref.watch(dashboardWidgetsOrderProvider);
                final widgetsHidden = ref.watch(dashboardWidgetsHiddenProvider);

                final widgetMap = <String, Widget>{
                  'quick_add': const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: QuickAddWidget(),
                  ),
                  'spending_streak': const SpendingStreakWidget(),
                  'accounts_overview': const AccountsOverviewWidget(),
                  'assets_overview': const AssetsOverviewWidget(),
                  'recent_transactions': recentTransactionsAsync.when(
                    data: (transactions) => RecentTransactionsList(transactions: transactions),
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => Center(child: Text('Error loading recent transactions: $err')),
                  ),
                  'attention_needed': const AttentionNeededWidget(),
                  'family_automation': const FamilyAutomationDashboard(),
                  'budget_overview': const BudgetOverviewWidget(),
                  'debts_overview': SizedBox.shrink(),
                  'wallet_member_summary': const WalletMemberSummaryWidget(),
                  'family_financial_summary': const FamilyFinancialSummaryWidget(),
                  'forecast_history': const ForecastHistoryWidget(),
                  'family_goal_summary': const FamilyGoalSummaryWidget(),
                  'spending_insights_summary': const SpendingInsightsSummaryWidget(),
                  'beta_metrics': const BetaMetricsWidget(),
                  'wallet_activity_feed': SizedBox.shrink(),
                };

                final visibleWidgets = widgetsOrder
                    .where((id) => widgetsHidden[id] != true && widgetMap.containsKey(id))
                    .map((id) => widgetMap[id]!)
                    .toList();

                return Column(
                  children: [
                    DashboardHeader(report: report)
                        .animate()
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.08, curve: Curves.easeOutQuad),
                    
                    if (_showSecondarySections) ...[
                      ...visibleWidgets.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final widget = entry.value;
                        return widget
                            .animate()
                            .fade(duration: 400.ms, delay: (25 + (idx * 25)).ms)
                            .slideY(begin: 0.08, curve: Curves.easeOutQuad);
                      }),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const CustomizeDashboardScreen(),
                          ));
                        },
                        icon: const Icon(Icons.tune),
                        label: const Text('Customize Dashboard'),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      const DashboardShimmer(),
                    ],
                  ],
                );
              },
              loading: () => const SizedBox(height: 200, child: DashboardShimmer()),
              error: (err, stack) => ErrorDisplayWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(monthlyReportProvider),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

