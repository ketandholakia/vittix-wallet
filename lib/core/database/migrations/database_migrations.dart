part of '../app_database.dart';

/// Schema creation and upgrade steps.
///
/// One function per schema version keeps the migration order obvious and makes
/// each step independently testable. Runs inside the same Drift library so it
/// can use the generated table fields and the database's private helpers.
extension AppDatabaseMigrations on AppDatabase {
  Future<void> createSchema(Migrator m) async {
    await m.createAll();
    await batch((batch) {
      batch.insertAll(accounts, DefaultAccounts.defaultAccounts);
      batch.insertAll(categories, DefaultCategories.defaultCategories);
    });

    // Tombstone every delete of a synced table so other devices can apply the
    // deletion instead of resurrecting the row.
    await _ensureDeletionTriggers();
  }

  Future<void> upgradeSchema(Migrator m, int from, int to) async {
    if (from < 2) await migrateToV2(m);
    if (from < 3) await migrateToV3(m);
    if (from < 4) await migrateToV4(m);
    if (from < 5) await migrateToV5(m);
    if (from < 6) await migrateToV6(m);
    if (from < 7) await migrateToV7(m);
    if (from < 8) await migrateToV8(m);
    if (from < 9) await migrateToV9(m);
    if (from < 10) await migrateToV10(m);
    if (from < 11) await migrateToV11(m);
    if (from < 12) await migrateToV12(m);
    if (from < 17) await migrateToV17(m);
    if (from < 18) await migrateToV18(m);
    if (from < 19) await migrateToV19(m);
  }

  Future<void> migrateToV2(Migrator m) async {
    await m.createTable(accounts);
    await batch((batch) {
      batch.insertAll(accounts, DefaultAccounts.defaultAccounts);
    });
    await m.addColumn(transactions, transactions.accountId);
    await customStatement(
      'UPDATE transactions SET account_id = 1 WHERE account_id IS NULL',
    );
  }

  Future<void> migrateToV3(Migrator m) async {
    await m.createTable(recurringTransactions);
  }

  Future<void> migrateToV4(Migrator m) async {
    await m.addColumn(categories, categories.parentId);
  }

  Future<void> migrateToV5(Migrator m) async {
    await m.addColumn(accounts, accounts.uuid);
    await m.addColumn(accounts, accounts.updatedAt);
    await m.addColumn(categories, categories.uuid);
    await m.addColumn(categories, categories.updatedAt);
    await m.addColumn(transactions, transactions.uuid);
    await m.addColumn(budgets, budgets.uuid);
    await m.addColumn(budgets, budgets.updatedAt);
    await m.addColumn(recurringTransactions, recurringTransactions.uuid);
    await m.addColumn(recurringTransactions, recurringTransactions.updatedAt);

    const uuid =
        "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' "
        "|| substr(lower(hex(randomblob(2))),2) || '-a' "
        "|| substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))";
    for (final table in const [
      'accounts',
      'categories',
      'transactions',
      'budgets',
      'recurring_transactions',
    ]) {
      await customStatement(
        'UPDATE $table SET uuid = $uuid WHERE uuid IS NULL',
      );
    }

    final nowIso = DateTime.now().toIso8601String();
    for (final table in const [
      'accounts',
      'categories',
      'budgets',
      'recurring_transactions',
    ]) {
      await customStatement(
        "UPDATE $table SET updated_at = '$nowIso' WHERE updated_at IS NULL",
      );
    }
  }

  Future<void> migrateToV6(Migrator m) async {
    // The tables were created by createAll on the previous schema; no step was
    // ever required here. Kept so version numbering stays explicit.
  }

  Future<void> migrateToV7(Migrator m) async {
    await m.addColumn(budgets, budgets.walletId);
    await customStatement(
      'UPDATE budgets SET wallet_id = 1 WHERE wallet_id IS NULL',
    );
  }

