import 'package:vittix_wallet/features/transactions/domain/transaction.dart';

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
