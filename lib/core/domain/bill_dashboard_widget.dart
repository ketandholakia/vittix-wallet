import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillDashboardWidget extends ConsumerWidget {
  const BillDashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billViewModelsProvider);
    return billsAsync.when(
      data: (bills) {
        final upcoming = bills.where((bill) => bill.status != 'paid').take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(title: Text('Upcoming Bills')),
            if (upcoming.isEmpty)
              const ListTile(title: Text('No upcoming bills'))
            else
              ...upcoming.map(
                (bill) => ListTile(
                  title: Text(bill.name),
                  subtitle: Text('${bill.dueDate}'),
                  trailing: Text(bill.amount.toStringAsFixed(0)),
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e'),
    );
  }
}
