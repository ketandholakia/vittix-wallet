import 'package:drift/drift.dart';
import 'package:vittix_wallet/core/money/money.dart';
import 'package:vittix_wallet/features/family/data/tables/allowances_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallet_members_table.dart';

@DataClassName('WalletAllowancePayment')
class WalletAllowancePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get allowanceId => integer().references(
    WalletAllowances,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get memberId =>
      integer().references(WalletMembers, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer().map(const MoneyConverter())();
  DateTimeColumn get paidDate =>
      dateTime().clientDefault(() => DateTime.now())();
  TextColumn get notes => text().nullable()();
}
