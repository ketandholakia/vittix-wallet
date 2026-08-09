// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/core/database/app_database.dart';

class RecurrenceOccurrence {
  final DateTime date;
  final double amount;
  final String kind;
  final int entityId;

  const RecurrenceOccurrence({
    required this.date,
    required this.amount,
    required this.kind,
    required this.entityId,
  });
}

class GoalForecast {
  final DateTime? projectedCompletionDate;
  final double contributionVelocity;
  final double remainingRequired;

  const GoalForecast({
    required this.projectedCompletionDate,
    required this.contributionVelocity,
    required this.remainingRequired,
  });
}

class AllowanceForecast {
  final DateTime? nextPaymentDate;
  final double annualTotal;
  final double projectedRemainingAllowance;

  const AllowanceForecast({
    required this.nextPaymentDate,
    required this.annualTotal,
    required this.projectedRemainingAllowance,
  });
}

class BillForecast {
  final String status;
  final DateTime dueDate;

  const BillForecast({required this.status, required this.dueDate});
}

class FamilyCashflowProjection {
  final double expectedIncome;
  final double expectedBills;
  final double expectedAllowancePayments;
  final double expectedGoalContributions;

  const FamilyCashflowProjection({
    required this.expectedIncome,
    required this.expectedBills,
    required this.expectedAllowancePayments,
    required this.expectedGoalContributions,
  });
}

class FamilyAutomationService {
  const FamilyAutomationService();

  DateTime _addFrequency(DateTime date, String frequency) {
    switch (frequency) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(date.year, date.month + 1, date.day, date.hour, date.minute);
      case 'quarterly':
        return DateTime(date.year, date.month + 3, date.day, date.hour, date.minute);
      case 'yearly':
        return DateTime(date.year + 1, date.month, date.day, date.hour, date.minute);
      default:
        return date.add(const Duration(days: 1));
    }
  }

  List<RecurrenceOccurrence> buildOccurrences({
    required DateTime from,
    required DateTime to,
    required List<WalletAllowance> allowances,
    required List<WalletGoalSchedule> schedules,
    required List<WalletBill> bills,
  }) {
    final occurrences = <RecurrenceOccurrence>[];
    for (final allowance in allowances.where((a) => a.isActive)) {
      var next = allowance.startDate;
      while (!next.isBefore(from) || next.isAfter(from)) {
        next = next.isBefore(from) ? from : next;
        if (next.isAfter(to)) break;
        occurrences.add(RecurrenceOccurrence(date: next, amount: allowance.amount, kind: 'allowance', entityId: allowance.id));
        next = _addFrequency(next, allowance.frequency.name);
      }
    }
    for (final schedule in schedules.where((s) => s.isActive)) {
      var next = schedule.nextDueDate;
      while (!next.isBefore(from) || next.isAfter(from)) {
        if (next.isAfter(to)) break;
        occurrences.add(RecurrenceOccurrence(date: next, amount: schedule.amount, kind: 'goal_schedule', entityId: schedule.id));
        next = _addFrequency(next, schedule.frequency.name);
      }
    }
    for (final bill in bills.where((b) => b.isActive)) {
      var next = bill.dueDate;
      while (!next.isBefore(from) || next.isAfter(from)) {
        if (next.isAfter(to)) break;
        occurrences.add(RecurrenceOccurrence(date: next, amount: bill.amount, kind: 'bill', entityId: bill.id));
        next = _addFrequency(next, bill.recurrence.name);
      }
    }
    occurrences.sort((a, b) => a.date.compareTo(b.date));
    return occurrences;
  }

  GoalForecast forecastGoal(WalletGoal goal, List<WalletGoalSchedule> schedules, List<WalletGoalContribution> contributions) {
    final remaining = (goal.targetAmount - goal.currentAmount).clamp(0.0, double.infinity);
    final goalSchedules = schedules.where((s) => s.walletGoalId == goal.id && s.isActive).toList();
    final scheduledVelocity = goalSchedules.fold<double>(0, (sum, schedule) => sum + schedule.amount);
    final contributionVelocity = contributions.fold<double>(0, (sum, contribution) => sum + contribution.amount);
    final velocity = scheduledVelocity > 0 ? scheduledVelocity : contributionVelocity;
    if (velocity <= 0) {
      return GoalForecast(projectedCompletionDate: null, contributionVelocity: 0, remainingRequired: remaining);
    }
    final months = (remaining / velocity).ceil();
    return GoalForecast(
      projectedCompletionDate: DateTime.now().add(Duration(days: 30 * months)),
      contributionVelocity: velocity,
      remainingRequired: remaining,
    );
  }

  AllowanceForecast forecastAllowance(WalletAllowance allowance, List<WalletAllowancePayment> payments) {
    final nextPaymentDate = _addFrequency(allowance.startDate, allowance.frequency.name);
    final annualTotal = switch (allowance.frequency) {
      WalletAllowanceFrequency.weekly => allowance.amount * 52,
      WalletAllowanceFrequency.monthly => allowance.amount * 12,
      WalletAllowanceFrequency.custom => allowance.amount,
    };
    final paid = payments.where((payment) => payment.allowanceId == allowance.id).fold<double>(0, (sum, payment) => sum + payment.amount);
    return AllowanceForecast(
      nextPaymentDate: nextPaymentDate,
      annualTotal: annualTotal,
      projectedRemainingAllowance: (annualTotal - paid).clamp(0.0, double.infinity),
    );
  }

  BillForecast forecastBill(WalletBill bill) {
    final now = DateTime.now();
    final status = bill.status == WalletBillStatus.paid
        ? 'paid'
        : bill.dueDate.isBefore(now)
            ? 'overdue'
            : bill.dueDate.day == now.day && bill.dueDate.month == now.month && bill.dueDate.year == now.year
                ? 'due_today'
                : 'upcoming';
    return BillForecast(status: status, dueDate: bill.dueDate);
  }

  FamilyCashflowProjection projectCashflow({
    required List<WalletBill> bills,
    required List<WalletAllowance> allowances,
    required List<WalletGoalSchedule> schedules,
    required DateTime horizon,
  }) {
    final now = DateTime.now();
    final occurrences = buildOccurrences(from: now, to: horizon, allowances: allowances, schedules: schedules, bills: bills);
    return FamilyCashflowProjection(
      expectedIncome: 0,
      expectedBills: occurrences.where((o) => o.kind == 'bill').fold<double>(0, (sum, o) => sum + o.amount),
      expectedAllowancePayments: occurrences.where((o) => o.kind == 'allowance').fold<double>(0, (sum, o) => sum + o.amount),
      expectedGoalContributions: occurrences.where((o) => o.kind == 'goal_schedule').fold<double>(0, (sum, o) => sum + o.amount),
    );
  }
}

