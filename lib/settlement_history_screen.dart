import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettlementHistoryScreen extends ConsumerWidget {
  const SettlementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(settlementHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settlement History')),
      body: historyAsync.when(
        data: (history) => ListView(
          children: [
            if (history.isEmpty)
              const ListTile(
                title: Text('No settlements yet'),
                subtitle: Text('Record a local settlement to keep balances up to date.'),
              )
            else
              ...history.map(
                (entry) => ListTile(
                  title: Text('${entry.payer} paid ${entry.receiver}'),
                  subtitle: Text('${entry.settlementDate} • ${entry.notes}'),
                  trailing: Text(entry.amount.toStringAsFixed(0)),
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
