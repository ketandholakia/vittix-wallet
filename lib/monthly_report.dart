import 'package:expense_tracker/transaction.dart';

class MonthlyReport {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<Transaction> transactions;

  MonthlyReport({
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  }) : balance = totalIncome - totalExpense;
}