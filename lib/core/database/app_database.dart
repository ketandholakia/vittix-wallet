export 'package:expense_tracker/core/database/database_enums.dart';
import 'dart:io';

import 'package:drift/drift.dart';
export 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/default_accounts.dart';
import 'package:expense_tracker/default_categories.dart';
import 'package:path/path.dart' as p;

// Import the generated part file

import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/bills/data/tables/bills_table.dart';
import 'package:expense_tracker/features/budgets/data/tables/budgets_table.dart';
import 'package:expense_tracker/features/categories/data/tables/categories_table.dart';
import 'package:expense_tracker/features/dashboard/data/tables/notifications_table.dart';
import 'package:expense_tracker/features/debts/data/tables/loans_table.dart';
import 'package:expense_tracker/features/debts/data/tables/peer_debts_table.dart';
import 'package:expense_tracker/features/family/data/tables/allowances_table.dart';
import 'package:expense_tracker/features/family/data/tables/allowance_payments_table.dart';
import 'package:expense_tracker/features/family/data/tables/settlements_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_invitations_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
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
// sms_import_metrics_table.dart is commented out - class unavailable
import 'package:expense_tracker/features/transactions/data/tables/tags_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/transactions_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/unrecognized_sms_table.dart';
import 'package:expense_tracker/features/debts/data/debts_dao.dart';
part 'app_database.g.dart';






// Accounts Table


// Categories Table


// Transactions Table


// Budgets Table


// --- DAOs (Data Access Objects) ---

