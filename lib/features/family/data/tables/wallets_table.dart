import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:uuid/uuid.dart';

@DataClassName('Wallet')
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => text().withDefault(const Constant('personal'))();
  IntColumn get createdByAccountId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
