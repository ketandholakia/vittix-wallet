export 'package:vittix_wallet/core/database/database_enums.dart';
import 'dart:io';

import 'package:drift/drift.dart';
export 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:vittix_wallet/core/money/money.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vittix_wallet/features/accounts/domain/default_accounts.dart';
import 'package:vittix_wallet/features/users/data/tables/users_table.dart';
import 'package:vittix_wallet/core/database/database_encryption.dart';
import 'package:vittix_wallet/core/database/sqlcipher_loader.dart';
import 'package:vittix_wallet/features/security/data/secure_key_value_store.dart';
import 'package:vittix_wallet/core/database/default_categories.dart';

// Import the generated part file

import 'package:vittix_wallet/core/database/database_enums.dart';
import 'package:vittix_wallet/features/accounts/data/tables/accounts_table.dart';
import 'package:vittix_wallet/features/bills/data/tables/bills_table.dart';
import 'package:vittix_wallet/features/budgets/data/tables/budgets_table.dart';
import 'package:vittix_wallet/features/categories/data/tables/categories_table.dart';
import 'package:vittix_wallet/features/dashboard/data/tables/notifications_table.dart';
import 'package:vittix_wallet/features/dashboard/data/tables/wallet_activities_table.dart';
import 'package:vittix_wallet/features/debts/data/tables/loans_table.dart';
import 'package:vittix_wallet/features/debts/data/tables/peer_debts_table.dart';
import 'package:vittix_wallet/features/family/data/tables/allowances_table.dart';
import 'package:vittix_wallet/features/family/data/tables/allowance_payments_table.dart';
import 'package:vittix_wallet/features/family/data/tables/settlements_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallets_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallet_invitations_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallet_members_table.dart';
import 'package:vittix_wallet/features/family/domain/wallet_permissions.dart';
import 'package:vittix_wallet/features/goals/data/tables/goals_table.dart';
import 'package:vittix_wallet/features/goals/data/tables/goal_contributions_table.dart';
import 'package:vittix_wallet/features/goals/data/tables/goal_schedules_table.dart';
import 'package:vittix_wallet/features/settings/data/tables/feedback_table.dart';
import 'package:vittix_wallet/features/settings/data/tables/notification_preferences_table.dart';
import 'package:vittix_wallet/features/sync/data/tables/deleted_records_table.dart';
import 'package:vittix_wallet/features/sync/data/tables/sync_conflicts_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/attachments_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/expense_splits_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/expense_split_members_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/merchant_mappings_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/payees_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/recurring_transactions_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/sms_import_metrics_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/tags_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/transactions_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/unrecognized_sms_table.dart';
import 'package:vittix_wallet/features/debts/data/debts_dao.dart';
import 'package:vittix_wallet/sms/data/sms_parsing_dao.dart';
import 'package:vittix_wallet/sms/data/sms_import_metrics_dao.dart';
// DAO implementations (same library, so generated mixins stay visible).
part 'daos/wallet_dao.dart';
part 'daos/payee_dao.dart';
part 'daos/transaction_tag_dao.dart';
part 'daos/attachment_dao.dart';
part 'daos/user_dao.dart';
part 'daos/allowance_dao.dart';
part 'daos/bill_dao.dart';
part 'daos/category_dao.dart';
part 'daos/account_dao.dart';
part 'daos/transaction_dao.dart';
part 'daos/budget_dao.dart';
part 'daos/recurring_transaction_dao.dart';
part 'daos/goal_dao.dart';
part 'migrations/database_migrations.dart';
part 'app_database.g.dart';

// Accounts Table

// Categories Table

// Transactions Table

// Budgets Table

// --- DAOs (Data Access Objects) ---

class LastOwnerException implements Exception {
  final String message;
  const LastOwnerException([
    this.message =
        'Cannot remove or demote the last owner of a wallet. Every wallet must have at least one owner.',
  ]);

  @override
  String toString() => message;
}

class WalletPermissionDeniedException implements Exception {
  final String message;
  const WalletPermissionDeniedException([
    this.message = 'Permission denied for this wallet operation.',
  ]);

  @override
  String toString() => message;
}

