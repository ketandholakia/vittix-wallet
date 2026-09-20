import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';

abstract class AllowanceRepository {
  Stream<List<WalletAllowance>> watchAllowances();
  Future<List<WalletAllowance>> getAllowances();
  Future<WalletAllowance?> getAllowanceById(int id);
  Future<int> addAllowance(Insertable<WalletAllowance> allowance, {int? actorAccountId});
  Future<bool> updateAllowance(Insertable<WalletAllowance> allowance, {int? actorAccountId});
  Future<int> deleteAllowance(int id, {int? actorAccountId});

  Stream<List<WalletAllowancePayment>> watchPayments();
  Future<List<WalletAllowancePayment>> getPayments();
  Future<int> addPayment(Insertable<WalletAllowancePayment> payment, {int? actorAccountId});
  Future<int> deletePayment(int id, {int? actorAccountId});
}

class AllowanceRepositoryImpl implements AllowanceRepository {
  final AllowanceDao _allowanceDao;
  final int walletId;
  final WalletDao? _walletDao;

  AllowanceRepositoryImpl(this._allowanceDao, this.walletId, [this._walletDao]);

  @override
  Stream<List<WalletAllowance>> watchAllowances() {
    return _allowanceDao.watchAllowancesForWallet(walletId);
  }

  @override
  Future<List<WalletAllowance>> getAllowances() {
    return _allowanceDao.getAllowancesForWallet(walletId);
  }

  @override
  Future<WalletAllowance?> getAllowanceById(int id) {
    return _allowanceDao.getAllowanceById(id, walletId);
  }

  @override
  Future<int> addAllowance(Insertable<WalletAllowance> allowance, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageAllowances(r),
      actorAccountId: actorAccountId,
      actionName: 'manage allowances',
    );
    return _allowanceDao.insertAllowance(allowance, walletId);
  }

  @override
  Future<bool> updateAllowance(Insertable<WalletAllowance> allowance, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageAllowances(r),
      actorAccountId: actorAccountId,
      actionName: 'manage allowances',
    );
    return _allowanceDao.updateAllowance(allowance, walletId);
  }

  @override
  Future<int> deleteAllowance(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageAllowances(r),
      actorAccountId: actorAccountId,
      actionName: 'manage allowances',
    );
    return _allowanceDao.deleteAllowance(id, walletId);
  }

  @override
  Stream<List<WalletAllowancePayment>> watchPayments() {
    return _allowanceDao.watchPaymentsForWallet(walletId);
  }

  @override
  Future<List<WalletAllowancePayment>> getPayments() {
    return _allowanceDao.getPaymentsForWallet(walletId);
  }

  @override
  Future<int> addPayment(Insertable<WalletAllowancePayment> payment, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canViewOwnAllowance(r) || s.canManageAllowances(r),
      actorAccountId: actorAccountId,
      actionName: 'record allowance payments',
    );
    return _allowanceDao.insertPayment(payment, walletId);
  }

  @override
  Future<int> deletePayment(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageAllowances(r),
      actorAccountId: actorAccountId,
      actionName: 'manage allowance payments',
    );
    return _allowanceDao.deletePayment(id, walletId);
  }
}
