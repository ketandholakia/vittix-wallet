import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/transactions/data/tables/sms_import_metrics_table.dart';

part 'sms_import_metrics_dao.g.dart';

@DriftAccessor(tables: [SmsImportMetrics])
class SmsImportMetricsDao extends DatabaseAccessor<AppDatabase> with _$SmsImportMetricsDaoMixin {
  SmsImportMetricsDao(AppDatabase db) : super(db);

  Future<void> record({
    required int walletId,
    required int acceptedImports,
    required int rejectedImports,
    required int duplicateDetections,
  }) async {
    final existing = await (select(smsImportMetrics)..where((t) => t.walletId.equals(walletId))).getSingleOrNull();

    if (existing == null) {
      await into(smsImportMetrics).insert(SmsImportMetricsCompanion.insert(
        walletId: walletId,
        acceptedImports: Value(acceptedImports),
        rejectedImports: Value(rejectedImports),
        duplicateDetections: Value(duplicateDetections),
      ));
    } else {
      await (update(smsImportMetrics)..where((t) => t.walletId.equals(walletId))).write(
        SmsImportMetricsCompanion(
          acceptedImports: Value(existing.acceptedImports + acceptedImports),
          rejectedImports: Value(existing.rejectedImports + rejectedImports),
          duplicateDetections: Value(existing.duplicateDetections + duplicateDetections),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<SmsImportMetric?> getForWallet(int walletId) {
    return (select(smsImportMetrics)..where((t) => t.walletId.equals(walletId))).getSingleOrNull();
  }
}
