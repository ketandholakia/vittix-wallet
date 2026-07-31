import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/debts/data/tables/loans_table.dart';
import 'package:expense_tracker/features/debts/data/tables/peer_debts_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Loans, PeerDebts])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Stream<List<LoanDb>> watchActiveLoans(int walletId) {
    return (select(loans)
          ..where((l) => l.walletId.equals(walletId) & l.isActive.equals(true)))
        .watch();
  }
  
  Stream<List<LoanDb>> watchAllLoans(int walletId) {
    return (select(loans)..where((l) => l.walletId.equals(walletId))).watch();
  }

  Stream<List<PeerDebtDb>> watchPeerDebts(int walletId) {
    return (select(peerDebts)
          ..where((pd) => pd.walletId.equals(walletId))
          ..orderBy([(pd) => OrderingTerm.desc(pd.date)]))
        .watch();
  }
  
  Future<int> insertLoan(LoansCompanion companion) {
    return into(loans).insert(companion);
  }
  
  Future<bool> updateLoan(LoansCompanion companion) {
    return update(loans).replace(companion);
  }
  
  Future<int> insertPeerDebt(PeerDebtsCompanion companion) {
    return into(peerDebts).insert(companion);
  }
  
  Future<bool> updatePeerDebt(PeerDebtsCompanion companion) {
    return update(peerDebts).replace(companion);
  }
}
