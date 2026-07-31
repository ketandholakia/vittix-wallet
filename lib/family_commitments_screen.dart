import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyCommitmentsScreen extends ConsumerWidget {
  const FamilyCommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(familyCommitmentSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Family Commitments')),
      body: summaryAsync.when(
        data: (summary) => ListView(
          children: [
            ListTile(title: const Text('Active Goals'), trailing: Text('${summary.activeGoals}')),
            ListTile(title: const Text('Recurring Contributions'), trailing: Text('${summary.recurringContributions}')),
            ListTile(title: const Text('Overdue Bills'), trailing: Text('${summary.overdueBills}')),
            const Divider(),
            if (summary.upcomingBills.isEmpty)
              const ListTile(title: Text('No upcoming bills'))
            else
              ...summary.upcomingBills.map(
                (bill) => ListTile(
                  title: Text(bill.name),
                  subtitle: Text('${bill.dueDate}'),
                  trailing: Text(bill.amount.toStringAsFixed(0)),
                ),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
