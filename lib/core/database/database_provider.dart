import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/sms/data/sms_parsing_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A provider for the AppDatabase instance.
// We use a singleton pattern here to ensure only one database instance is created.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Provider to get the database file. This is useful for backup/restore.
/*
final databaseFileProvider = FutureProvider<File>((ref) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, 'db.sqlite'));
});
*/

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

final recurringTransactionDaoProvider = Provider<RecurringTransactionDao>((ref) {
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

final notificationDaoProvider = Provider<NotificationDao>((ref) {
  return ref.watch(databaseProvider).notificationDao;
});

final notificationPreferenceDaoProvider = Provider<NotificationPreferenceDao>((ref) {
  return ref.watch(databaseProvider).notificationPreferenceDao;
});

final feedbackDaoProvider = Provider<FeedbackDao>((ref) {
  return ref.watch(databaseProvider).feedbackDao;
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

final tagDaoProvider = Provider<TagDao>((ref) {
  return ref.watch(databaseProvider).tagDao;
});

final transactionTagDaoProvider = Provider<TransactionTagDao>((ref) {
  return ref.watch(databaseProvider).transactionTagDao;
});

final attachmentDaoProvider = Provider<AttachmentDao>((ref) {
  return ref.watch(databaseProvider).attachmentDao;
});

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
