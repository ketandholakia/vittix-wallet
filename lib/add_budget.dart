import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';

class AddBudget {
  final BudgetRepository repository;

  AddBudget(this.repository);

  Future<void> call(Budget budget) {
    return repository.addBudget(budget);
  }
}