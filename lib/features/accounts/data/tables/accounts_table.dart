import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:uuid/uuid.dart';

@DataClassName('Account')
class Accounts extends Table {
  IntColumn get walletId => integer().withDefault(const Constant(1))();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => text().map(const EnumNameConverter(AccountType.values))();
  IntColumn get icon => integer()();
  TextColumn get color => text()();
  RealColumn get openingBalance => real().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
