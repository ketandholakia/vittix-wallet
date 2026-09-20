import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:flutter_test/flutter_test.dart';

/// Regression tests for the monthly range query: it must be the half-open
/// interval [firstDay, nextMonthStart) so that transactions logged on the last
/// day of the month (which carry a time of day) are not silently dropped.
void main() {
  late AppDatabase database;
  late int walletId;
  late int accountId;
  late int categoryId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    walletId = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );

    accountId = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletId),
        name: 'Cash',
        type: db_enums.AccountType.cash,
        icon: 0,
        color: '00FF00',
      ),
    );

    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Food'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<int> addTx({
    required double amount,
    required DateTime date,
    required db_enums.TransactionType type,
  }) {
    return database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            walletId: Value(walletId),
            amount: amount,
            date: date,
            type: type,
            categoryId: categoryId,
            accountId: accountId,
          ),
        );
  }

  group('Monthly range boundary', () {
    test('last day of the month with a time is included in monthly totals',
        () async {
      final month = DateTime(2026, 1);
      // 31 Jan 2026 23:59 — previously fell outside isBetween(first, 31st 00:00).
      await addTx(
        amount: 100,
        date: DateTime(2026, 1, 31, 23, 59),
        type: db_enums.TransactionType.expense,
      );
      await addTx(
        amount: 50,
        date: DateTime(2026, 1, 1, 0, 0),
        type: db_enums.TransactionType.income,
      );

      final totals =
          await database.transactionDao.getMonthlySummaryTotals(month, walletId);
      expect(totals.totalExpense, 100);
      expect(totals.totalIncome, 50);
    });

    test('midnight of the 1st of next month is excluded', () async {
      final month = DateTime(2026, 1);
      await addTx(
        amount: 100,
        date: DateTime(2026, 1, 15, 12),
        type: db_enums.TransactionType.expense,
      );
      await addTx(
        amount: 999,
        date: DateTime(2026, 2, 1, 0, 0),
        type: db_enums.TransactionType.expense,
      );

      final totals =
          await database.transactionDao.getMonthlySummaryTotals(month, walletId);
      expect(totals.totalExpense, 100);
    });

    test('watchTransactionsInMonth includes the last day of a short month',
        () async {
      // February 2026 has 28 days.
      await addTx(
        amount: 10,
        date: DateTime(2026, 2, 28, 23, 30),
        type: db_enums.TransactionType.expense,
      );
      await addTx(
        amount: 20,
        date: DateTime(2026, 3, 1, 0, 1),
        type: db_enums.TransactionType.expense,
      );

      final rows = await database.transactionDao
          .watchTransactionsInMonth(DateTime(2026, 2), walletId)
          .first;

      expect(rows.length, 1);
      expect(rows.first.transaction.amount, 10);
    });
  });
}
