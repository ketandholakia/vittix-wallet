import 'package:vittix_wallet/domain/entities/transaction.dart';
import 'package:vittix_wallet/domain/repositories/transaction_repository.dart';
import 'package:vittix_wallet/domain/usecases/budget/check_budget_thresholds.dart';

class UpdateTransaction {
  final TransactionRepository repository;
  final CheckBudgetThresholds? checkBudgetThresholds;

  UpdateTransaction(this.repository, this.checkBudgetThresholds);

  Future<void> call(Transaction transaction) async {
    await repository.updateTransaction(transaction);
    // Check for budget alerts, if the use case is available
    await checkBudgetThresholds?.call(transaction);
  }
}