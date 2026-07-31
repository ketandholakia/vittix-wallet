import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberBalancesWidget extends ConsumerWidget {
  const MemberBalancesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(memberBalancesProvider);
    return balancesAsync.when(
      data: (balances) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(title: Text('Member Balances')),
          if (balances.isEmpty)
            const ListTile(title: Text('No balances yet'))
          else
            ...balances.map(
              (balance) => ListTile(
                title: Text(balance.memberName),
                subtitle: Text('Paid ${balance.totalPaid.toStringAsFixed(0)} • Owed ${balance.totalOwed.toStringAsFixed(0)}'),
                trailing: Text(balance.netBalance.toStringAsFixed(0)),
              ),
            ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e'),
    );
  }
}
