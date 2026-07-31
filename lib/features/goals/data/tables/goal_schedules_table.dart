import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/goals/data/tables/goals_table.dart';

@DataClassName('WalletGoalSchedule')
class WalletGoalSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletGoalId => integer().references(WalletGoals, #id, onDelete: KeyAction.cascade)();
  IntColumn get memberId => integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  TextColumn get frequency => text().map(const EnumNameConverter(WalletGoalScheduleFrequency.values))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get createdByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get updatedByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
