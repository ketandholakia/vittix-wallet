import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/accounts/domain/account_repository.dart';

class WatchAllAccounts {
  final AccountRepository repository;

  WatchAllAccounts(this.repository);

  Stream<List<Account>> call() => repository.watchAllAccounts();
}
