import 'package:vittix_wallet/domain/entities/transaction.dart';
import 'package:vittix_wallet/domain/repositories/transaction_repository.dart';

class WatchRecentTransactions {
  final TransactionRepository repository;

  WatchRecentTransactions(this.repository);

  Stream<List<Transaction>> call({int limit = 10}) {
    return repository.watchRecentTransactions(limit: limit);
  }
}
