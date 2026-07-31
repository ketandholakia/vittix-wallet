// BROKEN DEPENDENCY: db.walletActivities
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/database_provider.dart';

enum SyncStatus { idle, syncing, success, error }
const int syncApiVersion = 1;
const String _syncDeviceIdKey = 'syncDeviceId';

Map<String, String> buildSyncHeaders({required String deviceId, required String token}) {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'X-Sync-Api-Version': syncApiVersion.toString(),
    'X-Device-Id': deviceId,
  };
  if (token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

class SyncState {
  final SyncStatus status;
  final String? errorMessage;
  SyncState({required this.status, this.errorMessage});
}

// Provider for SyncState
final syncStateProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final db = ref.watch(databaseProvider);
  return SyncNotifier(ref, db);
});

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref ref;
  final AppDatabase db;

  SyncNotifier(this.ref, this.db) : super(SyncState(status: SyncStatus.idle));

  Future<String> _deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_syncDeviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final generated = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    await prefs.setString(_syncDeviceIdKey, generated);
    return generated;
  }

  DateTime _parseDateTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  AccountType _parseAccountType(dynamic value) {
    if (value is String) {
      return AccountType.values.byName(value);
    } else if (value is int) {
      return AccountType.values[value];
    }
    throw ArgumentError("Invalid AccountType value: $value");
  }

  TransactionType _parseTransactionType(dynamic value) {
    if (value is String) {
      return TransactionType.values.byName(value);
    } else if (value is int) {
      return TransactionType.values[value];
    }
    throw ArgumentError("Invalid TransactionType value: $value");
  }

  PeerDebtType _parsePeerDebtType(dynamic value) {
    if (value is String) {
      return PeerDebtType.values.byName(value);
    } else if (value is int) {
      return PeerDebtType.values[value];
    }
    throw ArgumentError("Invalid PeerDebtType value: $value");
  }

  dynamic _jsonSafeValue(dynamic value) {
    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }
    if (value is Map) {
      return value.map((key, child) => MapEntry(key, _jsonSafeValue(child)));
    }
    if (value is Iterable) {
      return value.map(_jsonSafeValue).toList();
    }
    return value;
  }

  Future<void> _upsertWalletMember(Map<String, dynamic> data) async {
    final item = WalletMember.fromJson(data);
    final existing = await (db.select(db.walletMembers)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletMembers).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletMembers).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletInvitation(Map<String, dynamic> data) async {
    final item = WalletInvitation.fromJson(data);
    final existing = await (db.select(db.walletInvitations)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletInvitations).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletInvitations).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletActivity(Map<String, dynamic> data) async {
    final item = WalletActivity.fromJson(data);
    final existing = await (db.select(db.walletActivities)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletActivities).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletActivities).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletNotification(Map<String, dynamic> data) async {
    final item = WalletNotification.fromJson(data);
    final existing = await (db.select(db.walletNotifications)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletNotifications).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletNotifications).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletNotificationPreference(Map<String, dynamic> data) async {
    final item = WalletNotificationPreference.fromJson(data);
    final existing = await (db.select(db.walletNotificationPreferences)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletNotificationPreferences).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletNotificationPreferences).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoal(Map<String, dynamic> data) async {
    final item = WalletGoal.fromJson(data);
    final existing = await (db.select(db.walletGoals)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletGoals).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletGoals).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoalContribution(Map<String, dynamic> data) async {
    final item = WalletGoalContribution.fromJson(data);
    final existing = await (db.select(db.walletGoalContributions)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletGoalContributions).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletGoalContributions).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletAllowance(Map<String, dynamic> data) async {
    final item = WalletAllowance.fromJson(data);
    final existing = await (db.select(db.walletAllowances)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletAllowances).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletAllowances).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletAllowancePayment(Map<String, dynamic> data) async {
    final item = WalletAllowancePayment.fromJson(data);
    final existing = await (db.select(db.walletAllowancePayments)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletAllowancePayments).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletAllowancePayments).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletGoalSchedule(Map<String, dynamic> data) async {
    final item = WalletGoalSchedule.fromJson(data);
    final existing = await (db.select(db.walletGoalSchedules)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletGoalSchedules).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletGoalSchedules).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletBill(Map<String, dynamic> data) async {
    final item = WalletBill.fromJson(data);
    final existing = await (db.select(db.walletBills)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletBills).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletBills).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletExpenseSplit(Map<String, dynamic> data) async {
    final item = WalletExpenseSplit.fromJson(data);
    final existing = await (db.select(db.walletExpenseSplits)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletExpenseSplits).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletExpenseSplits).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWalletSettlement(Map<String, dynamic> data) async {
    final item = WalletSettlement.fromJson(data);
    final existing = await (db.select(db.walletSettlements)..where((m) => m.id.equals(item.id))).getSingleOrNull();
    if (existing == null) {
      await db.into(db.walletSettlements).insert(item.toCompanion(false));
    } else {
      await db.update(db.walletSettlements).replace(item.toCompanion(false));
    }
  }

  Future<void> _upsertWallet(Map<String, dynamic> data) async {
    final walletId = data['id'] as int;
    final existing = await db.customSelect(
      'SELECT id FROM wallets WHERE id = ?',
      variables: [Variable<int>(walletId)],
    ).getSingleOrNull();
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

  Future<Map<String, dynamic>?> _readWalletForSync(int walletId) async {
    final row = await db.customSelect(
      '''
      SELECT id, uuid, name, type, created_by_account_id AS createdByAccountId,
             CAST(strftime('%s', created_at) AS INTEGER) * 1000 AS createdAtMs
      FROM wallets
      WHERE id = ?
      ''',
      variables: [Variable<int>(walletId)],
    ).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return {
      'id': row.data['id'] as int,
      'uuid': row.data['uuid'] as String,
      'name': row.data['name'] as String,
      'type': row.data['type'] as String,
      'createdByAccountId': row.data['createdByAccountId'] as int?,
      'createdAt': DateTime.fromMillisecondsSinceEpoch((row.data['createdAtMs'] as int?) ?? 0),
      'updatedAt': DateTime.fromMillisecondsSinceEpoch((row.data['createdAtMs'] as int?) ?? 0),
    };
  }

  Future<void> performSync() async {
    state = SyncState(status: SyncStatus.syncing);
    try {
      final isSimulated = ref.read(isSimulatedSyncProvider);
      final syncUrl = ref.read(syncUrlProvider);
      final token = ref.read(syncTokenProvider);
      final lastSyncDateTime = ref.read(lastSyncTimeProvider);
      final walletId = ref.read(currentWalletIdProvider);
      final deviceId = await _deviceId();

      if (!isSimulated && syncUrl.isEmpty) {
        throw Exception("Sync URL is not configured. Please check your settings.");
      }

      // 1. Change detection
      final cutoff = lastSyncDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);

      // Query local changes in parallel.
      final localAccountsFuture = (db.select(db.accounts)
            ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
          .get();
      final localCategoriesFuture = (db.select(db.categories)..where((t) => t.updatedAt.isBiggerThanValue(cutoff))).get();
      final localTransactionsFuture = (db.select(db.transactions)
            ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
          .get();
      final localBudgetsFuture = (db.select(db.budgets)..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff))).get();
      final localRecurringFuture = (db.select(db.recurringTransactions)
            ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
          .get();
      final localLoansFuture = (db.select(db.loans)..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff))).get();
      final localPeerDebtsFuture = (db.select(db.peerDebts)..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff))).get();
      final localWalletFuture = _readWalletForSync(walletId);
      final localMembersFuture = (db.select(db.walletMembers)..where((t) => t.walletId.equals(walletId))).get();
      final localInvitationsFuture = (db.select(db.walletInvitations)..where((t) => t.walletId.equals(walletId))).get();
      final localActivitiesFuture = (db.select(db.walletActivities)..where((t) => t.walletId.equals(walletId))).get();
      final localNotificationsFuture = (db.select(db.walletNotifications)..where((t) => t.walletId.equals(walletId))).get();
      final localNotificationPreferencesFuture = (db.select(db.walletNotificationPreferences)..where((t) => t.walletId.equals(walletId))).get();
      final localGoalsFuture = (db.select(db.walletGoals)..where((t) => t.walletId.equals(walletId))).get();
      final localGoalContributionsFuture = (db.select(db.walletGoalContributions)..where((t) => t.walletId.equals(walletId))).get();
      final localAllowancesFuture = (db.select(db.walletAllowances)..where((t) => t.walletId.equals(walletId))).get();
      final localAllowancePaymentsFuture = (db.select(db.walletAllowancePayments).join([
        innerJoin(db.walletAllowances, db.walletAllowances.id.equalsExp(db.walletAllowancePayments.allowanceId)),
      ])..where(db.walletAllowances.walletId.equals(walletId)))
          .get();
      final localGoalSchedulesFuture = (db.select(db.walletGoalSchedules).join([
        innerJoin(db.walletGoals, db.walletGoals.id.equalsExp(db.walletGoalSchedules.walletGoalId)),
      ])..where(db.walletGoals.walletId.equals(walletId)))
          .get();
      final localBillsFuture = (db.select(db.walletBills)..where((t) => t.walletId.equals(walletId))).get();
      final localSplitsFuture = (db.select(db.walletExpenseSplits)..where((t) => t.walletId.equals(walletId))).get();
      final localSettlementsFuture = (db.select(db.walletSettlements)..where((t) => t.walletId.equals(walletId))).get();
      final localDeletionsFuture = db.select(db.deletedRecords).get();

      final localAccounts = await localAccountsFuture;
      final localCategories = await localCategoriesFuture;
      final localTransactions = await localTransactionsFuture;
      final localBudgets = await localBudgetsFuture;
      final localRecurring = await localRecurringFuture;
      final localLoans = await localLoansFuture;
      final localPeerDebts = await localPeerDebtsFuture;
      final localWallet = await localWalletFuture;
      final localMembers = await localMembersFuture;
      final localInvitations = await localInvitationsFuture;
      final localActivities = await localActivitiesFuture;
      final localNotifications = await localNotificationsFuture;
      final localNotificationPreferences = await localNotificationPreferencesFuture;
      final localGoals = await localGoalsFuture;
      final localGoalContributions = await localGoalContributionsFuture;
      final localAllowances = await localAllowancesFuture;
      final localAllowancePayments = await localAllowancePaymentsFuture;
      final localGoalSchedules = await localGoalSchedulesFuture;
      final localBills = await localBillsFuture;
      final localSplits = await localSplitsFuture;
      final localSettlements = await localSettlementsFuture;
      final localDeletionsList = await localDeletionsFuture;

      // 2. Build mapping maps
      final allAccountsFuture = (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
      final allCategoriesFuture = db.select(db.categories).get();
      final allTransactionsFuture = (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
      final allAccounts = await allAccountsFuture;
      final allCategories = await allCategoriesFuture;
      final allTransactions = await allTransactionsFuture;
      final accountIdToUuid = { for (final a in allAccounts) a.id: a.uuid };
      final categoryIdToUuid = { for (final c in allCategories) c.id: c.uuid };
      final transactionIdToUuid = { for (final t in allTransactions) t.id: t.uuid };

      // 3. Serialize local changes
      final accountsJson = localAccounts.map((a) => a.toJson()).toList();
      
      final categoriesJson = localCategories.map((c) {
        final map = c.toJson();
        if (c.parentId != null) {
          map['parentUuid'] = categoryIdToUuid[c.parentId];
        } else {
          map['parentUuid'] = null;
        }
        return map;
      }).toList();

      final transactionsJson = localTransactions.map((t) {
        final map = t.toJson();
        map['categoryUuid'] = categoryIdToUuid[t.categoryId];
        map['accountUuid'] = accountIdToUuid[t.accountId];
        return map;
      }).toList();

      final budgetsJson = localBudgets.map((b) {
        final map = b.toJson();
        map['categoryUuid'] = categoryIdToUuid[b.categoryId];
        return map;
      }).toList();

      final recurringJson = localRecurring.map((r) {
        final map = r.toJson();
        map['categoryUuid'] = categoryIdToUuid[r.categoryId];
        map['accountUuid'] = accountIdToUuid[r.accountId];
        return map;
      }).toList();

      final loansJson = localLoans.map((l) {
        final map = l.toJson();
        map['accountUuid'] = accountIdToUuid[l.accountId];
        map['walletId'] = walletId;
        return map;
      }).toList();

      final peerDebtsJson = localPeerDebts.map((pd) {
        final map = pd.toJson();
        if (pd.transactionId != null) {
          map['transactionUuid'] = transactionIdToUuid[pd.transactionId];
        } else {
          map['transactionUuid'] = null;
        }
        map['walletId'] = walletId;
        return map;
      }).toList();

      final walletsJson = localWallet == null ? <dynamic>[] : [localWallet];
      final walletMembersJson = localMembers.map((m) => m.toJson()).toList();
      final walletInvitationsJson = localInvitations.map((i) => i.toJson()).toList();
      final walletActivitiesJson = localActivities.map((a) => a.toJson()).toList();
      final walletNotificationsJson = localNotifications.map((n) => n.toJson()).toList();
      final walletNotificationPreferencesJson = localNotificationPreferences.map((p) => p.toJson()).toList();
      final walletGoalsJson = localGoals.map((g) => g.toJson()).toList();
      final walletGoalContributionsJson = localGoalContributions.map((c) => c.toJson()).toList();
      final walletAllowancesJson = localAllowances.map((a) => a.toJson()).toList();
      final walletAllowancePaymentsJson = localAllowancePayments.map((row) => row.readTable(db.walletAllowancePayments).toJson()).toList();
      final walletGoalSchedulesJson = localGoalSchedules.map((row) => row.readTable(db.walletGoalSchedules).toJson()).toList();
      final walletBillsJson = localBills.map((b) => b.toJson()).toList();
      final walletSplitsJson = localSplits.map((s) => s.toJson()).toList();
      final walletSettlementsJson = localSettlements.map((s) => s.toJson()).toList();

      final deletionsJson = localDeletionsList.map((d) => {
        'uuid': d.uuid,
        'tableName': d.deletedTable,
        'deletedAt': d.deletedAt.millisecondsSinceEpoch,
      }).toList();

      // Complete sync payload
      final payload = {
        'syncApiVersion': syncApiVersion,
        'lastSyncTime': cutoff.millisecondsSinceEpoch,
        'deviceId': deviceId,
        'changes': {
          'accounts': accountsJson,
          'categories': categoriesJson,
          'transactions': transactionsJson,
          'budgets': budgetsJson,
          'recurring_transactions': recurringJson,
          'loans': loansJson,
          'peer_debts': peerDebtsJson,
          'wallets': walletsJson,
          'wallet_members': walletMembersJson,
          'wallet_invitations': walletInvitationsJson,
          'wallet_activities': walletActivitiesJson,
          'wallet_notifications': walletNotificationsJson,
          'wallet_notification_preferences': walletNotificationPreferencesJson,
          'wallet_goals': walletGoalsJson,
          'wallet_goal_contributions': walletGoalContributionsJson,
          'wallet_allowances': walletAllowancesJson,
          'wallet_allowance_payments': walletAllowancePaymentsJson,
          'wallet_goal_schedules': walletGoalSchedulesJson,
          'wallet_bills': walletBillsJson,
          'wallet_expense_splits': walletSplitsJson,
          'wallet_settlements': walletSettlementsJson,
        },
        'deletions': deletionsJson,
        'walletId': walletId,
      };

      Map<String, dynamic> responseData;

      if (isSimulated) {
        // Run Simulated Server Sync
        responseData = await _runSimulatedServerSync(payload, cutoff);
      } else {
        // Run Actual REST Request
        final headers = buildSyncHeaders(deviceId: deviceId, token: token);
        final response = await http.post(
          Uri.parse(syncUrl),
          headers: headers,
          body: jsonEncode(payload),
        );

        if (response.statusCode != 200) {
          throw Exception("Server returned status code ${response.statusCode}: ${response.body}");
        }
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
      }

      // 4. Apply incoming remote changes & deletions inside a local database transaction
      await db.transaction(() async {
        // Get maps again to reflect local database updates during transaction
        var currentAccounts = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
        var currentCategories = await db.select(db.categories).get();
        var accountUuidToId = { for (final a in currentAccounts) a.uuid: a.id };
        var categoryUuidToId = { for (final c in currentCategories) c.uuid: c.id };

        final remoteChanges = responseData['changes'] as Map<String, dynamic>? ?? {};
        final remoteDeletions = responseData['deletions'] as List<dynamic>? ?? [];

        // Apply categories first (dependency order 1)
        final remoteCategoriesList = remoteChanges['categories'] as List<dynamic>? ?? [];
        for (final item in remoteCategoriesList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          // Find local category
          final existing = await (db.select(db.categories)..where((c) => c.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            int? parentId;
            final parentUuid = data['parentUuid'] as String?;
            if (parentUuid != null) {
              parentId = categoryUuidToId[parentUuid];
            }
            final companion = CategoriesCompanion.insert(
              uuid: Value(uuid),
              name: data['name'] as String,
              icon: (data['icon'] as num).toInt(),
              color: data['color'] as String,
              isDefault: Value(data['isDefault'] as bool? ?? false),
              parentId: Value(parentId),
              updatedAt: Value(updatedAt),
            );
            final insertedId = await db.into(db.categories).insert(companion);
            categoryUuidToId[uuid] = insertedId;
          } else {
            // Update only if remote updatedAt is newer (LWW)
            if (updatedAt.isAfter(existing.updatedAt)) {
              int? parentId;
              final parentUuid = data['parentUuid'] as String?;
              if (parentUuid != null) {
                parentId = categoryUuidToId[parentUuid];
              }
              final companion = CategoriesCompanion(
                id: Value(existing.id),
                uuid: Value(uuid),
                name: Value(data['name'] as String),
                icon: Value((data['icon'] as num).toInt()),
                color: Value(data['color'] as String),
                isDefault: Value(data['isDefault'] as bool? ?? false),
                parentId: Value(parentId),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.categories).replace(companion);
            }
          }
        }

        // Apply accounts (dependency order 2)
        final remoteAccountsList = remoteChanges['accounts'] as List<dynamic>? ?? [];
        for (final item in remoteAccountsList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          // Find local account
          final existing = await (db.select(db.accounts)..where((a) => a.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = AccountsCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              name: data['name'] as String,
              type: _parseAccountType(data['type']),
              icon: (data['icon'] as num).toInt(),
              color: data['color'] as String,
              openingBalance: Value((data['openingBalance'] as num?)?.toDouble() ?? 0.0),
              isDefault: Value(data['isDefault'] as bool? ?? false),
              updatedAt: Value(updatedAt),
            );
            final insertedId = await db.into(db.accounts).insert(companion);
            accountUuidToId[uuid] = insertedId;
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = AccountsCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                name: Value(data['name'] as String),
                type: Value(_parseAccountType(data['type'])),
                icon: Value((data['icon'] as num).toInt()),
                color: Value(data['color'] as String),
                openingBalance: Value((data['openingBalance'] as num?)?.toDouble() ?? 0.0),
                isDefault: Value(data['isDefault'] as bool? ?? false),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.accounts).replace(companion);
            }
          }
        }

        // Re-read category/account mappings as we might have added new ones
        currentAccounts = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
        currentCategories = await db.select(db.categories).get();
        accountUuidToId = { for (final a in currentAccounts) a.uuid: a.id };
        categoryUuidToId = { for (final c in currentCategories) c.uuid: c.id };

        // Apply transactions (dependency order 3)
        final remoteTransactionsList = remoteChanges['transactions'] as List<dynamic>? ?? [];
        for (final item in remoteTransactionsList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          final categoryUuid = data['categoryUuid'] as String?;
          final accountUuid = data['accountUuid'] as String?;
          final categoryId = categoryUuidToId[categoryUuid];
          final accountId = accountUuidToId[accountUuid];

          if (categoryId == null || accountId == null) {
            continue;
          }

          final existing = await (db.select(db.transactions)..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = TransactionsCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              amount: (data['amount'] as num).toDouble(),
              date: _parseDateTime(data['date']),
              note: Value(data['note'] as String?),
              type: _parseTransactionType(data['type']),
              categoryId: categoryId,
              accountId: accountId,
              createdAt: Value(_parseDateTime(data['createdAt'])),
              updatedAt: Value(updatedAt),
            );
            await db.into(db.transactions).insert(companion);
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = TransactionsCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                amount: Value((data['amount'] as num).toDouble()),
                date: Value(_parseDateTime(data['date'])),
                note: Value(data['note'] as String?),
                type: Value(_parseTransactionType(data['type'])),
                categoryId: Value(categoryId),
                accountId: Value(accountId),
                createdAt: Value(existing.createdAt),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.transactions).replace(companion);
            }
          }
        }

        // Re-read transactions as peer_debts may link to them
        final currentTransactions = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
        final transactionUuidToId = { for (final t in currentTransactions) t.uuid: t.id };

        // Apply budgets (dependency order 4)
        final remoteBudgetsList = remoteChanges['budgets'] as List<dynamic>? ?? [];
        for (final item in remoteBudgetsList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          final categoryUuid = data['categoryUuid'] as String?;
          final categoryId = categoryUuidToId[categoryUuid];

          if (categoryId == null) {
            continue;
          }

          final existing = await (db.select(db.budgets)..where((b) => b.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = BudgetsCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              amount: (data['amount'] as num).toDouble(),
              period: data['period'] as String,
              categoryId: categoryId,
              updatedAt: Value(updatedAt),
            );
            await db.into(db.budgets).insert(companion);
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = BudgetsCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                amount: Value((data['amount'] as num).toDouble()),
                period: Value(data['period'] as String),
                categoryId: Value(categoryId),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.budgets).replace(companion);
            }
          }
        }

        // Apply recurring transactions (dependency order 5)
        final remoteRecurringList = remoteChanges['recurring_transactions'] as List<dynamic>? ?? [];
        for (final item in remoteRecurringList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          final categoryUuid = data['categoryUuid'] as String?;
          final accountUuid = data['accountUuid'] as String?;
          final categoryId = categoryUuidToId[categoryUuid];
          final accountId = accountUuidToId[accountUuid];

          if (categoryId == null || accountId == null) {
            continue;
          }

          final existing = await (db.select(db.recurringTransactions)..where((r) => r.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = RecurringTransactionsCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              name: data['name'] as String,
              amount: (data['amount'] as num).toDouble(),
              type: _parseTransactionType(data['type']),
              categoryId: categoryId,
              accountId: accountId,
              interval: data['interval'] as String,
              startDate: _parseDateTime(data['startDate']),
              nextDueDate: _parseDateTime(data['nextDueDate']),
              lastGeneratedDate: Value(data['lastGeneratedDate'] == null ? null : _parseDateTime(data['lastGeneratedDate'])),
              isActive: Value(data['isActive'] as bool? ?? true),
              updatedAt: Value(updatedAt),
            );
            await db.into(db.recurringTransactions).insert(companion);
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = RecurringTransactionsCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                name: Value(data['name'] as String),
                amount: Value((data['amount'] as num).toDouble()),
                type: Value(_parseTransactionType(data['type'])),
                categoryId: Value(categoryId),
                accountId: Value(accountId),
                interval: Value(data['interval'] as String),
                startDate: Value(_parseDateTime(data['startDate'])),
                nextDueDate: Value(_parseDateTime(data['nextDueDate'])),
                lastGeneratedDate: Value(data['lastGeneratedDate'] == null ? null : _parseDateTime(data['lastGeneratedDate'])),
                isActive: Value(data['isActive'] as bool? ?? true),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.recurringTransactions).replace(companion);
            }
          }
        }

        // Apply loans (dependency order 6)
        final remoteLoansList = remoteChanges['loans'] as List<dynamic>? ?? [];
        for (final item in remoteLoansList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          final accountUuid = data['accountUuid'] as String?;
          final accountId = accountUuidToId[accountUuid];

          if (accountId == null) {
            continue;
          }

          final existing = await (db.select(db.loans)..where((l) => l.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = LoansCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              name: data['name'] as String,
              accountId: accountId,
              principalAmount: (data['principalAmount'] as num).toDouble(),
              interestRate: (data['interestRate'] as num).toDouble(),
              tenureMonths: (data['tenureMonths'] as num).toInt(),
              startDate: _parseDateTime(data['startDate']),
              nextEmiDate: Value(data['nextEmiDate'] == null ? null : _parseDateTime(data['nextEmiDate'])),
              emiAmount: (data['emiAmount'] as num).toDouble(),
              isActive: Value(data['isActive'] as bool? ?? true),
              updatedAt: Value(updatedAt),
            );
            await db.into(db.loans).insert(companion);
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = LoansCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                name: Value(data['name'] as String),
                accountId: Value(accountId),
                principalAmount: Value((data['principalAmount'] as num).toDouble()),
                interestRate: Value((data['interestRate'] as num).toDouble()),
                tenureMonths: Value((data['tenureMonths'] as num).toInt()),
                startDate: Value(_parseDateTime(data['startDate'])),
                nextEmiDate: Value(data['nextEmiDate'] == null ? null : _parseDateTime(data['nextEmiDate'])),
                emiAmount: Value((data['emiAmount'] as num).toDouble()),
                isActive: Value(data['isActive'] as bool? ?? true),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.loans).replace(companion);
            }
          }
        }

        // Apply peer debts (dependency order 7)
        final remotePeerDebtsList = remoteChanges['peer_debts'] as List<dynamic>? ?? [];
        for (final item in remotePeerDebtsList) {
          final data = item as Map<String, dynamic>;
          final uuid = data['uuid'] as String;
          final updatedAt = _parseDateTime(data['updatedAt']);
          final remoteWalletId = (data['walletId'] as num?)?.toInt() ?? walletId;

          final transactionUuid = data['transactionUuid'] as String?;
          final transactionId = transactionUuidToId[transactionUuid];

          final existing = await (db.select(db.peerDebts)..where((pd) => pd.uuid.equals(uuid))).getSingleOrNull();
          if (existing == null) {
            final companion = PeerDebtsCompanion.insert(
              walletId: Value(remoteWalletId),
              uuid: Value(uuid),
              personName: data['personName'] as String,
              type: _parsePeerDebtType(data['type']),
              amount: (data['amount'] as num).toDouble(),
              note: Value(data['note'] as String?),
              date: _parseDateTime(data['date']),
              isSettled: Value(data['isSettled'] as bool? ?? false),
              transactionId: Value(transactionId),
              updatedAt: Value(updatedAt),
            );
            await db.into(db.peerDebts).insert(companion);
          } else {
            if (updatedAt.isAfter(existing.updatedAt)) {
              final companion = PeerDebtsCompanion(
                id: Value(existing.id),
                walletId: Value(remoteWalletId),
                uuid: Value(uuid),
                personName: Value(data['personName'] as String),
                type: Value(_parsePeerDebtType(data['type'])),
                amount: Value((data['amount'] as num).toDouble()),
                note: Value(data['note'] as String?),
                date: Value(_parseDateTime(data['date'])),
                isSettled: Value(data['isSettled'] as bool? ?? false),
                transactionId: Value(transactionId),
                updatedAt: Value(updatedAt),
              );
              await db.update(db.peerDebts).replace(companion);
            }
          }
        }

        final remoteMembersList = remoteChanges['wallet_members'] as List<dynamic>? ?? [];
        final remoteWalletsList = remoteChanges['wallets'] as List<dynamic>? ?? [];
        for (final item in remoteWalletsList) {
          await _upsertWallet(item as Map<String, dynamic>);
        }
        for (final item in remoteMembersList) {
          await _upsertWalletMember(item as Map<String, dynamic>);
        }

        final remoteInvitationsList = remoteChanges['wallet_invitations'] as List<dynamic>? ?? [];
        for (final item in remoteInvitationsList) {
          await _upsertWalletInvitation(item as Map<String, dynamic>);
        }

        final remoteActivitiesList = remoteChanges['wallet_activities'] as List<dynamic>? ?? [];
        for (final item in remoteActivitiesList) {
          await _upsertWalletActivity(item as Map<String, dynamic>);
        }

        final remoteNotificationsList = remoteChanges['wallet_notifications'] as List<dynamic>? ?? [];
        for (final item in remoteNotificationsList) {
          await _upsertWalletNotification(item as Map<String, dynamic>);
        }

        final remoteNotificationPrefsList = remoteChanges['wallet_notification_preferences'] as List<dynamic>? ?? [];
        for (final item in remoteNotificationPrefsList) {
          await _upsertWalletNotificationPreference(item as Map<String, dynamic>);
        }

        final remoteGoalsList = remoteChanges['wallet_goals'] as List<dynamic>? ?? [];
        for (final item in remoteGoalsList) {
          await _upsertWalletGoal(item as Map<String, dynamic>);
        }

        final remoteGoalContribList = remoteChanges['wallet_goal_contributions'] as List<dynamic>? ?? [];
        for (final item in remoteGoalContribList) {
          await _upsertWalletGoalContribution(item as Map<String, dynamic>);
        }

        final remoteAllowancesList = remoteChanges['wallet_allowances'] as List<dynamic>? ?? [];
        for (final item in remoteAllowancesList) {
          await _upsertWalletAllowance(item as Map<String, dynamic>);
        }

        final remoteAllowancePaymentsList = remoteChanges['wallet_allowance_payments'] as List<dynamic>? ?? [];
        for (final item in remoteAllowancePaymentsList) {
          await _upsertWalletAllowancePayment(item as Map<String, dynamic>);
        }

        final remoteGoalSchedulesList = remoteChanges['wallet_goal_schedules'] as List<dynamic>? ?? [];
        for (final item in remoteGoalSchedulesList) {
          await _upsertWalletGoalSchedule(item as Map<String, dynamic>);
        }

        final remoteBillsList = remoteChanges['wallet_bills'] as List<dynamic>? ?? [];
        for (final item in remoteBillsList) {
          await _upsertWalletBill(item as Map<String, dynamic>);
        }

        final remoteSplitsList = remoteChanges['wallet_expense_splits'] as List<dynamic>? ?? [];
        for (final item in remoteSplitsList) {
          await _upsertWalletExpenseSplit(item as Map<String, dynamic>);
        }

        final remoteSettlementsList = remoteChanges['wallet_settlements'] as List<dynamic>? ?? [];
        for (final item in remoteSettlementsList) {
          await _upsertWalletSettlement(item as Map<String, dynamic>);
        }

        // Apply remote deletions
        for (final item in remoteDeletions) {
          final del = item as Map<String, dynamic>;
          final uuid = del['uuid'] as String;
          final tableName = del['tableName'] as String;

          if (tableName == 'accounts') {
            await (db.delete(db.accounts)..where((a) => a.uuid.equals(uuid))).go();
          } else if (tableName == 'categories') {
            await (db.delete(db.categories)..where((c) => c.uuid.equals(uuid))).go();
          } else if (tableName == 'transactions') {
            await (db.delete(db.transactions)..where((t) => t.uuid.equals(uuid))).go();
          } else if (tableName == 'budgets') {
            await (db.delete(db.budgets)..where((b) => b.uuid.equals(uuid))).go();
          } else if (tableName == 'recurring_transactions') {
            await (db.delete(db.recurringTransactions)..where((r) => r.uuid.equals(uuid))).go();
          } else if (tableName == 'loans') {
            await (db.delete(db.loans)..where((l) => l.uuid.equals(uuid))).go();
          } else if (tableName == 'peer_debts') {
            await (db.delete(db.peerDebts)..where((pd) => pd.uuid.equals(uuid))).go();
          }
        }

        // 5. Cleanup successfully synced local deletion logs.
        for (final d in localDeletionsList) {
          await (db.delete(db.deletedRecords)..where((dr) => dr.id.equals(d.id))).go();
        }
      });

      // 6. Update last sync time
      final responseVersion = (responseData['syncApiVersion'] as num?)?.toInt() ?? syncApiVersion;
      if (responseVersion != syncApiVersion) {
        throw Exception('Unsupported sync API version: $responseVersion');
      }

      final serverTimeVal = responseData['serverTime'];
      final newLastSync = serverTimeVal != null ? _parseDateTime(serverTimeVal) : DateTime.now();
      ref.read(lastSyncTimeProvider.notifier).updateLastSyncTime(newLastSync);

      state = SyncState(status: SyncStatus.success);
    } catch (e, stack) {
      debugPrint('Sync failed: $e\n$stack');
      state = SyncState(status: SyncStatus.error, errorMessage: e.toString());
    }
  }

  Future<Map<String, dynamic>> _runSimulatedServerSync(Map<String, dynamic> clientPayload, DateTime clientLastSync) async {
    // Artificial delay for UI realism
    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    const serverStateKey = 'simulated_server_state';
    final serverStateStr = prefs.getString(serverStateKey);

    Map<String, dynamic> serverDb;
    if (serverStateStr != null) {
      serverDb = jsonDecode(serverStateStr) as Map<String, dynamic>;
    } else {
      serverDb = {
        'accounts': <dynamic>[],
        'categories': <dynamic>[],
        'transactions': <dynamic>[],
        'budgets': <dynamic>[],
        'recurring_transactions': <dynamic>[],
        'loans': <dynamic>[],
        'peer_debts': <dynamic>[],
        'wallets': <dynamic>[],
        'wallet_members': <dynamic>[],
        'wallet_invitations': <dynamic>[],
        'wallet_activities': <dynamic>[],
        'wallet_notifications': <dynamic>[],
        'wallet_notification_preferences': <dynamic>[],
        'wallet_goals': <dynamic>[],
        'wallet_goal_contributions': <dynamic>[],
        'wallet_allowances': <dynamic>[],
        'wallet_allowance_payments': <dynamic>[],
        'wallet_goal_schedules': <dynamic>[],
        'wallet_bills': <dynamic>[],
        'wallet_expense_splits': <dynamic>[],
        'wallet_settlements': <dynamic>[],
        'deletions': <dynamic>[],
      };
    }

    final clientChanges = clientPayload['changes'] as Map<String, dynamic>;
    final clientDeletions = clientPayload['deletions'] as List<dynamic>;

    // 1. Process client deletions on simulated server
    for (final del in clientDeletions) {
      final d = del as Map<String, dynamic>;
      final uuid = d['uuid'] as String;
      final tableName = d['tableName'] as String;
      final deletedAt = d['deletedAt'];

      // Remove from server lists
      final list = serverDb[tableName] as List<dynamic>? ?? [];
      list.removeWhere((item) => (item as Map<String, dynamic>)['uuid'] == uuid);

      // Add to server deletions
      final deletionsList = serverDb['deletions'] as List<dynamic>? ?? [];
      final exists = deletionsList.any((item) => (item as Map<String, dynamic>)['uuid'] == uuid);
      if (!exists) {
        deletionsList.add({
          'uuid': uuid,
          'tableName': tableName,
          'deletedAt': deletedAt,
        });
      }
    }

    // 2. Merge client changes to simulated server (LWW)
    final tables = [
      'accounts',
      'categories',
      'transactions',
      'budgets',
      'recurring_transactions',
      'loans',
      'peer_debts',
      'wallets',
      'wallet_members',
      'wallet_invitations',
      'wallet_activities',
      'wallet_notifications',
      'wallet_notification_preferences',
      'wallet_goals',
      'wallet_goal_contributions',
      'wallet_allowances',
      'wallet_allowance_payments',
      'wallet_goal_schedules',
      'wallet_bills',
      'wallet_expense_splits',
      'wallet_settlements',
    ];
    for (final table in tables) {
      final clientList = clientChanges[table] as List<dynamic>? ?? [];
      final serverList = serverDb[table] as List<dynamic>? ?? [];

      for (final item in clientList) {
        final clientItem = item as Map<String, dynamic>;
        final identity = clientItem['uuid'] ?? clientItem['id'];
        if (identity == null) {
          continue;
        }
        final clientUpdatedAt = _parseDateTime(clientItem['updatedAt']);
        final normalizedClientItem = Map<String, dynamic>.from(_jsonSafeValue(clientItem) as Map);

        final existingIndex = serverList.indexWhere((x) {
          final row = x as Map<String, dynamic>;
          return row['uuid'] == identity || row['id'] == identity;
        });
        if (existingIndex == -1) {
          serverList.add(normalizedClientItem);
        } else {
          final serverItem = serverList[existingIndex] as Map<String, dynamic>;
          final serverUpdatedAt = _parseDateTime(serverItem['updatedAt']);
          if (clientUpdatedAt.isAfter(serverUpdatedAt)) {
            serverList[existingIndex] = normalizedClientItem;
          }
        }
      }
      serverDb[table] = serverList;
    }

    // Save server state
    final now = DateTime.now();
    await prefs.setString(serverStateKey, jsonEncode(serverDb));

    // 3. Determine changes to send back to client
    final responseChanges = <String, List<dynamic>>{};
    for (final table in tables) {
      final serverList = serverDb[table] as List<dynamic>? ?? [];
      final filteredList = serverList.where((item) {
        final updatedAt = _parseDateTime((item as Map<String, dynamic>)['updatedAt']);
        return updatedAt.isAfter(clientLastSync);
      }).toList();
      responseChanges[table] = filteredList;
    }

    final serverDeletions = serverDb['deletions'] as List<dynamic>? ?? [];
    final filteredDeletions = serverDeletions.where((item) {
      final deletedAt = _parseDateTime((item as Map<String, dynamic>)['deletedAt']);
      return deletedAt.isAfter(clientLastSync);
    }).toList();

    return {
      'syncApiVersion': clientPayload['syncApiVersion'] ?? syncApiVersion,
      'serverTime': now.millisecondsSinceEpoch,
      'changes': responseChanges,
      'deletions': filteredDeletions,
    };
  }

  Future<Map<String, dynamic>> runSimulatedServerSyncForTest(
    Map<String, dynamic> clientPayload,
    DateTime clientLastSync,
  ) {
    return _runSimulatedServerSync(clientPayload, clientLastSync);
  }
}

*/