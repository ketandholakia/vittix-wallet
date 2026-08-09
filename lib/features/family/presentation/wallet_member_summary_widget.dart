// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletMemberSummaryWidget extends ConsumerWidget {
  const WalletMemberSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(memberContributionSummaryProvider);
    return summaryAsync.when(
      data: (summaries) {
        if (summaries.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.groups_outlined),
            title: Text('No member contributions yet'),
          );
        }
        return Column(
          children: [
            const ListTile(
              leading: Icon(Icons.groups_outlined),
              title: Text('Member contributions'),
            ),
            ...summaries.map(
              (summary) => ListTile(
                dense: true,
                title: Text('Account ${summary.accountId}'),
                trailing: Text(summary.totalAmount.toStringAsFixed(0)),
              ),
            ),
          ],
        );
      },
      loading: () => const ListTile(
        leading: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text('Loading member contributions...'),
      ),
      error: (error, stack) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text('Member summary unavailable: $error'),
      ),
    );
  }
}

