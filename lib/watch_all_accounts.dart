import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/account_repository.dart';

class WatchAllAccounts {
  final AccountRepository repository;

  WatchAllAccounts(this.repository);

  Stream<List<Account>> call() => repository.watchAllAccounts();
}
