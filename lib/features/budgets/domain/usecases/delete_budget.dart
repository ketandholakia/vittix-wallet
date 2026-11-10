import 'package:vittix_wallet/domain/repositories/budget_repository.dart';

class DeleteBudget {
  final BudgetRepository repository;

  DeleteBudget(this.repository);

  Future<void> call(int id) {
    return repository.deleteBudget(id);
  }
}