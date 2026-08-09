import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentWalletMembersProvider = FutureProvider<List<WalletMember>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  return ref.watch(walletDaoProvider).getMembersForWallet(walletId);
});

final currentWalletMemberProvider = FutureProvider<WalletMember?>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final members = await ref.watch(walletDaoProvider).getMembersForWallet(walletId);
  return members.isEmpty ? null : members.first;
});

final currentWalletRoleProvider = FutureProvider<WalletRole?>((ref) async {
  final member = await ref.watch(currentWalletMemberProvider.future);
  return member?.role;
});

class WalletPermissionService {
  const WalletPermissionService();

  bool canManageMembers(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canEditMembers(WalletRole? role) {
    return canManageMembers(role);
  }

  bool canRemoveMembers(WalletRole? role) {
    return role == WalletRole.owner;
  }

  bool canChangeRoles(WalletRole? role) {
    return canManageMembers(role);
  }

  bool canAddTransactions(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin || role == WalletRole.member;
  }

  bool canManageBudgets(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canViewBudgets(WalletRole? role) {
    return role != null;
  }

  bool canManageGoals(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canContributeToGoals(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin || role == WalletRole.member;
  }

  bool canManageAllowances(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canViewOwnAllowance(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin || role == WalletRole.member;
  }

  bool canManageBillsAndSchedules(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canMarkBillsPaid(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin || role == WalletRole.member;
  }

  bool canManageSettlements(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin;
  }

  bool canCreateSplits(WalletRole? role) {
    return role == WalletRole.owner || role == WalletRole.admin || role == WalletRole.member;
  }

  bool canDeleteWallet(WalletRole? role) {
    return role == WalletRole.owner;
  }

  bool canTransferOwnership(WalletRole? role) {
    return role == WalletRole.owner;
  }

  bool canViewActivity(WalletRole? role) {
    return role != null;
  }
}

final walletPermissionServiceProvider = Provider<WalletPermissionService>((ref) {
  return const WalletPermissionService();
});
