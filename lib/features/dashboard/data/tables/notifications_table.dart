import 'package:drift/drift.dart';
import 'package:vittix_wallet/core/database/database_enums.dart';
import 'package:vittix_wallet/features/family/data/tables/wallet_members_table.dart';
import 'package:vittix_wallet/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletNotification')
class WalletNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get memberId => integer().nullable().references(
    WalletMembers,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get type =>
      text().map(const EnumNameConverter(WalletNotificationType.values))();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get message => text().withLength(min: 1, max: 300)();
  IntColumn get relatedEntityId => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get dismissedAt => dateTime().nullable()();
}
