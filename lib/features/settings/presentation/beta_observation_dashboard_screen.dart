import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BetaObservationDashboardScreen extends ConsumerWidget {
  const BetaObservationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingProgressProvider);
    final feedbackAsync = ref.watch(feedbackReviewSummaryProvider);
    final frictionAsync = ref.watch(workflowFrictionSummaryProvider);
    final smsAsync = ref.watch(smsImportMetricsProvider);
    final healthAsync = ref.watch(betaHealthSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Beta Observation Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Beta health',
            child: healthAsync.when(
              data: (health) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${health.score}/100', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(health.label),
                ],
              ),
              loading: () => const SizedBox(height: 32),
              error: (error, _) => Text('Health unavailable: $error'),
            ),
          ),
          _SectionCard(
            title: 'Onboarding funnel',
            child: onboardingAsync.when(
              data: (summary) => Column(
                children: [
                  _MetricRow('Started onboarding', summary.walletCreationStarted + summary.inviteFlowStarted + summary.smsSetupStarted),
                  _MetricRow('Completed onboarding', summary.walletCreationCompleted + summary.inviteFlowCompleted + summary.smsSetupCompleted),
                  _MetricRow('Wallet created', summary.walletCreationCompleted),
                  _MetricRow('Invite accepted', summary.inviteFlowCompleted),
                  _MetricRow('SMS setup completed', summary.smsSetupCompleted),
                ],
              ),
              loading: () => const SizedBox(height: 32),
              error: (error, _) => Text('Onboarding unavailable: $error'),
            ),
          ),
          _SectionCard(
            title: 'Wallet activity',
            child: ref.watch(walletActivityProvider).when(
                  data: (activities) => Text('Recent wallet activity events: ${activities.length}'),
                  loading: () => const SizedBox(height: 32),
                  error: (error, _) => Text('Activity unavailable: $error'),
                ),
          ),
          _SectionCard(
            title: 'SMS quality',
            child: smsAsync.when(
              data: (metric) => Column(
                children: [
                  _MetricRow('Accepted imports', metric?.acceptedImports ?? 0),
                  _MetricRow('Rejected imports', metric?.rejectedImports ?? 0),
                  _MetricRow('Duplicates', metric?.duplicateDetections ?? 0),
                  _MetricRow(
                    'Confidence distribution',
                    (metric?.acceptedImports ?? 0) + (metric?.rejectedImports ?? 0) + (metric?.duplicateDetections ?? 0),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 32),
              error: (error, _) => Text('SMS quality unavailable: $error'),
            ),
          ),
          _SectionCard(
            title: 'Workflow friction',
            child: frictionAsync.when(
              data: (friction) => Column(
                children: [
                  _MetricRow('Abandoned invites', friction.abandonedInviteFlows),
                  _MetricRow('Abandoned SMS setup', friction.abandonedSmsImports),
                  _MetricRow('Failed split creation', friction.failedSplitCreations),
                  _MetricRow('Failed settlement creation', friction.failedSettlementCreations),
                ],
              ),
              loading: () => const SizedBox(height: 32),
              error: (error, _) => Text('Friction unavailable: $error'),
            ),
          ),
          _SectionCard(
            title: 'Feedback summary',
            child: feedbackAsync.when(
              data: (feedback) => Column(
                children: [
                  _MetricRow('Bug reports', feedback.categoryCounts['bug'] ?? 0),
                  _MetricRow('UX issues', feedback.recentUxIssues),
                  _MetricRow('Feature requests', feedback.categoryCounts['improvement'] ?? 0),
                  _MetricRow('SMS issues', feedback.categoryCounts['smsParsingIssue'] ?? 0),
                ],
              ),
              loading: () => const SizedBox(height: 32),
              error: (error, _) => Text('Feedback unavailable: $error'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
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
