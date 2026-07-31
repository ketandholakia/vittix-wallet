import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('FeedbackEntry')
class FeedbackEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get category => text().map(const EnumNameConverter(FeedbackCategory.values))();
  TextColumn get severity => text().map(const EnumNameConverter(FeedbackSeverity.values))();
  TextColumn get workflow => text().withLength(min: 1, max: 80)();
  TextColumn get description => text().withLength(min: 1, max: 500)();
  TextColumn get resolutionStatus => text().map(const EnumNameConverter(FeedbackResolutionStatus.values))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
