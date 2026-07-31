import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/categories/data/tables/categories_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('MerchantMapping')
class MerchantMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get originalPattern => text()();
  TextColumn get cleanName => text()();
  IntColumn get defaultCategoryId => integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
