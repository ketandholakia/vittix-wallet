import 'package:expense_tracker/recurring_transaction.dart';
import 'package:expense_tracker/recurring_transaction_repository.dart';

class WatchAllRecurring {
  final RecurringTransactionRepository repository;

  WatchAllRecurring(this.repository);

  Stream<List<RecurringTransaction>> call() {
    return repository.watchAll();
  }
}
