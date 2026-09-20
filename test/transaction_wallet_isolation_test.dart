import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:expense_tracker/features/transactions/data/transaction_repository_impl.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late int walletIdA;
  late int walletIdB;
  late int accountIdA;
  late int accountIdB;
  late int categoryId;
  late Category categoryEntity;
  late Account accountEntityA;
  late Account accountEntityB;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    // Insert Wallet A (id = 1) and Wallet B (id = 2)
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert Accounts for testing
    accountIdA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Account A',
        type: db_enums.AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    accountIdB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Account B',
        type: db_enums.AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Insert Category for testing
    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Food'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );

    categoryEntity = Category(
      id: categoryId,
      name: 'Food',
      icon: Icons.fastfood,
      color: Colors.red,
    );

    accountEntityA = Account(
      id: accountIdA,
      name: 'Account A',
      type: AccountType.bank,
      icon: Icons.account_balance,
      color: Colors.green,
      openingBalance: 1000.0,
    );

    accountEntityB = Account(
      id: accountIdB,
      name: 'Account B',
      type: AccountType.bank,
      icon: Icons.account_balance,
      color: Colors.blue,
      openingBalance: 2000.0,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-2 Transaction Wallet Isolation Tests', () {
    test('Test 1 — Transaction belongs to wallet', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);

      final txA = Transaction(
        id: 0,
        amount: 150.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(txA);

      final transactionsA = await repoA.watchAllTransactions().first;
      expect(transactionsA.length, 1);
      expect(transactionsA.first.amount, 150.0);
    });

    test('Test 2 — Basic read isolation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 100.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 200.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final txsA = await repoA.watchAllTransactions().first;
      final txsB = await repoB.watchAllTransactions().first;

      expect(txsA.length, 1);
      expect(txsA.first.amount, 100.0);

      expect(txsB.length, 1);
      expect(txsB.first.amount, 200.0);
    });

    test('Test 3 — Recent transaction isolation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 50.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 75.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      final recentA = await repoA.watchRecentTransactions(limit: 10).first;
      final recentB = await repoB.watchRecentTransactions(limit: 10).first;

      expect(recentA.length, 1);
      expect(recentA.first.amount, 50.0);

      expect(recentB.length, 1);
      expect(recentB.first.amount, 75.0);
    });

    test('Test 4 — Monthly summary isolation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 500.0,
        date: now,
        type: TransactionType.income,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 200.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 1000.0,
        date: now,
        type: TransactionType.income,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final summaryA = await repoA.getMonthlySummaryTotals(now);
      final summaryB = await repoB.getMonthlySummaryTotals(now);

      expect(summaryA.$1, 500.0);
      expect(summaryA.$2, 200.0);

      expect(summaryB.$1, 1000.0);
      expect(summaryB.$2, 0.0);
    });

    test('Test 5 — Date-range isolation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 120.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 250.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final txsMonthA = await repoA.watchTransactionsInMonth(now).first;
      final txsMonthB = await repoB.watchTransactionsInMonth(now).first;

      expect(txsMonthA.length, 1);
      expect(txsMonthA.first.amount, 120.0);

      expect(txsMonthB.length, 1);
      expect(txsMonthB.first.amount, 250.0);
    });

    test('Test 6 — Category aggregation isolation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 300.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 400.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final trendA = await repoA.getMonthlyTrend(1);
      final trendB = await repoB.getMonthlyTrend(1);

      expect(trendA.length, 1);
      expect(trendA.first.amount, 300.0);

      expect(trendB.length, 1);
      expect(trendB.first.amount, 400.0);
    });

    test('Test 7 — Cross-wallet update protection', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 300.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final txsBBefore = await repoB.watchAllTransactions().first;
      final txB = txsBBefore.first;

      // Attempt to update Wallet B's transaction using Wallet A context
      final tamperedTx = Transaction(
        id: txB.id,
        amount: 9999.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      );

      await repoA.updateTransaction(tamperedTx);

      final txsBAfter = await repoB.watchAllTransactions().first;
      expect(txsBAfter.first.amount, 300.0);
    });

    test('Test 8 — Cross-wallet delete protection', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 400.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final txsBBefore = await repoB.watchAllTransactions().first;
      final txBId = txsBBefore.first.id;

      // Attempt deletion using Wallet A context
      await repoA.deleteTransaction(txBId);

      final txsBAfter = await repoB.watchAllTransactions().first;
      expect(txsBAfter.length, 1);
      expect(txsBAfter.first.id, txBId);
    });

    test('Test 9 — Transaction-by-ID protection', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 150.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      final txsB = await repoB.watchAllTransactions().first;
      final txBId = txsB.first.id;

      // Attempt lookup from Wallet A context
      final fetchedFromA = await repoA.getTransactionById(txBId);
      expect(fetchedFromA, equals(null));

      // Verify lookup from Wallet B context succeeds
      final fetchedFromB = await repoB.getTransactionById(txBId);
      expect(fetchedFromB, isNotNull);
      expect(fetchedFromB!.amount, 150.0);
    });

    test('Test 10 — Wallet switching', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 111.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      await repoB.addTransaction(Transaction(
        id: 0,
        amount: 222.0,
        date: now,
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityB,
        createdAt: now,
        updatedAt: now,
      ));

      var activeTxs = await repoA.watchAllTransactions().first;
      expect(activeTxs.single.amount, 111.0);

      activeTxs = await repoB.watchAllTransactions().first;
      expect(activeTxs.single.amount, 222.0);

      activeTxs = await repoA.watchAllTransactions().first;
      expect(activeTxs.single.amount, 111.0);
    });

    test('Test 11 — Dashboard/summary isolation', () async {
      final now = DateTime.now();

      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 50.0,
          date: now,
          type: db_enums.TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );

      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdB),
          amount: 100.0,
          date: now,
          type: db_enums.TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdB,
        ),
      );

      final summaryA = await database.transactionDao.getMonthlySummaryTotals(now, walletIdA);
      final summaryB = await database.transactionDao.getMonthlySummaryTotals(now, walletIdB);

      expect(summaryA.totalExpense, 50.0);
      expect(summaryB.totalExpense, 100.0);
    });

    test('Test 12 — Multiple transactions', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      final repoB = TransactionRepositoryImpl(database.transactionDao, walletIdB);
      final now = DateTime.now();

      for (int i = 1; i <= 5; i++) {
        await repoA.addTransaction(Transaction(
          id: 0,
          amount: i * 10.0,
          date: now,
          type: TransactionType.expense,
          category: categoryEntity,
          account: accountEntityA,
          createdAt: now,
          updatedAt: now,
        ));
      }

      for (int i = 1; i <= 3; i++) {
        await repoB.addTransaction(Transaction(
          id: 0,
          amount: i * 100.0,
          date: now,
          type: TransactionType.expense,
          category: categoryEntity,
          account: accountEntityB,
          createdAt: now,
          updatedAt: now,
        ));
      }

      final txsA = await repoA.watchAllTransactions().first;
      final txsB = await repoB.watchAllTransactions().first;

      expect(txsA.length, 5);
      expect(txsB.length, 3);
    });

    test('Test 13 — Recurring transaction ownership', () async {
      final now = DateTime.now();
      await database.into(database.recurringTransactions).insert(
        RecurringTransactionsCompanion.insert(
          name: 'Monthly Netflix',
          amount: 499.0,
          type: db_enums.TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
          interval: 'monthly',
          startDate: now,
          nextDueDate: now,
        ),
      );

      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);
      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 499.0,
        date: now,
        note: '[Recurring] Monthly Netflix',
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      final txsA = await repoA.watchAllTransactions().first;
      expect(txsA.length, 1);
      expect(txsA.first.note, contains('Monthly Netflix'));
    });

    test('Test 14 — SMS/import ownership', () async {
      final now = DateTime.now();
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA);

      await repoA.addTransaction(Transaction(
        id: 0,
        amount: 250.0,
        date: now,
        note: '[SMS Import] HDFC Bank debited 250.0',
        type: TransactionType.expense,
        category: categoryEntity,
        account: accountEntityA,
        createdAt: now,
        updatedAt: now,
      ));

      final txsA = await repoA.watchAllTransactions().first;
      expect(txsA.length, 1);
      expect(txsA.first.note, contains('SMS Import'));
    });

    test('Test 15 — Regression Test for Formerly Unsafe Global Queries', () async {
      final now = DateTime.now();

      // Create Transaction in Wallet A directly in DB
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 350.0,
          date: now,
          type: db_enums.TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );

      // Create Transaction in Wallet B directly in DB
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdB),
          amount: 850.0,
          date: now,
          type: db_enums.TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdB,
        ),
      );

      // Formerly unsafe watchRecentTransactions() without walletId
      final recentA = await database.transactionDao.watchRecentTransactions(limit: 10, walletId: walletIdA).first;
      final recentB = await database.transactionDao.watchRecentTransactions(limit: 10, walletId: walletIdB).first;

      expect(recentA.map((t) => t.transaction.amount), contains(350.0));
      expect(recentA.map((t) => t.transaction.amount), isNot(contains(850.0)));

      expect(recentB.map((t) => t.transaction.amount), contains(850.0));
      expect(recentB.map((t) => t.transaction.amount), isNot(contains(350.0)));

      // Formerly unsafe getMonthlySummaryTotals() without walletId
      final summaryA = await database.transactionDao.getMonthlySummaryTotals(now, walletIdA);
      final summaryB = await database.transactionDao.getMonthlySummaryTotals(now, walletIdB);

      expect(summaryA.totalExpense, 350.0);
      expect(summaryB.totalExpense, 850.0);
    });
  });
}
