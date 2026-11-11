part of 'sync_service.dart';

/// Per-entity upsert handlers used by the [SyncNotifier] coordinator.
extension SyncEntityUpserts on SyncNotifier {
  Future<void> _upsertWalletMember(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletMember.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet member sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletMembers,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet member mutation rejected for member ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletMembers).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletMembers).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletInvitation(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletInvitation.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet invitation sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletInvitations,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet invitation mutation rejected for invitation ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletInvitations).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletInvitations).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletNotification(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletNotification.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet notification sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletNotifications,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet notification mutation rejected for notification ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletNotifications).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletNotifications).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletNotificationPreference(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletNotificationPreference.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet notification preference sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletNotificationPreferences,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet notification preference mutation rejected for pref ${item.id}',
      );
    }
    if (existing == null) {
      await db
          .into(db.walletNotificationPreferences)
          .insert(item.toCompanion(false));
    } else {
      await db
          .update(db.walletNotificationPreferences)
          .replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoal(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletGoal.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet goal sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletGoals,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet goal mutation rejected for goal ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletGoals).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletGoals).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoalContribution(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletGoalContribution.fromJson(data);
    final parentGoal = await (db.select(
      db.walletGoals,
    )..where((g) => g.id.equals(item.goalId))).getSingleOrNull();
    if (parentGoal == null || parentGoal.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet goal contribution parent rejected for goal ${item.goalId}',
      );
    }
    final existing = await (db.select(
      db.walletGoalContributions,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletGoalContributions).insert(item.toCompanion(false));
    } else {
      await db
          .update(db.walletGoalContributions)
          .replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletAllowance(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletAllowance.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet allowance sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletAllowances,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet allowance mutation rejected for allowance ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletAllowances).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletAllowances).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletAllowancePayment(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletAllowancePayment.fromJson(data);
    final parentAllowance = await (db.select(
      db.walletAllowances,
    )..where((a) => a.id.equals(item.allowanceId))).getSingleOrNull();
    if (parentAllowance == null || parentAllowance.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet allowance payment parent rejected for allowance ${item.allowanceId}',
      );
    }
    final existing = await (db.select(
      db.walletAllowancePayments,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletAllowancePayments).insert(item.toCompanion(false));
    } else {
      await db
          .update(db.walletAllowancePayments)
          .replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoalSchedule(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletGoalSchedule.fromJson(data);
    final parentGoal = await (db.select(
      db.walletGoals,
    )..where((g) => g.id.equals(item.walletGoalId))).getSingleOrNull();
    if (parentGoal == null || parentGoal.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet goal schedule parent rejected for goal ${item.walletGoalId}',
      );
    }
    final existing = await (db.select(
      db.walletGoalSchedules,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletGoalSchedules).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletGoalSchedules).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletBill(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletBill.fromJson(data);
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet bill sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletBills,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet bill mutation rejected for bill ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletBills).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletBills).replace(item.toCompanion(false));
    }
  }

  /// Records a concurrent remote edit instead of dropping it silently.
  Future<void> _recordSyncConflict(
    int walletId,
    String entity,
    Map<String, dynamic> data,
    DateTime localUpdatedAt,
  ) async {
    final uuid = data['uuid'] as String;
    final remoteUpdatedAt = _parseDateTime(data['updatedAt']);
    // Deduplicate: every sync echoes unchanged rows, and they must not grow an
    // unbounded conflict log.
    final existing =
        await (db.select(db.syncConflicts)
              ..where(
                (c) =>
                    c.entity.equals(entity) &
                    c.uuid.equals(uuid) &
                    c.remoteUpdatedAt.equals(remoteUpdatedAt),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return;

    await db
        .into(db.syncConflicts)
        .insert(
          SyncConflictsCompanion.insert(
            walletId: Value(walletId),
            entity: entity,
            uuid: uuid,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            remoteJson: jsonEncode(_jsonSafeValue(data)),
          ),
        );
  }

  Future<bool> _hasAnyTombstone(String uuid, String table) async {
    final row =
        await (db.select(db.deletedRecords)
              ..where((d) => d.uuid.equals(uuid) & d.deletedTable.equals(table))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  Future<void> _deleteTombstone(String uuid, String table) async {
    await (db.delete(
      db.deletedRecords,
    )..where((d) => d.uuid.equals(uuid) & d.deletedTable.equals(table))).go();
  }

  Future<void> _upsertWalletExpenseSplit(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletExpenseSplit.fromJson(data);
    if (await _hasAnyTombstone(item.uuid, 'wallet_expense_splits')) return;
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet split sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletExpenseSplits,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet split mutation rejected for split ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletExpenseSplits).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletExpenseSplits).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletSettlement(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final item = WalletSettlement.fromJson(data);
    if (await _hasAnyTombstone(item.uuid, 'wallet_settlements')) return;
    if (item.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet settlement sync payload rejected (${item.walletId} != $targetWalletId)',
      );
    }
    final existing = await (db.select(
      db.walletSettlements,
    )..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing != null && existing.walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet settlement mutation rejected for settlement ${item.id}',
      );
    }
    if (existing == null) {
      await db.into(db.walletSettlements).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletSettlements).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWallet(
    Map<String, dynamic> data,
    int targetWalletId,
  ) async {
    final walletId = data['id'] as int;
    final updatedAt = _parseDateTime(data['updatedAt'] ?? data['createdAt']);
    final tombstone =
        await (db.select(db.deletedRecords)
              ..where(
                (d) =>
                    d.uuid.equals(data['uuid'] as String) &
                    d.deletedTable.equals('wallets'),
              )
              ..orderBy([(d) => OrderingTerm.desc(d.deletedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (tombstone != null && !tombstone.deletedAt.isBefore(updatedAt)) return;
    if (walletId != targetWalletId) {
      throw WalletPermissionDeniedException(
        'Cross-wallet sync payload wallet mismatch ($walletId != $targetWalletId)',
      );
    }
    final existing = await db
        .customSelect(
          'SELECT id FROM wallets WHERE id = ?',
          variables: [Variable<int>(walletId)],
        )
        .getSingleOrNull();
    final createdAt = data['createdAt'] ?? data['updatedAt'];
    final companion = WalletsCompanion(
      id: Value(walletId),
      uuid: Value(data['uuid'] as String),
      name: Value(data['name'] as String),
      type: Value(data['type'] as String),
      createdByAccountId: Value(data['createdByAccountId'] as int?),
      createdAt: Value(_parseDateTime(createdAt)),
    );
    if (existing == null) {
      await db.into(db.wallets).insert(companion);
    } else {
      await db.update(db.wallets).replace(companion);
    }
  }
}
