import 'package:drift/drift.dart';
import 'package:expense_tracker/features/users/data/tables/users_table.dart';
import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';

@DataClassName('WalletMember')
class WalletMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  /// A7 bridge: the real identity of this member.
  ///
  /// `accountId` above is a money container, not a person - that conflation is
  /// why collaboration could not be built. This column is the successor and is
  /// nullable so membership rows can carry a user identity while every existing
  /// `actorAccountId` call site is migrated across. Once step 3 is complete,
  /// `accountId` can be dropped.
  IntColumn get userId => integer().nullable().references(Users, #id, onDelete: KeyAction.setNull)();
  TextColumn get role => text().map(const EnumNameConverter(WalletRole.values))();
  DateTimeColumn get joinedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
