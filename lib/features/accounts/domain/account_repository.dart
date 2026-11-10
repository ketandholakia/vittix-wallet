import 'package:vittix_wallet/features/accounts/domain/account.dart';

abstract class AccountRepository {
  Stream<List<Account>> watchAllAccounts();
  Stream<List<AccountWithBalance>> watchAccountsWithBalance();
  Future<Account?> getAccountById(int id);
  Future<int> countTransactionsForAccount(int accountId);
  Future<void> addAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(int id);

  /// Moves every transaction off [fromAccountId] onto [toAccountId] and then
  /// deletes [fromAccountId], atomically.
  ///
  /// Returns the number of transactions moved. Throws [StateError] when the
  /// target account is not visible in the active wallet, and [ArgumentError]
  /// when source and target are the same account.
  Future<int> reassignAndDeleteAccount(int fromAccountId, int toAccountId);
}
