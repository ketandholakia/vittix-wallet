import 'package:expense_tracker/features/budgets/domain/budget.dart' as domain;
import 'package:expense_tracker/features/categories/domain/category.dart' as domain;
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/features/family/domain/family_finance_models.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedBudgetsScreen extends ConsumerWidget {
  const SharedBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletId = ref.watch(currentWalletIdProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final budgetsAsync = ref.watch(budgetViewModelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Budgets')),
      body: budgetsAsync.when(
        data: (budgets) => roleAsync.when(
          data: (role) => budgets.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No shared budgets yet. Create a wallet budget to set a common spending limit.'),
                  ),
                )
              : ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    final canManage = permissions.canManageBudgets(role);
                    return ListTile(
                      title: Text(budget.category),
                      subtitle: Text('${budget.spent.toStringAsFixed(0)} spent / ${budget.budgetAmount.toStringAsFixed(0)}'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (canManage) IconButton(icon: const Icon(Icons.edit), onPressed: () => _edit(context, ref, walletId, budget)),
                          if (canManage) IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(ref, budget.id)),
                        ],
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, int walletId, BudgetViewModel budget) async {
    final amount = TextEditingController(text: budget.budgetAmount.toString());
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Budget'),
        content: TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(amount.text) ?? budget.budgetAmount;
              final db = ref.read(databaseProvider);
              final categoryId = (await db.select(db.categories).get()).first.id;
              await ref.read(budgetRepositoryProvider).updateBudget(
                    domain.Budget(
                      id: budget.id,
                      amount: value,
                      period: '2026-06',
                      category: domain.Category(id: categoryId, name: budget.category, icon: Icons.pie_chart, color: Colors.blue),
                    ),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    await ref.read(budgetRepositoryProvider).deleteBudget(id);
  }
}
