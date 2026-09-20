import 'package:drift/drift.dart';
import 'package:expense_tracker/features/users/data/tables/users_table.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallet_members_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('WalletActivity')
class WalletActivities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get actorAccountId => integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get actorMemberId => integer().nullable().references(WalletMembers, #id, onDelete: KeyAction.setNull)();

  /// A7 step 3 slice 2: the real identity behind an audit event, alongside the
  /// legacy actorAccountId. Nullable while call sites migrate.
  IntColumn get actorUserId => integer().nullable().references(Users, #id, onDelete: KeyAction.setNull)();
  TextColumn get action => text().withLength(min: 1, max: 100)();
  TextColumn get entityType => text().withLength(min: 1, max: 100)();
  IntColumn get entityId => integer()();
  TextColumn get entityUuid => text().nullable()();
  TextColumn get details => text().nullable()();
  TextColumn get metadata => text().nullable()();
  TextColumn get source => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}