// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyGoalSummaryWidget extends ConsumerWidget {
  const FamilyGoalSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(familyGoalSummaryProvider);
    return goalsAsync.when(
      data: (goals) {
        if (goals.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goals', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...goals.map(
                (goal) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(goal.goal.name),
                  subtitle: Text('${(goal.progress * 100).toStringAsFixed(0)}% complete'),
                  trailing: Text('${goal.goal.currentAmount}/${goal.goal.targetAmount}'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

