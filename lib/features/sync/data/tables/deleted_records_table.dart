import 'package:drift/drift.dart';

/// Tombstones written whenever a synced row is deleted.
///
/// [walletId] scopes the tombstone to a wallet so one wallet's sync cannot
/// delete another wallet's rows. It is null for wallet-independent tables such
/// as `categories` and `wallets`.
@DataClassName('DeletedRecord')
class DeletedRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get deletedTable => text().named('table_name')();
  IntColumn get walletId => integer().nullable()();
  DateTimeColumn get deletedAt => dateTime().withDefault(currentDateAndTime)();
}
