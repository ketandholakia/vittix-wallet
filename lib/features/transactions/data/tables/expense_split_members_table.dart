import 'package:drift/drift.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/expense_splits_table.dart';

@DataClassName('WalletExpenseSplitMember')
class WalletExpenseSplitMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get splitId => integer().references(WalletExpenseSplits, #id, onDelete: KeyAction.cascade)();
  IntColumn get memberId => integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountOwed => integer().map(const MoneyConverter())();
  RealColumn get percentage => real().withDefault(const Constant(0))();
  IntColumn get settledAmount => integer().map(const MoneyConverter()).withDefault(const Constant(0))();
}
