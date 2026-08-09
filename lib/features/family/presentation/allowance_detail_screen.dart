import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllowanceDetailScreen extends ConsumerWidget {
  const AllowanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(allowanceSummaryProvider);
    final spendingAsync = ref.watch(allowanceSpendingSummaryProvider);
    final paymentsAsync = ref.watch(allowancePaymentViewModelsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Allowance Detail')),
      body: ListView(
        children: [
          summaryAsync.when(
            data: (summary) => Column(
              children: [
                ListTile(title: const Text('Active Allowances'), trailing: Text('${summary.activeAllowances}')),
                ListTile(title: const Text('Monthly Total'), trailing: Text(summary.monthlyTotal.toStringAsFixed(0))),
                if (summary.nextDue != null) ListTile(title: const Text('Next Due'), trailing: Text(summary.nextDue!)),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => ListTile(title: Text('$e')),
          ),
          const Divider(),
          spendingAsync.when(
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(title: Text('Child Spending Summary')),
                ListTile(title: const Text('Allowance Received'), trailing: Text(summary.allowanceReceived.toStringAsFixed(0))),
                ListTile(title: const Text('Expenses Recorded'), trailing: Text(summary.expensesRecorded.toStringAsFixed(0))),
                ListTile(title: const Text('Remaining Allowance'), trailing: Text(summary.remainingAllowance.toStringAsFixed(0))),
                ListTile(title: const Text('Savings Amount'), trailing: Text(summary.savingsAmount.toStringAsFixed(0))),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => ListTile(title: Text('$e')),
          ),
          const Divider(),
          paymentsAsync.when(
            data: (payments) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(title: Text('Recently Paid Allowances')),
                if (payments.isEmpty)
                  const ListTile(title: Text('No allowance payments yet'))
                else
                  ...payments.map(
                    (payment) => ListTile(
                      title: Text(payment.memberName),
                      subtitle: Text('${payment.paidDate} • ${payment.notes}'),
                      trailing: Text(payment.amount.toStringAsFixed(0)),
                    ),
                  ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => ListTile(title: Text('$e')),
          ),
        ],
      ),
    );
  }
}
