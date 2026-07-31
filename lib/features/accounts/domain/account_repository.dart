import 'package:expense_tracker/features/accounts/domain/account.dart';

abstract class AccountRepository {
  Stream<List<Account>> watchAllAccounts();
  Stream<List<AccountWithBalance>> watchAccountsWithBalance();
  Future<Account?> getAccountById(int id);
  Future<int> countTransactionsForAccount(int accountId);
  Future<void> addAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(int id);
}
