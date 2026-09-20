import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/category_mapper.dart';
import 'package:expense_tracker/domain/entities/budget.dart' as domain;

extension BudgetWithCategoryMapper on db.BudgetWithCategory {
  domain.Budget toDomain() {
    return domain.Budget(
      id: budget.id,
      walletId: budget.walletId,
      amount: budget.amount,
      period: budget.period,
      category: category.toDomain(),
      // spentAmount is calculated in the use case, so we default it here.
      spentAmount: 0,
    );
  }
}

extension BudgetDomainMapper on domain.Budget {
  db.BudgetsCompanion toCompanion([int? overrideWalletId]) {
    return db.BudgetsCompanion(
      id: id > 0 ? Value(id) : const Value.absent(),
      walletId: Value(overrideWalletId ?? walletId),
      amount: Value(amount),
      period: Value(period),
      categoryId: Value(category.id),
    );
  }
}