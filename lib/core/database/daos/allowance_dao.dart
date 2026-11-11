part of '../app_database.dart';

@DriftAccessor(tables: [WalletAllowances, WalletAllowancePayments])
class AllowanceDao extends DatabaseAccessor<AppDatabase>
    with _$AllowanceDaoMixin {
  AllowanceDao(super.db);

  Stream<List<WalletAllowance>> watchAllowancesForWallet(int walletId) {
    return (select(
      walletAllowances,
    )..where((a) => a.walletId.equals(walletId))).watch();
  }

  Future<List<WalletAllowance>> getAllowancesForWallet(int walletId) {
    return (select(
      walletAllowances,
    )..where((a) => a.walletId.equals(walletId))).get();
  }

  Future<WalletAllowance?> getAllowanceById(int id, [int? walletId]) {
    final query = select(walletAllowances)..where((a) => a.id.equals(id));
    if (walletId != null) {
      query.where((a) => a.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertAllowance(
    Insertable<WalletAllowance> allowance, [
    int? walletId,
  ]) async {
    if (walletId != null) {
      if (allowance is WalletAllowancesCompanion &&
          allowance.walletId.present) {
        if (allowance.walletId.value != walletId) {
          throw const WalletPermissionDeniedException(
            'Cannot create allowance for another wallet.',
          );
        }
      }
    }
    return into(walletAllowances).insert(allowance);
  }

  Future<bool> updateAllowance(
    Insertable<WalletAllowance> companion, [
    int? walletId,
  ]) async {
    if (walletId == null) {
      return update(walletAllowances).replace(companion);
    }
    int? id;
    if (companion is WalletAllowance) {
      id = companion.id;
    } else if (companion is WalletAllowancesCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletAllowances)
      ..where((a) => a.id.equals(id!) & a.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteAllowance(int id, [int? walletId]) async {
    final query = delete(walletAllowances)..where((a) => a.id.equals(id));
    if (walletId != null) {
      query.where((a) => a.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletAllowancePayment>> watchPaymentsForWallet(int walletId) {
    final query = select(walletAllowancePayments).join([
      innerJoin(
        walletAllowances,
        walletAllowances.id.equalsExp(walletAllowancePayments.allowanceId),
      ),
    ])..where(walletAllowances.walletId.equals(walletId));

    return query.watch().map(
      (rows) => rows.map((r) => r.readTable(walletAllowancePayments)).toList(),
    );
  }

  Future<List<WalletAllowancePayment>> getPaymentsForWallet(
    int walletId,
  ) async {
    final query = select(walletAllowancePayments).join([
      innerJoin(
        walletAllowances,
        walletAllowances.id.equalsExp(walletAllowancePayments.allowanceId),
      ),
    ])..where(walletAllowances.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(walletAllowancePayments)).toList();
  }

  Future<int> insertPayment(
    Insertable<WalletAllowancePayment> payment, [
    int? walletId,
  ]) async {
    if (walletId != null) {
      int? allowanceId;
      if (payment is WalletAllowancePayment) {
        allowanceId = payment.allowanceId;
      } else if (payment is WalletAllowancePaymentsCompanion &&
          payment.allowanceId.present) {
        allowanceId = payment.allowanceId.value;
      }
      if (allowanceId != null) {
        final allowance = await getAllowanceById(allowanceId, walletId);
        if (allowance == null) {
          throw const WalletPermissionDeniedException(
            'Target allowance does not belong to the target wallet.',
          );
        }
      }
    }
    return into(walletAllowancePayments).insert(payment);
  }

  Future<int> deletePayment(int id, [int? walletId]) async {
    if (walletId == null) {
      return (delete(
        walletAllowancePayments,
      )..where((p) => p.id.equals(id))).go();
    }
    final allowedAllowanceIds = selectOnly(walletAllowances)
      ..addColumns([walletAllowances.id])
      ..where(walletAllowances.walletId.equals(walletId));

    final query = delete(walletAllowancePayments)
      ..where(
        (p) => p.id.equals(id) & p.allowanceId.isInQuery(allowedAllowanceIds),
      );

    return query.go();
  }
}
