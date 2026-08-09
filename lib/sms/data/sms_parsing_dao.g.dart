// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_parsing_dao.dart';

// ignore_for_file: type=lint
mixin _$SmsParsingDaoMixin on DatabaseAccessor<AppDatabase> {
  $MerchantMappingsTable get merchantMappings =>
      attachedDatabase.merchantMappings;
  $UnrecognizedSmsEntriesTable get unrecognizedSmsEntries =>
      attachedDatabase.unrecognizedSmsEntries;
  SmsParsingDaoManager get managers => SmsParsingDaoManager(this);
}

class SmsParsingDaoManager {
  final _$SmsParsingDaoMixin _db;
  SmsParsingDaoManager(this._db);
  $$MerchantMappingsTableTableManager get merchantMappings =>
      $$MerchantMappingsTableTableManager(
        _db.attachedDatabase,
        _db.merchantMappings,
      );
  $$UnrecognizedSmsEntriesTableTableManager get unrecognizedSmsEntries =>
      $$UnrecognizedSmsEntriesTableTableManager(
        _db.attachedDatabase,
        _db.unrecognizedSmsEntries,
      );
}
