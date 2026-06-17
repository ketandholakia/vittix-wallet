import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/monthly_report.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the current month's summary report.
final monthlyReportProvider = FutureProvider.autoDispose<MonthlyReport>((ref) {
  return ref.watch(getMonthlySummaryUseCaseProvider).call(DateTime.now());
});

// Provider for the list of recent transactions.
final recentTransactionsProvider = StreamProvider.autoDispose<List<domain.Transaction>>((ref) {
  return ref.watch(watchRecentTransactionsUseCaseProvider).call(limit: 10);
});

final monthlyTransactionsProvider = StreamProvider.autoDispose<List<domain.Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTransactionsInMonth(DateTime.now());
});
