import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/transaction_mapper.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/trend_data_point.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final db.TransactionDao _transactionDao;

  TransactionRepositoryImpl(this._transactionDao);

  @override
  Future<void> addTransaction(Transaction transaction) {
    final companion = transaction.toCompanion().copyWith(id: const Value.absent());
    return _transactionDao.insertTransaction(companion);
  }

  @override
  Future<void> deleteTransaction(int id) {
    return _transactionDao.deleteTransaction(id);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    final companion = transaction.toCompanion();
    return _transactionDao.updateTransaction(companion);
  }

  @override
  Stream<List<Transaction>> watchTransactionsInMonth(DateTime month) {
    return _transactionDao.watchTransactionsInMonth(month).map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10}) {
    return _transactionDao.watchRecentTransactions(limit: limit).map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Stream<List<Transaction>> watchAllTransactions() {
    return _transactionDao.watchAllTransactions().map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Future<List<TrendDataPoint>> getMonthlyTrend(int months) async {
    final result = await _transactionDao.getMonthlyExpensesForLastNMonths(months);
    return result.map((monthlyTotal) {
      return TrendDataPoint(
        date: DateTime(monthlyTotal.year, monthlyTotal.month),
        amount: monthlyTotal.total,
      );
    }).toList();
  }

  @override
  Future<(double totalIncome, double totalExpense)> getMonthlySummaryTotals(DateTime month) async {
    final summary = await _transactionDao.getMonthlySummaryTotals(month);
    return (summary.totalIncome, summary.totalExpense);
  }
}
