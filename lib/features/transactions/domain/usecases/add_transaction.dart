import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/domain/usecases/budget/check_budget_thresholds.dart';

class AddTransaction {
  final TransactionRepository repository;
  final CheckBudgetThresholds? checkBudgetThresholds;

  AddTransaction(this.repository, this.checkBudgetThresholds);

  Future<void> call(Transaction transaction, {String source = 'user'}) async {
    await repository.addTransaction(transaction, source: source);
    // Check for budget alerts, if the use case is available
    await checkBudgetThresholds?.call(transaction);
  }
}