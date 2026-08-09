// BROKEN DEPENDENCY: Experimental
/*
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttentionNeededWidget extends ConsumerWidget {
  const AttentionNeededWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(attentionNeededProvider);
    return summaryAsync.when(
      data: (summary) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attention Needed', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('Overdue bills: ${summary.overdueBills}'),
              Text('Missed contributions: ${summary.missedGoalContributions}'),
              Text('Pending settlements: ${summary.pendingSettlements}'),
              Text('Pending invitations: ${summary.pendingInvitations}'),
            ],
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('Attention summary unavailable: $error'),
    );
  }
}

*/