import 'package:vittix_wallet/domain/entities/transaction.dart';
import 'package:vittix_wallet/domain/repositories/transaction_repository.dart';

/// Records a transfer as a linked pair of rows written in a single database
/// transaction, so the two legs can never diverge.
class AddTransfer {
  final TransactionRepository repository;

  AddTransfer(this.repository);

  Future<void> call(Transaction outgoing, Transaction incoming) {
    return repository.addTransfer(outgoing, incoming);
  }
}
