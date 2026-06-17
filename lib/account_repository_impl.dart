import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/account_mapper.dart';
import 'package:expense_tracker/account_repository.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;

class AccountRepositoryImpl implements AccountRepository {
  final db.AccountDao _accountDao;

  AccountRepositoryImpl(this._accountDao);

  @override
  Future<void> addAccount(Account account) {
    final companion = account.toCompanion().copyWith(id: const db.Value.absent());
    return _accountDao.insertAccount(companion);
  }

  @override
  Future<int> countTransactionsForAccount(int accountId) {
    return _accountDao.countTransactionsForAccount(accountId);
  }

  @override
  Future<void> deleteAccount(int id) {
    return _accountDao.deleteAccount(id);
  }

  @override
  Future<Account?> getAccountById(int id) async {
    final account = await _accountDao.getAccountById(id);
    return account?.toDomain();
  }

  @override
  Future<void> updateAccount(Account account) {
    return _accountDao.updateAccount(account.toCompanion());
  }

  @override
  Stream<List<Account>> watchAllAccounts() {
    return _accountDao.watchAllAccounts().map(
          (accounts) => accounts.map((a) => a.toDomain()).toList(),
        );
  }

  @override
  Stream<List<AccountWithBalance>> watchAccountsWithBalance() {
    return watchAllAccounts().asyncMap((accounts) async {
      final results = <AccountWithBalance>[];
      for (final account in accounts) {
        final dbAccount = await _accountDao.getAccountById(account.id);
        if (dbAccount == null) continue;
        final balance = await _accountDao.getBalanceForAccount(dbAccount);
        results.add(AccountWithBalance(account: account, balance: balance));
      }
      return results;
    });
  }
}
