part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(AppDatabase db) : super(db);

  // Add
  Future<int> insertBudget(Insertable<Budget> budget) => into(budgets).insert(budget);

  // Update with wallet ownership check
  Future<bool> updateBudget(int walletId, Insertable<Budget> budget) async {
    if (budget is BudgetsCompanion && budget.id.present) {
      final rows = await (update(budgets)
        ..where((b) => b.id.equals(budget.id.value) & b.walletId.equals(walletId)))
        .write(budget);
      return rows > 0;
    }
    return update(budgets).replace(budget);
  }

  // Delete with wallet ownership check
  Future<int> deleteBudget(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(budgets)..where((b) => b.id.equals(id) & b.walletId.equals(walletId))).go();
    }
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  Future<Budget?> getBudgetById(int id, [int? walletId]) {
    if (walletId != null) {
      return (select(budgets)..where((b) => b.id.equals(id) & b.walletId.equals(walletId))).getSingleOrNull();
    }
    return (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  // Watch budgets with category for a specific wallet
  Stream<List<BudgetWithCategory>> watchBudgetsWithCategory(int walletId) {
    final query = select(budgets).join([
      innerJoin(categories, categories.id.equalsExp(budgets.categoryId)),
    ])..where(budgets.walletId.equals(walletId));

    return query.watch().map((rows) {
      return rows.map((row) {
        return BudgetWithCategory(
          budget: row.readTable(budgets),
          category: row.readTable(categories),
        );
      }).toList();
    });
  }

  // Get budgets with category for a specific wallet
  Future<List<BudgetWithCategory>> getBudgetsForWallet(int walletId) async {
    final query = select(budgets).join([
      innerJoin(categories, categories.id.equalsExp(budgets.categoryId)),
    ])..where(budgets.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((row) {
      return BudgetWithCategory(
        budget: row.readTable(budgets),
        category: row.readTable(categories),
      );
    }).toList();
  }

  // Watch all budgets with their categories (legacy/fallback)
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

