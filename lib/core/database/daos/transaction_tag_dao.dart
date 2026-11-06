part of '../app_database.dart';

@DriftAccessor(tables: [Tags])
class TransactionTagDao extends DatabaseAccessor<AppDatabase> with _$TransactionTagDaoMixin {
  TransactionTagDao(AppDatabase db) : super(db);
  Future<void> setTagsForTransaction(int txId, List<int> tags) async {}
}
