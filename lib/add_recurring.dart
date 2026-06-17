import 'package:expense_tracker/recurring_transaction.dart';
import 'package:expense_tracker/recurring_transaction_repository.dart';

class AddRecurring {
  final RecurringTransactionRepository repository;

  AddRecurring(this.repository);

  Future<void> call(RecurringTransaction template) {
    return repository.add(template);
  }
}