class InvalidActiveWalletException implements Exception {
  final String message;
  const InvalidActiveWalletException([
    this.message =
        'No valid active wallet available for the current user context.',
  ]);

  @override
  String toString() => message;
}

// --- DATABASE CLASS ---

/// Schema version this build understands. Shared with backup validation and
/// the recovery screen, which must not import a database instance.
const int kCurrentSchemaVersion = 19;

/// Money columns that must be stored as integer minor units.
///
/// Drift already declares these as `INTEGER` (via `MoneyConverter`), but
/// databases created before schema v13 physically still hold `REAL` values.
/// The v18 migration rewrites any column whose declared type is still floating
/// point.
const Map<String, List<String>> kMoneyColumns = {
  'accounts': ['opening_balance'],
  'transactions': ['amount'],
  'recurring_transactions': ['amount'],
  'budgets': ['amount'],
  'peer_debts': ['amount'],
  'loans': ['principal_amount', 'emi_amount'],
  'wallet_bills': ['amount'],
  'wallet_settlements': ['amount'],
  'wallet_allowances': ['amount'],
  'wallet_allowance_payments': ['amount'],
  'wallet_goals': ['target_amount', 'current_amount'],
  'wallet_goal_contributions': ['amount'],
  'wallet_goal_schedules': ['amount'],
  'wallet_expense_split_members': ['amount_owed', 'settled_amount'],
};

/// Tables whose deletes are tombstoned for sync, mapped to the SQL expression
/// that yields their wallet id (`NULL` for wallet-independent tables).
const Map<String, String> kTombstonedTables = {
  'accounts': 'OLD.wallet_id',
  'budgets': 'OLD.wallet_id',
  'categories': 'NULL',
  'transactions': 'OLD.wallet_id',
  'recurring_transactions': 'OLD.wallet_id',
  'loans': 'OLD.wallet_id',
  'peer_debts': 'OLD.wallet_id',
  'wallet_expense_splits': 'OLD.wallet_id',
  'wallet_settlements': 'OLD.wallet_id',
  'wallet_activities': 'OLD.wallet_id',
  'wallets': 'NULL',
};

