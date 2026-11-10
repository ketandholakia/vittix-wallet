import 'package:drift/native.dart';
import 'package:vittix_wallet/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:vittix_wallet/core/database/database_enums.dart' as db_enums;
import 'package:vittix_wallet/features/accounts/data/account_repository_impl.dart';
import 'package:vittix_wallet/features/categories/data/category_repository_impl.dart';
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

  group('reassign-and-delete', () {
    late CategoryRepositoryImpl categories;
    late AccountRepositoryImpl accounts;
    late int diningId;

    setUp(() async {
      categories = CategoryRepositoryImpl(db.categoryDao);
      accounts = AccountRepositoryImpl(db.accountDao, walletId);
      diningId = await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              name: 'Dining',
              icon: 0,
              color: '123456',
              parentId: Value(foodId),
            ),
          );
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            walletId: Value(walletId),
            amount: 40,
            date: DateTime(2026, 6, 2),
            type: db_enums.TransactionType.expense,
            categoryId: diningId,
            accountId: cashId,
          ));
    });

    test('countTransactionsForCategory includes subcategory transactions',
        () async {
      expect(await categories.countTransactionsForCategory(foodId), 3,
          reason: '2 transactions on Food plus 1 on its Dining child');
    });

    test('reassignAndDeleteCategory moves the whole subtree and leaves no orphans',
        () async {
      final moved = await categories.reassignAndDeleteCategory(foodId, travelId);
      expect(moved, 3);

      final rows = await db.select(db.transactions).get();
      expect(rows.length, 4, reason: 'no transaction may be lost');
      expect(rows.where((t) => t.categoryId == foodId || t.categoryId == diningId),
          isEmpty);

      final remainingCategories = await db.select(db.categories).get();
      expect(remainingCategories.map((c) => c.id), isNot(contains(foodId)));
      expect(remainingCategories.map((c) => c.id), isNot(contains(diningId)),
          reason: 'the subcategory must not be left orphaned');
    });

    test('reassignAndDeleteCategory rejects an invalid target', () async {
      await expectLater(
        categories.reassignAndDeleteCategory(foodId, diningId),
        throwsArgumentError,
        reason: 'a target inside the subtree would be deleted with the source',
      );
      await expectLater(
        categories.reassignAndDeleteCategory(foodId, 999999),
        throwsArgumentError,
        reason: 'a non-existent target would orphan the history',
      );

      // Neither rejected call may mutate anything. Counts are scoped to the
      // records this test created — schema creation seeds default categories.
      final rows = await db.select(db.transactions).get();
      expect(rows, hasLength(4), reason: 'no transaction may be lost');
      expect(rows.where((t) => t.categoryId == foodId), hasLength(2),
          reason: 'no transaction may be reassigned away from Food');
      expect(rows.where((t) => t.categoryId == travelId), hasLength(1));
      expect(rows.where((t) => t.categoryId == diningId), hasLength(1));

      final categoriesAfter = await db.select(db.categories).get();
      expect(categoriesAfter.map((c) => c.id),
          containsAll([foodId, travelId, diningId]),
          reason: 'no test category may be deleted');
    });

    test('deleteCategory removes subcategories even without foreign keys',
        () async {
      await categories.deleteCategory(foodId);

      final remaining = await db.select(db.categories).get();
      expect(remaining.map((c) => c.id), isNot(contains(foodId)));
      expect(remaining.map((c) => c.id), isNot(contains(diningId)));
    });

    test('reassignAndDeleteAccount moves history then deletes the account',
        () async {
      final moved = await accounts.reassignAndDeleteAccount(cashId, bankId);
      expect(moved, 3);

      final rows = await db.select(db.transactions).get();
      expect(rows, hasLength(4));
      expect(rows.where((t) => t.accountId == cashId), isEmpty);

      final remainingAccounts = await db.select(db.accounts).get();
      expect(remainingAccounts.map((a) => a.id), isNot(contains(cashId)));
    });

    test('reassignAndDeleteAccount rejects the account itself', () async {
      await expectLater(
        accounts.reassignAndDeleteAccount(cashId, cashId),
        throwsArgumentError,
      );

      // Scoped to the records this test created — schema creation seeds
      // default accounts.
      final rows = await db.select(db.transactions).get();
      expect(rows.where((t) => t.accountId == cashId), hasLength(3),
          reason: 'no transaction may be reassigned away from Cash');
      expect(rows.where((t) => t.accountId == bankId), hasLength(1));

      final accountsAfter = await db.select(db.accounts).get();
      expect(accountsAfter.map((a) => a.id), containsAll([cashId, bankId]),
          reason: 'no test account may be deleted');
    });

    test('reassignAndDeleteAccount rejects a target in another wallet', () async {
      final otherWallet = await db
          .into(db.wallets)
          .insert(const WalletsCompanion(name: Value('Wallet B')));
      final foreignId = await db.into(db.accounts).insert(AccountsCompanion.insert(
            walletId: Value(otherWallet),
            name: 'Foreign',
            type: db_enums.AccountType.bank,
            icon: 0,
            color: 'FFFFFF',
          ));

      await expectLater(
        accounts.reassignAndDeleteAccount(cashId, foreignId),
        throwsStateError,
      );

      // Scoped to the records this test created — schema creation seeds
      // default accounts.
      final rows = await db.select(db.transactions).get();
      expect(rows, hasLength(4), reason: 'no transaction may be lost');
      expect(rows.where((t) => t.accountId == cashId), hasLength(3),
          reason: 'no transaction may be reassigned away from Cash');
      expect(rows.where((t) => t.accountId == bankId), hasLength(1));

      final accountsAfter = await db.select(db.accounts).get();
      expect(accountsAfter.map((a) => a.id),
          containsAll([cashId, bankId, foreignId]),
          reason: 'no test account may be deleted');
    });
  });
}
