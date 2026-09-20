import 'package:drift/drift.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/accounts/data/account_mapper.dart';
import 'package:expense_tracker/features/accounts/domain/account_repository.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;

class AccountRepositoryImpl implements AccountRepository {
  final db.AccountDao _accountDao;
  final int? walletId;
  final db.WalletDao? _walletDao;

  /// Actor identity injected from application context (not per-call).
  /// Null when no authenticated user context exists.
  final int? actorAccountId;

  AccountRepositoryImpl(this._accountDao, [this.walletId, this._walletDao, this.actorAccountId]);

  db.WalletDao get _auditDao => _walletDao ?? db.WalletDao(_accountDao.attachedDatabase);

  Future<void> _insertAuditEvent({
    required String action,
    required int entityId,
    String? entityUuid,
    String source = 'user',
  }) async {
    if (walletId == null) return;
    final effectiveActor = source == 'user' ? actorAccountId : null;
    await _auditDao.insertActivity(
      db.WalletActivitiesCompanion.insert(
        walletId: walletId!,
        action: action,
        entityType: 'account',
        entityId: entityId,
        entityUuid: db.Value(entityUuid),
        source: source,
      ),
      walletId!,
      actorAccountId: effectiveActor,
    );
  }

  @override
  Future<void> addAccount(Account account) async {
    if (walletId != null) {
      await _walletDao?.checkPermission(
        walletId: walletId!,
        permissionCheck: (s, r) => s.canManageAccounts(r),
        actorAccountId: actorAccountId,
        actionName: 'manage accounts',
      );
    }
    final companion = account.toCompanion().copyWith(id: const db.Value.absent());
    final database = _accountDao.attachedDatabase;
    await database.transaction(() async {
      final id = await _accountDao.insertAccount(companion, walletId);
      if (walletId != null) {
        final row = await _accountDao.getAccountById(id, walletId);
        await _insertAuditEvent(action: 'ACCOUNT_CREATED', entityId: id, entityUuid: row?.uuid);
      }
    });
  }

  @override
  Future<int> countTransactionsForAccount(int accountId) {
    return _accountDao.countTransactionsForAccount(accountId, walletId);
  }

  @override
  Future<void> deleteAccount(int id) async {
    if (walletId != null) {
      await _walletDao?.checkPermission(
        walletId: walletId!,
        permissionCheck: (s, r) => s.canManageAccounts(r),
        actorAccountId: actorAccountId,
        actionName: 'manage accounts',
      );
    }
    // Capture uuid before deletion.
    final existing = walletId != null ? await _accountDao.getAccountById(id, walletId) : null;
    final database = _accountDao.attachedDatabase;
    await database.transaction(() async {
      final deleted = await _accountDao.deleteAccount(id, walletId);
      if (deleted > 0 && existing != null) {
        await _insertAuditEvent(action: 'ACCOUNT_DELETED', entityId: id, entityUuid: existing.uuid);
      }
    });
  }

  @override
  Future<Account?> getAccountById(int id) async {
    final account = await _accountDao.getAccountById(id, walletId);
    if (account == null) {
      return null;
    }
    return account.toDomain();
  }

  @override
  Future<void> updateAccount(Account account) async {
    if (walletId != null) {
      await _walletDao?.checkPermission(
        walletId: walletId!,
        permissionCheck: (s, r) => s.canManageAccounts(r),
        actorAccountId: actorAccountId,
        actionName: 'manage accounts',
      );
    }
    final database = _accountDao.attachedDatabase;
    await database.transaction(() async {
      final updated = await _accountDao.updateAccount(account.toCompanion(), walletId);
      if (updated && walletId != null) {
        final row = await _accountDao.getAccountById(account.id, walletId);
        await _insertAuditEvent(action: 'ACCOUNT_UPDATED', entityId: account.id, entityUuid: row?.uuid);
      }
    });
  }

  @override
  Stream<List<Account>> watchAllAccounts() {
    return _accountDao.watchAllAccounts(walletId).map(
          (accounts) => accounts.map((a) => a.toDomain()).toList(),
        );
  }

  @override
  Stream<List<AccountWithBalance>> watchAccountsWithBalance() {
    return watchAllAccounts().asyncMap((accounts) async {
      final results = <AccountWithBalance>[];
      for (final account in accounts) {
        final dbAccount = await _accountDao.getAccountById(account.id, walletId);
        if (dbAccount == null) continue;
        final balance = await _accountDao.getBalanceForAccount(dbAccount, walletId);
        results.add(AccountWithBalance(account: account, balance: balance));
      }
      return results;
    });
  }
}
