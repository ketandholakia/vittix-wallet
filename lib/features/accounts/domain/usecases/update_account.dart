import 'package:vittix_wallet/features/accounts/domain/account.dart';
import 'package:vittix_wallet/features/accounts/domain/account_repository.dart';

class UpdateAccount {
  final AccountRepository repository;

  UpdateAccount(this.repository);

  Future<void> call(Account account) => repository.updateAccount(account);
}
