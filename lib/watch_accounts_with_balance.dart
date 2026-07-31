import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/accounts/domain/account_repository.dart';

class WatchAccountsWithBalance {
  final AccountRepository repository;

  WatchAccountsWithBalance(this.repository);

  Stream<List<AccountWithBalance>> call() => repository.watchAccountsWithBalance();
}
