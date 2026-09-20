export 'package:expense_tracker/core/database/database_enums.dart';
import 'dart:io';

import 'package:drift/drift.dart';
export 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/features/accounts/domain/default_accounts.dart';
import 'package:expense_tracker/core/database/database_encryption.dart';
import 'package:expense_tracker/core/database/sqlcipher_loader.dart';
import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';
import 'package:expense_tracker/core/database/default_categories.dart';
import 'package:path/path.dart' as p;

// Import the generated part file

import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/bills/data/tables/bills_table.dart';
import 'package:expense_tracker/features/budgets/data/tables/budgets_table.dart';
import 'package:expense_tracker/features/categories/data/tables/categories_table.dart';
import 'package:expense_tracker/features/dashboard/data/tables/notifications_table.dart';
import 'package:expense_tracker/features/dashboard/data/tables/wallet_activities_table.dart';
import 'package:expense_tracker/features/debts/data/tables/loans_table.dart';
import 'package:expense_tracker/features/debts/data/tables/peer_debts_table.dart';
import 'package:expense_tracker/features/family/data/tables/allowances_table.dart';
import 'package:expense_tracker/features/family/data/tables/allowance_payments_table.dart';
import 'package:expense_tracker/features/family/data/tables/settlements_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_invitations_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';
import 'package:expense_tracker/features/goals/data/tables/goals_table.dart';
import 'package:expense_tracker/features/goals/data/tables/goal_contributions_table.dart';
import 'package:expense_tracker/features/goals/data/tables/goal_schedules_table.dart';
import 'package:expense_tracker/features/settings/data/tables/feedback_table.dart';
import 'package:expense_tracker/features/settings/data/tables/notification_preferences_table.dart';
import 'package:expense_tracker/features/sync/data/tables/deleted_records_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/attachments_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/expense_splits_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/expense_split_members_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/merchant_mappings_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/payees_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/recurring_transactions_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/sms_import_metrics_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/tags_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/transactions_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/unrecognized_sms_table.dart';
import 'package:expense_tracker/features/debts/data/debts_dao.dart';
import 'package:expense_tracker/sms/data/sms_parsing_dao.dart';
import 'package:expense_tracker/sms/data/sms_import_metrics_dao.dart';
part 'app_database.g.dart';






// Accounts Table


// Categories Table


// Transactions Table


// Budgets Table


// --- DAOs (Data Access Objects) ---

class LastOwnerException implements Exception {
  final String message;
  const LastOwnerException([this.message = 'Cannot remove or demote the last owner of a wallet. Every wallet must have at least one owner.']);

  @override
  String toString() => message;
}

class WalletPermissionDeniedException implements Exception {
  final String message;
  const WalletPermissionDeniedException([this.message = 'Permission denied for this wallet operation.']);

  @override
  String toString() => message;
}

class InvalidActiveWalletException implements Exception {
  final String message;
  const InvalidActiveWalletException([this.message = 'No valid active wallet available for the current user context.']);

  @override
  String toString() => message;
}

