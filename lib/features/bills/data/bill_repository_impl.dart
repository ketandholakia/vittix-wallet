import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';

abstract class BillRepository {
  Stream<List<WalletBill>> watchBills();
  Future<List<WalletBill>> getBills();
  Future<WalletBill?> getBillById(int id);
  Future<int> addBill(Insertable<WalletBill> bill, {int? actorAccountId});
  Future<bool> updateBill(Insertable<WalletBill> bill, {int? actorAccountId});
  Future<int> deleteBill(int id, {int? actorAccountId});
  Future<bool> markBillPaid(int id, {int? actorAccountId});
  Future<bool> updateBillStatus(int id, WalletBillStatus status, {int? actorAccountId});
}

class BillRepositoryImpl implements BillRepository {
  final BillDao _billDao;
  final int walletId;
  final WalletDao? _walletDao;

  BillRepositoryImpl(this._billDao, this.walletId, [this._walletDao]);

  @override
  Stream<List<WalletBill>> watchBills() {
    return _billDao.watchBillsForWallet(walletId);
  }

  @override
  Future<List<WalletBill>> getBills() {
    return _billDao.getBillsForWallet(walletId);
  }

  @override
  Future<WalletBill?> getBillById(int id) {
    return _billDao.getBillById(id, walletId);
  }

  @override
  Future<int> addBill(Insertable<WalletBill> bill, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBillsAndSchedules(r),
      actorAccountId: actorAccountId,
      actionName: 'manage bills',
    );
    return _billDao.insertBill(bill, walletId);
  }

  @override
  Future<bool> updateBill(Insertable<WalletBill> bill, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBillsAndSchedules(r),
      actorAccountId: actorAccountId,
      actionName: 'manage bills',
    );
    return _billDao.updateBill(bill, walletId);
  }

  @override
  Future<int> deleteBill(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBillsAndSchedules(r),
      actorAccountId: actorAccountId,
      actionName: 'manage bills',
    );
    return _billDao.deleteBill(id, walletId);
  }

  @override
  Future<bool> markBillPaid(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canMarkBillsPaid(r),
      actorAccountId: actorAccountId,
      actionName: 'mark bills paid',
    );
    return _billDao.updateBillStatus(id, WalletBillStatus.paid, walletId);
  }

  @override
  Future<bool> updateBillStatus(int id, WalletBillStatus status, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canMarkBillsPaid(r),
      actorAccountId: actorAccountId,
      actionName: 'update bill status',
    );
    return _billDao.updateBillStatus(id, status, walletId);
  }
}
