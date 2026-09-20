import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/notification_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/features/accounts/domain/usecases/add_account.dart';
import 'package:expense_tracker/features/accounts/domain/usecases/delete_account.dart';
import 'package:expense_tracker/features/accounts/domain/usecases/update_account.dart';
import 'package:expense_tracker/features/accounts/domain/usecases/watch_accounts_with_balance.dart';
import 'package:expense_tracker/features/accounts/domain/usecases/watch_all_accounts.dart';
import 'package:expense_tracker/domain/usecases/category/add_category.dart';
import 'package:expense_tracker/domain/usecases/category/delete_category.dart';
import 'package:expense_tracker/domain/usecases/category/update_category.dart';
import 'package:expense_tracker/domain/usecases/category/watch_all_categories.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/add_transfer.dart';
import 'package:expense_tracker/domain/usecases/budget/add_budget.dart';
import 'package:expense_tracker/domain/usecases/budget/check_budget_thresholds.dart';
import 'package:expense_tracker/domain/usecases/budget/delete_budget.dart';
import 'package:expense_tracker/domain/usecases/budget/get_budget_status.dart';
import 'package:expense_tracker/domain/usecases/budget/update_budget.dart';
import 'package:expense_tracker/domain/usecases/summary/get_monthly_summary.dart';
import 'package:expense_tracker/domain/usecases/summary/get_trend_report.dart';
import 'package:expense_tracker/domain/usecases/transaction/add_transaction.dart';
import 'package:expense_tracker/domain/usecases/transaction/delete_transaction.dart';
import 'package:expense_tracker/domain/usecases/transaction/update_transaction.dart';
import 'package:expense_tracker/domain/usecases/transaction/watch_recent_transactions.dart';
import 'package:expense_tracker/domain/usecases/recurring/watch_all_recurring.dart';
import 'package:expense_tracker/domain/usecases/recurring/add_recurring.dart';
import 'package:expense_tracker/domain/usecases/recurring/delete_recurring.dart';
import 'package:expense_tracker/domain/usecases/recurring/process_recurring_transactions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Category Use Cases ---

final watchAllCategoriesUseCaseProvider = Provider<WatchAllCategories>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return WatchAllCategories(repo);
});

final addCategoryUseCaseProvider = Provider<AddCategory>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return AddCategory(repo);
});

final updateCategoryUseCaseProvider = Provider<UpdateCategory>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return UpdateCategory(repo);
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategory>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return DeleteCategory(repo);
});

final checkBudgetThresholdsUseCaseProvider = Provider<CheckBudgetThresholds?>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) {
      return CheckBudgetThresholds(
        ref.watch(budgetRepositoryProvider),
        ref.watch(transactionRepositoryProvider),
        ref.watch(notificationServiceProvider),
        prefs,
      );
    },
    loading: () => null,
    error: (e, s) => null,
  );
});

final addTransactionUseCaseProvider = Provider<AddTransaction>((ref) {
  return AddTransaction(ref.watch(transactionRepositoryProvider), ref.watch(checkBudgetThresholdsUseCaseProvider));
});

final addTransferUseCaseProvider = Provider<AddTransfer>((ref) {
  return AddTransfer(ref.watch(transactionRepositoryProvider));
});

final updateTransactionUseCaseProvider = Provider<UpdateTransaction>((ref) {
  return UpdateTransaction(ref.watch(transactionRepositoryProvider), ref.watch(checkBudgetThresholdsUseCaseProvider));
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return DeleteTransaction(repo);
});

final watchRecentTransactionsUseCaseProvider = Provider<WatchRecentTransactions>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return WatchRecentTransactions(repo);
});

// --- Summary Use Cases ---

final getMonthlySummaryUseCaseProvider = Provider<GetMonthlySummary>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return GetMonthlySummary(repo);
});

final getTrendReportUseCaseProvider = Provider<GetTrendReport>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return GetTrendReport(repo);
});

// --- Budget Use Cases ---

final addBudgetUseCaseProvider = Provider<AddBudget>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return AddBudget(repo);
});

final updateBudgetUseCaseProvider = Provider<UpdateBudget>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return UpdateBudget(repo);
});

final deleteBudgetUseCaseProvider = Provider<DeleteBudget>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return DeleteBudget(repo);
});

final getBudgetStatusUseCaseProvider = Provider<GetBudgetStatus>((ref) {
  final budgetRepo = ref.watch(budgetRepositoryProvider);
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  return GetBudgetStatus(budgetRepo, transactionRepo);
});

// --- Account Use Cases ---

final watchAllAccountsUseCaseProvider = Provider<WatchAllAccounts>((ref) {
  return WatchAllAccounts(ref.watch(accountRepositoryProvider));
});

final watchAccountsWithBalanceUseCaseProvider = Provider<WatchAccountsWithBalance>((ref) {
  return WatchAccountsWithBalance(ref.watch(accountRepositoryProvider));
});

final addAccountUseCaseProvider = Provider<AddAccount>((ref) {
  return AddAccount(ref.watch(accountRepositoryProvider));
});

final updateAccountUseCaseProvider = Provider<UpdateAccount>((ref) {
  return UpdateAccount(ref.watch(accountRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider<DeleteAccount>((ref) {
  return DeleteAccount(ref.watch(accountRepositoryProvider));
});

// --- Recurring Use Cases ---

final watchAllRecurringUseCaseProvider = Provider<WatchAllRecurring>((ref) {
  return WatchAllRecurring(ref.watch(recurringTransactionRepositoryProvider));
});

final addRecurringUseCaseProvider = Provider<AddRecurring>((ref) {
  return AddRecurring(ref.watch(recurringTransactionRepositoryProvider));
});

final deleteRecurringUseCaseProvider = Provider<DeleteRecurring>((ref) {
  return DeleteRecurring(ref.watch(recurringTransactionRepositoryProvider));
});

final processRecurringTransactionsUseCaseProvider = Provider<ProcessRecurringTransactions>((ref) {
  return ProcessRecurringTransactions(
    ref.watch(recurringTransactionRepositoryProvider),
    ref.watch(addTransactionUseCaseProvider),
    ref.watch(notificationServiceProvider),
  );
});