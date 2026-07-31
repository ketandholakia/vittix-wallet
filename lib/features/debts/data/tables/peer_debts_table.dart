import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:drift/drift.dart';
import 'package:expense_tracker/features/transactions/data/tables/transactions_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:uuid/uuid.dart';


@DataClassName('PeerDebtDb')
class PeerDebts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().withDefault(const Constant(1))();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get personName => text().withLength(min: 1, max: 100)();
  IntColumn get type => intEnum<PeerDebtType>()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}