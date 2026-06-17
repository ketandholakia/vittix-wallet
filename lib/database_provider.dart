import 'dart:io';

import 'package:expense_tracker/data/local/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// A provider for the AppDatabase instance.
// We use a singleton pattern here to ensure only one database instance is created.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Provider to get the database file. This is useful for backup/restore.
final databaseFileProvider = FutureProvider<File>((ref) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, 'db.sqlite'));
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

final recurringTransactionDaoProvider = Provider<RecurringTransactionDao>((ref) {
  return ref.watch(databaseProvider).recurringTransactionDao;
});