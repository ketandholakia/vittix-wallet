import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';
import 'package:expense_tracker/features/recurring/data/recurring_transaction_repository.dart';

class WatchAllRecurring {
  final RecurringTransactionRepository repository;

  WatchAllRecurring(this.repository);

  Stream<List<RecurringTransaction>> call() {
    return repository.watchAll();
  }
}
