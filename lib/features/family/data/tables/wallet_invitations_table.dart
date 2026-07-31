import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletInvitation')
class WalletInvitations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get invitedByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().map(const EnumNameConverter(WalletInvitationStatus.values))();
  TextColumn get role => text().map(const EnumNameConverter(WalletRole.values))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
}
