import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/categories/domain/category.dart';
import 'package:expense_tracker/features/transactions/domain/transaction.dart';

enum RecurringInterval {
  daily,
  weekly,
  monthly,
  yearly,
}

extension RecurringIntervalX on RecurringInterval {
  String get label => switch (this) {
        RecurringInterval.daily => 'Daily',
        RecurringInterval.weekly => 'Weekly',
        RecurringInterval.monthly => 'Monthly',
        RecurringInterval.yearly => 'Yearly',
      };
}

class RecurringTransaction {
  final int id;
  final int walletId;
  final String name;
  final double amount;
  final TransactionType type;
  final Category category;
  final Account account;
  final RecurringInterval interval;
  final DateTime startDate;
  final DateTime nextDueDate;
  final DateTime? lastGeneratedDate;
  final bool isActive;

  RecurringTransaction({
    required this.id,
    this.walletId = 0,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.account,
    required this.interval,
    required this.startDate,
    required this.nextDueDate,
    this.lastGeneratedDate,
    this.isActive = true,
  });
}