/*
@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(AppDatabase db) : super(db);
  Future<List<dynamic>> getMembersForWallet(int id) async => [];
  Future<void> insertActivity(dynamic activity) async {}
}
*/
/*
@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class TransactionTagDao extends DatabaseAccessor<AppDatabase> with _$TransactionTagDaoMixin {
  TransactionTagDao(AppDatabase db) : super(db);
  Future<void> setTagsForTransaction(int txId, List<int> tags) async {}
}
*/
/*
@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class AttachmentDao extends DatabaseAccessor<AppDatabase> with _$AttachmentDaoMixin {
  AttachmentDao(AppDatabase db) : super(db);
  Future<void> insertAttachment(dynamic a) async {}
}
*/
/*
@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class AllowanceDao extends DatabaseAccessor<AppDatabase> with _$AllowanceDaoMixin {
  AllowanceDao(AppDatabase db) : super(db);
}
*/


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

  Stream<List<Account>> watchAllAccounts() => select(accounts).watch();

  Future<int> insertAccount(Insertable<Account> account) => into(accounts).insert(account);

  Future<bool> updateAccount(Insertable<Account> account) => update(accounts).replace(account);

  Future<int> deleteAccount(int id) => (delete(accounts)..where((a) => a.id.equals(id))).go();

  Future<Account?> getAccountById(int id) => (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> countTransactionsForAccount(int accountId) async {
    final count = countAll();
    final query = selectOnly(transactions)
      ..addColumns([count])
      ..where(transactions.accountId.equals(accountId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<double> getBalanceForAccount(Account account) async {
    final accountTransactions = await (select(transactions)..where((t) => t.accountId.equals(account.id))).get();
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

  Future<Map<int, double>> getBalancesForAccounts(List<Account> targetAccounts) async {
    if (targetAccounts.isEmpty) {
      return const {};
    }

    final accountIds = targetAccounts.map((account) => account.id).toList();
    final accountRows = await (select(this.accounts)..where((a) => a.id.isIn(accountIds))).get();
    final transactionsByAccount = await (select(transactions)..where((t) => t.accountId.isIn(accountIds))).get();

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
  Future<int> insertTransaction(Insertable<Transaction> transaction) => into(transactions).insert(transaction);

  // Edit
  Future<bool> updateTransaction(Insertable<Transaction> transaction) => update(transactions).replace(transaction);

  // Delete
  Future<int> deleteTransaction(int id) => (delete(transactions)..where((t) => t.id.equals(id))).go();

  // Get By Month
  Stream<List<TransactionWithDetails>> watchTransactionsInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..where(transactions.date.isBetween(Constant(firstDay), Constant(lastDay)))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    return query.watch().map(_mapTransactionRows);
  }

  // Get recent transactions
  Stream<List<TransactionWithDetails>> watchRecentTransactions({int limit = 10}) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)])
      ..limit(limit);

    return query.watch().map(_mapTransactionRows);
  }

  // Get all transactions (watches changes)
  Stream<List<TransactionWithDetails>> watchAllTransactions() {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)]);

    return query.watch().map(_mapTransactionRows);
  }

  // Get monthly expenses for trend report
  Future<List<MonthlyTotal>> getMonthlyExpensesForLastNMonths(int n) async {
    final now = DateTime.now();
    // Go back n-1 months from the start of the current month
    final startDate = DateTime(now.year, now.month - (n - 1), 1);

    final year = transactions.date.year;
    final month = transactions.date.month;
    final totalAmount = transactions.amount.sum();

    final query = selectOnly(transactions)
      ..addColumns([year, month, totalAmount])
      ..where(transactions.type.equalsValue(TransactionType.expense) & transactions.date.isBiggerOrEqualValue(startDate))
      ..groupBy([year, month]);

    return query.map((row) {
      return MonthlyTotal(
          year: row.read(year)!, month: row.read(month)!, total: row.read(totalAmount) ?? 0.0);
    }).get();
  }

  Future<MonthlySummaryTotals> getMonthlySummaryTotals(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final incomeSum = transactions.amount.sum();
    final expenseSum = transactions.amount.sum();

    final incomeRow = await (selectOnly(transactions)
          ..addColumns([incomeSum])
          ..where(
            transactions.type.equalsValue(TransactionType.income) &
                transactions.date.isBetween(Constant(firstDay), Constant(lastDay)),
          ))
        .getSingle();

    final expenseRow = await (selectOnly(transactions)
          ..addColumns([expenseSum])
          ..where(
            transactions.type.equalsValue(TransactionType.expense) &
                transactions.date.isBetween(Constant(firstDay), Constant(lastDay)),
          ))
        .getSingle();

    return MonthlySummaryTotals(
      totalIncome: incomeRow.read(incomeSum) ?? 0.0,
      totalExpense: expenseRow.read(expenseSum) ?? 0.0,
    );
  }
}

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(AppDatabase db) : super(db);

  // Add
  Future<int> insertBudget(Insertable<Budget> budget) => into(budgets).insert(budget);

  // Update
  Future<bool> updateBudget(Insertable<Budget> budget) => update(budgets).replace(budget);

  // Delete
  Future<int> deleteBudget(int id) => (delete(budgets)..where((b) => b.id.equals(id))).go();

  // Watch all budgets with their categories
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

  Stream<List<RecurringTransactionWithDetails>> watchAllWithDetails() {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..orderBy([OrderingTerm.desc(recurringTransactions.nextDueDate)]);
    return query.watch().map(_mapRows);
  }

  Future<List<RecurringTransactionWithDetails>> getActiveTemplatesWithDetails() async {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.isActive.equals(true));
    final rows = await query.get();
    return _mapRows(rows);
  }

  Future<int> insertTemplate(Insertable<RecurringTransactionDb> template) => into(recurringTransactions).insert(template);

  Future<bool> updateTemplate(Insertable<RecurringTransactionDb> template) => update(recurringTransactions).replace(template);

  Future<int> deleteTemplate(int id) => (delete(recurringTransactions)..where((t) => t.id.equals(id))).go();
}

// --- DATABASE CLASS ---

@DriftDatabase(
  tables: [Accounts, WalletBills, Budgets, Categories, WalletNotifications, Loans, PeerDebts, WalletAllowances, WalletAllowancePayments, WalletSettlements, Wallets, WalletInvitations, WalletMembers, WalletGoals, WalletGoalContributions, WalletGoalSchedules, FeedbackEntries, WalletNotificationPreferences, DeletedRecords, Attachments, WalletExpenseSplits, WalletExpenseSplitMembers, MerchantMappings, Payees, RecurringTransactions, Tags, Transactions, UnrecognizedSmsEntries],
  daos: [CategoryDao, AccountDao, TransactionDao, BudgetDao, RecurringTransactionDao, DebtsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

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

/*
@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  Stream<List<WalletGoal>> watchGoals(int walletId) {
    return (select(walletGoals)..where((g) => g.walletId.equals(walletId))..orderBy([(g) => OrderingTerm.desc(g.updatedAt)])).watch();
  }
  */


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
