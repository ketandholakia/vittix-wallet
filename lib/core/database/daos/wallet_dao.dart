part of '../app_database.dart';

@DriftAccessor(tables: [Wallets, WalletMembers, WalletInvitations, WalletSettlements, WalletExpenseSplits, WalletExpenseSplitMembers, PeerDebts, Transactions, WalletActivities])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(AppDatabase db) : super(db);

  Future<WalletRole?> getRoleInWallet(
    int walletId, {
    int? actorAccountId,
    int? actorUserId,
  }) async {
    if (actorAccountId == null && actorUserId == null) return null;
    final query = select(walletMembers)
      ..where((m) =>
          m.walletId.equals(walletId) &
          m.isActive.equals(true) &
          // A7 step 3: prefer the real identity when supplied, otherwise fall
          // back to the legacy money-account path until every call site has
          // been migrated.
          (actorUserId != null
              ? m.userId.equals(actorUserId)
              : m.accountId.equals(actorAccountId!)));
    final list = await query.get();
    return list.isEmpty ? null : list.first.role;
  }

  Future<void> checkPermission({
    required int walletId,
    required bool Function(WalletPermissionService service, WalletRole? role) permissionCheck,
    int? actorAccountId,
    int? actorUserId,
    String actionName = 'this operation',
  }) async {
    if (actorAccountId == null && actorUserId == null) return;
    final role = await getRoleInWallet(
      walletId,
      actorAccountId: actorAccountId,
      actorUserId: actorUserId,
    );
    const service = WalletPermissionService();
    if (!permissionCheck(service, role)) {
      throw WalletPermissionDeniedException(
        'Permission denied: You do not have permission to $actionName for wallet $walletId.',
      );
    }
  }

  Future<bool> isWalletValid(int walletId, {int? actorAccountId, int? actorUserId}) async {
    final wallet = await (select(wallets)..where((w) => w.id.equals(walletId))).getSingleOrNull();
    if (wallet == null) return false;

    if (actorAccountId != null || actorUserId != null) {
      final role = await getRoleInWallet(
        walletId,
        actorAccountId: actorAccountId,
        actorUserId: actorUserId,
      );
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

  Future<int> insertMember(Insertable<WalletMember> member, {int? actorAccountId, int? actorUserId}) async {
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
        actorUserId: actorUserId,
      );
      return id;
    });
  }

  Future<bool> updateMember(Insertable<WalletMember> companion, {int? actorAccountId, int? actorUserId}) async {
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
            actorUserId: actorUserId,
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
              final actorRole = await getRoleInWallet(existing.walletId, actorAccountId: actorAccountId, actorUserId: actorUserId);
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
            actorUserId: actorUserId,
          );
        }
      }

      return replaced;
    });
  }

  Future<void> deactivateMember(int walletId, int accountId, {int? actorAccountId, int? actorUserId}) async {
    await transaction(() async {
      await checkPermission(
        walletId: walletId,
        permissionCheck: (s, r) => s.canRemoveMembers(r),
        actorAccountId: actorAccountId,
        actorUserId: actorUserId,
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
        actorUserId: actorUserId,
      );
    });
  }

  Future<void> deleteMember(int memberId, {int? actorAccountId, int? actorUserId}) async {
    await transaction(() async {
      final existing = await (select(walletMembers)..where((m) => m.id.equals(memberId))).getSingleOrNull();
      if (existing == null) return;

      await checkPermission(
        walletId: existing.walletId,
        permissionCheck: (s, r) => s.canRemoveMembers(r),
        actorAccountId: actorAccountId,
        actorUserId: actorUserId,
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
        actorUserId: actorUserId,
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

  Future<int> insertActivity(
    WalletActivitiesCompanion activity,
    int walletId, {
    int? actorAccountId,
    int? actorUserId,
  }) async {
    await checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canCreateActivity(r),
      actorAccountId: actorAccountId,
      actorUserId: actorUserId,
      actionName: 'create activity',
    );
    // A7 step 3 slice 2: record whoever acted. The helper previously used the
    // actor only for the permission check and never stamped it on the row, so
    // audit events did not say who did anything. Prefer the real user identity,
    // falling back to the legacy account actor.
    var row = activity;
    if (actorUserId != null) {
      row = row.copyWith(actorUserId: Value(actorUserId));
    } else if (actorAccountId != null) {
      row = row.copyWith(actorAccountId: Value(actorAccountId));
    }
    return into(walletActivities).insert(row);
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

  Future<void> logMemberAdded({required int walletId, required int accountId, int? actorAccountId, int? actorUserId}) async {
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
      actorUserId: actorUserId,
    );
  }

  Future<void> logInvitationActivity({required int walletId, required int invitationId, required String action, int? actorAccountId, int? actorUserId}) async {
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
      actorUserId: actorUserId,
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
