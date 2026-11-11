import 'package:vittix_wallet/domain/entities/trend_data_point.dart';
import 'package:vittix_wallet/domain/repositories/transaction_repository.dart';

class GetTrendReport {
  final TransactionRepository repository;

  GetTrendReport(this.repository);

  Future<List<TrendDataPoint>> call(int months) {
    return repository.getMonthlyTrend(months);
  }
}
