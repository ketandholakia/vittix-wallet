part of '../app_database.dart';

@DriftAccessor(tables: [WalletBills])
class BillDao extends DatabaseAccessor<AppDatabase> with _$BillDaoMixin {
  BillDao(super.db);

  Stream<List<WalletBill>> watchBillsForWallet(int walletId) {
    return (select(walletBills)..where((b) => b.walletId.equals(walletId))).watch();
  }

  Future<List<WalletBill>> getBillsForWallet(int walletId) {
    return (select(walletBills)..where((b) => b.walletId.equals(walletId))).get();
  }

  Future<WalletBill?> getBillById(int id, [int? walletId]) {
    final query = select(walletBills)..where((b) => b.id.equals(id));
    if (walletId != null) {
      query.where((b) => b.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertBill(Insertable<WalletBill> bill, [int? walletId]) async {
    if (walletId != null) {
      if (bill is WalletBillsCompanion && bill.walletId.present) {
        if (bill.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot create bill for another wallet.');
        }
      }
    }
    return into(walletBills).insert(bill);
  }

  Future<bool> updateBill(Insertable<WalletBill> companion, [int? walletId]) async {
    if (walletId == null) {
      return update(walletBills).replace(companion);
    }
    int? id;
    if (companion is WalletBill) {
      id = companion.id;
    } else if (companion is WalletBillsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletBills)..where((b) => b.id.equals(id!) & b.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteBill(int id, [int? walletId]) async {
    final query = delete(walletBills)..where((b) => b.id.equals(id));
    if (walletId != null) {
      query.where((b) => b.walletId.equals(walletId));
    }
    return query.go();
  }

  Future<bool> updateBillStatus(int id, WalletBillStatus status, [int? walletId]) async {
    return updateBill(
      WalletBillsCompanion(
        id: Value(id),
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
      walletId,
    );
  }
}


