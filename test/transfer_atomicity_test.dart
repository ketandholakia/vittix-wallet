import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A2 — a transfer is a first-class linked pair of rows, written atomically and
/// excluded from income/expense reporting.
void main() {
  late AppDatabase db;
  late int walletId;
  late Account accountA;
  late Account accountB;
  late Category transferCategory;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    walletId = await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Wallet A')));

    final accountIdA = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Cash',
            type: db_enums.AccountType.cash,
            icon: 0,
            color: '00FF00',
          ),
        );
    final accountIdB = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Bank',
            type: db_enums.AccountType.bank,
            icon: 0,
            color: '0000FF',
          ),
        );
    final categoryId = await db.into(db.categories).insert(
          const CategoriesCompanion(
            name: Value('Transfer'),
            icon: Value(0),
            color: Value('FF0000'),
          ),
        );

    accountA = Account(
      id: accountIdA,
      name: 'Cash',
      type: AccountType.cash,
      icon: Icons.money,
      color: const Color(0xFF00FF00),
    );
    accountB = Account(
      id: accountIdB,
      name: 'Bank',
      type: AccountType.bank,
      icon: Icons.money,
      color: const Color(0xFF0000FF),
    );
    transferCategory = Category(
      id: categoryId,
      name: 'Transfer',
      icon: Icons.swap_horiz,
      color: const Color(0xFFFF0000),
    );
  });

  tearDown(() async {
    await db.close();
  });

  Transaction leg({
    required Account account,
    required TransactionType type,
    double amount = 500,
  }) {
    return Transaction(
      id: 0,
      amount: amount,
      date: DateTime(2026, 5, 10),
      note: '[Transfer]',
      type: type,
      category: transferCategory,
      account: account,
      createdAt: DateTime(2026, 5, 10),
      updatedAt: DateTime(2026, 5, 10),
    );
  }

  TransactionRepositoryImpl repository() =>
      TransactionRepositoryImpl(db.transactionDao, walletId, db.walletDao);

  test('both legs are written with one shared transfer group id', () async {
    await repository().addTransfer(
      leg(account: accountA, type: TransactionType.expense),
      leg(account: accountB, type: TransactionType.income),
    );

    final rows = await db.select(db.transactions).get();
    expect(rows.length, 2);

    final groupIds = rows.map((r) => r.transferGroupId).toSet();
    expect(groupIds.length, 1, reason: 'legs must share one group id');
    expect(groupIds.single, isNotNull);

    expect(rows.where((r) => r.type == db_enums.TransactionType.expense).length, 1);
    expect(rows.where((r) => r.type == db_enums.TransactionType.income).length, 1);
    expect(
      rows.map((r) => r.accountId).toSet(),
      equals({accountA.id, accountB.id}),
    );
  });

  test('a normal entry has no transfer group id', () async {
    await repository().addTransaction(
      Transaction(
        id: 0,
        amount: 100,
        date: DateTime(2026, 5, 11),
        type: TransactionType.expense,
        category: transferCategory,
        account: accountA,
        createdAt: DateTime(2026, 5, 11),
        updatedAt: DateTime(2026, 5, 11),
      ),
    );

    final rows = await db.select(db.transactions).get();
    expect(rows.single.transferGroupId, isNull);
  });

  test('transfers are excluded from monthly income and expense totals',
      () async {
    final repo = repository();

    await repo.addTransfer(
      leg(account: accountA, type: TransactionType.expense),
      leg(account: accountB, type: TransactionType.income),
    );

    // An ordinary expense that must still be counted.
    await repo.addTransaction(
      Transaction(
        id: 0,
        amount: 100,
        date: DateTime(2026, 5, 11),
        type: TransactionType.expense,
        category: transferCategory,
        account: accountA,
        createdAt: DateTime(2026, 5, 11),
        updatedAt: DateTime(2026, 5, 11),
      ),
    );

    final totals = await db.transactionDao
        .getMonthlySummaryTotals(DateTime(2026, 5), walletId);

    expect(totals.totalExpense, 100, reason: 'transfer leg must not count');
    expect(totals.totalIncome, 0, reason: 'transfer leg must not count');
  });
}
