part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

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
  /// Moves every transaction from one category to another.
  ///
  /// Deleting a category must never orphan its history (the lists inner-join
  /// categories, so orphaned rows silently vanish from the UI while still
  /// counting in balances) nor erase it (`transactions.categoryId` cascades if
  /// foreign keys are ever enabled). Callers reassign first, then delete.
  Future<int> reassignTransactionsForCategory(
    int fromCategoryId,
    int toCategoryId, [
    int? walletId,
  ]) {
    final query = update(transactions)
      ..where((t) => t.categoryId.equals(fromCategoryId));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.write(TransactionsCompanion(categoryId: Value(toCategoryId)));
  }

  /// Moves every transaction from one account to another. Accounts use
  /// `restrict` on delete, so this is what lets an account be removed without
  /// rejecting the delete or losing its history.
  Future<int> reassignTransactionsForAccount(
    int fromAccountId,
    int toAccountId, [
    int? walletId,
  ]) {
    final query = update(transactions)
      ..where((t) => t.accountId.equals(fromAccountId));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.write(TransactionsCompanion(accountId: Value(toAccountId)));
  }

  Future<int> insertTransaction(Insertable<Transaction> transaction, [int? walletId]) {
    if (walletId != null && transaction is TransactionsCompanion) {
      transaction = transaction.copyWith(walletId: Value(walletId));
    }
    return into(transactions).insert(transaction);
  }

  // Edit (with cross-wallet guard)
  Future<bool> updateTransaction(Insertable<Transaction> transaction, [int? walletId]) async {
    if (transaction is TransactionsCompanion && transaction.id.present) {
      final targetWalletId = walletId ?? (transaction.walletId.present ? transaction.walletId.value : null);
      if (targetWalletId != null) {
        final rows = await (update(transactions)
          ..where((t) => t.id.equals(transaction.id.value) & t.walletId.equals(targetWalletId)))
          .write(transaction);
        return rows > 0;
      }
    } else if (transaction is Transaction) {
      final targetWalletId = walletId ?? transaction.walletId;
      final rows = await (update(transactions)
        ..where((t) => t.id.equals(transaction.id) & t.walletId.equals(targetWalletId)))
        .write(transaction);
      return rows > 0;
    }
    return update(transactions).replace(transaction);
  }

  // Delete (with cross-wallet guard)
  Future<int> deleteTransaction(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(transactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).go();
    }
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  // Get single transaction by ID with wallet isolation
  Future<Transaction?> getTransactionById(int id, [int? walletId]) {
    final query = select(transactions)..where((t) => t.id.equals(id));
    if (walletId != null) {
      query.where((t) => t.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  // Get transaction with details by ID with wallet isolation
  Future<TransactionWithDetails?> getTransactionWithDetailsById(int id, [int? walletId]) async {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])..where(transactions.id.equals(id));
    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return _mapTransactionRows(rows).first;
  }

  // Get By Month
  Stream<List<TransactionWithDetails>> watchTransactionsInMonth(DateTime month, [int? walletId]) {
    final firstDay = DateTime(month.year, month.month, 1);
    // Half-open range [firstDay, nextMonthStart) so transactions on the last
    // day of the month (which carry a time of day) are not dropped.
    final nextMonthStart = DateTime(month.year, month.month + 1, 1);

    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..where(transactions.date.isBiggerOrEqualValue(firstDay) &
          transactions.date.isSmallerThanValue(nextMonthStart))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get recent transactions
  Stream<List<TransactionWithDetails>> watchRecentTransactions({int limit = 10, int? walletId}) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)])
      ..limit(limit);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get all transactions (watches changes)
  Stream<List<TransactionWithDetails>> watchAllTransactions([int? walletId]) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
    ])
      ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.id)]);

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    return query.watch().map(_mapTransactionRows);
  }

  // Get monthly expenses for trend report
  Future<List<MonthlyTotal>> getMonthlyExpensesForLastNMonths(int n, [int? walletId]) async {
    final now = DateTime.now();
    // Go back n-1 months from the start of the current month
    final startDate = DateTime(now.year, now.month - (n - 1), 1);

    final year = transactions.date.year;
    final month = transactions.date.month;
    final totalAmount = transactions.amount.sum();

    final query = selectOnly(transactions)
      ..addColumns([year, month, totalAmount])
      ..where(transactions.type.equalsValue(TransactionType.expense) & transactions.date.isBiggerOrEqualValue(startDate));

    if (walletId != null) {
      query.where(transactions.walletId.equals(walletId));
    }

    query.groupBy([year, month]);

    return query.map((row) {
      return MonthlyTotal(
          year: row.read(year)!, month: row.read(month)!, total: Money.toMajorUnits(row.read(totalAmount) ?? 0));
    }).get();
  }

  Future<MonthlySummaryTotals> getMonthlySummaryTotals(DateTime month, [int? walletId]) async {
    final firstDay = DateTime(month.year, month.month, 1);
    // Half-open range [firstDay, nextMonthStart) so transactions on the last
    // day of the month (which carry a time of day) are not dropped.
    final nextMonthStart = DateTime(month.year, month.month + 1, 1);

    final incomeSum = transactions.amount.sum();
    final expenseSum = transactions.amount.sum();

    final incomeQuery = selectOnly(transactions)
      ..addColumns([incomeSum])
      ..where(
        transactions.type.equalsValue(TransactionType.income) &
            transactions.date.isBiggerOrEqualValue(firstDay) &
            transactions.date.isSmallerThanValue(nextMonthStart) &
            transactions.transferGroupId.isNull(),
      );
    if (walletId != null) {
      incomeQuery.where(transactions.walletId.equals(walletId));
    }
    final incomeRow = await incomeQuery.getSingle();

    final expenseQuery = selectOnly(transactions)
      ..addColumns([expenseSum])
      ..where(
        transactions.type.equalsValue(TransactionType.expense) &
            transactions.date.isBiggerOrEqualValue(firstDay) &
            transactions.date.isSmallerThanValue(nextMonthStart) &
            transactions.transferGroupId.isNull(),
      );
    if (walletId != null) {
      expenseQuery.where(transactions.walletId.equals(walletId));
    }
    final expenseRow = await expenseQuery.getSingle();

    return MonthlySummaryTotals(
      // Summed in SQL as exact minor units, converted once at the boundary.
      totalIncome: Money.toMajorUnits(incomeRow.read(incomeSum) ?? 0),
      totalExpense: Money.toMajorUnits(expenseRow.read(expenseSum) ?? 0),
    );
  }
}

