import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletMember')
class WalletMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text().map(const EnumNameConverter(WalletRole.values))();
  DateTimeColumn get joinedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
