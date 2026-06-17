import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/budget_mapper.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final db.BudgetDao _budgetDao;

  BudgetRepositoryImpl(this._budgetDao);

  @override
  Future<void> addBudget(Budget budget) {
    final companion = budget.toCompanion().copyWith(id: const Value.absent());
    return _budgetDao.insertBudget(companion);
  }

  @override
  Future<void> deleteBudget(int id) {
    return _budgetDao.deleteBudget(id);
  }

  @override
  Future<void> updateBudget(Budget budget) {
    final companion = budget.toCompanion();
    return _budgetDao.updateBudget(companion);
  }

  @override
  Stream<List<Budget>> watchAllBudgets() {
    return _budgetDao.watchAllBudgetsWithCategory().map((dbBudgets) {
      return dbBudgets.map((dbBudget) => dbBudget.toDomain()).toList();
    });
  }
}