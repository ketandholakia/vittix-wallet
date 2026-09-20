import 'package:drift/drift.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:expense_tracker/features/goals/data/tables/goals_table.dart';

@DataClassName('WalletGoalContribution')
class WalletGoalContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get goalId => integer().references(WalletGoals, #id, onDelete: KeyAction.cascade)();
  IntColumn get contributedByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get amount => integer().map(const MoneyConverter())();
  DateTimeColumn get contributedAt => dateTime().clientDefault(() => DateTime.now())();
}
