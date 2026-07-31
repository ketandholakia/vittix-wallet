import 'package:drift/drift.dart';
import 'package:expense_tracker/features/accounts/data/account_mapper.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/category_mapper.dart';
import 'package:expense_tracker/recurring_transaction.dart';
import 'package:expense_tracker/features/transactions/domain/transaction.dart';

extension RecurringWithDetailsMapper on db.RecurringTransactionWithDetails {
  RecurringTransaction toDomain() {
    return RecurringTransaction(
      id: template.id,
      name: template.name,
      amount: template.amount,
      type: TransactionType.values.byName(template.type.name),
      category: category.toDomain(),
      account: account.toDomain(),
      interval: RecurringInterval.values.byName(template.interval),
      startDate: template.startDate,
      nextDueDate: template.nextDueDate,
      lastGeneratedDate: template.lastGeneratedDate,
      isActive: template.isActive,
    );
  }
}

extension RecurringDomainMapper on RecurringTransaction {
  db.RecurringTransactionsCompanion toCompanion() {
    return db.RecurringTransactionsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      type: Value(db.TransactionType.values.byName(type.name)),
      categoryId: Value(category.id),
      accountId: Value(account.id),
      interval: Value(interval.name),
      startDate: Value(startDate),
      nextDueDate: Value(nextDueDate),
      lastGeneratedDate: Value(lastGeneratedDate),
      isActive: Value(isActive),
    );
  }
}
