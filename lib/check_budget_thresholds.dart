import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
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
    final firstDay = DateTime(transaction.date.year, transaction.date.month, 1);
    final nextMonth = DateTime(transaction.date.year, transaction.date.month + 1, 1);

    final allBudgets = await _budgetRepository.watchAllBudgets().first;
    final matchingBudgets = allBudgets.where(
      (b) => b.category.id == transaction.category.id && b.period == period,
    );
    if (matchingBudgets.isEmpty) return;
    final budget = matchingBudgets.first;

    // Get rollover mode from preferences
    final rolloverKey = 'rolloverMode';
    final rolloverModeName = _prefs.getString(rolloverKey) ?? 'surplusOnly';
    final mode = RolloverMode.values.firstWhere(
      (e) => e.name == rolloverModeName,
      orElse: () => RolloverMode.surplusOnly,
    );

    final allTransactions = await _transactionRepository.watchAllTransactions().first;

    // Calculate rollover
    double rollover = 0.0;
    if (mode != RolloverMode.disabled) {
      final categoryBudgets = allBudgets
          .where((b) => b.category.id == budget.category.id)
          .toList();

      DateTime? oldestMonth;
      final budgetMap = <String, dynamic>{};
      for (final b in categoryBudgets) {
        budgetMap[b.period] = b;
        final parts = b.period.split('-');
        if (parts.length == 2) {
          final y = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (y != null && m != null) {
            final dt = DateTime(y, m, 1);
            if (oldestMonth == null || dt.isBefore(oldestMonth)) {
              oldestMonth = dt;
            }
          }
        }
      }

      if (oldestMonth != null && oldestMonth.isBefore(firstDay)) {
        DateTime current = oldestMonth;
        while (current.isBefore(firstDay)) {
          final currentPeriod = '${current.year}-${current.month.toString().padLeft(2, '0')}';
          final currentBudget = budgetMap[currentPeriod];

          if (currentBudget != null) {
            final currentNext = DateTime(current.year, current.month + 1, 1);
            final spent = allTransactions
                .where((tx) =>
                    tx.type == TransactionType.expense &&
                    (tx.category.id == budget.category.id ||
                     tx.category.parentId == budget.category.id) &&
                    !tx.date.isBefore(current) &&
                    tx.date.isBefore(currentNext))
                .fold(0.0, (sum, tx) => sum + tx.amount);

            final remaining = (currentBudget.amount + rollover) - spent;

            if (mode == RolloverMode.surplusOnly) {
              rollover = remaining > 0 ? remaining : 0.0;
            } else if (mode == RolloverMode.surplusAndDeficit) {
              rollover = remaining;
            }
          } else {
            rollover = 0.0;
          }

          current = DateTime(current.year, current.month + 1, 1);
        }
      }
    }

    final totalLimit = budget.amount + rollover;
    if (totalLimit <= 0) return;

    // Calculate spent for target month (including subcategories)
    final spentAmount = allTransactions
        .where((tx) =>
            (tx.category.id == budget.category.id ||
             tx.category.parentId == budget.category.id) &&
            tx.type == TransactionType.expense &&
            !tx.date.isBefore(firstDay) &&
            tx.date.isBefore(nextMonth))
        .fold(0.0, (sum, item) => sum + item.amount);

    final oldSpentAmount = spentAmount - transaction.amount;

    final newPercentage = spentAmount / totalLimit;
    final oldPercentage = oldSpentAmount / totalLimit;

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
