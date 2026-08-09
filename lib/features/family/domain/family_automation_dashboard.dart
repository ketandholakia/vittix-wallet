// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyAutomationDashboard extends ConsumerWidget {
  const FamilyAutomationDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectionAsync = ref.watch(cashflowProjectionProvider);
    return projectionAsync.when(
      data: (projection) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(title: Text('Future Commitments')),
          ListTile(title: const Text('Expected Bills'), trailing: Text(projection.expectedBills.toStringAsFixed(0))),
          ListTile(title: const Text('Allowance Payments'), trailing: Text(projection.expectedAllowancePayments.toStringAsFixed(0))),
          ListTile(title: const Text('Goal Contributions'), trailing: Text(projection.expectedGoalContributions.toStringAsFixed(0))),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e'),
    );
  }
}

