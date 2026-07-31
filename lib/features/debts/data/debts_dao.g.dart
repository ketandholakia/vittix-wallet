// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_dao.dart';

// ignore_for_file: type=lint
mixin _$DebtsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoansTable get loans => attachedDatabase.loans;
  $PeerDebtsTable get peerDebts => attachedDatabase.peerDebts;
  DebtsDaoManager get managers => DebtsDaoManager(this);
}

class DebtsDaoManager {
  final _$DebtsDaoMixin _db;
  DebtsDaoManager(this._db);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db.attachedDatabase, _db.loans);
  $$PeerDebtsTableTableManager get peerDebts =>
      $$PeerDebtsTableTableManager(_db.attachedDatabase, _db.peerDebts);
}
