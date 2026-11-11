import 'package:vittix_wallet/core/providers/database_provider.dart';
import 'package:vittix_wallet/data/repositories/category_repository_impl.dart';
import 'package:vittix_wallet/domain/repositories/category_repository.dart';
import 'package:vittix_wallet/data/repositories/transaction_repository_impl.dart';
import 'package:vittix_wallet/domain/repositories/transaction_repository.dart';
import 'package:vittix_wallet/features/accounts/data/account_repository_impl.dart';
import 'package:vittix_wallet/features/accounts/domain/account_repository.dart';
import 'package:vittix_wallet/data/repositories/budget_repository_impl.dart';
import 'package:vittix_wallet/domain/repositories/budget_repository.dart';
import 'package:vittix_wallet/domain/repositories/recurring_transaction_repository.dart';
import 'package:vittix_wallet/features/recurring/data/recurring_transaction_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vittix_wallet/features/settings/presentation/settings_providers.dart';

import 'package:vittix_wallet/features/goals/data/goal_repository_impl.dart';
import 'package:vittix_wallet/features/bills/data/bill_repository_impl.dart';
import 'package:vittix_wallet/features/family/data/allowance_repository_impl.dart';

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

final recurringTransactionRepositoryProvider =
    Provider<RecurringTransactionRepository>((ref) {
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
