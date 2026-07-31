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
import 'package:expense_tracker/recurring_transaction_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoryRepositoryImpl(dao);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  final walletDao = null /* ref.watch(walletDaoProvider) */;
  final transactionTagDao = null /* ref.watch(transactionTagDaoProvider) */;
  final attachmentDao = null /* ref.watch(attachmentDaoProvider) */;
  final walletId = ref.watch(currentWalletIdProvider);
  return TransactionRepositoryImpl(dao, walletId);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  final walletDao = null /* ref.watch(walletDaoProvider) */;
  final walletId = ref.watch(currentWalletIdProvider);
  return BudgetRepositoryImpl(dao, walletId);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dao = ref.watch(accountDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return AccountRepositoryImpl(dao, walletId);
});

final recurringTransactionRepositoryProvider = Provider<RecurringTransactionRepository>((ref) {
  final dao = ref.watch(recurringTransactionDaoProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return RecurringTransactionRepositoryImpl(dao, walletId);
});
