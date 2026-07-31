import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/categories/data/tables/categories_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('RecurringTransactionDb')
class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get type => text().map(const EnumNameConverter(TransactionType.values))();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.restrict)();
  TextColumn get interval => text()(); // 'daily', 'weekly', 'monthly', 'yearly'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime()();
  DateTimeColumn get lastGeneratedDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
