// BROKEN DEPENDENCY RESOLVED

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:expense_tracker/features/sync/data/sync_merge.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/core/database/database_provider.dart';

// Per-entity handlers and the simulated server are parts of this library.
part 'sync_entity_upserts.dart';
part 'sync_simulated_server.dart';

enum SyncStatus { idle, syncing, success, error }
const int syncApiVersion = 1;
const String _syncDeviceIdKey = 'syncDeviceId';

/// Validates a sync endpoint.
///
/// Release builds only accept `https`. Debug builds additionally allow plain
/// `http` for localhost and private 10.x/192.168.x hosts so a local server can
/// be used during development.
Uri validateSyncUrl(String raw, {bool? debugOverride}) {
  final debug = debugOverride ?? kDebugMode;
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    throw const FormatException('Sync URL is not a valid absolute URL.');
  }
  if (uri.scheme == 'https') return uri;
  if (debug && uri.scheme == 'http' && _isPrivateHttpHost(uri.host)) {
    return uri;
  }
  throw const FormatException(
    'Sync URL must use https. Plain http is only allowed for localhost and '
    '10.x/192.168.x hosts in debug builds.',
  );
}

bool _isPrivateHttpHost(String host) {
  if (host == 'localhost' || host == '127.0.0.1' || host == '::1') return true;
  return RegExp(r'^10\.').hasMatch(host) ||
      RegExp(r'^192\.168\.').hasMatch(host);
}

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

  Future<void> _validateSyncAuthorization(int walletId, {int? actorAccountId}) async {
    final isValid = await db.walletDao.isWalletValid(walletId, actorAccountId: actorAccountId);
    if (!isValid) {
      throw WalletPermissionDeniedException(
        'Cannot sync wallet: Wallet $walletId does not exist or user lacks active membership.',
      );
    }

    if (actorAccountId != null) {
      await db.walletDao.checkPermission(
        walletId: walletId,
        permissionCheck: (s, r) => s.canSynchronizeWallet(r),
        actorAccountId: actorAccountId,
        actionName: 'synchronize data',
      );
    }
  }

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

  Future<Map<String, dynamic>> _buildSyncPayload(int walletId, DateTime cutoff, String deviceId, {int? actorAccountId}) async {
    await _validateSyncAuthorization(walletId, actorAccountId: actorAccountId);

    // Query local changes in parallel.
    final localAccountsFuture = (db.select(db.accounts)
          ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
        .get();
    final localCategoriesFuture = (db.select(db.categories)..where((t) => t.updatedAt.isBiggerThanValue(cutoff))).get();
    final localTransactionsFuture = (db.select(db.transactions)
          ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
        .get();
    final localBudgetsFuture = (db.select(db.budgets)
          ..where((t) => t.walletId.equals(walletId) & t.updatedAt.isBiggerThanValue(cutoff)))
        .get();
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
    // Only this wallet's tombstones (plus wallet-independent ones such as
    // categories) are pushed. Pushing every wallet's log let one wallet's sync
    // delete another wallet's data.
    final localDeletionsFuture = (db.select(db.deletedRecords)
          ..where((d) => d.walletId.equals(walletId) | d.walletId.isNull()))
        .get();

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
      map['walletId'] = walletId;
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
      'walletId': d.walletId,
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

    return payload;
  }

  Future<void> performSync({int? targetWalletId, int? actorAccountId}) async {
    state = SyncState(status: SyncStatus.syncing);
    try {
      final isSimulated = ref.read(isSimulatedSyncProvider);
      final syncUrl = ref.read(syncUrlProvider);
      // Never touch the keystore for simulated sync; secrets are only read when
      // they are actually needed.
      final nextcloudUsername =
          isSimulated ? '' : ref.read(nextcloudUsernameProvider);
      final nextcloudPassword =
          isSimulated ? '' : ref.read(nextcloudPasswordProvider);
      final isNextcloud =
          nextcloudUsername.isNotEmpty && nextcloudPassword.isNotEmpty;

      final token = ref.read(syncTokenProvider);
      // The passphrase lives in the platform keystore; simulated sync never
      // needs it and must not touch the keystore.
      final syncPassphrase =
          isSimulated ? '' : ref.read(syncPassphraseProvider);
      final lastSyncDateTime = ref.read(lastSyncTimeProvider);
      final int walletId = targetWalletId ?? ref.read(currentWalletIdProvider);

      await _validateSyncAuthorization(walletId, actorAccountId: actorAccountId);

      final deviceId = await _deviceId();

      if (!isSimulated && syncUrl.isEmpty) {
        throw Exception("Sync URL is not configured. Please check your settings.");
      }

      // 1. Change detection
      final cutoff = (isNextcloud || lastSyncDateTime == null) ? DateTime.fromMillisecondsSinceEpoch(0) : lastSyncDateTime;

      final payload = await _buildSyncPayload(walletId, cutoff, deviceId, actorAccountId: actorAccountId);

      // Remember exactly which tombstones this run pushes. Cleanup must not
      // touch other wallets' pending tombstones.
      final pushedDeletions = await (db.select(db.deletedRecords)
            ..where((d) => d.walletId.equals(walletId) | d.walletId.isNull()))
          .get();
      final pushedDeletionIds = pushedDeletions.map((d) => d.id).toList();

      Map<String, dynamic> responseData;
      if (isSimulated) {
        responseData = await _runSimulatedServerSync(payload, cutoff);
      } else if (isNextcloud) {
        final basicAuth = 'Basic ${base64Encode(utf8.encode('$nextcloudUsername:$nextcloudPassword'))}';
        final fileUrl = syncUrl.endsWith('/') ? '${syncUrl}vittix_sync_state.json' : '$syncUrl/vittix_sync_state.json';
        final uri = validateSyncUrl(fileUrl);
        final getResponse = await http.get(uri, headers: {'Authorization': basicAuth});
        if (getResponse.statusCode == 200) {
          responseData = await _decodeSyncResponse(getResponse, syncPassphrase);
        } else if (getResponse.statusCode == 404) {
          responseData = {'changes': <String, dynamic>{}, 'deletions': <dynamic>[]};
        } else {
          throw Exception(
            'Nextcloud returned status code ${getResponse.statusCode}',
          );
        }
      } else {
        final uri = validateSyncUrl(syncUrl);
        final headers = buildSyncHeaders(deviceId: deviceId, token: token);
        Object body;
        if (syncPassphrase.isNotEmpty) {
          // Reuse the backup AES-GCM container instead of inventing a second
          // format. The server stores opaque bytes.
          body = await BackupService.encryptBytes(
            utf8.encode(jsonEncode(payload)),
            syncPassphrase,
          );
          headers['Content-Type'] = 'application/octet-stream';
          headers['X-Sync-Encrypted'] = 'v1';
        } else {
          body = jsonEncode(payload);
        }
        final response = await http.post(uri, headers: headers, body: body);
        if (response.statusCode != 200) {
          throw Exception('Server returned status code ${response.statusCode}');
        }
        responseData = await _decodeSyncResponse(response, syncPassphrase);
      }

      if (responseData.containsKey('walletId') && responseData['walletId'] != null) {
        final payloadWalletId = (responseData['walletId'] as num).toInt();
        if (payloadWalletId != walletId) {
          throw WalletPermissionDeniedException('Remote sync payload walletId mismatch ($payloadWalletId != $walletId).');
        }
      }

      // 4. Apply incoming remote changes & deletions inside a local database transaction
      await db.transaction(() async {
        await _validateSyncAuthorization(walletId, actorAccountId: actorAccountId);

        // Get maps again to reflect local database updates during transaction
        var currentAccounts = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
        var currentCategories = await db.select(db.categories).get();
        var accountUuidToId = { for (final a in currentAccounts) a.uuid: a.id };
        var categoryUuidToId = { for (final c in currentCategories) c.uuid: c.id };

        final remoteChanges = responseData['changes'] as Map<String, dynamic>? ?? {};
        final remoteDeletions = responseData['deletions'] as List<dynamic>? ?? [];

        // A tombstone must not be resurrected by an older remote change.
        final localTombstones = await db.select(db.deletedRecords).get();
        final tombstoneByKey = <String, DateTime>{
          for (final t in localTombstones)
            '${t.deletedTable}:${t.uuid}': t.deletedAt,
        };

        // Apply categories first (dependency order 1)
        final remoteCategoriesList = remoteChanges['categories'] as List<dynamic>? ?? [];
        await mergeEntityChanges<Category>(
          entity: 'categories',
          changes: remoteCategoriesList,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) => (db.select(db.categories)
                ..where((c) => c.uuid.equals(uuid)))
              .getSingleOrNull(),
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final uuid = data['uuid'] as String;
            final parentUuid = data['parentUuid'] as String?;
            final insertedId = await db.into(db.categories).insert(
                  CategoriesCompanion.insert(
                    uuid: Value(uuid),
                    name: data['name'] as String,
                    icon: (data['icon'] as num).toInt(),
                    color: data['color'] as String,
                    isDefault: Value(data['isDefault'] as bool? ?? false),
                    parentId: Value(
                      parentUuid == null ? null : categoryUuidToId[parentUuid],
                    ),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
            categoryUuidToId[uuid] = insertedId;
          },
          updateRemote: (local, data) async {
            final parentUuid = data['parentUuid'] as String?;
            await db.update(db.categories).replace(
                  CategoriesCompanion(
                    id: Value(local.id),
                    uuid: Value(data['uuid'] as String),
                    name: Value(data['name'] as String),
                    icon: Value((data['icon'] as num).toInt()),
                    color: Value(data['color'] as String),
                    isDefault: Value(data['isDefault'] as bool? ?? false),
                    parentId: Value(
                      parentUuid == null ? null : categoryUuidToId[parentUuid],
                    ),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) =>
              _recordSyncConflict(walletId, 'categories', data, local.updatedAt),
        );

        // Apply accounts (dependency order 2)
        final remoteAccountsList = remoteChanges['accounts'] as List<dynamic>? ?? [];
        await mergeEntityChanges<Account>(
          entity: 'accounts',
          changes: remoteAccountsList,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.accounts)
                  ..where((a) => a.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet account mutation rejected for uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final uuid = data['uuid'] as String;
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet account payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            final insertedId = await db.into(db.accounts).insert(
                  AccountsCompanion.insert(
                    walletId: Value(remoteWalletId),
                    uuid: Value(uuid),
                    name: data['name'] as String,
                    type: _parseAccountType(data['type']),
                    icon: (data['icon'] as num).toInt(),
                    color: data['color'] as String,
                    openingBalance: Value(
                      (data['openingBalance'] as num?)?.toDouble() ?? 0.0,
                    ),
                    isDefault: Value(data['isDefault'] as bool? ?? false),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
            accountUuidToId[uuid] = insertedId;
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet account payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.accounts).replace(
                  AccountsCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    name: Value(data['name'] as String),
                    type: Value(_parseAccountType(data['type'])),
                    icon: Value((data['icon'] as num).toInt()),
                    color: Value(data['color'] as String),
                    openingBalance: Value(
                      (data['openingBalance'] as num?)?.toDouble() ?? 0.0,
                    ),
                    isDefault: Value(data['isDefault'] as bool? ?? false),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) =>
              _recordSyncConflict(walletId, 'accounts', data, local.updatedAt),
        );

        // Re-read category/account mappings as we might have added new ones
        currentAccounts = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
        currentCategories = await db.select(db.categories).get();
        accountUuidToId = { for (final a in currentAccounts) a.uuid: a.id };
        categoryUuidToId = { for (final c in currentCategories) c.uuid: c.id };

        // Apply transactions (dependency order 3)
        final remoteTransactionsList = remoteChanges['transactions'] as List<dynamic>? ?? [];
        final readyTransactions = remoteTransactionsList.where((item) {
          final data = item as Map<String, dynamic>;
          return categoryUuidToId[data['categoryUuid']] != null &&
              accountUuidToId[data['accountUuid']] != null;
        }).toList();
        await mergeEntityChanges<Transaction>(
          entity: 'transactions',
          changes: readyTransactions,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.transactions)
                  ..where((t) => t.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet transaction mutation rejected for uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet transaction payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.into(db.transactions).insert(
                  TransactionsCompanion.insert(
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    amount: (data['amount'] as num).toDouble(),
                    date: _parseDateTime(data['date']),
                    note: Value(data['note'] as String?),
                    type: _parseTransactionType(data['type']),
                    categoryId: categoryUuidToId[data['categoryUuid']]!,
                    accountId: accountUuidToId[data['accountUuid']]!,
                    createdAt: Value(_parseDateTime(data['createdAt'])),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet transaction payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.transactions).replace(
                  TransactionsCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    amount: Value((data['amount'] as num).toDouble()),
                    date: Value(_parseDateTime(data['date'])),
                    note: Value(data['note'] as String?),
                    type: Value(_parseTransactionType(data['type'])),
                    categoryId: Value(categoryUuidToId[data['categoryUuid']]!),
                    accountId: Value(accountUuidToId[data['accountUuid']]!),
                    createdAt: Value(local.createdAt),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) => _recordSyncConflict(
              walletId, 'transactions', data, local.updatedAt),
        );

        // Re-read transactions as peer_debts may link to them
        final currentTransactions = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
        final transactionUuidToId = { for (final t in currentTransactions) t.uuid: t.id };

        // Apply budgets (dependency order 4)
        final remoteBudgetsList = remoteChanges['budgets'] as List<dynamic>? ?? [];
        final readyBudgets = remoteBudgetsList
            .where((item) =>
                categoryUuidToId[(item as Map<String, dynamic>)['categoryUuid']] !=
                null)
            .toList();
        await mergeEntityChanges<Budget>(
          entity: 'budgets',
          changes: readyBudgets,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.budgets)
                  ..where((b) => b.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet budget mutation rejected for uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet budget payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.into(db.budgets).insert(
                  BudgetsCompanion.insert(
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    amount: (data['amount'] as num).toDouble(),
                    period: data['period'] as String,
                    categoryId: categoryUuidToId[data['categoryUuid']]!,
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet budget payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.budgets).replace(
                  BudgetsCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    amount: Value((data['amount'] as num).toDouble()),
                    period: Value(data['period'] as String),
                    categoryId: Value(categoryUuidToId[data['categoryUuid']]!),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) =>
              _recordSyncConflict(walletId, 'budgets', data, local.updatedAt),
        );

        // Apply recurring transactions (dependency order 5)
        final remoteRecurringList = remoteChanges['recurring_transactions'] as List<dynamic>? ?? [];
        final readyRecurring = remoteRecurringList.where((item) {
          final data = item as Map<String, dynamic>;
          return categoryUuidToId[data['categoryUuid']] != null &&
              accountUuidToId[data['accountUuid']] != null;
        }).toList();
        await mergeEntityChanges<RecurringTransactionDb>(
          entity: 'recurring_transactions',
          changes: readyRecurring,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.recurringTransactions)
                  ..where((r) => r.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet recurring transaction mutation rejected for '
                'uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet recurring transaction payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.into(db.recurringTransactions).insert(
                  RecurringTransactionsCompanion.insert(
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    name: data['name'] as String,
                    amount: (data['amount'] as num).toDouble(),
                    type: _parseTransactionType(data['type']),
                    categoryId: categoryUuidToId[data['categoryUuid']]!,
                    accountId: accountUuidToId[data['accountUuid']]!,
                    interval: data['interval'] as String,
                    startDate: _parseDateTime(data['startDate']),
                    nextDueDate: _parseDateTime(data['nextDueDate']),
                    lastGeneratedDate: Value(data['lastGeneratedDate'] == null
                        ? null
                        : _parseDateTime(data['lastGeneratedDate'])),
                    isActive: Value(data['isActive'] as bool? ?? true),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet recurring transaction payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.recurringTransactions).replace(
                  RecurringTransactionsCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    name: Value(data['name'] as String),
                    amount: Value((data['amount'] as num).toDouble()),
                    type: Value(_parseTransactionType(data['type'])),
                    categoryId: Value(categoryUuidToId[data['categoryUuid']]!),
                    accountId: Value(accountUuidToId[data['accountUuid']]!),
                    interval: Value(data['interval'] as String),
                    startDate: Value(_parseDateTime(data['startDate'])),
                    nextDueDate: Value(_parseDateTime(data['nextDueDate'])),
                    lastGeneratedDate: Value(data['lastGeneratedDate'] == null
                        ? null
                        : _parseDateTime(data['lastGeneratedDate'])),
                    isActive: Value(data['isActive'] as bool? ?? true),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) => _recordSyncConflict(
              walletId, 'recurring_transactions', data, local.updatedAt),
        );

        // Apply loans (dependency order 6)
        final remoteLoansList = remoteChanges['loans'] as List<dynamic>? ?? [];
        final readyLoans = remoteLoansList
            .where((item) =>
                accountUuidToId[(item as Map<String, dynamic>)['accountUuid']] !=
                null)
            .toList();
        await mergeEntityChanges<LoanDb>(
          entity: 'loans',
          changes: readyLoans,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.loans)
                  ..where((l) => l.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet loan mutation rejected for uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet loan payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.into(db.loans).insert(
                  LoansCompanion.insert(
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    name: data['name'] as String,
                    accountId: accountUuidToId[data['accountUuid']]!,
                    principalAmount: (data['principalAmount'] as num).toDouble(),
                    interestRate: (data['interestRate'] as num).toDouble(),
                    tenureMonths: (data['tenureMonths'] as num).toInt(),
                    startDate: _parseDateTime(data['startDate']),
                    nextEmiDate: Value(data['nextEmiDate'] == null
                        ? null
                        : _parseDateTime(data['nextEmiDate'])),
                    emiAmount: (data['emiAmount'] as num).toDouble(),
                    isActive: Value(data['isActive'] as bool? ?? true),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet loan payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.loans).replace(
                  LoansCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    name: Value(data['name'] as String),
                    accountId: Value(accountUuidToId[data['accountUuid']]!),
                    principalAmount:
                        Value((data['principalAmount'] as num).toDouble()),
                    interestRate:
                        Value((data['interestRate'] as num).toDouble()),
                    tenureMonths: Value((data['tenureMonths'] as num).toInt()),
                    startDate: Value(_parseDateTime(data['startDate'])),
                    nextEmiDate: Value(data['nextEmiDate'] == null
                        ? null
                        : _parseDateTime(data['nextEmiDate'])),
                    emiAmount: Value((data['emiAmount'] as num).toDouble()),
                    isActive: Value(data['isActive'] as bool? ?? true),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) =>
              _recordSyncConflict(walletId, 'loans', data, local.updatedAt),
        );

        // Apply peer debts (dependency order 7)
        final remotePeerDebtsList = remoteChanges['peer_debts'] as List<dynamic>? ?? [];
        await mergeEntityChanges<PeerDebtDb>(
          entity: 'peer_debts',
          changes: remotePeerDebtsList,
          tombstoneByKey: tombstoneByKey,
          uuidOf: (data) => data['uuid'] as String,
          remoteUpdatedAt: (data) => _parseDateTime(data['updatedAt']),
          findLocal: (uuid) async {
            final existing = await (db.select(db.peerDebts)
                  ..where((pd) => pd.uuid.equals(uuid)))
                .getSingleOrNull();
            if (existing != null && existing.walletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet peer debt mutation rejected for uuid $uuid',
              );
            }
            return existing;
          },
          localUpdatedAt: (local) => local.updatedAt,
          insertRemote: (data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet peer debt payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.into(db.peerDebts).insert(
                  PeerDebtsCompanion.insert(
                    walletId: remoteWalletId,
                    uuid: Value(data['uuid'] as String),
                    personName: data['personName'] as String,
                    type: _parsePeerDebtType(data['type']),
                    amount: (data['amount'] as num).toDouble(),
                    note: Value(data['note'] as String?),
                    date: _parseDateTime(data['date']),
                    isSettled: Value(data['isSettled'] as bool? ?? false),
                    transactionId: Value(
                      transactionUuidToId[data['transactionUuid']],
                    ),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          updateRemote: (local, data) async {
            final remoteWalletId =
                (data['walletId'] as num?)?.toInt() ?? walletId;
            if (remoteWalletId != walletId) {
              throw WalletPermissionDeniedException(
                'Cross-wallet peer debt payload rejected '
                '($remoteWalletId != $walletId)',
              );
            }
            await db.update(db.peerDebts).replace(
                  PeerDebtsCompanion(
                    id: Value(local.id),
                    walletId: Value(remoteWalletId),
                    uuid: Value(data['uuid'] as String),
                    personName: Value(data['personName'] as String),
                    type: Value(_parsePeerDebtType(data['type'])),
                    amount: Value((data['amount'] as num).toDouble()),
                    note: Value(data['note'] as String?),
                    date: Value(_parseDateTime(data['date'])),
                    isSettled: Value(data['isSettled'] as bool? ?? false),
                    transactionId: Value(
                      transactionUuidToId[data['transactionUuid']],
                    ),
                    updatedAt: Value(_parseDateTime(data['updatedAt'])),
                  ),
                );
          },
          recordConflict: (data, local) =>
              _recordSyncConflict(walletId, 'peer_debts', data, local.updatedAt),
        );

        final remoteMembersList = remoteChanges['wallet_members'] as List<dynamic>? ?? [];
        final remoteWalletsList = remoteChanges['wallets'] as List<dynamic>? ?? [];
        for (final item in remoteWalletsList) {
          await _upsertWallet(item as Map<String, dynamic>, walletId);
        }
        for (final item in remoteMembersList) {
          await _upsertWalletMember(item as Map<String, dynamic>, walletId);
        }

        final remoteInvitationsList = remoteChanges['wallet_invitations'] as List<dynamic>? ?? [];
        for (final item in remoteInvitationsList) {
          await _upsertWalletInvitation(item as Map<String, dynamic>, walletId);
        }

        final remoteNotificationsList = remoteChanges['wallet_notifications'] as List<dynamic>? ?? [];
        for (final item in remoteNotificationsList) {
          await _upsertWalletNotification(item as Map<String, dynamic>, walletId);
        }

        final remoteNotificationPrefsList = remoteChanges['wallet_notification_preferences'] as List<dynamic>? ?? [];
        for (final item in remoteNotificationPrefsList) {
          await _upsertWalletNotificationPreference(item as Map<String, dynamic>, walletId);
        }

        final remoteGoalsList = remoteChanges['wallet_goals'] as List<dynamic>? ?? [];
        for (final item in remoteGoalsList) {
          await _upsertWalletGoal(item as Map<String, dynamic>, walletId);
        }

        final remoteGoalContribList = remoteChanges['wallet_goal_contributions'] as List<dynamic>? ?? [];
        for (final item in remoteGoalContribList) {
          await _upsertWalletGoalContribution(item as Map<String, dynamic>, walletId);
        }

        final remoteAllowancesList = remoteChanges['wallet_allowances'] as List<dynamic>? ?? [];
        for (final item in remoteAllowancesList) {
          await _upsertWalletAllowance(item as Map<String, dynamic>, walletId);
        }

        final remoteAllowancePaymentsList = remoteChanges['wallet_allowance_payments'] as List<dynamic>? ?? [];
        for (final item in remoteAllowancePaymentsList) {
          await _upsertWalletAllowancePayment(item as Map<String, dynamic>, walletId);
        }

        final remoteGoalSchedulesList = remoteChanges['wallet_goal_schedules'] as List<dynamic>? ?? [];
        for (final item in remoteGoalSchedulesList) {
          await _upsertWalletGoalSchedule(item as Map<String, dynamic>, walletId);
        }

        final remoteBillsList = remoteChanges['wallet_bills'] as List<dynamic>? ?? [];
        for (final item in remoteBillsList) {
          await _upsertWalletBill(item as Map<String, dynamic>, walletId);
        }

        final remoteSplitsList = remoteChanges['wallet_expense_splits'] as List<dynamic>? ?? [];
        for (final item in remoteSplitsList) {
          await _upsertWalletExpenseSplit(item as Map<String, dynamic>, walletId);
        }

        final remoteSettlementsList = remoteChanges['wallet_settlements'] as List<dynamic>? ?? [];
        for (final item in remoteSettlementsList) {
          await _upsertWalletSettlement(item as Map<String, dynamic>, walletId);
        }

        // Apply remote deletions. A tombstone only wins when it is at least as
        // new as the local row; a newer local edit is kept.
        const tombstonedColumns = <String, String?>{
          'accounts': 'wallet_id',
          'categories': null,
          'transactions': 'wallet_id',
          'budgets': 'wallet_id',
          'recurring_transactions': 'wallet_id',
          'loans': 'wallet_id',
          'peer_debts': 'wallet_id',
          'wallet_expense_splits': 'wallet_id',
          'wallet_settlements': 'wallet_id',
          'wallet_activities': 'wallet_id',
          'wallets': null,
        };
        const tablesWithUpdatedAt = {
          'accounts',
          'categories',
          'transactions',
          'budgets',
          'recurring_transactions',
          'loans',
          'peer_debts',
        };

        for (final item in remoteDeletions) {
          final del = item as Map<String, dynamic>;
          final uuid = del['uuid'] as String;
          final tableName = del['tableName'] as String;
          if (!tombstonedColumns.containsKey(tableName)) continue;

          final deletionWalletId = (del['walletId'] as num?)?.toInt();
          if (deletionWalletId != null && deletionWalletId != walletId) {
            // Never apply another wallet's tombstone.
            continue;
          }

          final deletedAt = _parseDateTime(del['deletedAt']);
          final walletColumn = tombstonedColumns[tableName];
          final updatedAtExpression =
              tablesWithUpdatedAt.contains(tableName) ? 'updated_at' : 'NULL';
          final existing = await db.customSelect(
            'SELECT ${walletColumn ?? 'NULL'} AS wallet_id, '
            '$updatedAtExpression AS updated_at '
            'FROM $tableName WHERE uuid = ? LIMIT 1',
            variables: [Variable<String>(uuid)],
          ).getSingleOrNull();

          if (existing == null) {
            await _deleteTombstone(uuid, tableName);
            continue;
          }
          if (walletColumn != null && existing.data['wallet_id'] != walletId) {
            continue;
          }
          final updatedAtSeconds = existing.data['updated_at'] as int?;
          if (updatedAtSeconds != null &&
              DateTime.fromMillisecondsSinceEpoch(updatedAtSeconds * 1000)
                  .isAfter(deletedAt)) {
            // The local row was edited after the remote deletion: keep it.
            continue;
          }

          await db.customStatement(
            'DELETE FROM $tableName WHERE uuid = ?',
            [uuid],
          );
          // The trigger just wrote a local tombstone; the server already has
          // this deletion, so drop it instead of pushing it straight back.
          await _deleteTombstone(uuid, tableName);
        }

        // 5. Cleanup only the tombstones this run pushed. Other wallets'
        // pending tombstones must survive.
        if (pushedDeletionIds.isNotEmpty) {
          await (db.delete(db.deletedRecords)
                ..where((dr) => dr.id.isIn(pushedDeletionIds)))
              .go();
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
    } on Object catch (e, stack) {
      // Never log the error text: HTTP exceptions can embed request or response
      // payloads. The type plus the stack is enough for diagnostics.
      debugPrint('Sync failed: ${e.runtimeType}');
      if (kDebugMode) {
        debugPrintStack(stackTrace: stack);
      }
      state = SyncState(status: SyncStatus.error, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _decodeSyncResponse(
    http.Response response,
    String passphrase,
  ) async {
    final bytes = response.bodyBytes;
    if (BackupService.isEncryptedBytes(bytes)) {
      if (passphrase.isEmpty) {
        throw const FormatException(
          'Received an encrypted sync payload but no sync passphrase is '
          'configured.',
        );
      }
      final clear = await BackupService.decryptBytes(bytes, passphrase);
      return jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    }
    return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  }

}

