import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/transactions_table.dart';

@DataClassName('WalletExpenseSplit')
class WalletExpenseSplits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get transactionId => integer().references(Transactions, #id, onDelete: KeyAction.cascade)();
  IntColumn get paidByMemberId => integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  TextColumn get splitMethod => text().map(const EnumNameConverter(WalletExpenseSplitMethod.values))();
  IntColumn get createdByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
