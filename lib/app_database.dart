import 'dart:io';

import 'package:drift/drift.dart';
export 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/default_accounts.dart';
import 'package:expense_tracker/default_categories.dart';
import 'package:path/path.dart' as p;

// Import the generated part file
part 'app_database.g.dart';

// --- ENUMS ---
// It's a good practice to use enums for fields with a fixed set of values.
enum TransactionType {
  income,
  expense,
}

enum AccountType {
  bank,
  creditCard,
  loan,
  cash,
  income,
}

enum PeerDebtType {
  lent,
  borrowed,
}

// --- TABLE DEFINITIONS ---

// Accounts Table
@DataClassName('Account')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => text().map(const EnumNameConverter(AccountType.values))();
  IntColumn get icon => integer()();
  TextColumn get color => text()();
  RealColumn get openingBalance => real().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

// Categories Table
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get icon => integer()(); // Storing icon codepoint
  TextColumn get color => text()(); // Storing color as a hex string (e.g., "FF0000")
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get parentId => integer().nullable().references(Categories, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

// Transactions Table
@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  // Enum for transaction type
  TextColumn get type => text().map(const EnumNameConverter(TransactionType.values))();

  // Foreign key to Categories table
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  // Foreign key to Accounts table
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Budgets Table
@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  RealColumn get amount => real()();
  TextColumn get period => text()(); // e.g., '2024-07' for monthly budget

  // Foreign key to Categories table
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

// --- DAOs (Data Access Objects) ---

@DriftAccessor(tables: [Categories])
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

@DriftAccessor(tables: [Accounts, Transactions])
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

@DriftAccessor(tables: [Transactions, Categories, Accounts])
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

@DriftAccessor(tables: [Budgets, Categories])
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
@DataClassName('RecurringTransactionDb')
class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get type => text().map(const EnumNameConverter(TransactionType.values))();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.restrict)();
  TextColumn get interval => text()(); // 'daily', 'weekly', 'monthly', 'yearly'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime()();
  DateTimeColumn get lastGeneratedDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

// Deleted Records Table for Sync Tracking
@DataClassName('DeletedRecord')
class DeletedRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get deletedTable => text().named('table_name')();
  DateTimeColumn get deletedAt => dateTime().withDefault(currentDateAndTime)();
}

// Loans Table
@DataClassName('LoanDb')
class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  RealColumn get principalAmount => real()();
  RealColumn get interestRate => real()();
  IntColumn get tenureMonths => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextEmiDate => dateTime().nullable()();
  RealColumn get emiAmount => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

// Peer Debts Table
@DataClassName('PeerDebtDb')
class PeerDebts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get personName => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().map(const EnumNameConverter(PeerDebtType.values))();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

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

@DriftAccessor(tables: [RecurringTransactions, Categories, Accounts])
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
  tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions, DeletedRecords, Loans, PeerDebts],
  daos: [CategoryDao, AccountDao, TransactionDao, BudgetDao, RecurringTransactionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  Future<int> insertDeletedRecord(String uuid, String tableName) {
    return into(deletedRecords).insert(
      DeletedRecordsCompanion.insert(
        uuid: uuid,
        deletedTable: tableName,
      ),
    );
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
        await customStatement('''
          CREATE TRIGGER after_account_delete AFTER DELETE ON accounts
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'accounts', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_category_delete AFTER DELETE ON categories
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'categories', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_transaction_delete AFTER DELETE ON transactions
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'transactions', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_budget_delete AFTER DELETE ON budgets
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'budgets', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_recurring_delete AFTER DELETE ON recurring_transactions
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'recurring_transactions', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_loan_delete AFTER DELETE ON loans
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'loans', strftime('%s', 'now'));
          END;
        ''');
        await customStatement('''
          CREATE TRIGGER after_peer_debt_delete AFTER DELETE ON peer_debts
          BEGIN
            INSERT INTO deleted_records (uuid, table_name, deleted_at)
            VALUES (OLD.uuid, 'peer_debts', strftime('%s', 'now'));
          END;
        ''');
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
          await m.createTable(deletedRecords);

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
          await customStatement('''
            CREATE TRIGGER after_account_delete AFTER DELETE ON accounts
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'accounts', strftime('%s', 'now'));
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER after_category_delete AFTER DELETE ON categories
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'categories', strftime('%s', 'now'));
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER after_transaction_delete AFTER DELETE ON transactions
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'transactions', strftime('%s', 'now'));
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER after_budget_delete AFTER DELETE ON budgets
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'budgets', strftime('%s', 'now'));
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER after_recurring_delete AFTER DELETE ON recurring_transactions
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'recurring_transactions', strftime('%s', 'now'));
            END;
          ''');
        }
        if (from < 6) {
          await m.createTable(loans);
          await m.createTable(peerDebts);

          await customStatement('''
            CREATE TRIGGER after_loan_delete AFTER DELETE ON loans
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'loans', strftime('%s', 'now'));
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER after_peer_debt_delete AFTER DELETE ON peer_debts
            BEGIN
              INSERT INTO deleted_records (uuid, table_name, deleted_at)
              VALUES (OLD.uuid, 'peer_debts', strftime('%s', 'now'));
            END;
          ''');
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

// This is the function that opens the database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final stopwatch = Stopwatch()..start();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final database = NativeDatabase.createInBackground(file);
    if (kDebugMode) {
      debugPrint('Database connection prepared in ${stopwatch.elapsedMilliseconds}ms');
    }
    return database;
  });
}
