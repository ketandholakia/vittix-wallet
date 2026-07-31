// BROKEN DEPENDENCY: Experimental
/*
import 'package:expense_tracker/budget_form_dialog.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/presentation/screens/budget/widgets/budget_list_item.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:expense_tracker/presentation/widgets/shimmer_list.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/budget.dart';
import 'package:expense_tracker/budget_list_item.dart';
import 'package:expense_tracker/empty_state_widget.dart';
import 'package:expense_tracker/shimmer_list.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/app_drawer.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll just get budgets for the current month.
    // This can be enhanced with a date picker later.
    final rolloverMode = ref.watch(rolloverModeProvider);
    final budgetStatusStream = ref.watch(getBudgetStatusUseCaseProvider).call(DateTime.now(), rolloverMode);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: StreamBuilder<List<Budget>>(
        stream: budgetStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const ShimmerList();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final budgets = snapshot.data ?? [];
          if (budgets.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.pie_chart_outline,
              message: 'No Budgets Found',
              subMessage: 'Create a budget to track your spending against a goal.',
            );
          }

          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              return BudgetListItem(budget: budgets[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showBudgetFormDialog(context, ref);
          if (result != null) {
            await ref.read(addBudgetUseCaseProvider).call(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/