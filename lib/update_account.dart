import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/account_repository.dart';

class UpdateAccount {
  final AccountRepository repository;

  UpdateAccount(this.repository);

  Future<void> call(Account account) => repository.updateAccount(account);
}
