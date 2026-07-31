import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletMembersScreen extends ConsumerWidget {
  const WalletMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(currentWalletMembersProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet members')),
      body: membersAsync.when(
        data: (members) {
          final canManage = permissions.canManageMembers(roleAsync.asData?.value);
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Account ${member.accountId}'),
                  subtitle: Text('Joined ${member.joinedAt.toLocal()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<WalletRole>(
                        value: member.role,
                        onChanged: canManage
                            ? (value) async {
                                if (value == null) return;
                                final walletId = ref.read(currentWalletIdProvider);
                                final previousRole = member.role;
                                await ref.read(walletDaoProvider).updateMember(
                                      WalletMembersCompanion(
                                        id: Value(member.id),
                                        walletId: Value(walletId),
                                        accountId: Value(member.accountId),
                                        role: Value(value),
                                        joinedAt: Value(member.joinedAt),
                                        isActive: Value(member.isActive),
                                      ),
                                    );
                                await ref.read(walletDaoProvider).logRoleChanged(
                                      walletId: walletId,
                                      accountId: member.accountId,
                                      oldRole: previousRole,
                                      newRole: value,
                                    );
                                ref.invalidate(currentWalletMembersProvider);
                              }
                            : null,
                        items: WalletRole.values
                            .map((role) => DropdownMenuItem(value: role, child: Text(role.name.toUpperCase())))
                            .toList(),
                      ),
                      IconButton(
                        onPressed: canManage && permissions.canRemoveMembers(roleAsync.asData?.value)
                            ? () async {
                                final walletId = ref.read(currentWalletIdProvider);
                                await ref.read(walletDaoProvider).deactivateMember(walletId, member.accountId);
                                await ref.read(walletDaoProvider).logMemberRemoved(
                                      walletId: walletId,
                                      accountId: member.accountId,
                                      actorAccountId: null,
                                    );
                                ref.invalidate(currentWalletMembersProvider);
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load members: $error')),
      ),
    );
  }
}
