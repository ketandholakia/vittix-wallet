import 'package:drift/drift.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletBill')
class WalletBills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get amount => integer().map(const MoneyConverter())();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get recurrence => text().map(const EnumNameConverter(WalletBillRecurrence.values))();
  TextColumn get category => text().withLength(min: 1, max: 60)();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().map(const EnumNameConverter(WalletBillStatus.values)).withDefault(const Constant('unpaid'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get createdByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get updatedByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
