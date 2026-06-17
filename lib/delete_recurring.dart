import 'package:expense_tracker/recurring_transaction_repository.dart';

class DeleteRecurring {
  final RecurringTransactionRepository repository;

  DeleteRecurring(this.repository);

  Future<void> call(int id) {
    return repository.delete(id);
  }
}
