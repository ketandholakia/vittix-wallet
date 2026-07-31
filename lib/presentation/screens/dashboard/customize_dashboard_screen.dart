import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomizeDashboardScreen extends ConsumerWidget {
  const CustomizeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetsOrder = ref.watch(dashboardWidgetsOrderProvider);
    final widgetsHidden = ref.watch(dashboardWidgetsHiddenProvider);

    final widgetNames = {
      'quick_add': 'Quick Add Widget',
      'spending_streak': 'Spending Streak',
      'accounts_overview': 'Accounts Overview',
      'assets_overview': 'Assets & Investments',
      'recent_transactions': 'Recent Transactions',
      'attention_needed': 'Attention Needed',
      'family_automation': 'Family Automation',
      'budget_overview': 'Budget Overview',
      'debts_overview': 'Debts Overview',
      'wallet_member_summary': 'Wallet Member Summary',
      'family_financial_summary': 'Family Financial Summary',
      'forecast_history': 'Forecast History',
      'family_goal_summary': 'Family Goal Summary',
      'spending_insights_summary': 'Spending Insights',
      'beta_metrics': 'Beta Metrics',
      'wallet_activity_feed': 'Wallet Activity Feed',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Dashboard'),
      ),
      body: ReorderableListView.builder(
        itemCount: widgetsOrder.length,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final newList = List<String>.from(widgetsOrder);
          final item = newList.removeAt(oldIndex);
          newList.insert(newIndex, item);
          ref.read(dashboardWidgetsOrderProvider.notifier).updateOrder(newList);
        },
        itemBuilder: (context, index) {
          final widgetId = widgetsOrder[index];
          final isHidden = widgetsHidden[widgetId] == true;
          return ListTile(
            key: ValueKey(widgetId),
            leading: const Icon(Icons.drag_handle),
            title: Text(widgetNames[widgetId] ?? widgetId),
            trailing: Switch(
              value: !isHidden,
              onChanged: (value) {
                ref.read(dashboardWidgetsHiddenProvider.notifier).toggleWidget(widgetId, !value);
              },
            ),
          );
        },
      ),
    );
  }
}