@DriftDatabase(
  tables: [
    Accounts,
    WalletBills,
    Budgets,
    Categories,
    WalletNotifications,
    Loans,
    PeerDebts,
    WalletAllowances,
    WalletAllowancePayments,
    WalletSettlements,
    Wallets,
    WalletInvitations,
    WalletMembers,
    WalletGoals,
    WalletGoalContributions,
    WalletGoalSchedules,
    FeedbackEntries,
    WalletNotificationPreferences,
    DeletedRecords,
    SyncConflicts,
    Attachments,
    WalletExpenseSplits,
    WalletExpenseSplitMembers,
    MerchantMappings,
    Payees,
    RecurringTransactions,
    SmsImportMetrics,
    Tags,
    Transactions,
    UnrecognizedSmsEntries,
    WalletActivities,
    Users,
  ],
  daos: [
    CategoryDao,
    AccountDao,
    TransactionDao,
    BudgetDao,
    RecurringTransactionDao,
    DebtsDao,
    WalletDao,
    TransactionTagDao,
    AttachmentDao,
    AllowanceDao,
    GoalDao,
    BillDao,
    PayeeDao,
    SmsParsingDao,
    SmsImportMetricsDao,
    UserDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => kCurrentSchemaVersion;

  /// Records a tombstone manually.
  ///
  /// Deletes performed through SQL (any DAO, cascade or raw statement) are
  /// tombstoned by the triggers installed in [_ensureDeletionTriggers]; this is
  /// available for callers that need to write one explicitly.
  Future<int> insertDeletedRecord(
    String uuid,
    String tableName, {
    int? walletId,
  }) {
    return into(deletedRecords).insert(
      DeletedRecordsCompanion.insert(
        uuid: uuid,
        deletedTable: tableName,
        walletId: Value(walletId),
      ),
    );
  }

  /// Converts legacy `REAL` money columns to exact integer minor units.
  ///
  /// SQLite cannot change a column's declared type in place, so each affected
  /// column is replaced: add an integer sibling, round the value half away from
  /// zero (`ROUND(value * 100)`), drop the old column and rename the sibling.
  /// Columns that are already `INTEGER` (the normal case) are left untouched,
  /// which makes this idempotent.
  ///
  /// [columns] is overridable for tests; production uses [kMoneyColumns].
  Future<void> convertLegacyMoneyColumns({
    Map<String, List<String>> columns = kMoneyColumns,
  }) async {
    for (final entry in columns.entries) {
      final table = entry.key;
      final info = await customSelect("PRAGMA table_info('$table')").get();
      if (info.isEmpty) continue; // Table did not exist in this schema.

      final declaredTypes = <String, String>{
        for (final row in info)
          row.read<String>('name'): row.read<String>('type').toUpperCase(),
      };

      for (final column in entry.value) {
        final type = declaredTypes[column];
        if (type == null) continue; // Column did not exist in this schema.
        final isFloatingPoint =
            type.contains('REAL') ||
            type.contains('DOUBLE') ||
            type.contains('FLOAT') ||
            type.contains('NUMERIC');
        if (!isFloatingPoint) continue;

        final temporary = '${column}_minor_tmp';
        await customStatement(
          'ALTER TABLE "$table" ADD COLUMN "$temporary" INTEGER',
        );
        await customStatement(
          'UPDATE "$table" SET "$temporary" = '
          'CAST(ROUND("$column" * 100.0) AS INTEGER) '
          'WHERE "$column" IS NOT NULL',
        );
        await customStatement('ALTER TABLE "$table" DROP COLUMN "$column"');
        await customStatement(
          'ALTER TABLE "$table" RENAME COLUMN "$temporary" TO "$column"',
        );
      }
    }
  }

  /// Installs `AFTER DELETE` triggers that write a `deleted_records` row for
  /// every synced table. Idempotent.
  Future<void> _ensureDeletionTriggers() async {
    for (final entry in kTombstonedTables.entries) {
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS ${entry.key}_tombstone
        AFTER DELETE ON ${entry.key}
        BEGIN
          INSERT INTO deleted_records (uuid, table_name, wallet_id, deleted_at)
          VALUES (OLD.uuid, '${entry.key}', ${entry.value},
                  CAST(strftime('%s', 'now') AS INTEGER));
        END
      ''');
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: createSchema, onUpgrade: upgradeSchema);
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

/// File name of the on-device SQLite database. Shared with the backup/restore
/// service (`core/services/backup_service.dart`) so both agree on the location.
const String kDatabaseFileName = 'db.sqlite';

/// Memoized key-resolution result.
///
/// Resolution must run once per process: the plaintext → encrypted migration
/// must not race with itself, and the recovery UI needs the exact same outcome
/// as the database opener. A failed future is cached too; the recovery screen
/// clears the cache before retrying.
Future<DatabaseOpenPlan>? _cachedOpenPlan;

/// Resolves (and caches) how the on-device database must be opened.
///
/// Throws [DatabaseKeyUnavailableException] when the database is encrypted but
/// cannot be unlocked. It never falls back to opening an encrypted file as
/// plaintext.
Future<DatabaseOpenPlan> resolveDatabaseOpenPlan({bool forceReload = false}) {
  if (forceReload) _cachedOpenPlan = null;
  return _cachedOpenPlan ??= _resolveDatabaseOpenPlan();
}

/// Drops the memoized resolution so the next call retries from scratch.
void resetDatabaseOpenPlanCache() {
  _cachedOpenPlan = null;
}

Future<DatabaseOpenPlan> _resolveDatabaseOpenPlan() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, kDatabaseFileName));
  return DatabaseEncryption.resolveOpenPlan(
    file: file,
    store: SecureStorageKeyValueStore(),
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, kDatabaseFileName));

    // A3: encrypt at rest with a random key held in the platform keystore
    // (option (a) - the PIN stays a UI gate, so a PIN reset cannot lose data).
    // Resolution fails closed: an encrypted database is never opened as
    // plaintext (see DatabaseEncryption.resolveOpenPlan).
    final plan = await resolveDatabaseOpenPlan();

    DatabaseSetup? setup;
    if (plan.base64Key != null) {
      final key = plan.base64Key!;
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
