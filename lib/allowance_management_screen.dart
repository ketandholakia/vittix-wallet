import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/core/providers/dashboard_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/family_allowance_models.dart';
import 'package:expense_tracker/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllowanceManagementScreen extends ConsumerWidget {
  const AllowanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletId = ref.watch(currentWalletIdProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final allowancesAsync = ref.watch(allowanceViewModelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Allowance Management')),
      body: allowancesAsync.when(
        data: (allowances) => roleAsync.when(
          data: (role) => allowances.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No allowances yet. Create a wallet allowance for a member to begin tracking payments.'),
                  ),
                )
              : ListView.builder(
                  itemCount: allowances.length,
                  itemBuilder: (context, index) {
                    final allowance = allowances[index];
                    final canManage = permissions.canManageAllowances(role);
                    return ListTile(
                      title: Text(allowance.memberName),
                      subtitle: Text('${allowance.amount.toStringAsFixed(0)} • ${allowance.frequency}'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (canManage) IconButton(icon: const Icon(Icons.edit), onPressed: () => _edit(context, ref, walletId, allowance)),
                          if (canManage && allowance.isActive) IconButton(icon: const Icon(Icons.pause), onPressed: () => _toggle(ref, walletId, allowance, false)),
                          if (canManage && !allowance.isActive) IconButton(icon: const Icon(Icons.play_arrow), onPressed: () => _toggle(ref, walletId, allowance, true)),
                          if (canManage) IconButton(icon: const Icon(Icons.payments_outlined), onPressed: () => _recordPayment(context, ref, allowance)),
                          if (canManage) IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(ref, allowance.id)),
                        ],
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: roleAsync.maybeWhen(
        data: (role) => permissions.canManageAllowances(role)
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
    final amount = TextEditingController();
    final memberId = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Allowance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: memberId, decoration: const InputDecoration(labelText: 'Member ID')),
            TextField(controller: amount, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(allowanceDaoProvider).insertAllowance(
                    db.WalletAllowancesCompanion.insert(
                      walletId: walletId,
                      memberId: int.tryParse(memberId.text) ?? 1,
                      amount: double.tryParse(amount.text) ?? 0,
                      frequency: db.WalletAllowanceFrequency.monthly,
                      startDate: DateTime.now(),
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

  Future<void> _edit(BuildContext context, WidgetRef ref, int walletId, AllowanceViewModel allowance) async {
    final amount = TextEditingController(text: allowance.amount.toString());
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Allowance'),
        content: TextField(controller: amount, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(allowanceDaoProvider).updateAllowance(
                    db.WalletAllowancesCompanion(
                      id: db.Value(allowance.id),
                      walletId: db.Value(walletId),
                      memberId: db.Value(allowance.memberId),
                      amount: db.Value(double.tryParse(amount.text) ?? allowance.amount),
                      frequency: db.Value(db.WalletAllowanceFrequency.monthly),
                      startDate: db.Value(allowance.startDate),
                      isActive: db.Value(allowance.isActive),
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

  Future<void> _toggle(WidgetRef ref, int walletId, AllowanceViewModel allowance, bool active) async {
    await ref.read(allowanceDaoProvider).updateAllowance(
          db.WalletAllowancesCompanion(
            id: db.Value(allowance.id),
            walletId: db.Value(walletId),
            memberId: db.Value(allowance.memberId),
            amount: db.Value(allowance.amount),
            frequency: db.Value(db.WalletAllowanceFrequency.monthly),
            startDate: db.Value(allowance.startDate),
            isActive: db.Value(active),
          ),
        );
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    await ref.read(allowanceDaoProvider).deleteAllowance(id);
  }

  Future<void> _recordPayment(BuildContext context, WidgetRef ref, AllowanceViewModel allowance) async {
    final amount = TextEditingController(text: allowance.amount.toString());
    final notes = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await ref.read(allowanceDaoProvider).insertPayment(
                    db.WalletAllowancePaymentsCompanion.insert(
                      allowanceId: allowance.id,
                      memberId: allowance.memberId,
                      amount: double.tryParse(amount.text) ?? allowance.amount,
                      paidDate: db.Value(DateTime.now()),
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
