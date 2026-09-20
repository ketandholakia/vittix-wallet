import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/trend_data_point.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> watchTransactionsInMonth(DateTime month);
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10});
  Stream<List<Transaction>> watchAllTransactions();
  Future<List<TrendDataPoint>> getMonthlyTrend(int months);
  Future<(double totalIncome, double totalExpense)> getMonthlySummaryTotals(DateTime month);
  Future<Transaction?> getTransactionById(int id);
  Future<void> addTransaction(Transaction transaction, {String source = 'user'});

  /// Writes both legs of a transfer atomically, sharing one transfer group id.
  Future<void> addTransfer(
    Transaction outgoing,
    Transaction incoming, {
    String source = 'user',
  });
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(int id);
}
