// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_parsing_dao.dart';

// ignore_for_file: type=lint
mixin _$SmsParsingDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletsTable get wallets => attachedDatabase.wallets;
  $CategoriesTable get categories => attachedDatabase.categories;
  $MerchantMappingsTable get merchantMappings =>
      attachedDatabase.merchantMappings;
  $UnrecognizedSmsEntriesTable get unrecognizedSmsEntries =>
      attachedDatabase.unrecognizedSmsEntries;
  SmsParsingDaoManager get managers => SmsParsingDaoManager(this);
}

class SmsParsingDaoManager {
  final _$SmsParsingDaoMixin _db;
  SmsParsingDaoManager(this._db);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db.attachedDatabase, _db.wallets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
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
