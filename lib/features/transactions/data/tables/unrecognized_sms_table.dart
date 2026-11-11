import 'package:drift/drift.dart';
import 'package:vittix_wallet/features/family/data/tables/wallets_table.dart';

@DataClassName('UnrecognizedSms')
class UnrecognizedSmsEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  TextColumn get smsBody => text()();
  TextColumn get sender => text()();
  DateTimeColumn get receivedAt => dateTime()();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
