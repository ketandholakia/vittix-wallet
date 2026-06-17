import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/trend_data_point.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> watchTransactionsInMonth(DateTime month);
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10});
  Stream<List<Transaction>> watchAllTransactions();
  Future<List<TrendDataPoint>> getMonthlyTrend(int months);
  Future<(double totalIncome, double totalExpense)> getMonthlySummaryTotals(DateTime month);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(int id);
}
