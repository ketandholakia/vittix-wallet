import 'dart:io';

import 'package:vittix_wallet/core/database/app_database.dart';
import 'package:vittix_wallet/core/database/database_encryption.dart';
import 'package:vittix_wallet/core/services/auto_backup.dart';
import 'package:vittix_wallet/core/services/backup_service.dart';
import 'package:vittix_wallet/sms/data/sms_import_metrics_dao.dart';
import 'package:vittix_wallet/sms/data/sms_parsing_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// A provider for the AppDatabase instance.
// We use a singleton pattern here to ensure only one database instance is created.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// How the database was unlocked.
///
/// `AsyncError` carries [DatabaseKeyUnavailableException] when an encrypted
/// database cannot be opened; `AsyncData` with a non-null
/// [DatabaseOpenPlan.warning] means the app is running on an unencrypted
/// database and must show a persistent warning.
final databaseOpenPlanProvider = FutureProvider<DatabaseOpenPlan>((ref) {
  return resolveDatabaseOpenPlan();
});

/// Non-null when the live database is unencrypted; drives the warning banner.
final databaseEncryptionWarningProvider = Provider<String?>((ref) {
  return ref.watch(databaseOpenPlanProvider).valueOrNull?.warning;
});

/// Base64 key that opens the live database, or null when it is plaintext.
///
/// Used to validate and restore encrypted SQLCipher snapshots, which are
/// encrypted with this same key.
final databaseKeyProvider = FutureProvider<String?>((ref) async {
  final plan = await ref.watch(databaseOpenPlanProvider.future);
  return plan.base64Key;
});

/// The on-device database file. Used by backup and restore.
final databaseFileProvider = FutureProvider<File>((ref) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, kDatabaseFileName));
});

/// Snapshot/validate/restore operations for the live database.
final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

/// Periodic backups into a user-chosen folder (runs at app start).
final autoBackupServiceProvider = Provider<AutoBackupService>((ref) {
  return AutoBackupService(ref.watch(backupServiceProvider));
});

// Providers for each DAO
final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return ref.watch(databaseProvider).categoryDao;
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return ref.watch(databaseProvider).transactionDao;
});

final budgetDaoProvider = Provider<BudgetDao>((ref) {
  return ref.watch(databaseProvider).budgetDao;
});

final accountDaoProvider = Provider<AccountDao>((ref) {
  return ref.watch(databaseProvider).accountDao;
});

final recurringTransactionDaoProvider = Provider<RecurringTransactionDao>((
  ref,
) {
  return ref.watch(databaseProvider).recurringTransactionDao;
});

final walletDaoProvider = Provider<WalletDao>((ref) {
  return ref.watch(databaseProvider).walletDao;
});

final goalDaoProvider = Provider<GoalDao>((ref) {
  return ref.watch(databaseProvider).goalDao;
});

final allowanceDaoProvider = Provider<AllowanceDao>((ref) {
  return ref.watch(databaseProvider).allowanceDao;
});

final billDaoProvider = Provider<BillDao>((ref) {
  return ref.watch(databaseProvider).billDao;
});

/*
/*
final commitmentDaoProvider = Provider<CommitmentDao>((ref) {
  return ref.watch(databaseProvider).commitmentDao;
});
*/

/*
final settlementDaoProvider = Provider<SettlementDao>((ref) {
  return ref.watch(databaseProvider).settlementDao;
});
*/
*/

/*
final notificationDaoProvider = Provider<NotificationDao>((ref) {
  return ref.watch(databaseProvider).notificationDao;
});

final notificationPreferenceDaoProvider = Provider<NotificationPreferenceDao>((ref) {
  return ref.watch(databaseProvider).notificationPreferenceDao;
});

final feedbackDaoProvider = Provider<FeedbackDao>((ref) {
  return ref.watch(databaseProvider).feedbackDao;
});
*/

final userDaoProvider = Provider<UserDao>((ref) {
  return ref.watch(databaseProvider).userDao;
});

final smsImportMetricsDaoProvider = Provider<SmsImportMetricsDao>((ref) {
  return ref.watch(databaseProvider).smsImportMetricsDao;
});

final smsParsingDaoProvider = Provider<SmsParsingDao>((ref) {
  return ref.watch(databaseProvider).smsParsingDao;
});

final payeeDaoProvider = Provider<PayeeDao>((ref) {
  return ref.watch(databaseProvider).payeeDao;
});

/*
final tagDaoProvider = Provider<TagDao>((ref) {
  return ref.watch(databaseProvider).tagDao;
});

final transactionTagDaoProvider = Provider<TransactionTagDao>((ref) {
  return ref.watch(databaseProvider).transactionTagDao;
});

final attachmentDaoProvider = Provider<AttachmentDao>((ref) {
  return ref.watch(databaseProvider).attachmentDao;
});
*/

/*
final familyAutomationServiceProvider = Provider<FamilyAutomationService>((ref) {
  return const FamilyAutomationService();
});
*/

/*
final notificationCenterServiceProvider = Provider<NotificationCenterService>((ref) {
  return const NotificationCenterService();
});
*/
