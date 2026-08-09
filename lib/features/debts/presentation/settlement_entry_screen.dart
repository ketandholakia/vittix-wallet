// BROKEN DEPENDENCY: settlementDao
/*
import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettlementEntryScreen extends ConsumerWidget {
  const SettlementEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final walletId = ref.watch(currentWalletIdProvider);
    final balancesAsync = ref.watch(memberBalancesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Record Settlement')),
      body: balancesAsync.when(
        data: (balances) => roleAsync.when(
          data: (role) => ListView(
            children: [
              if (!permissions.canManageSettlements(role) && !permissions.canMarkBillsPaid(role))
                const ListTile(title: Text('Read only'))
              else
                ...balances.map((balance) => ListTile(
                      title: Text(balance.memberName),
                      subtitle: Text('Net ${balance.netBalance.toStringAsFixed(0)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _record(context, ref, walletId, balance.memberId),
                      ),
                    )),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Future<void> _record(BuildContext context, WidgetRef ref, int walletId, int payerMemberId) async {
    final receiver = TextEditingController();
    final amount = TextEditingController();
    final notes = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settlement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: receiver, decoration: const InputDecoration(labelText: 'Receiver Member ID')),
            TextField(controller: amount, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(settlementDaoProvider).insertSettlement(
                    db.WalletSettlementsCompanion.insert(
                      walletId: walletId,
                      payerMemberId: payerMemberId,
                      receiverMemberId: int.tryParse(receiver.text) ?? payerMemberId,
                      amount: double.tryParse(amount.text) ?? 0,
                      notes: db.Value(notes.text.isEmpty ? null : notes.text),
                    ),
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

*/