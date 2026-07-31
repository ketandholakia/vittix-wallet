// BROKEN DEPENDENCY: settlementDao
/*
import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/family_settlement_models.dart';
import 'package:expense_tracker/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitExpenseScreen extends ConsumerWidget {
  const SplitExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitsAsync = ref.watch(splitExpenseViewModelsProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final walletId = ref.watch(currentWalletIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Split Expenses')),
      body: splitsAsync.when(
        data: (splits) => roleAsync.when(
          data: (role) => ListView(
            children: [
              if (splits.isEmpty) const ListTile(title: Text('No split expenses yet')),
              ...splits.map((split) => ListTile(
                    title: Text('Transaction #${split.transactionId}'),
                    subtitle: Text('${split.splitMethod} split'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        if (permissions.canCreateSplits(role))
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _edit(context, ref, walletId, split),
                          ),
                        if (permissions.canCreateSplits(role))
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(ref, split.id),
                          ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SplitDetailScreen(splitId: split.id))),
                  )),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: roleAsync.maybeWhen(
        data: (role) => permissions.canCreateSplits(role)
            ? FloatingActionButton(
                onPressed: () => _create(context, ref, walletId),
                child: const Icon(Icons.add),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref, int walletId) async {
    await _showSplitDialog(context, ref, walletId);
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, int walletId, SplitExpenseViewModel split) async {
    await _showSplitDialog(context, ref, walletId, splitId: split.id);
  }

  Future<void> _delete(WidgetRef ref, int splitId) async {
    await ref.read(settlementDaoProvider).deleteSplit(splitId);
  }

  Future<void> _showSplitDialog(BuildContext context, WidgetRef ref, int walletId, {int? splitId}) async {
    final transactionId = TextEditingController();
    final payerMemberId = TextEditingController();
    final memberIds = TextEditingController();
    final amounts = TextEditingController();
    final percentages = TextEditingController();
    final method = ValueNotifier<db.WalletExpenseSplitMethod>(db.WalletExpenseSplitMethod.equal);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(splitId == null ? 'Split Expense' : 'Edit Split Expense'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: transactionId, decoration: const InputDecoration(labelText: 'Transaction ID')),
                TextField(controller: payerMemberId, decoration: const InputDecoration(labelText: 'Payer Member ID')),
                DropdownButton<db.WalletExpenseSplitMethod>(
                  value: method.value,
                  items: db.WalletExpenseSplitMethod.values
                      .map((value) => DropdownMenuItem(value: value, child: Text(value.name)))
                      .toList(),
                  onChanged: (value) => setState(() => method.value = value ?? method.value),
                ),
                TextField(controller: memberIds, decoration: const InputDecoration(labelText: 'Member IDs comma separated')),
                TextField(controller: amounts, decoration: const InputDecoration(labelText: 'Amounts comma separated')),
                TextField(controller: percentages, decoration: const InputDecoration(labelText: 'Percentages comma separated')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final ids = memberIds.text.split(',').map((e) => int.tryParse(e.trim())).whereType<int>().toList();
              final owed = amounts.text.split(',').map((e) => double.tryParse(e.trim())).whereType<double>().toList();
              final perc = percentages.text.split(',').map((e) => double.tryParse(e.trim())).whereType<double>().toList();
              if (ids.isEmpty) return;
              final split = db.WalletExpenseSplitsCompanion.insert(
                walletId: walletId,
                transactionId: int.tryParse(transactionId.text) ?? 0,
                paidByMemberId: int.tryParse(payerMemberId.text) ?? ids.first,
                splitMethod: method.value,
              );
              final splitIdValue = await ref.read(settlementDaoProvider).insertSplit(split);
              for (var i = 0; i < ids.length; i++) {
                await ref.read(settlementDaoProvider).insertSplitMember(
                      db.WalletExpenseSplitMembersCompanion.insert(
                        splitId: splitIdValue,
                        memberId: ids[i],
                        amountOwed: owed.length > i ? owed[i] : 0,
                        percentage: db.Value(perc.length > i ? perc[i] : 0),
                        settledAmount: const db.Value(0),
                      ),
                    );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class SplitDetailScreen extends ConsumerWidget {
  final int splitId;
  const SplitDetailScreen({super.key, required this.splitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitAsync = ref.watch(splitExpenseViewModelsProvider);
    final historyAsync = ref.watch(walletActivityProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Split Detail')),
      body: splitAsync.when(
        data: (splits) {
          final splitMatches = splits.where((element) => element.id == splitId).toList();
          if (splitMatches.isEmpty) return const Center(child: Text('Split not found'));
          final split = splitMatches.first;
          return ListView(
            children: [
              ListTile(title: Text('Transaction #${split.transactionId}'), subtitle: Text('Payer ${split.paidByMemberId}')),
              ...split.members.map(
                (member) => ListTile(
                  title: Text(member.memberName),
                  subtitle: Text('Owed ${member.amountOwed.toStringAsFixed(0)} • Settled ${member.settledAmount.toStringAsFixed(0)}'),
                  trailing: Text(member.percentage.toStringAsFixed(0)),
                ),
              ),
              const Divider(),
              historyAsync.when(
                data: (events) => Column(
                  children: events
                      .where((event) => event.entityType == 'settlement' || event.entityType == 'split')
                      .map(
                        (event) => ListTile(
                          title: Text(event.action),
                          subtitle: Text('${event.createdAt} • ${event.details ?? ''}'),
                        ),
                      )
                      .toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('$e'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

*/