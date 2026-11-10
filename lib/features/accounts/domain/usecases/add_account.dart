import 'package:vittix_wallet/features/accounts/domain/account.dart';
import 'package:vittix_wallet/features/accounts/domain/account_repository.dart';

class AddAccount {
  final AccountRepository repository;

  AddAccount(this.repository);

  Future<void> call(Account account) => repository.addAccount(account);
}
