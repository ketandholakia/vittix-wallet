import 'package:drift/drift.dart';

/// Records remote changes that could not be ordered confidently against the
/// local row (timestamps within the conflict window).
///
/// The local row is kept; the remote payload is stored here instead of being
/// silently dropped so it can be reviewed or recovered.
@DataClassName('SyncConflict')
class SyncConflicts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().nullable()();
  TextColumn get entity => text()();
  TextColumn get uuid => text()();
  DateTimeColumn get localUpdatedAt => dateTime()();
  DateTimeColumn get remoteUpdatedAt => dateTime()();
  TextColumn get remoteJson => text()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
}
