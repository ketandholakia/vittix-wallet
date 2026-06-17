import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/data/repositories/category_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/category_repository.dart';
import 'package:expense_tracker/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/account_repository_impl.dart';
import 'package:expense_tracker/account_repository.dart';
import 'package:expense_tracker/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/recurring_transaction_repository.dart';
import 'package:expense_tracker/recurring_transaction_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoryRepositoryImpl(dao);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return TransactionRepositoryImpl(dao);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  return BudgetRepositoryImpl(dao);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dao = ref.watch(accountDaoProvider);
  return AccountRepositoryImpl(dao);
});

final recurringTransactionRepositoryProvider = Provider<RecurringTransactionRepository>((ref) {
  final dao = ref.watch(recurringTransactionDaoProvider);
  return RecurringTransactionRepositoryImpl(dao);
});