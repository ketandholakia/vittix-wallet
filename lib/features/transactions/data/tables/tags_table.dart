import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('Tag')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().withDefault(const Constant(1)).references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get color => text().nullable()();
}
