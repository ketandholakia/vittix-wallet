part of '../app_database.dart';

@DriftAccessor(tables: [Attachments, Transactions])
class AttachmentDao extends DatabaseAccessor<AppDatabase> with _$AttachmentDaoMixin {
  AttachmentDao(AppDatabase db) : super(db);
  Future<void> insertAttachment(dynamic a) async {}
}
