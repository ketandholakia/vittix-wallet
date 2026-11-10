import 'package:vittix_wallet/domain/entities/budget.dart';
import 'package:vittix_wallet/domain/repositories/budget_repository.dart';

class AddBudget {
  final BudgetRepository repository;

  AddBudget(this.repository);

  Future<void> call(Budget budget) {
    return repository.addBudget(budget);
  }
}