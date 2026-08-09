// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_import_metrics_dao.dart';

// ignore_for_file: type=lint
mixin _$SmsImportMetricsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SmsImportMetricsTable get smsImportMetrics =>
      attachedDatabase.smsImportMetrics;
  SmsImportMetricsDaoManager get managers => SmsImportMetricsDaoManager(this);
}

class SmsImportMetricsDaoManager {
  final _$SmsImportMetricsDaoMixin _db;
  SmsImportMetricsDaoManager(this._db);
  $$SmsImportMetricsTableTableManager get smsImportMetrics =>
      $$SmsImportMetricsTableTableManager(
        _db.attachedDatabase,
        _db.smsImportMetrics,
      );
}