@DriftAccessor(tables: [Wallets, WalletMembers, WalletInvitations, WalletSettlements, WalletExpenseSplits, WalletExpenseSplitMembers, PeerDebts, Transactions, WalletActivities])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(AppDatabase db) : super(db);

  Future<WalletRole?> getRoleInWallet(int walletId, {int? actorAccountId}) async {
    if (actorAccountId == null) return null;
    final query = select(walletMembers)
      ..where((m) =>
          m.walletId.equals(walletId) &
          m.accountId.equals(actorAccountId) &
          m.isActive.equals(true));
    final list = await query.get();
    return list.isEmpty ? null : list.first.role;
  }

  Future<void> checkPermission({
    required int walletId,
    required bool Function(WalletPermissionService service, WalletRole? role) permissionCheck,
    int? actorAccountId,
    String actionName = 'this operation',
  }) async {
    if (actorAccountId == null) return;
    final role = await getRoleInWallet(walletId, actorAccountId: actorAccountId);
    const service = WalletPermissionService();
    if (!permissionCheck(service, role)) {
      throw WalletPermissionDeniedException(
        'Permission denied: You do not have permission to $actionName for wallet $walletId.',
      );
    }
  }

  Future<bool> isWalletValid(int walletId, {int? actorAccountId}) async {
    final wallet = await (select(wallets)..where((w) => w.id.equals(walletId))).getSingleOrNull();
    if (wallet == null) return false;

    if (actorAccountId != null) {
      final role = await getRoleInWallet(walletId, actorAccountId: actorAccountId);
      if (role == null) return false;
    } else {
      final members = await getMembersForWallet(walletId);
      if (members.isEmpty) return false;
    }

    return true;
  }

  Future<List<Wallet>> getAccessibleWallets({int? actorAccountId}) async {
    if (actorAccountId != null) {
      final memberQuery = select(walletMembers)
        ..where((m) => m.accountId.equals(actorAccountId) & m.isActive.equals(true));
      final memberRows = await memberQuery.get();
      final walletIds = memberRows.map((m) => m.walletId).toSet();
      if (walletIds.isEmpty) return [];
      return (select(wallets)..where((w) => w.id.isIn(walletIds))).get();
    } else {
      final allWallets = await select(wallets).get();
      final accessible = <Wallet>[];
      for (final w in allWallets) {
        final members = await getMembersForWallet(w.id);
        if (members.isNotEmpty) {
          accessible.add(w);
        }
      }
      return accessible;
    }
  }

  Future<int?> validateActiveWallet(int? walletId, {int? actorAccountId}) async {
    if (walletId != null) {
      final isValid = await isWalletValid(walletId, actorAccountId: actorAccountId);
      if (isValid) return walletId;
    }
    final accessible = await getAccessibleWallets(actorAccountId: actorAccountId);
    return accessible.isEmpty ? null : accessible.first.id;
  }

  /// Checks if the wallet has any active member with the required permission.
  /// This is a wallet-level check that does not require a specific actor.
  Future<bool> hasActiveMemberWithPermission({
    required int walletId,
    required bool Function(WalletPermissionService service, WalletRole? role) permissionCheck,
  }) async {
    final members = await getMembersForWallet(walletId);
    const service = WalletPermissionService();
    for (final member in members) {
      if (permissionCheck(service, member.role)) {
        return true;
      }
    }
    return false;
  }

  Future<List<WalletMember>> getMembersForWallet(int walletId) async {
    return (select(walletMembers)
          ..where((m) => m.walletId.equals(walletId) & m.isActive.equals(true)))
        .get();
  }

  Future<int> countActiveOwners(int walletId) async {
    final query = select(walletMembers)
      ..where((m) =>
          m.walletId.equals(walletId) &
          m.role.equalsValue(WalletRole.owner) &
          m.isActive.equals(true));
    final list = await query.get();
    return list.length;
  }

  Future<int> insertMember(Insertable<WalletMember> member, {int? actorAccountId}) async {
    // Resolve wallet/account for the audit event before insert.
    int? memberWalletId;
    int? memberAccountId;
    if (member is WalletMember) {
      memberWalletId = member.walletId;
      memberAccountId = member.accountId;
    } else if (member is WalletMembersCompanion) {
      memberWalletId = member.walletId.present ? member.walletId.value : null;
      memberAccountId = member.accountId.present ? member.accountId.value : null;
    }
    if (memberWalletId == null || memberAccountId == null) {
      return into(walletMembers).insert(member);
    }
    final wid = memberWalletId;
    final aid = memberAccountId;
    return transaction(() async {
      final id = await into(walletMembers).insert(member);
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: wid,
          action: 'MEMBER_ADDED',
          entityType: 'wallet_member',
          entityId: aid,
          source: 'user',
        ),
        wid,
        actorAccountId: actorAccountId,
      );
      return id;
    });
  }

  Future<bool> updateMember(Insertable<WalletMember> companion, {int? actorAccountId}) async {
    return transaction(() async {
      int? memberId;
      if (companion is WalletMember) {
        memberId = companion.id;
      } else if (companion is WalletMembersCompanion) {
        memberId = companion.id.present ? companion.id.value : null;
      }

      // Resolve existing member outside nested block so audit code can access it.
      WalletMember? existing;
      if (memberId != null) {
        existing = await (select(walletMembers)..where((m) => m.id.equals(memberId!))).getSingleOrNull();
        if (existing != null) {
          await checkPermission(
            walletId: existing.walletId,
            permissionCheck: (s, r) => s.canChangeRoles(r),
            actorAccountId: actorAccountId,
            actionName: 'manage member roles',
          );

          if (existing.isActive && existing.role == WalletRole.owner) {
            WalletRole? newRole;
            bool? newIsActive;

            if (companion is WalletMember) {
              newRole = companion.role;
              newIsActive = companion.isActive;
            } else if (companion is WalletMembersCompanion) {
              newRole = companion.role.present ? companion.role.value : existing.role;
              newIsActive = companion.isActive.present ? companion.isActive.value : existing.isActive;
            }

            if ((newRole != null && newRole != WalletRole.owner) || (newIsActive != null && !newIsActive)) {
              final actorRole = await getRoleInWallet(existing.walletId, actorAccountId: actorAccountId);
              if (actorRole != null && actorRole != WalletRole.owner) {
                throw const WalletPermissionDeniedException('Permission denied: Only wallet owners can demote another owner.');
              }

              final ownerCount = await countActiveOwners(existing.walletId);
              if (ownerCount <= 1) {
                throw const LastOwnerException('Cannot demote or remove the last owner of the wallet. Assign another owner first.');
              }
            }
          }
        }
      }

      final replaced = await update(walletMembers).replace(companion);

      // Audit role change atomically (actor = acting admin, entity = affected member).
      if (existing != null) {
        WalletRole? newRole;
        if (companion is WalletMember) {
          newRole = companion.role;
        } else if (companion is WalletMembersCompanion) {
          newRole = companion.role.present ? companion.role.value : existing.role;
        }
        if (newRole != null && newRole != existing.role) {
          await insertActivity(
            WalletActivitiesCompanion.insert(
              walletId: existing.walletId,
              action: 'MEMBER_ROLE_CHANGED',
              entityType: 'wallet_member',
              entityId: existing.accountId,
              details: Value('Role changed from ${existing.role.name} to ${newRole.name}'),
              source: 'user',
            ),
            existing.walletId,
            actorAccountId: actorAccountId,
          );
        }
      }

      return replaced;
    });
  }

  Future<void> deactivateMember(int walletId, int accountId, {int? actorAccountId}) async {
    await transaction(() async {
      await checkPermission(
        walletId: walletId,
        permissionCheck: (s, r) => s.canRemoveMembers(r),
        actorAccountId: actorAccountId,
        actionName: 'remove members',
      );

      final existing = await (select(walletMembers)
            ..where((m) => m.walletId.equals(walletId) & m.accountId.equals(accountId) & m.isActive.equals(true)))
          .getSingleOrNull();

      if (existing == null) return;

      if (existing.role == WalletRole.owner) {
        final ownerCount = await countActiveOwners(walletId);
        if (ownerCount <= 1) {
          throw const LastOwnerException('Cannot remove the last owner of the wallet. Assign another owner first.');
        }
      }

      await (update(walletMembers)..where((m) => m.id.equals(existing.id)))
          .write(const WalletMembersCompanion(isActive: Value(false)));

      // Audit deactivation atomically (actor = acting admin, entity = affected member).
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletId,
          action: 'MEMBER_DEACTIVATED',
          entityType: 'wallet_member',
          entityId: accountId,
          source: 'user',
        ),
        walletId,
        actorAccountId: actorAccountId,
      );
    });
  }

  Future<void> deleteMember(int memberId, {int? actorAccountId}) async {
    await transaction(() async {
      final existing = await (select(walletMembers)..where((m) => m.id.equals(memberId))).getSingleOrNull();
      if (existing == null) return;

      await checkPermission(
        walletId: existing.walletId,
        permissionCheck: (s, r) => s.canRemoveMembers(r),
        actorAccountId: actorAccountId,
        actionName: 'remove members',
      );

      if (existing.isActive && existing.role == WalletRole.owner) {
        final ownerCount = await countActiveOwners(existing.walletId);
        if (ownerCount <= 1) {
          throw const LastOwnerException('Cannot remove the last owner of the wallet. Assign another owner first.');
        }
      }

      // Audit removal BEFORE the row becomes inaccessible, inside the same transaction.
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: existing.walletId,
          action: 'MEMBER_REMOVED',
          entityType: 'wallet_member',
          entityId: existing.accountId,
          source: 'user',
        ),
        existing.walletId,
        actorAccountId: actorAccountId,
      );

      await (delete(walletMembers)..where((m) => m.id.equals(memberId))).go();
    });
  }

  Future<int> insertInvitation(Insertable<WalletInvitation> companion) =>
      into(walletInvitations).insert(companion);

  Stream<List<WalletInvitation>> watchInvitationsForWallet(int walletId) {
    return (select(walletInvitations)..where((i) => i.walletId.equals(walletId))).watch();
  }

  Future<List<WalletInvitation>> getInvitationsForWallet(int walletId) {
    return (select(walletInvitations)..where((i) => i.walletId.equals(walletId))).get();
  }

  Future<WalletInvitation?> getInvitationById(int id) {
    return (select(walletInvitations)..where((i) => i.id.equals(id))).getSingleOrNull();
  }

  Future<WalletInvitation?> getInvitationByIdAndToken(int id, String token) {
    return (select(walletInvitations)..where((i) => i.id.equals(id) & i.token.equals(token))).getSingleOrNull();
  }

  Future<bool> updateInvitation(Insertable<WalletInvitation> companion) {
    return update(walletInvitations).replace(companion);
  }

  Future<int> consumeInvitationAtomically(int id, String token, WalletInvitationStatus expectedStatus) async {
    return await (update(walletInvitations)
          ..where((i) =>
              i.id.equals(id) &
              i.token.equals(token) &
              i.status.equals(WalletInvitationStatus.pending.name) &
              (i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(DateTime.now()))))
        .write(WalletInvitationsCompanion(
      status: Value(expectedStatus),
      respondedAt: Value(DateTime.now()),
    ));
  }

  // --- Wallet-scoped Activity operations (P2-3) ---

  Future<int> insertActivity(WalletActivitiesCompanion activity, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canCreateActivity(r),
      actorAccountId: actorAccountId,
      actionName: 'create activity',
    );
    return into(walletActivities).insert(activity);
  }

  Future<List<WalletActivity>> getActivityForWallet(int walletId, {int? limit, int? offset, int? actorAccountId, String? action, String? entityType}) async {
    final query = select(walletActivities)..where((a) => a.walletId.equals(walletId));
    if (actorAccountId != null) {
      query..where((a) => a.actorAccountId.equals(actorAccountId));
    }
    if (action != null) {
      query..where((a) => a.action.equals(action));
    }
    if (entityType != null) {
      query..where((a) => a.entityType.equals(entityType));
    }
    query..orderBy([(a) => OrderingTerm.desc(a.createdAt)]);
    if (limit != null) {
      query..limit(limit, offset: offset ?? 0);
    }
    return query.get();
  }

  Stream<List<WalletActivity>> watchActivityForWallet(int walletId, {int? limit, int? actorAccountId, String? action, String? entityType}) {
    final query = select(walletActivities)..where((a) => a.walletId.equals(walletId));
    if (actorAccountId != null) {
      query..where((a) => a.actorAccountId.equals(actorAccountId));
    }
    if (action != null) {
      query..where((a) => a.action.equals(action));
    }
    if (entityType != null) {
      query..where((a) => a.entityType.equals(entityType));
    }
    query..orderBy([(a) => OrderingTerm.desc(a.createdAt)]);
    if (limit != null) {
      query..limit(limit);
    }
    return query.watch();
  }

  Future<void> logOnboardingActivity({required int walletId, required String action}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: action,
        entityType: 'Onboarding',
        entityId: 0,
        source: 'user',
      ),
      walletId,
    );
  }

  Future<void> logWalletCreated({required int walletId, required String walletType, int? actorAccountId}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: 'WALLET_CREATED',
        entityType: 'Wallet',
        entityId: walletId,
        details: Value('Wallet type: $walletType'),
        source: 'user',
        actorAccountId: actorAccountId != null ? Value(actorAccountId) : const Value.absent(),
      ),
      walletId,
      actorAccountId: actorAccountId,
    );
  }

  Future<void> logRoleChanged({required int walletId, required int accountId, required WalletRole oldRole, required WalletRole newRole, int? actorAccountId}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: 'MEMBER_ROLE_CHANGED',
        entityType: 'WalletMember',
        entityId: accountId,
        details: Value('Role changed from ${oldRole.name} to ${newRole.name}'),
        source: 'user',
        actorAccountId: actorAccountId != null ? Value(actorAccountId) : const Value.absent(),
      ),
      walletId,
      actorAccountId: actorAccountId,
    );
  }

  Future<void> logMemberRemoved({required int walletId, required int accountId, int? actorAccountId}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: 'MEMBER_REMOVED',
        entityType: 'WalletMember',
        entityId: accountId,
        source: 'user',
        actorAccountId: actorAccountId != null ? Value(actorAccountId) : const Value.absent(),
      ),
      walletId,
      actorAccountId: actorAccountId,
    );
  }

  Future<void> logMemberAdded({required int walletId, required int accountId, int? actorAccountId}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: 'MEMBER_ADDED',
        entityType: 'WalletMember',
        entityId: accountId,
        source: 'user',
        actorAccountId: actorAccountId != null ? Value(actorAccountId) : const Value.absent(),
      ),
      walletId,
      actorAccountId: actorAccountId,
    );
  }

  Future<void> logInvitationActivity({required int walletId, required int invitationId, required String action, int? actorAccountId}) async {
    await insertActivity(
      WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: action,
        entityType: 'WalletInvitation',
        entityId: invitationId,
        source: 'user',
        actorAccountId: actorAccountId != null ? Value(actorAccountId) : const Value.absent(),
      ),
      walletId,
      actorAccountId: actorAccountId,
    );
  }

  Future<void> deleteWallet(int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canDeleteWallet(r),
      actorAccountId: actorAccountId,
      actionName: 'delete this wallet',
    );

    await transaction(() async {
      final db = attachedDatabase;

      // 1. Indirect child tables dependent on wallet entities
      await db.customStatement(
        'DELETE FROM wallet_allowance_payments WHERE allowance_id IN (SELECT id FROM wallet_allowances WHERE wallet_id = ?)',
        [walletId],
      );
      await db.customStatement(
        'DELETE FROM wallet_goal_schedules WHERE wallet_goal_id IN (SELECT id FROM wallet_goals WHERE wallet_id = ?)',
        [walletId],
      );
      await db.customStatement(
        'DELETE FROM wallet_expense_split_members WHERE split_id IN (SELECT id FROM wallet_expense_splits WHERE wallet_id = ?)',
        [walletId],
      );
      await db.customStatement(
        'DELETE FROM attachments WHERE transaction_id IN (SELECT id FROM transactions WHERE wallet_id = ?)',
        [walletId],
      );
      await db.customStatement(
        'DELETE FROM attachments WHERE transaction_id IN (SELECT id FROM transactions WHERE wallet_id = ?)',
        [walletId],
      );

      // 2. Direct wallet-owned entities
      final directTables = [
        'transactions',
        'recurring_transactions',
        'peer_debts',
        'loans',
        'accounts',
        'wallet_notifications',
        'wallet_notification_preferences',
        'wallet_bills',
        'budgets',
        'wallet_goal_contributions',
        'wallet_goals',
        'wallet_allowances',
        'wallet_settlements',
        'wallet_expense_splits',
        'wallet_members',
        'wallet_invitations',
        'merchant_mappings',
        'unrecognized_sms_entries',
        'sms_import_metrics',
        'feedback_entries',
        'payees',
        'tags',
        'wallet_activities',
      ];

      for (final table in directTables) {
        await db.customStatement('DELETE FROM $table WHERE wallet_id = ?', [walletId]);
      }

      // 3. Delete the wallet itself
      await db.customStatement('DELETE FROM wallets WHERE id = ?', [walletId]);
      db.notifyUpdates(db.allTables.map((t) => TableUpdate(t.actualTableName)).toSet());
    });
  }

  // --- Wallet-scoped Split operations (P2-2) ---

  Stream<List<WalletExpenseSplit>> watchSplitsForWallet(int walletId) {
    return (select(walletExpenseSplits)..where((s) => s.walletId.equals(walletId))).watch();
  }

  Future<List<WalletExpenseSplit>> getSplitsForWallet(int walletId) {
    return (select(walletExpenseSplits)..where((s) => s.walletId.equals(walletId))).get();
  }

  Future<WalletExpenseSplit?> getSplitById(int id, int walletId) {
    return (select(walletExpenseSplits)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).getSingleOrNull();
  }

  Future<int> insertSplit(Insertable<WalletExpenseSplit> split, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canCreateSplits(r),
      actorAccountId: actorAccountId,
      actionName: 'create splits',
    );

    int? transactionId;
    int? paidByMemberId;
    if (split is WalletExpenseSplit) {
      transactionId = split.transactionId;
      paidByMemberId = split.paidByMemberId;
    } else if (split is WalletExpenseSplitsCompanion) {
      transactionId = split.transactionId.present ? split.transactionId.value : null;
      paidByMemberId = split.paidByMemberId.present ? split.paidByMemberId.value : null;
    }

    if (transactionId != null) {
      final tid = transactionId;
      final tx = await (select(transactions)..where((t) => t.id.equals(tid) & t.walletId.equals(walletId))).getSingleOrNull();
      if (tx == null) {
        throw const WalletPermissionDeniedException('Target transaction does not belong to the target wallet.');
      }
    }
    if (paidByMemberId != null) {
      final pbid = paidByMemberId;
      final member = await (select(walletMembers)..where((m) => m.id.equals(pbid) & m.walletId.equals(walletId) & m.isActive.equals(true))).getSingleOrNull();
      if (member == null) {
        throw const WalletPermissionDeniedException('Paid-by member does not belong to the target wallet.');
      }
    }

    final scoped = split is WalletExpenseSplitsCompanion
        ? split.copyWith(walletId: Value(walletId))
        : split;
    return transaction(() async {
      final id = await into(walletExpenseSplits).insert(scoped);
      final row = await (select(walletExpenseSplits)..where((s) => s.id.equals(id))).getSingle();
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletId,
          action: 'SPLIT_CREATED',
          entityType: 'split',
          entityId: id,
          entityUuid: Value(row.uuid),
          source: 'user',
        ),
        walletId,
        actorAccountId: actorAccountId,
      );
      return id;
    });
  }

  Future<bool> updateSplit(Insertable<WalletExpenseSplit> companion, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage splits',
    );
    int? id;
    if (companion is WalletExpenseSplit) {
      id = companion.id;
    } else if (companion is WalletExpenseSplitsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final existing = await (select(walletExpenseSplits)..where((s) => s.id.equals(id!) & s.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return false;

    final query = update(walletExpenseSplits)..where((s) => s.id.equals(id!) & s.walletId.equals(walletId));
    return transaction(() async {
      final count = await query.write(companion);
      if (count > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'SPLIT_UPDATED',
            entityType: 'split',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return count > 0;
    });
  }

  Future<int> deleteSplit(int id, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage splits',
    );
    // Capture uuid before deletion (the row will be gone after delete).
    final existing = await (select(walletExpenseSplits)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return 0;
    return transaction(() async {
      final deleted = await (delete(walletExpenseSplits)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).go();
      if (deleted > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'SPLIT_DELETED',
            entityType: 'split',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return deleted;
    });
  }

  // --- Wallet-scoped Split Member operations (P2-2) ---

  Stream<List<WalletExpenseSplitMember>> watchSplitMembersForWallet(int walletId) {
    final query = select(walletExpenseSplitMembers).join([
      innerJoin(walletExpenseSplits, walletExpenseSplits.id.equalsExp(walletExpenseSplitMembers.splitId)),
    ])..where(walletExpenseSplits.walletId.equals(walletId));
    return query.watch().map((rows) => rows.map((r) => r.readTable(walletExpenseSplitMembers)).toList());
  }

  Future<List<WalletExpenseSplitMember>> getSplitMembersForSplit(int splitId, int walletId) async {
    final query = select(walletExpenseSplitMembers).join([
      innerJoin(walletExpenseSplits, walletExpenseSplits.id.equalsExp(walletExpenseSplitMembers.splitId)),
    ])..where(walletExpenseSplitMembers.splitId.equals(splitId) & walletExpenseSplits.walletId.equals(walletId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(walletExpenseSplitMembers)).toList();
  }

  Future<int> insertSplitMember(Insertable<WalletExpenseSplitMember> member, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canCreateSplits(r),
      actorAccountId: actorAccountId,
      actionName: 'create split members',
    );

    int? splitId;
    int? memberId;
    if (member is WalletExpenseSplitMember) {
      splitId = member.splitId;
      memberId = member.memberId;
    } else if (member is WalletExpenseSplitMembersCompanion) {
      splitId = member.splitId.present ? member.splitId.value : null;
      memberId = member.memberId.present ? member.memberId.value : null;
    }

    if (splitId == null || memberId == null) {
      throw const WalletPermissionDeniedException('Split member requires both splitId and memberId.');
    }

    final sid = splitId;
    final split = await (select(walletExpenseSplits)..where((s) => s.id.equals(sid) & s.walletId.equals(walletId))).getSingleOrNull();
    if (split == null) {
      throw const WalletPermissionDeniedException('Target split does not belong to the target wallet.');
    }

    final mid = memberId;
    final walletMember = await (select(walletMembers)..where((m) => m.id.equals(mid) & m.walletId.equals(walletId) & m.isActive.equals(true))).getSingleOrNull();
    if (walletMember == null) {
      throw const WalletPermissionDeniedException('Target member does not belong to the target wallet.');
    }

    return into(walletExpenseSplitMembers).insert(member);
  }

  Future<bool> updateSplitMember(Insertable<WalletExpenseSplitMember> companion, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage split members',
    );
    int? id;
    if (companion is WalletExpenseSplitMember) {
      id = companion.id;
    } else if (companion is WalletExpenseSplitMembersCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;
    final memberId = id;

    final existing = await (select(walletExpenseSplitMembers)..where((m) => m.id.equals(memberId))).getSingleOrNull();
    if (existing == null) return false;
    final split = await (select(walletExpenseSplits)..where((s) => s.id.equals(existing.splitId) & s.walletId.equals(walletId))).getSingleOrNull();
    if (split == null) return false;

    final query = update(walletExpenseSplitMembers)..where((m) => m.id.equals(memberId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteSplitMember(int id, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage split members',
    );
    final existing = await (select(walletExpenseSplitMembers)..where((m) => m.id.equals(id))).getSingleOrNull();
    if (existing == null) return 0;
    final split = await (select(walletExpenseSplits)..where((s) => s.id.equals(existing.splitId) & s.walletId.equals(walletId))).getSingleOrNull();
    if (split == null) return 0;
    return (delete(walletExpenseSplitMembers)..where((m) => m.id.equals(id))).go();
  }

  // --- Wallet-scoped Settlement operations (P2-2) ---

  Stream<List<WalletSettlement>> watchSettlementsForWallet(int walletId) {
    return (select(walletSettlements)..where((s) => s.walletId.equals(walletId))).watch();
  }

  Future<List<WalletSettlement>> getSettlementsForWallet(int walletId) {
    return (select(walletSettlements)..where((s) => s.walletId.equals(walletId))).get();
  }

  Future<WalletSettlement?> getSettlementById(int id, int walletId) {
    return (select(walletSettlements)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).getSingleOrNull();
  }

  Future<int> insertSettlement(Insertable<WalletSettlement> settlement, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage settlements',
    );

    int? payerMemberId;
    int? receiverMemberId;
    if (settlement is WalletSettlement) {
      payerMemberId = settlement.payerMemberId;
      receiverMemberId = settlement.receiverMemberId;
    } else if (settlement is WalletSettlementsCompanion) {
      payerMemberId = settlement.payerMemberId.present ? settlement.payerMemberId.value : null;
      receiverMemberId = settlement.receiverMemberId.present ? settlement.receiverMemberId.value : null;
    }

    if (payerMemberId != null) {
      final pid = payerMemberId;
      final member = await (select(walletMembers)..where((m) => m.id.equals(pid) & m.walletId.equals(walletId) & m.isActive.equals(true))).getSingleOrNull();
      if (member == null) {
        throw const WalletPermissionDeniedException('Payer member does not belong to the target wallet.');
      }
    }
    if (receiverMemberId != null) {
      final rid = receiverMemberId;
      final member = await (select(walletMembers)..where((m) => m.id.equals(rid) & m.walletId.equals(walletId) & m.isActive.equals(true))).getSingleOrNull();
      if (member == null) {
        throw const WalletPermissionDeniedException('Receiver member does not belong to the target wallet.');
      }
    }

    final scoped = settlement is WalletSettlementsCompanion
        ? settlement.copyWith(walletId: Value(walletId))
        : settlement;
    return transaction(() async {
      final id = await into(walletSettlements).insert(scoped);
      final row = await (select(walletSettlements)..where((s) => s.id.equals(id))).getSingle();
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletId,
          action: 'SETTLEMENT_CREATED',
          entityType: 'settlement',
          entityId: id,
          entityUuid: Value(row.uuid),
          source: 'user',
        ),
        walletId,
        actorAccountId: actorAccountId,
      );
      return id;
    });
  }

  Future<bool> updateSettlement(Insertable<WalletSettlement> companion, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage settlements',
    );
    int? id;
    if (companion is WalletSettlement) {
      id = companion.id;
    } else if (companion is WalletSettlementsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final existing = await (select(walletSettlements)..where((s) => s.id.equals(id!) & s.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return false;

    final query = update(walletSettlements)..where((s) => s.id.equals(id!) & s.walletId.equals(walletId));
    return transaction(() async {
      final count = await query.write(companion);
      if (count > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'SETTLEMENT_UPDATED',
            entityType: 'settlement',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return count > 0;
    });
  }

  Future<int> deleteSettlement(int id, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageSettlements(r),
      actorAccountId: actorAccountId,
      actionName: 'manage settlements',
    );
    // Capture uuid before deletion (the row will be gone after delete).
    final existing = await (select(walletSettlements)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return 0;
    return transaction(() async {
      final deleted = await (delete(walletSettlements)..where((s) => s.id.equals(id) & s.walletId.equals(walletId))).go();
      if (deleted > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'SETTLEMENT_DELETED',
            entityType: 'settlement',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return deleted;
    });
  }

  // --- Wallet-scoped PeerDebt operations (P2-2) ---

  Future<List<PeerDebtDb>> getPeerDebtsForWallet(int walletId) {
    return (select(peerDebts)..where((pd) => pd.walletId.equals(walletId))).get();
  }

  Future<PeerDebtDb?> getPeerDebtById(int id, int walletId) {
    return (select(peerDebts)..where((pd) => pd.id.equals(id) & pd.walletId.equals(walletId))).getSingleOrNull();
  }

  Future<int> insertPeerDebt(Insertable<PeerDebtDb> peerDebt, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageDebts(r),
      actorAccountId: actorAccountId,
      actionName: 'manage debts',
    );

    int? transactionId;
    if (peerDebt is PeerDebtDb) {
      transactionId = peerDebt.transactionId;
    } else if (peerDebt is PeerDebtsCompanion) {
      transactionId = peerDebt.transactionId.present ? peerDebt.transactionId.value : null;
    }

    if (transactionId != null) {
      final tid = transactionId;
      final tx = await (select(transactions)..where((t) => t.id.equals(tid) & t.walletId.equals(walletId))).getSingleOrNull();
      if (tx == null) {
        throw const WalletPermissionDeniedException('Target transaction does not belong to the target wallet.');
      }
    }

    final scoped = peerDebt is PeerDebtsCompanion
        ? peerDebt.copyWith(walletId: Value(walletId))
        : peerDebt;
    return transaction(() async {
      final id = await into(peerDebts).insert(scoped);
      final row = await (select(peerDebts)..where((pd) => pd.id.equals(id))).getSingle();
      await insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletId,
          action: 'PEER_DEBT_CREATED',
          entityType: 'peer_debt',
          entityId: id,
          entityUuid: Value(row.uuid),
          source: 'user',
        ),
        walletId,
        actorAccountId: actorAccountId,
      );
      return id;
    });
  }

  Future<bool> updatePeerDebt(Insertable<PeerDebtDb> companion, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageDebts(r),
      actorAccountId: actorAccountId,
      actionName: 'manage debts',
    );
    int? id;
    if (companion is PeerDebtDb) {
      id = companion.id;
    } else if (companion is PeerDebtsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final existing = await (select(peerDebts)..where((pd) => pd.id.equals(id!) & pd.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return false;

    final query = update(peerDebts)..where((pd) => pd.id.equals(id!) & pd.walletId.equals(walletId));
    return transaction(() async {
      final count = await query.write(companion);
      if (count > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'PEER_DEBT_UPDATED',
            entityType: 'peer_debt',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return count > 0;
    });
  }

  Future<int> deletePeerDebt(int id, int walletId, {int? actorAccountId}) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageDebts(r),
      actorAccountId: actorAccountId,
      actionName: 'manage debts',
    );
    // Capture uuid before deletion (the row will be gone after delete).
    final existing = await (select(peerDebts)..where((pd) => pd.id.equals(id) & pd.walletId.equals(walletId))).getSingleOrNull();
    if (existing == null) return 0;
    return transaction(() async {
      final deleted = await (delete(peerDebts)..where((pd) => pd.id.equals(id) & pd.walletId.equals(walletId))).go();
      if (deleted > 0) {
        await insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletId,
            action: 'PEER_DEBT_DELETED',
            entityType: 'peer_debt',
            entityId: existing.id,
            entityUuid: Value(existing.uuid),
            source: 'user',
          ),
          walletId,
          actorAccountId: actorAccountId,
        );
      }
      return deleted;
    });
  }
}

@DriftAccessor(tables: [Tags, Transactions])

@DriftAccessor(tables: [Payees])
class PayeeDao extends DatabaseAccessor<AppDatabase> with _$PayeeDaoMixin {
  PayeeDao(AppDatabase db) : super(db);
  Stream<List<Payee>> watchPayees() => select(attachedDatabase.payees).watch();
  Future<int> insertPayee(Insertable<Payee> payee) => into(attachedDatabase.payees).insert(payee);
}

@DriftAccessor(tables: [Tags])
class TransactionTagDao extends DatabaseAccessor<AppDatabase> with _$TransactionTagDaoMixin {
  TransactionTagDao(AppDatabase db) : super(db);
  Future<void> setTagsForTransaction(int txId, List<int> tags) async {}
}

@DriftAccessor(tables: [Attachments, Transactions])
class AttachmentDao extends DatabaseAccessor<AppDatabase> with _$AttachmentDaoMixin {
  AttachmentDao(AppDatabase db) : super(db);
  Future<void> insertAttachment(dynamic a) async {}
}

@DriftAccessor(tables: [WalletAllowances, WalletAllowancePayments])
class AllowanceDao extends DatabaseAccessor<AppDatabase> with _$AllowanceDaoMixin {
  AllowanceDao(AppDatabase db) : super(db);

  Stream<List<WalletAllowance>> watchAllowancesForWallet(int walletId) {
    return (select(walletAllowances)..where((a) => a.walletId.equals(walletId))).watch();
  }

  Future<List<WalletAllowance>> getAllowancesForWallet(int walletId) {
    return (select(walletAllowances)..where((a) => a.walletId.equals(walletId))).get();
  }

  Future<WalletAllowance?> getAllowanceById(int id, [int? walletId]) {
    final query = select(walletAllowances)..where((a) => a.id.equals(id));
    if (walletId != null) {
      query.where((a) => a.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertAllowance(Insertable<WalletAllowance> allowance, [int? walletId]) async {
    if (walletId != null) {
      if (allowance is WalletAllowancesCompanion && allowance.walletId.present) {
        if (allowance.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot create allowance for another wallet.');
        }
      }
    }
    return into(walletAllowances).insert(allowance);
  }

  Future<bool> updateAllowance(Insertable<WalletAllowance> companion, [int? walletId]) async {
    if (walletId == null) {
      return update(walletAllowances).replace(companion);
    }
    int? id;
    if (companion is WalletAllowance) {
      id = companion.id;
    } else if (companion is WalletAllowancesCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletAllowances)..where((a) => a.id.equals(id!) & a.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteAllowance(int id, [int? walletId]) async {
    final query = delete(walletAllowances)..where((a) => a.id.equals(id));
    if (walletId != null) {
      query.where((a) => a.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletAllowancePayment>> watchPaymentsForWallet(int walletId) {
    final query = select(walletAllowancePayments).join([
      innerJoin(walletAllowances, walletAllowances.id.equalsExp(walletAllowancePayments.allowanceId)),
    ])..where(walletAllowances.walletId.equals(walletId));

    return query.watch().map((rows) => rows.map((r) => r.readTable(walletAllowancePayments)).toList());
  }

  Future<List<WalletAllowancePayment>> getPaymentsForWallet(int walletId) async {
    final query = select(walletAllowancePayments).join([
      innerJoin(walletAllowances, walletAllowances.id.equalsExp(walletAllowancePayments.allowanceId)),
    ])..where(walletAllowances.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(walletAllowancePayments)).toList();
  }

  Future<int> insertPayment(Insertable<WalletAllowancePayment> payment, [int? walletId]) async {
    if (walletId != null) {
      int? allowanceId;
      if (payment is WalletAllowancePayment) {
        allowanceId = payment.allowanceId;
      } else if (payment is WalletAllowancePaymentsCompanion && payment.allowanceId.present) {
        allowanceId = payment.allowanceId.value;
      }
      if (allowanceId != null) {
        final allowance = await getAllowanceById(allowanceId, walletId);
        if (allowance == null) {
          throw const WalletPermissionDeniedException('Target allowance does not belong to the target wallet.');
        }
      }
    }
    return into(walletAllowancePayments).insert(payment);
  }

  Future<int> deletePayment(int id, [int? walletId]) async {
    if (walletId == null) {
      return (delete(walletAllowancePayments)..where((p) => p.id.equals(id))).go();
    }
    final allowedAllowanceIds = selectOnly(walletAllowances)
      ..addColumns([walletAllowances.id])
      ..where(walletAllowances.walletId.equals(walletId));

    final query = delete(walletAllowancePayments)
      ..where((p) => p.id.equals(id) & p.allowanceId.isInQuery(allowedAllowanceIds));

    return query.go();
  }
}

@DriftAccessor(tables: [WalletBills])
class BillDao extends DatabaseAccessor<AppDatabase> with _$BillDaoMixin {
  BillDao(AppDatabase db) : super(db);

  Stream<List<WalletBill>> watchBillsForWallet(int walletId) {
    return (select(walletBills)..where((b) => b.walletId.equals(walletId))).watch();
  }

  Future<List<WalletBill>> getBillsForWallet(int walletId) {
    return (select(walletBills)..where((b) => b.walletId.equals(walletId))).get();
  }

  Future<WalletBill?> getBillById(int id, [int? walletId]) {
    final query = select(walletBills)..where((b) => b.id.equals(id));
    if (walletId != null) {
      query.where((b) => b.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertBill(Insertable<WalletBill> bill, [int? walletId]) async {
    if (walletId != null) {
      if (bill is WalletBillsCompanion && bill.walletId.present) {
        if (bill.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot create bill for another wallet.');
        }
      }
    }
    return into(walletBills).insert(bill);
  }

  Future<bool> updateBill(Insertable<WalletBill> companion, [int? walletId]) async {
    if (walletId == null) {
      return update(walletBills).replace(companion);
    }
    int? id;
    if (companion is WalletBill) {
      id = companion.id;
    } else if (companion is WalletBillsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletBills)..where((b) => b.id.equals(id!) & b.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteBill(int id, [int? walletId]) async {
    final query = delete(walletBills)..where((b) => b.id.equals(id));
    if (walletId != null) {
      query.where((b) => b.walletId.equals(walletId));
    }
    return query.go();
  }

  Future<bool> updateBillStatus(int id, WalletBillStatus status, [int? walletId]) async {
    return updateBill(
      WalletBillsCompanion(
        id: Value(id),
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
      walletId,
    );
  }
}


@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  // Get All: Returns a stream that automatically updates when the data changes.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  // Create
  Future<int> insertCategory(Insertable<Category> category) => into(categories).insert(category);

  // Update
  Future<bool> updateCategory(Insertable<Category> category) => update(categories).replace(category);

  // Delete
  Future<int> deleteCategory(int id) => (delete(categories)..where((c) => c.id.equals(id))).go();

  // Get by ID
  Future<Category?> getCategoryById(int id) => (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
}

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Stream<List<Account>> watchAllAccounts([int? walletId]) {
    if (walletId != null) {
      return (select(accounts)..where((a) => a.walletId.equals(walletId))).watch();
    }
    return select(accounts).watch();
  }

  Future<int> insertAccount(Insertable<Account> account, [int? walletId]) {
    if (walletId != null && account is AccountsCompanion) {
      return into(accounts).insert(account.copyWith(walletId: Value(walletId)));
    }
    return into(accounts).insert(account);
  }

  Future<bool> updateAccount(Insertable<Account> companion, [int? walletId]) async {
    int? accountId;
    if (companion is Account) {
      accountId = companion.id;
    } else if (companion is AccountsCompanion) {
      accountId = companion.id.present ? companion.id.value : null;
    }

    if (accountId != null && walletId != null) {
      final updatedRows = await (update(accounts)
            ..where((a) => a.id.equals(accountId!) & a.walletId.equals(walletId)))
          .write(companion);
      return updatedRows > 0;
    }

    return update(accounts).replace(companion);
  }

  Future<int> deleteAccount(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(accounts)..where((a) => a.id.equals(id) & a.walletId.equals(walletId))).go();
    }
    return (delete(accounts)..where((a) => a.id.equals(id))).go();
  }

  Future<Account?> getAccountById(int id, [int? walletId]) {
    if (walletId != null) {
      return (select(accounts)..where((a) => a.id.equals(id) & a.walletId.equals(walletId))).getSingleOrNull();
    }
    return (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  Future<int> countTransactionsForAccount(int accountId, [int? walletId]) async {
    final count = countAll();
    final query = selectOnly(transactions)..addColumns([count]);
    if (walletId != null) {
      query.where(transactions.accountId.equals(accountId) & transactions.walletId.equals(walletId));
    } else {
      query.where(transactions.accountId.equals(accountId));
    }
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<double> getBalanceForAccount(Account account, [int? walletId]) async {
    final query = select(transactions);
    if (walletId != null) {
      query.where((t) => t.accountId.equals(account.id) & t.walletId.equals(walletId));
    } else {
      query.where((t) => t.accountId.equals(account.id));
    }
    final accountTransactions = await query.get();
    var balance = account.openingBalance;
    final isLiability = account.type == AccountType.creditCard || account.type == AccountType.loan;
    for (final tx in accountTransactions) {
      if (isLiability) {
        balance += tx.type == TransactionType.expense ? tx.amount : -tx.amount;
      } else {
        balance += tx.type == TransactionType.income ? tx.amount : -tx.amount;
      }
    }
    return balance;
  }

  Future<Map<int, double>> getBalancesForAccounts(List<Account> targetAccounts, [int? walletId]) async {
    if (targetAccounts.isEmpty) {
      return const {};
    }

    final accountIds = targetAccounts.map((account) => account.id).toList();
    final accountRows = await (select(this.accounts)..where((a) => a.id.isIn(accountIds))).get();
    final query = select(transactions);
    if (walletId != null) {
      query.where((t) => t.accountId.isIn(accountIds) & t.walletId.equals(walletId));
    } else {
      query.where((t) => t.accountId.isIn(accountIds));
    }
    final transactionsByAccount = await query.get();

    final balances = <int, double>{
      for (final account in accountRows) account.id: account.openingBalance,
    };
    final accountTypeById = {for (final account in accountRows) account.id: account.type};

    for (final tx in transactionsByAccount) {
      final accountType = accountTypeById[tx.accountId];
      if (accountType == null) {
        continue;
      }

      final isLiability = accountType == AccountType.creditCard || accountType == AccountType.loan;
      final delta = isLiability
          ? (tx.type == TransactionType.expense ? tx.amount : -tx.amount)
          : (tx.type == TransactionType.income ? tx.amount : -tx.amount);
      balances[tx.accountId] = (balances[tx.accountId] ?? 0) + delta;
    }

    return balances;
  }

}

// Helper class to hold joined data
class TransactionWithCategory {
  final Transaction transaction;
  final Category category;

  TransactionWithCategory({required this.transaction, required this.category});
}

class TransactionWithDetails {
  final Transaction transaction;
  final Category category;
  final Account account;

  TransactionWithDetails({
    required this.transaction,
    required this.category,
    required this.account,
  });
}

// Helper class to hold joined Budget data
class BudgetWithCategory {
  final Budget budget;
  final Category category;

  BudgetWithCategory({required this.budget, required this.category});
}

// Helper class for trend data
class MonthlyTotal {
  final int year;
  final int month;
  final double total;
  MonthlyTotal({required this.year, required this.month, required this.total});
}

class MonthlySummaryTotals {
  final double totalIncome;
  final double totalExpense;

  MonthlySummaryTotals({required this.totalIncome, required this.totalExpense});
}

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  List<TransactionWithDetails> _mapTransactionRows(List<TypedResult> rows) {
    return rows.map((row) {
      return TransactionWithDetails(
        transaction: row.readTable(transactions),
        category: row.readTable(categories),
        account: row.readTable(accounts),
      );
    }).toList();
  }

  // Add
  /// Moves every transaction from one category to another.
  ///
  /// Deleting a category must never orphan its history (the lists inner-join
  /// categories, so orphaned rows silently vanish from the UI while still
  /// counting in balances) nor erase it (`transactions.categoryId` cascades if
  /// foreign keys are ever enabled). Callers reassign first, then delete.
  Future<int> reassignTransactionsForCategory(
    int fromCategoryId,
    int toCategoryId, [
    int? walletId,
  ]) {
    final query = update(transactions)
      ..where((t) => t.categoryId.equals(fromCategoryId));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.write(TransactionsCompanion(categoryId: Value(toCategoryId)));
  }

  /// Moves every transaction from one account to another. Accounts use
  /// `restrict` on delete, so this is what lets an account be removed without
  /// rejecting the delete or losing its history.
  Future<int> reassignTransactionsForAccount(
    int fromAccountId,
    int toAccountId, [
    int? walletId,
  ]) {
    final query = update(transactions)
      ..where((t) => t.accountId.equals(fromAccountId));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.write(TransactionsCompanion(accountId: Value(toAccountId)));
  }

  Future<int> insertTransaction(Insertable<Transaction> transaction, [int? walletId]) {
    if (walletId != null && transaction is TransactionsCompanion) {
      transaction = transaction.copyWith(walletId: Value(walletId));
    }
    return into(transactions).insert(transaction);
  }

  // Edit (with cross-wallet guard)
  Future<bool> updateTransaction(Insertable<Transaction> transaction, [int? walletId]) async {
    if (transaction is TransactionsCompanion && transaction.id.present) {
      final targetWalletId = walletId ?? (transaction.walletId.present ? transaction.walletId.value : null);
      if (targetWalletId != null) {
        final rows = await (update(transactions)
          ..where((t) => t.id.equals(transaction.id.value) & t.walletId.equals(targetWalletId)))
          .write(transaction);
        return rows > 0;
      }
    } else if (transaction is Transaction) {
      final targetWalletId = walletId ?? transaction.walletId;
      final rows = await (update(transactions)
        ..where((t) => t.id.equals(transaction.id) & t.walletId.equals(targetWalletId)))
        .write(transaction);
      return rows > 0;
    }
    return update(transactions).replace(transaction);
  }

  // Delete (with cross-wallet guard)
  Future<int> deleteTransaction(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(transactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).go();
    }
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  // Get single transaction by ID with wallet isolation
  Future<Transaction?> getTransactionById(int id, [int? walletId]) {
    final query = select(transactions)..where((t) => t.id.equals(id));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  // Get transaction with details by ID with wallet isolation
  Future<TransactionWithDetails?> getTransactionWithDetailsById(int id, [int? walletId]) async {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])..where(transactions.id.equals(id));
    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return _mapTransactionRows(rows).first;
  }

  // Get By Month
  Stream<List<TransactionWithDetails>> watchTransactionsInMonth(DateTime month, [int? walletId]) {
    final firstDay = DateTime(month.year, month.month, 1);
    // Half-open range [firstDay, nextMonthStart) so transactions on the last
    // day of the month (which carry a time of day) are not dropped.
    final nextMonthStart = DateTime(month.year, month.month + 1, 1);

    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..where(transactions.date.isBiggerOrEqualValue(firstDay) &
          transactions.date.isSmallerThanValue(nextMonthStart))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get recent transactions
  Stream<List<TransactionWithDetails>> watchRecentTransactions({int limit = 10, int? walletId}) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)])
      ..limit(limit);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get all transactions (watches changes)
  Stream<List<TransactionWithDetails>> watchAllTransactions([int? walletId]) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)]);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get monthly expenses for trend report
  Future<List<MonthlyTotal>> getMonthlyExpensesForLastNMonths(int n, [int? walletId]) async {
    final now = DateTime.now();
    // Go back n-1 months from the start of the current month
    final startDate = DateTime(now.year, now.month - (n - 1), 1);

    final year = transactions.date.year;
    final month = transactions.date.month;
    final totalAmount = transactions.amount.sum();

    final query = selectOnly(transactions)
      ..addColumns([year, month, totalAmount])
      ..where(transactions.type.equalsValue(TransactionType.expense) & transactions.date.isBiggerOrEqualValue(startDate));

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    query.groupBy([year, month]);

    return query.map((row) {
      return MonthlyTotal(
          year: row.read(year)!, month: row.read(month)!, total: Money.toMajorUnits(row.read(totalAmount) ?? 0));
    }).get();
  }

  Future<MonthlySummaryTotals> getMonthlySummaryTotals(DateTime month, [int? walletId]) async {
    final firstDay = DateTime(month.year, month.month, 1);
    // Half-open range [firstDay, nextMonthStart) so transactions on the last
    // day of the month (which carry a time of day) are not dropped.
    final nextMonthStart = DateTime(month.year, month.month + 1, 1);

    final incomeSum = transactions.amount.sum();
    final expenseSum = transactions.amount.sum();

    final incomeQuery = selectOnly(transactions)
      ..addColumns([incomeSum])
      ..where(
        transactions.type.equalsValue(TransactionType.income) &
            transactions.date.isBiggerOrEqualValue(firstDay) &
            transactions.date.isSmallerThanValue(nextMonthStart) &
            transactions.transferGroupId.isNull(),
      );
    if (walletId != null) {
      incomeQuery.where(transactions.walletId.equals(walletId));
    }
    final incomeRow = await incomeQuery.getSingle();

    final expenseQuery = selectOnly(transactions)
      ..addColumns([expenseSum])
      ..where(
        transactions.type.equalsValue(TransactionType.expense) &
            transactions.date.isBiggerOrEqualValue(firstDay) &
            transactions.date.isSmallerThanValue(nextMonthStart) &
            transactions.transferGroupId.isNull(),
      );
    if (walletId != null) {
      expenseQuery.where(transactions.walletId.equals(walletId));
    }
    final expenseRow = await expenseQuery.getSingle();

    return MonthlySummaryTotals(
      // Summed in SQL as exact minor units, converted once at the boundary.
      totalIncome: Money.toMajorUnits(incomeRow.read(incomeSum) ?? 0),
      totalExpense: Money.toMajorUnits(expenseRow.read(expenseSum) ?? 0),
    );
  }
}

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(AppDatabase db) : super(db);

  // Add
  Future<int> insertBudget(Insertable<Budget> budget) => into(budgets).insert(budget);

  // Update with wallet ownership check
  Future<bool> updateBudget(int walletId, Insertable<Budget> budget) async {
    if (budget is BudgetsCompanion && budget.id.present) {
      final rows = await (update(budgets)
        ..where((b) => b.id.equals(budget.id.value) & b.walletId.equals(walletId)))
        .write(budget);
      return rows > 0;
    }
    return update(budgets).replace(budget);
  }

  // Delete with wallet ownership check
  Future<int> deleteBudget(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(budgets)..where((b) => b.id.equals(id) & b.walletId.equals(walletId))).go();
    }
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  Future<Budget?> getBudgetById(int id, [int? walletId]) {
    if (walletId != null) {
      return (select(budgets)..where((b) => b.id.equals(id) & b.walletId.equals(walletId))).getSingleOrNull();
    }
    return (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  // Watch budgets with category for a specific wallet
  Stream<List<BudgetWithCategory>> watchBudgetsWithCategory(int walletId) {
    final query = select(budgets).join([
      innerJoin(categories, categories.id.equalsExp(budgets.categoryId)),
    ])..where(budgets.walletId.equals(walletId));

    return query.watch().map((rows) {
      return rows.map((row) {
        return BudgetWithCategory(
          budget: row.readTable(budgets),
          category: row.readTable(categories),
        );
      }).toList();
    });
  }

  // Get budgets with category for a specific wallet
  Future<List<BudgetWithCategory>> getBudgetsForWallet(int walletId) async {
    final query = select(budgets).join([
      innerJoin(categories, categories.id.equalsExp(budgets.categoryId)),
    ])..where(budgets.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((row) {
      return BudgetWithCategory(
        budget: row.readTable(budgets),
        category: row.readTable(categories),
      );
    }).toList();
  }

  // Watch all budgets with their categories (legacy/fallback)
  Stream<List<BudgetWithCategory>> watchAllBudgetsWithCategory() {
    final query = select(budgets).join([
      innerJoin(categories, categories.id.equalsExp(budgets.categoryId)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return BudgetWithCategory(
          budget: row.readTable(budgets),
          category: row.readTable(categories),
        );
      }).toList();
    });
  }
}

// Recurring Transactions Table


// Deleted Records Table for Sync Tracking


// Loans Table


// Peer Debts Table


class RecurringTransactionWithDetails {
  final RecurringTransactionDb template;
  final Category category;
  final Account account;

  RecurringTransactionWithDetails({
    required this.template,
    required this.category,
    required this.account,
  });
}

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class RecurringTransactionDao extends DatabaseAccessor<AppDatabase> with _$RecurringTransactionDaoMixin {
  RecurringTransactionDao(AppDatabase db) : super(db);

  List<RecurringTransactionWithDetails> _mapRows(List<TypedResult> rows) {
    return rows.map((row) {
      return RecurringTransactionWithDetails(
        template: row.readTable(recurringTransactions),
        category: row.readTable(categories),
        account: row.readTable(accounts),
      );
    }).toList();
  }

  Stream<List<RecurringTransactionWithDetails>> watchAllWithDetails(int walletId) {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.walletId.equals(walletId))
      ..orderBy([OrderingTerm.desc(recurringTransactions.nextDueDate)]);
    return query.watch().map(_mapRows);
  }

  Future<List<RecurringTransactionWithDetails>> getActiveTemplatesWithDetails(int walletId) async {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.isActive.equals(true) & recurringTransactions.walletId.equals(walletId));
    final rows = await query.get();
    return _mapRows(rows);
  }

  Future<RecurringTransactionWithDetails?> getById(int id, int walletId) async {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.id.equals(id) & recurringTransactions.walletId.equals(walletId));
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return _mapRows(rows).first;
  }

  Future<int> insertTemplate(Insertable<RecurringTransactionDb> template, int walletId) {
    final scoped = template is RecurringTransactionsCompanion
        ? template.copyWith(walletId: Value(walletId))
        : template;
    return into(recurringTransactions).insert(scoped);
  }

  Future<bool> updateTemplate(Insertable<RecurringTransactionDb> template, int walletId) {
    final scoped = template is RecurringTransactionsCompanion
        ? template.copyWith(walletId: Value(walletId))
        : template;
    return (update(recurringTransactions)..where((t) => t.walletId.equals(walletId))).replace(scoped);
  }

  /// Updates a template and verifies it actually belongs to the wallet.
  /// Returns true if the update succeeded, false if the record doesn't belong to the wallet.
  Future<bool> updateTemplateVerified(RecurringTransactionsCompanion template, int walletId) async {
    final id = template.id;
    if (id is! Value<int>) return false;
    final count = await (update(recurringTransactions)
          ..where((t) => t.id.equals(id.value) & t.walletId.equals(walletId)))
        .write(template);
    return count > 0;
  }

  Future<int> deleteTemplate(int id, int walletId) =>
      (delete(recurringTransactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).go();

  /// Returns the walletId of the given account, or null if the account does not exist.
  Future<int?> getAccountWalletId(int accountId) async {
    final account = await (select(accounts)..where((a) => a.id.equals(accountId))).getSingleOrNull();
    if (account == null) return null;
    return account.walletId;
  }
}

// --- DATABASE CLASS ---

@DriftDatabase(
  tables: [Accounts, WalletBills, Budgets, Categories, WalletNotifications, Loans, PeerDebts, WalletAllowances, WalletAllowancePayments, WalletSettlements, Wallets, WalletInvitations, WalletMembers, WalletGoals, WalletGoalContributions, WalletGoalSchedules, FeedbackEntries, WalletNotificationPreferences, DeletedRecords, Attachments, WalletExpenseSplits, WalletExpenseSplitMembers, MerchantMappings, Payees, RecurringTransactions, SmsImportMetrics, Tags, Transactions, UnrecognizedSmsEntries, WalletActivities],
  daos: [CategoryDao, AccountDao, TransactionDao, BudgetDao, RecurringTransactionDao, DebtsDao, WalletDao, TransactionTagDao, AttachmentDao, AllowanceDao, GoalDao, BillDao, PayeeDao, SmsParsingDao, SmsImportMetricsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 13;

  Future<int> insertDeletedRecord(String uuid, String tableName) {
    /* return into(deletedRecords).insert(
      DeletedRecordsCompanion.insert(
        uuid: uuid,
        deletedTable: tableName,
      ),
    ); */ return Future.value(0);
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await batch((batch) {
          batch.insertAll(accounts, DefaultAccounts.defaultAccounts);
          batch.insertAll(categories, DefaultCategories.defaultCategories);
        });

        // Create Deletion Triggers for fresh db
        
        
        
        
        
        
        
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(accounts);
          await batch((batch) {
            batch.insertAll(accounts, DefaultAccounts.defaultAccounts);
          });
          await m.addColumn(transactions, transactions.accountId);
          await customStatement('UPDATE transactions SET account_id = 1 WHERE account_id IS NULL');
        }
        if (from < 3) {
          await m.createTable(recurringTransactions);
        }
        if (from < 4) {
          await m.addColumn(categories, categories.parentId);
        }
        if (from < 5) {
          await m.addColumn(accounts, accounts.uuid);
          await m.addColumn(accounts, accounts.updatedAt);
          await m.addColumn(categories, categories.uuid);
          await m.addColumn(categories, categories.updatedAt);
          await m.addColumn(transactions, transactions.uuid);
          await m.addColumn(budgets, budgets.uuid);
          await m.addColumn(budgets, budgets.updatedAt);
          await m.addColumn(recurringTransactions, recurringTransactions.uuid);
          await m.addColumn(recurringTransactions, recurringTransactions.updatedAt);
          // await m.createTable(deletedRecords);

          // Populate UUIDs for existing records
          await customStatement("UPDATE accounts SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL");
          await customStatement("UPDATE categories SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL");
          await customStatement("UPDATE transactions SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL");
          await customStatement("UPDATE budgets SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL");
          await customStatement("UPDATE recurring_transactions SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL");

          // Set updatedAt default
          final nowIso = DateTime.now().toIso8601String();
          await customStatement("UPDATE accounts SET updated_at = '$nowIso' WHERE updated_at IS NULL");
          await customStatement("UPDATE categories SET updated_at = '$nowIso' WHERE updated_at IS NULL");
          await customStatement("UPDATE budgets SET updated_at = '$nowIso' WHERE updated_at IS NULL");
          await customStatement("UPDATE recurring_transactions SET updated_at = '$nowIso' WHERE updated_at IS NULL");

          // Create Triggers
          
          
          
          
          
        }
        if (from < 6) {
          // await m.createTable(loans);
          // await m.createTable(peerDebts);

          
          
        }
        if (from < 7) {
          await m.addColumn(budgets, budgets.walletId);
          await customStatement('UPDATE budgets SET wallet_id = 1 WHERE wallet_id IS NULL');
        }
        if (from < 8) {
          await m.addColumn(recurringTransactions, recurringTransactions.walletId);
          // Backfill: assign wallet_id from the referenced account's wallet_id
          await customStatement(
            'UPDATE recurring_transactions SET wallet_id = (SELECT wallet_id FROM accounts WHERE accounts.id = recurring_transactions.account_id) WHERE account_id IS NOT NULL',
          );
          // Check for orphaned records (account_id is NULL or account has no wallet)
          final orphanResult = await customSelect(
            'SELECT COUNT(*) AS c FROM recurring_transactions WHERE wallet_id IS NULL',
          ).getSingle();
          final orphanCount = orphanResult.read<int>('c');
          if (orphanCount > 0) {
            throw StateError(
              'Migration to schema v8 failed: $orphanCount recurring transaction(s) have no resolvable wallet via their account. '
              'Orphaned records must be resolved manually before upgrading.',
            );
          }
        }
        if (from < 9) {
          // P2-2: Harden peer_debts.wallet_id — remove unsafe DEFAULT 1 and add FK to wallets.id.
          // Also add uuid columns to splits and settlements so they participate in UUID-based sync deletion.

          // Step 0: Add uuid columns to splits and settlements (existing tables), then backfill.
          await m.addColumn(walletExpenseSplits, walletExpenseSplits.uuid);
          await customStatement(
            "UPDATE wallet_expense_splits SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL",
          );
          await m.addColumn(walletSettlements, walletSettlements.uuid);
          await customStatement(
            "UPDATE wallet_settlements SET uuid = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE uuid IS NULL",
          );

          // Step 1: Backfill wallet_id deterministically from the linked transaction's wallet_id.
          await customStatement(
            'UPDATE peer_debts SET wallet_id = ('
            'SELECT t.wallet_id FROM transactions t WHERE t.id = peer_debts.transaction_id'
            ') WHERE transaction_id IS NOT NULL',
          );

          // Step 2: Identify orphan records (NULL wallet_id or wallet_id referencing a non-existent wallet).
          final orphanResult = await customSelect(
            'SELECT uuid FROM peer_debts WHERE wallet_id IS NULL OR wallet_id NOT IN (SELECT id FROM wallets)',
          ).get();
          if (orphanResult.isNotEmpty) {
            final orphanUuids = orphanResult.map((r) => r.read<String>('uuid')).join(', ');
            throw StateError(
              'Migration to schema v9 failed: ${orphanResult.length} peer debt(s) have no resolvable wallet ownership. '
              'Orphan UUIDs: $orphanUuids. '
              'Orphaned records must be resolved manually before upgrading.',
            );
          }

          // Step 3: Recreate the table with the FK constraint (SQLite cannot ADD CONSTRAINT to an existing column).
          // peer_debts has no triggers (triggers are commented out in onCreate), so a plain rebuild is safe.
          await customStatement(
            'CREATE TABLE peer_debts_v9 ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'wallet_id INTEGER NOT NULL REFERENCES wallets(id) ON DELETE CASCADE, '
            'uuid TEXT NOT NULL DEFAULT (lower(hex(randomblob(16)))), '
            'person_name TEXT NOT NULL, '
            'type INTEGER NOT NULL, '
            'amount REAL NOT NULL, '
            'note TEXT, '
            'date TEXT NOT NULL, '
            'is_settled INTEGER NOT NULL DEFAULT 0, '
            'transaction_id INTEGER REFERENCES transactions(id) ON DELETE SET NULL, '
            'updated_at TEXT NOT NULL DEFAULT (strftime(\'%Y-%m-%dT%H:%M:%f\', \'now\'))'
            ')',
          );
          await customStatement(
            'INSERT INTO peer_debts_v9 (id, wallet_id, uuid, person_name, type, amount, note, date, is_settled, transaction_id, updated_at) '
            'SELECT id, wallet_id, uuid, person_name, type, amount, note, date, is_settled, transaction_id, updated_at FROM peer_debts',
          );
          await customStatement('DROP TABLE peer_debts');
          await customStatement('ALTER TABLE peer_debts_v9 RENAME TO peer_debts');
        }
        if (from < 10) {
          // P2-3: Add wallet_activities table for audit trail
          await m.createTable(walletActivities);
        }
        if (from < 11) {
          // P2-5: Add secure token column to WalletInvitations
          await m.addColumn(walletInvitations, walletInvitations.token);
          await customStatement("UPDATE wallet_invitations SET token = lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-a' || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6))) WHERE token IS NULL OR token = ''");
        }
        if (from < 12) {
          // A2: link the two legs of a transfer so they can be excluded from
          // income/expense totals and edited or deleted as a unit.
          await m.addColumn(transactions, transactions.transferGroupId);
        }
      },
    );
  }

  Future<void> resetDatabase() async {
    // This will delete all data from all tables
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
    await batch((batch) {
      batch.insertAll(accounts, DefaultAccounts.defaultAccounts);
      batch.insertAll(categories, DefaultCategories.defaultCategories);
    });
  }
}

@DriftAccessor(tables: [WalletGoals, WalletGoalContributions, WalletGoalSchedules])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  Stream<List<WalletGoal>> watchGoals(int walletId) {
    return (select(walletGoals)..where((g) => g.walletId.equals(walletId))).watch();
  }

  Future<List<WalletGoal>> getGoalsForWallet(int walletId) {
    return (select(walletGoals)..where((g) => g.walletId.equals(walletId))).get();
  }

  Future<WalletGoal?> getGoalById(int id, [int? walletId]) {
    final query = select(walletGoals)..where((g) => g.id.equals(id));
    if (walletId != null) {
      query.where((g) => g.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertGoal(Insertable<WalletGoal> goal, [int? walletId]) async {
    if (walletId != null) {
      if (goal is WalletGoalsCompanion && goal.walletId.present) {
        if (goal.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot create goal for another wallet.');
        }
      }
    }
    return into(walletGoals).insert(goal);
  }

  Future<bool> updateGoal(Insertable<WalletGoal> companion, [int? walletId]) async {
    if (walletId == null) {
      return update(walletGoals).replace(companion);
    }
    int? id;
    if (companion is WalletGoal) {
      id = companion.id;
    } else if (companion is WalletGoalsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletGoals)..where((g) => g.id.equals(id!) & g.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteGoal(int id, [int? walletId]) async {
    final query = delete(walletGoals)..where((g) => g.id.equals(id));
    if (walletId != null) {
      query.where((g) => g.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletGoalContribution>> watchContributionsForGoal(int goalId, [int? walletId]) {
    final query = select(walletGoalContributions)..where((c) => c.goalId.equals(goalId));
    if (walletId != null) {
      query.where((c) => c.walletId.equals(walletId));
    }
    return query.watch();
  }

  Stream<List<WalletGoalContribution>> watchContributionsForWallet(int walletId) {
    return (select(walletGoalContributions)..where((c) => c.walletId.equals(walletId))).watch();
  }

  Future<List<WalletGoalContribution>> getContributionsForWallet(int walletId) {
    return (select(walletGoalContributions)..where((c) => c.walletId.equals(walletId))).get();
  }

  Future<int> addContribution(Insertable<WalletGoalContribution> contribution, [int? walletId]) async {
    if (walletId != null) {
      if (contribution is WalletGoalContributionsCompanion && contribution.walletId.present) {
        if (contribution.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot add contribution for another wallet.');
        }
      }
      int? goalId;
      if (contribution is WalletGoalContribution) {
        goalId = contribution.goalId;
      } else if (contribution is WalletGoalContributionsCompanion && contribution.goalId.present) {
        goalId = contribution.goalId.value;
      }
      if (goalId != null) {
        final goal = await getGoalById(goalId, walletId);
        if (goal == null) {
          throw const WalletPermissionDeniedException('Target goal does not belong to the target wallet.');
        }
      }
    }

    return transaction(() async {
      final id = await into(walletGoalContributions).insert(contribution);

      double amount = 0;
      int goalId = 0;
      if (contribution is WalletGoalContribution) {
        amount = contribution.amount;
        goalId = contribution.goalId;
      } else if (contribution is WalletGoalContributionsCompanion) {
        amount = contribution.amount.value;
        goalId = contribution.goalId.value;
      }

      if (goalId > 0 && amount > 0) {
        final goal = await getGoalById(goalId);
        if (goal != null) {
          await (update(walletGoals)..where((g) => g.id.equals(goalId))).write(
            WalletGoalsCompanion(
              currentAmount: Value(goal.currentAmount + amount),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      return id;
    });
  }

  Future<int> deleteContribution(int id, [int? walletId]) async {
    final query = delete(walletGoalContributions)..where((c) => c.id.equals(id));
    if (walletId != null) {
      query.where((c) => c.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletGoalSchedule>> watchSchedulesForWallet(int walletId) {
    final query = select(walletGoalSchedules).join([
      innerJoin(walletGoals, walletGoals.id.equalsExp(walletGoalSchedules.walletGoalId)),
    ])..where(walletGoals.walletId.equals(walletId));

    return query.watch().map((rows) => rows.map((r) => r.readTable(walletGoalSchedules)).toList());
  }

  Future<List<WalletGoalSchedule>> getSchedulesForWallet(int walletId) async {
    final query = select(walletGoalSchedules).join([
      innerJoin(walletGoals, walletGoals.id.equalsExp(walletGoalSchedules.walletGoalId)),
    ])..where(walletGoals.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(walletGoalSchedules)).toList();
  }

  Future<int> addSchedule(Insertable<WalletGoalSchedule> schedule, [int? walletId]) async {
    if (walletId != null) {
      int? goalId;
      if (schedule is WalletGoalSchedule) {
        goalId = schedule.walletGoalId;
      } else if (schedule is WalletGoalSchedulesCompanion && schedule.walletGoalId.present) {
        goalId = schedule.walletGoalId.value;
      }
      if (goalId != null) {
        final goal = await getGoalById(goalId, walletId);
        if (goal == null) {
          throw const WalletPermissionDeniedException('Target goal does not belong to the target wallet.');
        }
      }
    }
    return into(walletGoalSchedules).insert(schedule);
  }

  Future<int> deleteSchedule(int id, [int? walletId]) async {
    if (walletId == null) {
      return (delete(walletGoalSchedules)..where((s) => s.id.equals(id))).go();
    }
    final allowedGoalIds = selectOnly(walletGoals)
      ..addColumns([walletGoals.id])
      ..where(walletGoals.walletId.equals(walletId));

    final query = delete(walletGoalSchedules)
      ..where((s) => s.id.equals(id) & s.walletGoalId.isInQuery(allowedGoalIds));

    return query.go();
  }

  Future<void> logGoalActivity({required int walletId, required String action, required int goalId, int? actorAccountId}) async {
    // Log goal activity helper if needed
  }
}


/// File name of the on-device SQLite database. Shared with the backup/restore
/// service (`core/services/backup_service.dart`) so both agree on the location.
const String kDatabaseFileName = 'db.sqlite';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, kDatabaseFileName));

    // A3: encrypt at rest with a random key held in the platform keystore
    // (option (a) - the PIN stays a UI gate, so a PIN reset cannot lose data).
    // Every failure path falls back to plaintext rather than leaving the app
    // unable to open its own database.
    String? resolvedKey;
    try {
      final store = SecureStorageKeyValueStore();
      final key = await DatabaseEncryption.getOrCreateKey(store);
      if (DatabaseEncryption.isPlaintextFile(file)) {
        final migrated = await DatabaseEncryption.migrateToEncrypted(
          file: file,
          base64Key: key,
        );
        resolvedKey = migrated ? key : null;
      } else {
        resolvedKey = key;
        // The database is already encrypted and opening fine, so the plaintext
        // copy from the one-time migration must not be left lying around.
        await DatabaseEncryption.purgePlaintextBackup(file);
      }
    } catch (_) {
      resolvedKey = null;
    }

    DatabaseSetup? setup;
    if (resolvedKey != null) {
      final key = resolvedKey;
      setup = (raw) => raw.execute(DatabaseEncryption.pragmaForKey(key));
    }

    // The loader override must also be applied inside the background isolate:
    // `open` is per-isolate, and without this drift falls back to the plain
    // libsqlite3.so, which is not bundled when using SQLCipher.
    return NativeDatabase.createInBackground(
      file,
      isolateSetup: () {
        useSqlCipher();
      },
      setup: setup,
    );
  });
}
