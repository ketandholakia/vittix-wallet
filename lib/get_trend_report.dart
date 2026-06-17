import 'package:expense_tracker/domain/entities/trend_data_point.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

class GetTrendReport {
  final TransactionRepository repository;

  GetTrendReport(this.repository);

  Future<List<TrendDataPoint>> call(int months) {
    return repository.getMonthlyTrend(months);
  }
}