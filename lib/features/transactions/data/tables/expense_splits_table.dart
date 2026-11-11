import 'package:drift/drift.dart';
import 'package:vittix_wallet/core/database/database_enums.dart';
import 'package:vittix_wallet/features/accounts/data/tables/accounts_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallet_members_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallets_table.dart';
import 'package:vittix_wallet/features/transactions/data/tables/transactions_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('WalletExpenseSplit')
class WalletExpenseSplits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get transactionId =>
      integer().references(Transactions, #id, onDelete: KeyAction.cascade)();
  IntColumn get paidByMemberId =>
      integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  TextColumn get splitMethod =>
      text().map(const EnumNameConverter(WalletExpenseSplitMethod.values))();
  IntColumn get createdByAccountId => integer().nullable().references(
    Accounts,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
