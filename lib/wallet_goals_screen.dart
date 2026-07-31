import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/family_finance_models.dart';
import 'package:expense_tracker/wallet_permissions.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletGoalsScreen extends ConsumerWidget {
  const WalletGoalsScreen({super.key});

  @override
  m.Widget build(m.BuildContext context, WidgetRef ref) {
    final walletId = ref.watch(currentWalletIdProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final goalsAsync = ref.watch(goalViewModelsProvider);

    return m.Scaffold(
      appBar: m.AppBar(title: const m.Text('Wallet Goals')),
      body: goalsAsync.when(
        data: (goals) => roleAsync.when(
          data: (role) => goals.isEmpty
              ? const m.Center(
                  child: m.Padding(
                    padding: m.EdgeInsets.all(24),
                    child: m.Text('No goals yet. Add a wallet goal to track savings progress together.'),
                  ),
                )
              : m.ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final canManage = permissions.canManageGoals(role);
                    final canContribute = permissions.canContributeToGoals(role);
                    return m.ListTile(
                      title: m.Text(goal.name),
                      subtitle: m.Text('${(goal.progress * 100).toStringAsFixed(0)}% of ${goal.targetAmount.toStringAsFixed(0)}'),
                      trailing: m.Wrap(
                        spacing: 8,
                        children: [
                          if (canContribute) m.IconButton(icon: const m.Icon(m.Icons.add), onPressed: () => _contribute(context, ref, walletId, goal)),
                          if (canManage) m.IconButton(icon: const m.Icon(m.Icons.edit), onPressed: () => _edit(context, ref, walletId, goal)),
                          if (canManage) m.IconButton(icon: const m.Icon(m.Icons.archive), onPressed: () => _archive(ref, goal.id)),
                          if (canManage) m.IconButton(icon: const m.Icon(m.Icons.delete), onPressed: () => _delete(ref, goal.id)),
                        ],
                      ),
                    );
                  },
                ),
          loading: () => const m.Center(child: m.CircularProgressIndicator()),
          error: (e, _) => m.Center(child: m.Text('$e')),
        ),
        loading: () => const m.Center(child: m.CircularProgressIndicator()),
        error: (e, _) => m.Center(child: m.Text('$e')),
      ),
    );
  }

  Future<void> _contribute(m.BuildContext context, WidgetRef ref, int walletId, GoalViewModel goal) async {
    final amount = m.TextEditingController();
    await m.showDialog<void>(
      context: context,
      builder: (context) => m.AlertDialog(
        title: m.Text('Contribute to ${goal.name}'),
        content: m.TextField(controller: amount, keyboardType: m.TextInputType.number, decoration: const m.InputDecoration(labelText: 'Amount')),
        actions: [
          m.TextButton(onPressed: () => m.Navigator.pop(context), child: const m.Text('Cancel')),
          m.FilledButton(
            onPressed: () async {
              final value = double.tryParse(amount.text) ?? 0;
              if (value > 0) {
                await ref.read(goalDaoProvider).addContribution(
                      db.WalletGoalContributionsCompanion.insert(walletId: walletId, goalId: goal.id, amount: value),
                    );
                await ref.read(goalDaoProvider).logGoalActivity(walletId: walletId, action: 'goal_contribution', goalId: goal.id);
              }
              if (context.mounted) m.Navigator.pop(context);
            },
            child: const m.Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(m.BuildContext context, WidgetRef ref, int walletId, GoalViewModel goal) async {
    final name = m.TextEditingController(text: goal.name);
    final target = m.TextEditingController(text: goal.targetAmount.toString());
    await m.showDialog<void>(
      context: context,
      builder: (context) => m.AlertDialog(
        title: const m.Text('Edit Goal'),
        content: m.Column(
          mainAxisSize: m.MainAxisSize.min,
          children: [
            m.TextField(controller: name, decoration: const m.InputDecoration(labelText: 'Name')),
            m.TextField(controller: target, decoration: const m.InputDecoration(labelText: 'Target'), keyboardType: m.TextInputType.number),
          ],
        ),
        actions: [
          m.TextButton(onPressed: () => m.Navigator.pop(context), child: const m.Text('Cancel')),
          m.FilledButton(
            onPressed: () async {
              await ref.read(goalDaoProvider).updateGoal(
                    db.WalletGoalsCompanion(
                      id: db.Value(goal.id),
                      walletId: db.Value(walletId),
                      name: db.Value(name.text),
                      targetAmount: db.Value(double.tryParse(target.text) ?? goal.targetAmount),
                      currentAmount: db.Value(goal.currentAmount),
                      targetDate: db.Value(goal.targetDate),
                    ),
                  );
              await ref.read(goalDaoProvider).logGoalActivity(walletId: walletId, action: 'goal_updated', goalId: goal.id);
              if (context.mounted) m.Navigator.pop(context);
            },
            child: const m.Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _archive(WidgetRef ref, int id) async {
    await ref.read(goalDaoProvider).deleteGoal(id);
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    await ref.read(goalDaoProvider).deleteGoal(id);
  }
}
