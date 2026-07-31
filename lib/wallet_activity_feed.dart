// BROKEN DEPENDENCY: Experimental
/*
import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletActivityFeed extends ConsumerWidget {
  const WalletActivityFeed({super.key});

  String _labelFor(db.WalletActivity activity) {
    final actor = activity.actorAccountId == null ? 'System' : 'Member ${activity.actorAccountId}';
    return '$actor ${activity.action}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(walletActivityProvider);

    return activityAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.history),
            title: Text('No wallet activity yet'),
          );
        }
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.history),
              title: Text('Wallet activity'),
            ),
            ...activities.take(5).map(
                  (activity) => ListTile(
                    dense: true,
                    title: Text(_labelFor(activity)),
                    subtitle: Text(activity.details ?? activity.entityType),
                  ),
                ),
          ],
        );
      },
      loading: () => const ListTile(
        leading: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text('Loading wallet activity...'),
      ),
      error: (error, stack) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text('Activity unavailable: $error'),
      ),
    );
  }
}

*/