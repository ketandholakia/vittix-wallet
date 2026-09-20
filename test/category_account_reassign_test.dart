import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:flutter_test/flutter_test.dart';

/// A4 — deleting a category or account must never orphan or erase history.
void main() {
  late AppDatabase db;
  late int walletId;
  late int foodId;
  late int travelId;
  late int cashId;
  late int bankId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    walletId = await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Wallet A')));

    cashId = await db.into(db.accounts).insert(AccountsCompanion.insert(
          walletId: Value(walletId),
          name: 'Cash',
          type: db_enums.AccountType.cash,
          icon: 0,
          color: '00FF00',
        ));
    bankId = await db.into(db.accounts).insert(AccountsCompanion.insert(
          walletId: Value(walletId),
          name: 'Bank',
          type: db_enums.AccountType.bank,
          icon: 0,
          color: '0000FF',
        ));

    foodId = await db.into(db.categories).insert(
          const CategoriesCompanion(name: Value('Food'), icon: Value(0), color: Value('FF0000')),
        );
    travelId = await db.into(db.categories).insert(
          const CategoriesCompanion(name: Value('Travel'), icon: Value(0), color: Value('00FF00')),
        );

    Future<void> tx(int categoryId, int accountId, double amount) =>
        db.into(db.transactions).insert(TransactionsCompanion.insert(
              walletId: Value(walletId),
              amount: amount,
              date: DateTime(2026, 6, 1),
              type: db_enums.TransactionType.expense,
              categoryId: categoryId,
              accountId: accountId,
            ));

    await tx(foodId, cashId, 10);
    await tx(foodId, cashId, 20);
    await tx(travelId, bankId, 30);
  });

  tearDown(() async {
    await db.close();
  });

  test('reassigning a category moves its transactions instead of orphaning them',
      () async {
    final moved = await db.transactionDao.reassignTransactionsForCategory(foodId, travelId, walletId);
    expect(moved, 2);

    final remaining = await db.select(db.transactions).get();
    expect(remaining.where((t) => t.categoryId == foodId), isEmpty);
    expect(remaining.where((t) => t.categoryId == travelId).length, 3);
    expect(remaining.length, 3, reason: 'no transaction may be lost');
  });

  test('reassigning an account moves its transactions', () async {
    final moved = await db.transactionDao.reassignTransactionsForAccount(cashId, bankId, walletId);
    expect(moved, 2);

    final rows = await db.select(db.transactions).get();
    expect(rows.where((t) => t.accountId == cashId), isEmpty);
    expect(rows.length, 3);
  });

  test('after reassignment the source category can be deleted safely', () async {
    await db.transactionDao.reassignTransactionsForCategory(foodId, travelId, walletId);
    await db.categoryDao.deleteCategory(foodId);

    final categories = await db.select(db.categories).get();
    expect(categories.map((c) => c.id), isNot(contains(foodId)));

    // The history survives, attached to the replacement category.
    final rows = await db.select(db.transactions).get();
    expect(rows.length, 3);
    expect(rows.every((t) => t.categoryId != foodId), isTrue);
  });

  test('reassignment is wallet-scoped when a wallet is supplied', () async {
    final otherWallet = await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Wallet B')));
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
          walletId: Value(otherWallet),
          amount: 99,
          date: DateTime(2026, 6, 1),
          type: db_enums.TransactionType.expense,
          categoryId: foodId,
          accountId: cashId,
        ));

    final moved = await db.transactionDao.reassignTransactionsForCategory(foodId, travelId, walletId);
    expect(moved, 2, reason: 'the other wallet must be untouched');

    final other = await (db.select(db.transactions)
          ..where((t) => t.walletId.equals(otherWallet)))
        .get();
    expect(other.single.categoryId, foodId);
  });
}
