part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Stream<List<Account>> watchAllAccounts([int? walletId]) {
    if (walletId != null) {
      return (select(accounts)..where((a) => a.walletId.equals(walletId))).watch();
    }
    return select(accounts).watch();
  }

  Future<int> insertAccount(Insertable<Account> account, [int? walletId]) {
    if (walletId != null && account is AccountsCompanion) {
      return into(accounts).insert(account.copyWith(walletId: Value(walletId)));
    }
    return into(accounts).insert(account);
  }

  Future<bool> updateAccount(Insertable<Account> companion, [int? walletId]) async {
    int? accountId;
    if (companion is Account) {
      accountId = companion.id;
    } else if (companion is AccountsCompanion) {
      accountId = companion.id.present ? companion.id.value : null;
    }

    if (accountId != null && walletId != null) {
      final updatedRows = await (update(accounts)
            ..where((a) => a.id.equals(accountId!) & a.walletId.equals(walletId)))
          .write(companion);
      return updatedRows > 0;
    }

    return update(accounts).replace(companion);
  }

  Future<int> deleteAccount(int id, [int? walletId]) {
    if (walletId != null) {
      return (delete(accounts)..where((a) => a.id.equals(id) & a.walletId.equals(walletId))).go();
    }
    return (delete(accounts)..where((a) => a.id.equals(id))).go();
  }

  Future<Account?> getAccountById(int id, [int? walletId]) {
    if (walletId != null) {
      return (select(accounts)..where((a) => a.id.equals(id) & a.walletId.equals(walletId))).getSingleOrNull();
    }
    return (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  Future<int> countTransactionsForAccount(int accountId, [int? walletId]) async {
    final count = countAll();
    final query = selectOnly(transactions)..addColumns([count]);
    if (walletId != null) {
      query.where(transactions.accountId.equals(accountId) & transactions.walletId.equals(walletId));
    } else {
      query.where(transactions.accountId.equals(accountId));
    }
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<double> getBalanceForAccount(Account account, [int? walletId]) async {
    final query = select(transactions);
    if (walletId != null) {
      query.where((t) => t.accountId.equals(account.id) & t.walletId.equals(walletId));
    } else {
      query.where((t) => t.accountId.equals(account.id));
    }
    final accountTransactions = await query.get();
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

  Future<Map<int, double>> getBalancesForAccounts(List<Account> targetAccounts, [int? walletId]) async {
    if (targetAccounts.isEmpty) {
      return const {};
    }

    final accountIds = targetAccounts.map((account) => account.id).toList();
    final accountRows = await (select(this.accounts)..where((a) => a.id.isIn(accountIds))).get();
    final query = select(transactions);
    if (walletId != null) {
      query.where((t) => t.accountId.isIn(accountIds) & t.walletId.equals(walletId));
    } else {
      query.where((t) => t.accountId.isIn(accountIds));
    }
    final transactionsByAccount = await query.get();

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

