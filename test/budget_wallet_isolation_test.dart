import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Budget, Category;
import 'package:expense_tracker/features/budgets/data/budget_repository_impl.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late int walletIdA;
  late int walletIdB;
  late int categoryId;
  late Category categoryEntity;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    // Insert Wallet A (id = 1) and Wallet B (id = 2)
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert a category for testing
    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Groceries'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );

    categoryEntity = Category(
      id: categoryId,
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Colors.red,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-1 Budget Wallet Isolation Tests', () {
    test('Test 1 — Budget belongs to wallet', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      
      final budgetA = Budget(
        id: 0,
        amount: 500.0,
        period: '2026-09',
        category: categoryEntity,
      );

      await repoA.addBudget(budgetA);

      final dbBudgets = await database.budgetDao.getBudgetsForWallet(walletIdA);
      expect(dbBudgets.length, 1);
      expect(dbBudgets.first.budget.walletId, walletIdA);
      expect(dbBudgets.first.budget.amount, 500.0);
    });

    test('Test 2 — Wallet isolation', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      final repoB = BudgetRepositoryImpl(database.budgetDao, walletIdB);

      await repoA.addBudget(Budget(
        id: 0,
        amount: 100.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      await repoB.addBudget(Budget(
        id: 0,
        amount: 200.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      final budgetsA = await repoA.watchAllBudgets().first;
      final budgetsB = await repoB.watchAllBudgets().first;

      expect(budgetsA.length, 1);
      expect(budgetsA.first.amount, 100.0);
      expect(budgetsA.first.walletId, walletIdA);

      expect(budgetsB.length, 1);
      expect(budgetsB.first.amount, 200.0);
      expect(budgetsB.first.walletId, walletIdB);
    });

    test('Test 3 — Cross-wallet budget cannot be updated', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      final repoB = BudgetRepositoryImpl(database.budgetDao, walletIdB);

      // Create budget in Wallet B
      await repoB.addBudget(Budget(
        id: 0,
        amount: 300.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      final budgetsBBefore = await repoB.watchAllBudgets().first;
      final budgetBId = budgetsBBefore.first.id;

      // Attempt to update Wallet B's budget using Wallet A context
      final tamperedBudget = Budget(
        id: budgetBId,
        walletId: walletIdA,
        amount: 9999.0,
        period: '2026-09',
        category: categoryEntity,
      );

      await repoA.updateBudget(tamperedBudget);

      // Verify Wallet B budget is unchanged
      final budgetsBAfter = await repoB.watchAllBudgets().first;
      expect(budgetsBAfter.first.amount, 300.0);
      expect(budgetsBAfter.first.walletId, walletIdB);
    });

    test('Test 4 — Cross-wallet budget cannot be deleted', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      final repoB = BudgetRepositoryImpl(database.budgetDao, walletIdB);

      // Create budget in Wallet B
      await repoB.addBudget(Budget(
        id: 0,
        amount: 400.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      final budgetsBBefore = await repoB.watchAllBudgets().first;
      final budgetBId = budgetsBBefore.first.id;

      // Attempt deletion using Wallet A context
      await repoA.deleteBudget(budgetBId);

      // Verify Wallet B budget still exists
      final budgetsBAfter = await repoB.watchAllBudgets().first;
      expect(budgetsBAfter.length, 1);
      expect(budgetsBAfter.first.id, budgetBId);
    });

    test('Test 5 — Wallet switching isolation', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      final repoB = BudgetRepositoryImpl(database.budgetDao, walletIdB);

      await repoA.addBudget(Budget(
        id: 0,
        amount: 150.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      await repoB.addBudget(Budget(
        id: 0,
        amount: 250.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      // Simulate switching: Wallet A active
      var activeBudgets = await repoA.watchAllBudgets().first;
      expect(activeBudgets.single.amount, 150.0);

      // Switch to Wallet B
      activeBudgets = await repoB.watchAllBudgets().first;
      expect(activeBudgets.single.amount, 250.0);

      // Switch back to Wallet A
      activeBudgets = await repoA.watchAllBudgets().first;
      expect(activeBudgets.single.amount, 150.0);
    });

    test('Test 6 — Multiple budgets within one wallet', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      final repoB = BudgetRepositoryImpl(database.budgetDao, walletIdB);

      await repoA.addBudget(Budget(id: 0, amount: 100.0, period: '2026-01', category: categoryEntity));
      await repoA.addBudget(Budget(id: 0, amount: 200.0, period: '2026-02', category: categoryEntity));
      await repoA.addBudget(Budget(id: 0, amount: 300.0, period: '2026-03', category: categoryEntity));

      final budgetsA = await repoA.watchAllBudgets().first;
      final budgetsB = await repoB.watchAllBudgets().first;

      expect(budgetsA.length, 3);
      expect(budgetsB.isEmpty, isTrue);
    });

    test('Test 7 — Migration (Default wallet assignment & field preservation)', () async {
      // Insert budget directly with default walletId (legacy migration target)
      await database.into(database.budgets).insert(
        BudgetsCompanion.insert(
          walletId: const Value(1),
          amount: 750.0,
          period: '2026-09',
          categoryId: categoryId,
        ),
      );

      final dbBudgets = await database.budgetDao.getBudgetsForWallet(1);
      expect(dbBudgets.length, 1);
      expect(dbBudgets.first.budget.walletId, 1);
      expect(dbBudgets.first.budget.amount, 750.0);
      expect(dbBudgets.first.budget.period, '2026-09');
    });

    test('Test 8 — Foreign-key behavior (Cascade delete)', () async {
      final repoA = BudgetRepositoryImpl(database.budgetDao, walletIdA);
      await repoA.addBudget(Budget(
        id: 0,
        amount: 600.0,
        period: '2026-09',
        category: categoryEntity,
      ));

      expect((await database.budgetDao.getBudgetsForWallet(walletIdA)).length, 1);

      // Delete Wallet A
      await database.walletDao.deleteWallet(walletIdA);

      // Verify budget is cleaned up
      expect((await database.budgetDao.getBudgetsForWallet(walletIdA)).length, 0);
    });
  });
}
