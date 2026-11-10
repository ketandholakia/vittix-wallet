// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_dao.dart';

// ignore_for_file: type=lint
mixin _$DebtsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountsTable get accounts => attachedDatabase.accounts;
  $LoansTable get loans => attachedDatabase.loans;
  $WalletsTable get wallets => attachedDatabase.wallets;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $PeerDebtsTable get peerDebts => attachedDatabase.peerDebts;
  DebtsDaoManager get managers => DebtsDaoManager(this);
}

class DebtsDaoManager {
  final _$DebtsDaoMixin _db;
  DebtsDaoManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db.attachedDatabase, _db.loans);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db.attachedDatabase, _db.wallets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$PeerDebtsTableTableManager get peerDebts =>
      $$PeerDebtsTableTableManager(_db.attachedDatabase, _db.peerDebts);
}
