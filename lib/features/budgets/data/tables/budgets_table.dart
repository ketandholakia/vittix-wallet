import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/categories/data/tables/categories_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().withDefault(const Constant(1)).references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  RealColumn get amount => real()();
  TextColumn get period => text()(); // e.g., '2024-07' for monthly budget

  // Foreign key to Categories table
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