  Future<void> migrateToV8(Migrator m) async {
    await m.addColumn(recurringTransactions, recurringTransactions.walletId);
    await customStatement(
      'UPDATE recurring_transactions SET wallet_id = (SELECT wallet_id FROM '
      'accounts WHERE accounts.id = recurring_transactions.account_id) '
      'WHERE account_id IS NOT NULL',
    );
    final orphanResult = await customSelect(
      'SELECT COUNT(*) AS c FROM recurring_transactions '
      'WHERE wallet_id IS NULL',
    ).getSingle();
    final orphanCount = orphanResult.read<int>('c');
    if (orphanCount > 0) {
      throw StateError(
        'Migration to schema v8 failed: $orphanCount recurring transaction(s) '
        'have no resolvable wallet via their account. Orphaned records must be '
        'resolved manually before upgrading.',
      );
    }
  }

  Future<void> migrateToV9(Migrator m) async {
    // Harden peer_debts.wallet_id and add UUIDs for splits/settlements.
    const uuid =
        "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' "
        "|| substr(lower(hex(randomblob(2))),2) || '-a' "
        "|| substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))";

    await m.addColumn(walletExpenseSplits, walletExpenseSplits.uuid);
    await customStatement(
      'UPDATE wallet_expense_splits SET uuid = $uuid WHERE uuid IS NULL',
    );
    await m.addColumn(walletSettlements, walletSettlements.uuid);
    await customStatement(
      'UPDATE wallet_settlements SET uuid = $uuid WHERE uuid IS NULL',
    );

    await customStatement(
      'UPDATE peer_debts SET wallet_id = ('
      'SELECT t.wallet_id FROM transactions t '
      'WHERE t.id = peer_debts.transaction_id'
      ') WHERE transaction_id IS NOT NULL',
    );

    final orphanResult = await customSelect(
      'SELECT uuid FROM peer_debts WHERE wallet_id IS NULL '
      'OR wallet_id NOT IN (SELECT id FROM wallets)',
    ).get();
    if (orphanResult.isNotEmpty) {
      final orphanUuids = orphanResult
          .map((r) => r.read<String>('uuid'))
          .join(', ');
      throw StateError(
        'Migration to schema v9 failed: ${orphanResult.length} peer debt(s) '
        'have no resolvable wallet ownership. Orphan UUIDs: $orphanUuids. '
        'Orphaned records must be resolved manually before upgrading.',
      );
    }

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
      "updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%f', 'now'))"
      ')',
    );
    await customStatement(
      'INSERT INTO peer_debts_v9 (id, wallet_id, uuid, person_name, type, '
      'amount, note, date, is_settled, transaction_id, updated_at) '
      'SELECT id, wallet_id, uuid, person_name, type, amount, note, date, '
      'is_settled, transaction_id, updated_at FROM peer_debts',
    );
    await customStatement('DROP TABLE peer_debts');
    await customStatement('ALTER TABLE peer_debts_v9 RENAME TO peer_debts');
  }

  Future<void> migrateToV10(Migrator m) async {
    await m.createTable(walletActivities);
  }

  Future<void> migrateToV11(Migrator m) async {
    await m.addColumn(walletInvitations, walletInvitations.token);
    const uuid =
        "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' "
        "|| substr(lower(hex(randomblob(2))),2) || '-a' "
        "|| substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))";
    await customStatement(
      "UPDATE wallet_invitations SET token = $uuid "
      "WHERE token IS NULL OR token = ''",
    );
  }

  Future<void> migrateToV12(Migrator m) async {
    await m.addColumn(transactions, transactions.transferGroupId);
  }

  Future<void> migrateToV17(Migrator m) async {
    // Re-enable sync tombstones with wallet scoping.
    final table = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name = 'deleted_records'",
    ).get();
    if (table.isEmpty) {
      await m.createTable(deletedRecords);
    } else {
      final columns = await customSelect(
        "PRAGMA table_info('deleted_records')",
      ).get();
      final hasWalletId = columns.any(
        (row) => row.read<String>('name') == 'wallet_id',
      );
      if (!hasWalletId) {
        await m.addColumn(deletedRecords, deletedRecords.walletId);
      }
    }
    await _ensureDeletionTriggers();
  }

  Future<void> migrateToV18(Migrator m) async {
    // Normalise any legacy floating-point money columns to exact integer minor
    // units (paise/cents).
    await convertLegacyMoneyColumns();
  }

  Future<void> migrateToV19(Migrator m) async {
    // Keep near-simultaneous remote edits instead of dropping them.
    await m.createTable(syncConflicts);
  }
}
