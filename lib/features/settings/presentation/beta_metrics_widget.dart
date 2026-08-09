// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BetaMetricsWidget extends ConsumerWidget {
  const BetaMetricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(betaMetricsSummaryProvider);
    final feedbackAsync = ref.watch(feedbackReviewSummaryProvider);
    final frictionAsync = ref.watch(workflowFrictionSummaryProvider);
    return metricsAsync.when(
      data: (metrics) => feedbackAsync.when(
        data: (feedback) => frictionAsync.when(
          data: (friction) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Beta Metrics', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _MetricRow('Wallet creations', metrics.walletCreations),
                  _MetricRow('Invitation acceptances', metrics.invitationAcceptances),
                  _MetricRow('SMS imports', metrics.smsImports),
                  _MetricRow('Budget creations', metrics.budgetCreations),
                  _MetricRow('Goal creations', metrics.goalCreations),
                  _MetricRow('Split creations', metrics.splitCreations),
                  _MetricRow('Settlement recordings', metrics.settlementCreations),
                  const SizedBox(height: 8),
                  Text('Feedback review', style: Theme.of(context).textTheme.titleSmall),
                  _MetricRow('Bug reports', feedback.categoryCounts['bug'] ?? 0),
                  _MetricRow('UX issues', feedback.categoryCounts['uxIssue'] ?? 0),
                  _MetricRow('Feature requests', feedback.categoryCounts['featureRequest'] ?? 0),
                  _MetricRow('SMS issues', feedback.categoryCounts['smsAccuracy'] ?? 0),
                  _MetricRow('Recent bugs (14d)', feedback.recentBugReports),
                  _MetricRow('Recent UX issues (14d)', feedback.recentUxIssues),
                  _MetricRow('Recent requests (14d)', feedback.recentFeatureRequests),
                  _MetricRow('Recent SMS issues (14d)', feedback.recentSmsIssues),
                  const SizedBox(height: 8),
                  Text('Workflow friction', style: Theme.of(context).textTheme.titleSmall),
                  _MetricRow('Abandoned invite flows', friction.abandonedInviteFlows),
                  _MetricRow('Abandoned SMS imports', friction.abandonedSmsImports),
                  _MetricRow('Failed split creation', friction.failedSplitCreations),
                  _MetricRow('Failed settlement creation', friction.failedSettlementCreations),
                  _MetricRow('Total friction signals', friction.totalFrictionSignals),
                  const SizedBox(height: 8),
                  Text('SMS quality', style: Theme.of(context).textTheme.titleSmall),
                  _MetricRow('Accepted', metrics.smsAccepted),
                  _MetricRow('Rejected', metrics.smsRejected),
                  _MetricRow('Duplicate', metrics.smsDuplicates),
                  if (metrics.feedbackCategories.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Feedback categories', style: Theme.of(context).textTheme.titleSmall),
                    for (final entry in metrics.feedbackCategories.entries) _MetricRow(entry.key, entry.value),
                  ],
                ],
              ),
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => Text('Workflow friction unavailable: $error'),
        ),
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Text('Feedback review unavailable: $error'),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('Beta metrics unavailable: $error'),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final num value;

  const _MetricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(value.toString()),
        ],
      ),
    );
  }
}

