import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:rxdart/rxdart.dart';

class GetBudgetStatus {
  final BudgetRepository budgetRepository;
  final TransactionRepository transactionRepository;

  GetBudgetStatus(this.budgetRepository, this.transactionRepository);

  Stream<List<Budget>> call(DateTime month, RolloverMode mode) {
    final targetPeriod = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    final targetStart = DateTime(month.year, month.month, 1);
    final targetEnd = DateTime(month.year, month.month + 1, 1);

    return Rx.combineLatest2(
      budgetRepository.watchAllBudgets(),
      transactionRepository.watchAllTransactions(),
      (List<Budget> allBudgets, List<Transaction> allTransactions) {
        // Filter budgets for the target month
        final monthlyBudgets = allBudgets.where((b) => b.period == targetPeriod).toList();

        return monthlyBudgets.map((budget) {
          // Calculate rolloverAmount dynamically
          double rollover = 0.0;

          if (mode != RolloverMode.disabled) {
            // Find all budgets for this category
            final categoryBudgets = allBudgets
                .where((b) => b.category.id == budget.category.id)
                .toList();

            // Find the start month
            DateTime? oldestMonth;
            final budgetMap = <String, Budget>{};
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

            if (oldestMonth != null && oldestMonth.isBefore(targetStart)) {
              DateTime current = oldestMonth;
              while (current.isBefore(targetStart)) {
                final currentPeriod = '${current.year}-${current.month.toString().padLeft(2, '0')}';
                final currentBudget = budgetMap[currentPeriod];

                if (currentBudget != null) {
                  final nextMonth = DateTime(current.year, current.month + 1, 1);
                  final spent = allTransactions
                      .where((tx) =>
                          tx.type == TransactionType.expense &&
                          (tx.category.id == budget.category.id ||
                           tx.category.parentId == budget.category.id) &&
                          !tx.date.isBefore(current) &&
                          tx.date.isBefore(nextMonth))
                      .fold(0.0, (sum, tx) => sum + tx.amount);

                  final remaining = (currentBudget.amount + rollover) - spent;

                  if (mode == RolloverMode.surplusOnly) {
                    rollover = remaining > 0 ? remaining : 0.0;
                  } else if (mode == RolloverMode.surplusAndDeficit) {
                    rollover = remaining;
                  }
                } else {
                  // Gaps in budget reset rollover to 0
                  rollover = 0.0;
                }

                current = DateTime(current.year, current.month + 1, 1);
              }
            }
          }

          // Calculate spent for the target month
          final spent = allTransactions
              .where((tx) =>
                  tx.type == TransactionType.expense &&
                  (tx.category.id == budget.category.id ||
                   tx.category.parentId == budget.category.id) &&
                  !tx.date.isBefore(targetStart) &&
                  tx.date.isBefore(targetEnd))
              .fold(0.0, (sum, tx) => sum + tx.amount);

          return Budget(
            id: budget.id,
            amount: budget.amount,
            period: budget.period,
            category: budget.category,
            spentAmount: spent,
            rolloverAmount: rollover,
          );
        }).toList();
      },
    );
  }
}