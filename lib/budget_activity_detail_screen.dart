import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetActivityDetailScreen extends ConsumerWidget {
  const BudgetActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(budgetActivityViewModelsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Activity')),
      body: activitiesAsync.when(
        data: (activities) => activities.isEmpty
            ? const Center(child: Text('No budget activity yet'))
            : ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ListTile(
                    title: Text(activity.action),
                    subtitle: Text('${activity.actor} • ${activity.timestamp}\n${activity.details}'),
                    isThreeLine: true,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
