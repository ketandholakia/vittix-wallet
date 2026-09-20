import 'package:drift/drift.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import '../../../../features/accounts/data/tables/accounts_table.dart';
import '../../../../features/categories/data/tables/categories_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get walletId => integer().withDefault(const Constant(1))();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get amount => integer().map(const MoneyConverter())();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  // Enum for transaction type
  TextColumn get type => text().map(const EnumNameConverter(TransactionType.values))();

  // Foreign key to Categories table
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  // Foreign key to Accounts table
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  /// Groups the two legs of a transfer. Both rows share one value, which is
  /// what makes a transfer first-class: it can be excluded from income/expense
  /// reporting and edited or deleted as a unit. Null for ordinary entries.
  TextColumn get transferGroupId => text().nullable()();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
