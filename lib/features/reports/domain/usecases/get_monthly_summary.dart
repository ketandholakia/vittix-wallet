import 'package:expense_tracker/domain/entities/monthly_report.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

class GetMonthlySummary {
  final TransactionRepository repository;

  GetMonthlySummary(this.repository);

  Future<MonthlyReport> call(DateTime month) async {
    final totals = await repository.getMonthlySummaryTotals(month);
    final txStream = repository.watchTransactionsInMonth(month);
    final transactions = await txStream.first;
    return MonthlyReport(
      totalIncome: totals.$1,
      totalExpense: totals.$2,
      transactions: transactions,
    );
  }
}
