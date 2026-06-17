import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/presentation/widgets/transaction_list_item.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<domain.Transaction> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: EmptyStateWidget(icon: Icons.history_toggle_off, message: 'No recent activity'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (ctx, index) => TransactionListItem(transaction: transactions[index]),
            ),
        ],
      ),
    );
  }
}