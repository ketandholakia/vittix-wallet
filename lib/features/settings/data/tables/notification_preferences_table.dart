import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletNotificationPreference')
class WalletNotificationPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  BoolColumn get billReminders => boolean().withDefault(const Constant(true))();
  BoolColumn get goalReminders => boolean().withDefault(const Constant(true))();
  BoolColumn get allowanceReminders => boolean().withDefault(const Constant(true))();
  BoolColumn get settlementReminders => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
