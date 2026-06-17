import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckBudgetThresholds {
  final BudgetRepository _budgetRepository;
  final TransactionRepository _transactionRepository;
  final NotificationService _notificationService;
  final SharedPreferences _prefs;

  CheckBudgetThresholds(
    this._budgetRepository,
    this._transactionRepository,
    this._notificationService,
    this._prefs,
  );

  Future<void> call(Transaction transaction) async {
    if (transaction.type == TransactionType.income) return;

    final period = DateFormat('yyyy-MM').format(transaction.date);
    final allBudgets = await _budgetRepository.watchAllBudgets().first;
    final budget = allBudgets.firstWhere((b) => b.category.id == transaction.category.id && b.period == period,
        orElse: () => throw Exception('No budget found'));

    final allTransactions = await _transactionRepository.watchTransactionsInMonth(transaction.date).first;
    final spentAmount = allTransactions
        .where((tx) => tx.category.id == budget.category.id && tx.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);

    final oldSpentAmount = spentAmount - transaction.amount;

    if (budget.amount <= 0) return;

    final newPercentage = spentAmount / budget.amount;
    final oldPercentage = oldSpentAmount / budget.amount;

    final thresholds = {1.0: 100, 0.9: 90, 0.8: 80};

    for (var entry in thresholds.entries) {
      final threshold = entry.key;
      final percentageInt = entry.value;

      if (newPercentage >= threshold && oldPercentage < threshold) {
        await _notifyUser(budget.id, period, percentageInt, budget.category.name);
      }
    }
  }

  Future<void> _notifyUser(int budgetId, String period, int percentage, String categoryName) async {
    final key = 'budget_alert_${budgetId}_${period}_$percentage';
    final hasNotified = _prefs.getBool(key) ?? false;

    if (!hasNotified) {
      await _notificationService.showBudgetAlert(categoryName, percentage);
      await _prefs.setBool(key, true);
    }
  }
}