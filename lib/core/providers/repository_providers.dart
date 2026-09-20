import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/data/repositories/category_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/category_repository.dart';
import 'package:expense_tracker/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/accounts/data/account_repository_impl.dart';
import 'package:expense_tracker/features/accounts/domain/account_repository.dart';
import 'package:expense_tracker/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/recurring_transaction_repository.dart';
import 'package:expense_tracker/features/recurring/data/recurring_transaction_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

import 'package:expense_tracker/features/goals/data/goal_repository_impl.dart';
import 'package:expense_tracker/features/bills/data/bill_repository_impl.dart';
import 'package:expense_tracker/features/family/data/allowance_repository_impl.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoryRepositoryImpl(dao);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return TransactionRepositoryImpl(dao, walletId, walletDao);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return BudgetRepositoryImpl(dao, walletId, walletDao);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dao = ref.watch(accountDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return AccountRepositoryImpl(dao, walletId, walletDao);
});

final recurringTransactionRepositoryProvider = Provider<RecurringTransactionRepository>((ref) {
  final dao = ref.watch(recurringTransactionDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return RecurringTransactionRepositoryImpl(dao, walletDao, walletId);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final dao = ref.watch(goalDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return GoalRepositoryImpl(dao, walletId, walletDao);
});

final billRepositoryProvider = Provider<BillRepository>((ref) {
  final dao = ref.watch(billDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return BillRepositoryImpl(dao, walletId, walletDao);
});

final allowanceRepositoryProvider = Provider<AllowanceRepository>((ref) {
  final dao = ref.watch(allowanceDaoProvider);
  final walletDao = ref.watch(walletDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return AllowanceRepositoryImpl(dao, walletId, walletDao);
});
