import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';

@DataClassName('DeletedRecord')
class DeletedRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get deletedTable => text().named('table_name')();
  DateTimeColumn get deletedAt => dateTime().withDefault(currentDateAndTime)();
}
