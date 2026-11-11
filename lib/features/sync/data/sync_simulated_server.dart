part of 'sync_service.dart';

/// Local "server" used when simulated sync is enabled.
extension SyncSimulatedServer on SyncNotifier {
  Future<Map<String, dynamic>> _runSimulatedServerSync(
    Map<String, dynamic> clientPayload,
    DateTime clientLastSync,
  ) async {
    // Artificial delay for UI realism
    await Future<void>.delayed(const Duration(milliseconds: 800));

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

    // 1. Process client deletions on simulated server. A newer server-side edit
    // beats an older tombstone.
    for (final del in clientDeletions) {
      final d = del as Map<String, dynamic>;
      final uuid = d['uuid'] as String;
      final tableName = d['tableName'] as String;
      final deletedAt = d['deletedAt'];
      final deletionAt = _parseDateTime(deletedAt);
      final walletId = (d['walletId'] as num?)?.toInt();

      final list = serverDb[tableName] as List<dynamic>? ?? [];
      final hasNewerEdit = list.any((item) {
        final row = item as Map<String, dynamic>;
        if (row['uuid'] != uuid) return false;
        final updated = _parseDateTime(row['updatedAt'] ?? row['createdAt']);
        return updated.isAfter(deletionAt);
      });
      if (hasNewerEdit) continue;

      list.removeWhere(
        (item) => (item as Map<String, dynamic>)['uuid'] == uuid,
      );

      final deletionsList = serverDb['deletions'] as List<dynamic>? ?? [];
      final exists = deletionsList.any((item) {
        final row = item as Map<String, dynamic>;
        return row['uuid'] == uuid && row['tableName'] == tableName;
      });
      if (!exists) {
        deletionsList.add({
          'uuid': uuid,
          'tableName': tableName,
          'walletId': walletId,
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
        final normalizedClientItem = Map<String, dynamic>.from(
          _jsonSafeValue(clientItem) as Map,
        );

        // Do not resurrect a row that has a tombstone at least as new as this
        // client edit.
        final serverDeletions = serverDb['deletions'] as List<dynamic>? ?? [];
        final tombstoned = serverDeletions.any((deletion) {
          final row = deletion as Map<String, dynamic>;
          return row['uuid'] == identity &&
              !_parseDateTime(row['deletedAt']).isBefore(clientUpdatedAt);
        });
        if (tombstoned) continue;

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
        final updatedAt = _parseDateTime(
          (item as Map<String, dynamic>)['updatedAt'],
        );
        return updatedAt.isAfter(clientLastSync);
      }).toList();
      responseChanges[table] = filteredList;
    }

    final serverDeletions = serverDb['deletions'] as List<dynamic>? ?? [];
    final filteredDeletions = serverDeletions.where((item) {
      final deletedAt = _parseDateTime(
        (item as Map<String, dynamic>)['deletedAt'],
      );
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
