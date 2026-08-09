import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/transactions/data/tables/merchant_mappings_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/unrecognized_sms_table.dart';

part 'sms_parsing_dao.g.dart';

@DriftAccessor(tables: [MerchantMappings, UnrecognizedSmsEntries])
class SmsParsingDao extends DatabaseAccessor<AppDatabase> with _$SmsParsingDaoMixin {
  SmsParsingDao(AppDatabase db) : super(db);

  Future<List<MerchantMapping>> getMerchantMappings(int walletId) {
    return (select(merchantMappings)..where((t) => t.walletId.equals(walletId))).get();
  }

  Stream<List<MerchantMapping>> watchMerchantMappings(int walletId) {
    return (select(merchantMappings)..where((t) => t.walletId.equals(walletId))).watch();
  }

  Future<int> insertMerchantMapping(MerchantMappingsCompanion mapping) {
    return into(merchantMappings).insert(mapping);
  }

  Future<bool> updateMerchantMapping(Insertable<MerchantMapping> mapping) {
    return update(merchantMappings).replace(mapping);
  }

  Future<int> deleteMerchantMapping(int id) {
    return (delete(merchantMappings)..where((t) => t.id.equals(id))).go();
  }

  Future<int> insertUnrecognizedSms(UnrecognizedSmsEntriesCompanion entry) {
    return into(unrecognizedSmsEntries).insert(entry);
  }
  
  Stream<List<UnrecognizedSms>> watchUnresolvedSms(int walletId) {
    return (select(unrecognizedSmsEntries)
          ..where((t) => t.walletId.equals(walletId))
          ..where((t) => t.isResolved.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> markSmsResolved(int id) {
    return (update(unrecognizedSmsEntries)..where((t) => t.id.equals(id)))
        .write(const UnrecognizedSmsEntriesCompanion(isResolved: Value(true)));
  }

  Future<int> deleteUnrecognizedSms(int id) {
    return (delete(unrecognizedSmsEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<int> clearUnrecognizedSms(int walletId) {
    return (delete(unrecognizedSmsEntries)..where((t) => t.walletId.equals(walletId))).go();
  }
}
