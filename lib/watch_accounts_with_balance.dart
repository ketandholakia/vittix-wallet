import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/account_repository.dart';

class WatchAccountsWithBalance {
  final AccountRepository repository;

  WatchAccountsWithBalance(this.repository);

  Stream<List<AccountWithBalance>> call() => repository.watchAccountsWithBalance();
}
