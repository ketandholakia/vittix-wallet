import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<void> call(int id) {
    return repository.deleteTransaction(id);
  }
}