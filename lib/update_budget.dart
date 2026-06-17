import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';

class UpdateBudget {
  final BudgetRepository repository;

  UpdateBudget(this.repository);

  Future<void> call(Budget budget) {
    return repository.updateBudget(budget);
  }
}