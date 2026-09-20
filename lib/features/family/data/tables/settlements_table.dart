import 'package:drift/drift.dart';
import 'package:expense_tracker/core/money/money.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('WalletSettlement')
class WalletSettlements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get payerMemberId => integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  IntColumn get receiverMemberId => integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer().map(const MoneyConverter())();
  DateTimeColumn get settlementDate => dateTime().clientDefault(() => DateTime.now())();
  TextColumn get notes => text().nullable()();
  IntColumn get createdByAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
