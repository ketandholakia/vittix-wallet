// BROKEN DEPENDENCY: SmsImportMetrics
/*
import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('SmsImportMetric')
class SmsImportMetrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get acceptedImports => integer().withDefault(const Constant(0))();
  IntColumn get rejectedImports => integer().withDefault(const Constant(0))();
  IntColumn get duplicateDetections => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

*/