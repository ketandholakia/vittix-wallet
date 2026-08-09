import 'package:expense_tracker/domain/entities/budget.dart';

abstract class BudgetRepository {
  Stream<List<Budget>> watchAllBudgets();
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(int id);
}