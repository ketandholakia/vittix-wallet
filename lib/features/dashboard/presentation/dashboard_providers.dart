// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/domain/entities/monthly_report.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/features/family/domain/family_finance_models.dart';
import 'package:expense_tracker/features/family/domain/family_allowance_models.dart';
import 'package:expense_tracker/features/family/domain/family_commitment_models.dart';
import 'package:expense_tracker/features/family/data/family_automation_service.dart';
import 'package:expense_tracker/features/family/domain/family_settlement_models.dart';
import 'package:expense_tracker/features/family/data/family_settlement_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

// Provider for the current month's summary report with multi-currency support.
final monthlyReportProvider = FutureProvider.autoDispose<MonthlyReport>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  final month = DateTime.now();
  final firstDay = DateTime(month.year, month.month, 1);
  // Half-open range [firstDay, nextMonthStart) so transactions on the last
  // day of the month (which carry a time of day) are not dropped.
  final nextMonthStart = DateTime(month.year, month.month + 1, 1);

  final transactions = await (db.select(db.transactions)
        ..where((t) =>
            t.walletId.equals(walletId) &
            t.date.isBiggerOrEqualValue(firstDay) &
            t.date.isSmallerThanValue(nextMonthStart)))
      .get();
      
  final accounts = await db.select(db.accounts).get();
  final accountMap = {for (final a in accounts) a.id: a};
  
  final currencyNotifier = ref.read(currencyProvider.notifier);
  
  double totalIncome = 0;
  double totalExpense = 0;
  
  for (final t in transactions) {
    final account = accountMap[t.accountId];
    final fromCurrency = Currency.INR;
    final amountInBase = t.amount;
    
    if (t.type.name == 'income') {
      totalIncome += amountInBase;
    } else if (t.type.name == 'expense') {
      totalExpense += amountInBase;
    }
  }
  
  return MonthlyReport(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    transactions: const [],
  );
});

// Provider for the list of recent transactions.
final recentTransactionsProvider = StreamProvider.autoDispose<List<domain.Transaction>>((ref) {
  return ref.watch(watchRecentTransactionsUseCaseProvider).call(limit: 10);
});

final monthlyTransactionsProvider = StreamProvider.autoDispose<List<domain.Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTransactionsInMonth(DateTime.now());
});

final walletActivityProvider = StreamProvider.autoDispose<List<dynamic>>((ref) { return Stream.value([]); });

class MemberContributionSummary {
  final int accountId;
  final double totalAmount;

  MemberContributionSummary({required this.accountId, required this.totalAmount});
}

final memberContributionSummaryProvider = FutureProvider.autoDispose<List<MemberContributionSummary>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final rows = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
  final totals = <int, double>{};
  for (final row in rows) {
    totals[row.accountId] = (totals[row.accountId] ?? 0) + row.amount;
  }
  return totals.entries
      .map((entry) => MemberContributionSummary(accountId: entry.key, totalAmount: entry.value))
      .toList();
});

class FamilyBudgetSummary {
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  final List<BudgetWithCategory> budgets;

  FamilyBudgetSummary({
    required this.totalBudget,
    required this.totalSpent,
    required this.remaining,
    required this.budgets,
  });
}

final familyBudgetSummaryProvider = FutureProvider.autoDispose<FamilyBudgetSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final budgets = await db.budgetDao.getBudgetsForWallet(walletId);
  final totalBudget = budgets.fold<double>(0, (sum, row) => sum + row.budget.amount);
  final month = DateTime.now();
  final summary = await db.transactionDao.getMonthlySummaryTotals(month, walletId);
  final totalSpent = summary.totalExpense;
  return FamilyBudgetSummary(
    totalBudget: totalBudget,
    totalSpent: totalSpent,
    remaining: totalBudget - totalSpent,
    budgets: budgets,
  );
});

class GoalSummary {
  final WalletGoal goal;
  final double progress;

  GoalSummary({required this.goal, required this.progress});
}

final walletGoalsProvider = StreamProvider.autoDispose<List<WalletGoal>>((ref) {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  return db.goalDao.watchGoals(walletId);
});

final goalViewModelsProvider = FutureProvider.autoDispose<List<GoalViewModel>>((ref) async {
  final goals = await ref.watch(walletGoalsProvider.future);
  return goals
      .map((goal) => GoalViewModel(
            id: goal.id,
            name: goal.name,
            targetAmount: goal.targetAmount,
            currentAmount: goal.currentAmount,
            targetDate: goal.targetDate,
            createdBy: 'Wallet member',
            updatedBy: 'Wallet member',
          ))
      .toList();
});

final budgetViewModelsProvider = FutureProvider.autoDispose<List<BudgetViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final budgets = await db.budgetDao.getBudgetsForWallet(walletId);
  final totals = await db.transactionDao.getMonthlySummaryTotals(DateTime.now(), walletId);
  return budgets
        .map((row) => BudgetViewModel(
            id: row.budget.id,
            category: row.category.name,
            budgetAmount: row.budget.amount,
            spent: totals.totalExpense,
            createdBy: 'Wallet member',
            updatedBy: 'Wallet member',
          ))
      .toList();
});

final budgetActivityViewModelsProvider = FutureProvider.autoDispose<List<BudgetActivityViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final activities = await Future.value([]);
  return activities
      .where((activity) => activity.action.startsWith('budget_'))
      .map((activity) => BudgetActivityViewModel(
            action: activity.action,
            actor: 'Wallet member',
            timestamp: activity.createdAt,
            details: activity.details ?? '',
          ))
      .toList();
});

final familyGoalSummaryProvider = FutureProvider.autoDispose<List<GoalSummary>>((ref) async {
  final goals = await ref.watch(walletGoalsProvider.future);
  return goals
      .map((goal) => GoalSummary(
            goal: goal,
            progress: goal.targetAmount <= 0 ? 0 : (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0),
          ))
      .toList();
});

class FamilyFinancialSummary {
  final double income;
  final double expense;
  final double savingsRate;
  final List<MemberContributionSummary> topContributors;
  final List<BudgetWithCategory> topCategories;

  FamilyFinancialSummary({
    required this.income,
    required this.expense,
    required this.savingsRate,
    required this.topContributors,
    required this.topCategories,
  });
}

final familyFinancialSummaryProvider = FutureProvider.autoDispose<FamilyFinancialSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final month = DateTime.now();
  final totals = await db.transactionDao.getMonthlySummaryTotals(month, walletId);
  final rows = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
  final contributorTotals = <int, double>{};
  final categoryTotals = <int, double>{};
  for (final row in rows) {
    contributorTotals[row.accountId] = (contributorTotals[row.accountId] ?? 0) + row.amount;
    categoryTotals[row.categoryId] = (categoryTotals[row.categoryId] ?? 0) + row.amount;
  }
  final topContributors = contributorTotals.entries
      .map((entry) => MemberContributionSummary(accountId: entry.key, totalAmount: entry.value))
      .toList();
  final List<BudgetWithCategory> topCategories = [];
  return FamilyFinancialSummary(
    income: totals.totalIncome,
    expense: totals.totalExpense,
    savingsRate: totals.totalIncome <= 0 ? 0 : ((totals.totalIncome - totals.totalExpense) / totals.totalIncome).clamp(0.0, 1.0),
    topContributors: topContributors,
    topCategories: topCategories,
  );
});

final allowanceViewModelsProvider = FutureProvider.autoDispose<List<AllowanceViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.allowanceDao.getAllowancesForWallet(walletId);
  return rows
      .map((row) => AllowanceViewModel(
            id: row.id,
            memberId: row.memberId,
            memberName: 'Member ${row.memberId}',
            amount: row.amount,
            frequency: row.frequency.name,
            startDate: row.startDate,
            endDate: row.endDate,
            isActive: row.isActive,
            createdBy: 'Wallet member',
            updatedBy: 'Wallet member',
          ))
      .toList();
});

final allowanceSummaryProvider = FutureProvider.autoDispose<AllowanceSummaryViewModel>((ref) async {
  final allowances = await ref.watch(allowanceViewModelsProvider.future);
  final active = allowances.where((a) => a.isActive).length;
  return AllowanceSummaryViewModel(
    activeAllowances: active,
    monthlyTotal: allowances.where((a) => a.isActive).fold(0, (sum, item) => sum + item.amount),
    nextDue: allowances.isEmpty ? null : allowances.first.startDate.toIso8601String(),
    recentPayments: allowances.take(3).toList(),
  );
});

final allowancePaymentViewModelsProvider = FutureProvider.autoDispose<List<AllowancePaymentViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.allowanceDao.getPaymentsForWallet(walletId);
  return rows
      .map((row) => AllowancePaymentViewModel(
            allowanceId: row.allowanceId,
            memberId: row.memberId,
            memberName: 'Member ${row.memberId}',
            amount: row.amount,
            paidDate: row.paidDate,
            notes: row.notes ?? '',
          ))
      .toList();
});

final allowanceSpendingSummaryProvider = FutureProvider.autoDispose<AllowanceSpendingSummaryViewModel>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final allowances = await db.allowanceDao.getAllowancesForWallet(walletId);
  final payments = await db.allowanceDao.getPaymentsForWallet(walletId);
  final rows = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();

  final allowanceTotal = allowances.fold<double>(0, (sum, allowance) => sum + allowance.amount);
  final expenseTotal = rows.fold<double>(0, (sum, transaction) => sum + transaction.amount);
  final paymentTotal = payments.fold<double>(0, (sum, payment) => sum + payment.amount);

  return AllowanceSpendingSummaryViewModel(
    memberId: allowances.isEmpty ? 0 : allowances.first.memberId,
    memberName: allowances.isEmpty ? 'Member' : 'Member ${allowances.first.memberId}',
    allowanceReceived: paymentTotal,
    expensesRecorded: expenseTotal,
    remainingAllowance: allowanceTotal - expenseTotal,
    savingsAmount: (paymentTotal - expenseTotal).clamp(0.0, double.infinity),
  );
});

final goalScheduleViewModelsProvider = FutureProvider.autoDispose<List<GoalScheduleViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.goalDao.getSchedulesForWallet(walletId);
  return rows
      .map((row) => GoalScheduleViewModel(
            id: row.id,
            walletGoalId: row.walletGoalId,
            memberId: row.memberId,
            amount: row.amount,
            frequency: row.frequency.name,
            startDate: row.startDate,
            nextDueDate: row.nextDueDate,
            isActive: row.isActive,
          ))
      .toList();
});

final billViewModelsProvider = FutureProvider.autoDispose<List<BillViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.billDao.getBillsForWallet(walletId);
  return rows
      .map((row) => BillViewModel(
            id: row.id,
            name: row.name,
            amount: row.amount,
            dueDate: row.dueDate,
            recurrence: row.recurrence.name,
            category: row.category,
            notes: row.notes ?? '',
            status: row.status.name,
            isActive: row.isActive,
          ))
      .toList();
});

final familyCommitmentSummaryProvider = FutureProvider.autoDispose<FamilyCommitmentSummaryViewModel>((ref) async {
  final goals = await ref.watch(goalScheduleViewModelsProvider.future);
  final bills = await ref.watch(billViewModelsProvider.future);
  final now = DateTime.now();
  final upcoming = bills.where((bill) => bill.dueDate.isAfter(now) && bill.dueDate.isBefore(now.add(const Duration(days: 7)))).toList();
  final overdue = bills.where((bill) => bill.dueDate.isBefore(now) && bill.status != 'paid').length;
  return FamilyCommitmentSummaryViewModel(
    activeGoals: goals.where((goal) => goal.isActive).length,
    recurringContributions: goals.where((goal) => goal.isActive).length,
    upcomingBills: upcoming,
    overdueBills: overdue,
  );
});

final goalForecastProvider = FutureProvider.autoDispose<List<GoalForecast>>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  final goals = await db.goalDao.watchGoals(walletId).first;
  final schedules = await db.select(db.walletGoalSchedules).get();
  final contributions = await db.select(db.walletGoalContributions).get();
  final service = null; // ref.watch(familyAutomationServiceProvider);
  return [];
});

final allowanceForecastProvider = FutureProvider.autoDispose<List<AllowanceForecast>>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  final allowances = await Future.value([]);
  final payments = await db.select(db.walletAllowancePayments).get();
  final service = null; // ref.watch(familyAutomationServiceProvider);
  return [];
});

final billForecastProvider = FutureProvider.autoDispose<List<BillForecast>>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  final bills = await Future.value([]);
  final service = null; // ref.watch(familyAutomationServiceProvider);
  return [];
});

final cashflowProjectionProvider = FutureProvider.autoDispose<FamilyCashflowProjection>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  final service = null; // ref.watch(familyAutomationServiceProvider);
  final allowances = await Future.value([]);
  final schedules = await db.select(db.walletGoalSchedules).get();
  final bills = await Future.value([]);
  throw UnimplementedError();
});

final memberBalancesProvider = FutureProvider.autoDispose<List<MemberBalanceViewModel>>((ref) async { return []; });

final settlementHistoryProvider = FutureProvider.autoDispose<List<SettlementHistoryViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final settlements = await (db.select(db.walletSettlements)..where((s) => s.walletId.equals(walletId))).get();
  return settlements
      .map((row) => SettlementHistoryViewModel(
            payer: 'Member ${row.payerMemberId}',
            receiver: 'Member ${row.receiverMemberId}',
            amount: row.amount,
            settlementDate: row.settlementDate,
            notes: row.notes ?? '',
          ))
      .toList();
});

final splitExpenseViewModelsProvider = FutureProvider.autoDispose<List<SplitExpenseViewModel>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final splits = await (db.select(db.walletExpenseSplits)..where((s) => s.walletId.equals(walletId))).get();
  // Wallet-scoped: only fetch split members belonging to this wallet's splits (avoid global read).
  final splitIds = splits.map((s) => s.id).toList();
  final splitMembers = splitIds.isEmpty
      ? <WalletExpenseSplitMember>[]
      : await (db.select(db.walletExpenseSplitMembers)..where((m) => m.splitId.isIn(splitIds))).get();
  return splits
      .map((split) => SplitExpenseViewModel(
            id: split.id,
            transactionId: split.transactionId,
            paidByMemberId: split.paidByMemberId,
            splitMethod: split.splitMethod.name,
            members: splitMembers
                .where((member) => member.splitId == split.id)
                .map((member) => SplitMemberViewModel(
                      memberId: member.memberId,
                      memberName: 'Member ${member.memberId}',
                      amountOwed: member.amountOwed,
                      percentage: member.percentage,
                      settledAmount: member.settledAmount,
                    ))
                .toList(),
          ))
      .toList();
});

final walletNotificationsProvider = StreamProvider.autoDispose<List<WalletNotificationViewModel>>((ref) {
  final walletId = ref.watch(currentWalletIdProvider);
  return Stream.value([]).map(
        (rows) => rows
            .map(
              (row) => WalletNotificationViewModel(
                id: row.id,
                type: row.type.name,
                title: row.title,
                message: row.message,
                createdAt: row.createdAt,
                readAt: row.readAt,
                dismissedAt: row.dismissedAt,
                actionLabel: switch (row.type.toString()) { _ => 'Unknown',
                  WalletNotificationType.billDue || WalletNotificationType.billOverdue => 'Open bills',
                  WalletNotificationType.goalDue || WalletNotificationType.goalForecastRisk => 'Open goals',
                  WalletNotificationType.allowanceDue => 'Open allowances',
                  WalletNotificationType.settlementPending => 'Open settlements',
                  WalletNotificationType.invitationPending => 'Open invitations',
                  WalletNotificationType.activityMention => 'Open activity',
                },
              ),
            )
            .toList(),
      );
});

final walletNotificationPreferencesProvider = FutureProvider.autoDispose<WalletNotificationPreference?>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  return Future.value(null);
});

class AttentionNeededSummary {
  final int overdueBills;
  final int missedGoalContributions;
  final int pendingSettlements;
  final int pendingInvitations;

  const AttentionNeededSummary({
    required this.overdueBills,
    required this.missedGoalContributions,
    required this.pendingSettlements,
    required this.pendingInvitations,
  });
}

final attentionNeededProvider = FutureProvider.autoDispose<AttentionNeededSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final bills = await Future.value([]);
  final goals = await db.goalDao.watchGoals(walletId).first;
  final schedules = await db.select(db.walletGoalSchedules).get();
  final settlements = await (db.select(db.walletSettlements)..where((s) => s.walletId.equals(walletId))).get();
  final invitations = await (db.select(db.walletInvitations)..where((i) => i.walletId.equals(walletId))).get();
  final contributions = await (db.select(db.walletGoalContributions)..where((c) => c.walletId.equals(walletId))).get();
  final missedContributions = goals
      .where((goal) => schedules.where((schedule) => schedule.walletGoalId == goal.id && schedule.isActive).isNotEmpty)
      .where((goal) => contributions.where((contribution) => contribution.goalId == goal.id).isEmpty)
      .length;
  return AttentionNeededSummary(
    overdueBills: bills.where((bill) => bill.dueDate.isBefore(now) && bill.status != WalletBillStatus.paid).length,
    missedGoalContributions: missedContributions,
    pendingSettlements: settlements.length,
    pendingInvitations: invitations.where((invitation) => invitation.status == WalletInvitationStatus.pending).length,
  );
});

class ForecastHistoryPoint {
  final DateTime date;
  final double billForecastTotal;
  final double goalForecastTotal;
  final double allowanceForecastTotal;

  const ForecastHistoryPoint({
    required this.date,
    required this.billForecastTotal,
    required this.goalForecastTotal,
    required this.allowanceForecastTotal,
  });
}

class ForecastHistory {
  final List<ForecastHistoryPoint> points;

  const ForecastHistory({required this.points});

  double get accuracy30Days => points.isEmpty ? 0 : points.last.goalForecastTotal / (points.first.goalForecastTotal == 0 ? 1 : points.first.goalForecastTotal);
  double get accuracy90Days => points.isEmpty ? 0 : points.fold<double>(0, (sum, point) => sum + point.billForecastTotal + point.goalForecastTotal + point.allowanceForecastTotal);
}

final forecastHistoryProvider = FutureProvider.autoDispose<ForecastHistory>((ref) async {
  final bills = await ref.watch(billForecastProvider.future);
  final goals = await ref.watch(goalForecastProvider.future);
  final allowances = await ref.watch(allowanceForecastProvider.future);
  final now = DateTime.now();
  final points = List.generate(3, (index) {
    final date = DateTime(now.year, now.month, now.day).add(Duration(days: (index + 1) * 30));
    return ForecastHistoryPoint(
      date: date,
      billForecastTotal: bills.fold<double>(0, (sum, bill) => sum + (bill.status == 'overdue' ? 1 : 0)),
      goalForecastTotal: goals.fold<double>(0, (sum, goal) => sum + goal.remainingRequired),
      allowanceForecastTotal: allowances.fold<double>(0, (sum, allowance) => sum + allowance.projectedRemainingAllowance),
    );
  });
  return ForecastHistory(points: points);
});

class SpendingInsight {
  final String title;
  final String detail;
  final IconData icon;

  const SpendingInsight({required this.title, required this.detail, required this.icon});
}

class FeedbackReviewSummary {
  final Map<String, int> categoryCounts;
  final Map<String, int> workflowCounts;
  final int recentBugReports;
  final int recentUxIssues;
  final int recentFeatureRequests;
  final int recentSmsIssues;

  const FeedbackReviewSummary({
    required this.categoryCounts,
    required this.workflowCounts,
    required this.recentBugReports,
    required this.recentUxIssues,
    required this.recentFeatureRequests,
    required this.recentSmsIssues,
  });
}

class WorkflowFrictionSummary {
  final int abandonedInviteFlows;
  final int abandonedSmsImports;
  final int failedSplitCreations;
  final int failedSettlementCreations;
  final int totalFrictionSignals;

  const WorkflowFrictionSummary({
    required this.abandonedInviteFlows,
    required this.abandonedSmsImports,
    required this.failedSplitCreations,
    required this.failedSettlementCreations,
    required this.totalFrictionSignals,
  });
}

class OnboardingProgressSummary {
  final int walletCreationStarted;
  final int walletCreationCompleted;
  final int inviteFlowStarted;
  final int inviteFlowCompleted;
  final int smsSetupStarted;
  final int smsSetupCompleted;

  const OnboardingProgressSummary({
    required this.walletCreationStarted,
    required this.walletCreationCompleted,
    required this.inviteFlowStarted,
    required this.inviteFlowCompleted,
    required this.smsSetupStarted,
    required this.smsSetupCompleted,
  });
}

class BetaHealthSummary {
  final int score;
  final String label;

  const BetaHealthSummary({required this.score, required this.label});
}

class BetaMetricsSummary {
  final int walletCreations;
  final int invitationAcceptances;
  final int smsImports;
  final int budgetCreations;
  final int goalCreations;
  final int splitCreations;
  final int settlementCreations;
  final int abandonedInviteFlows;
  final int abandonedSmsImports;
  final int failedSplitCreations;
  final int failedSettlementCreations;
  final Map<String, int> feedbackCategories;
  final int smsAccepted;
  final int smsRejected;
  final int smsDuplicates;

  const BetaMetricsSummary({
    required this.walletCreations,
    required this.invitationAcceptances,
    required this.smsImports,
    required this.budgetCreations,
    required this.goalCreations,
    required this.splitCreations,
    required this.settlementCreations,
    required this.abandonedInviteFlows,
    required this.abandonedSmsImports,
    required this.failedSplitCreations,
    required this.failedSettlementCreations,
    required this.feedbackCategories,
    required this.smsAccepted,
    required this.smsRejected,
    required this.smsDuplicates,
  });
}

final spendingInsightsProvider = FutureProvider.autoDispose<List<SpendingInsight>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final transactions = await (db.select(db.transactions)..where((t) => t.walletId.equals(walletId))).get();
  if (transactions.isEmpty) return const [];
  final previousMonth = DateTime.now().subtract(const Duration(days: 30));
  final currentMonthTotal = transactions.where((tx) => tx.date.isAfter(previousMonth)).fold<double>(0, (sum, tx) => sum + tx.amount);
  final total = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);
  return [
    SpendingInsight(title: 'Monthly comparison', detail: 'Current 30-day spend ${currentMonthTotal.toStringAsFixed(0)} vs total ${total.toStringAsFixed(0)}', icon: Icons.trending_up),
    SpendingInsight(title: 'Category growth', detail: 'Track changing spend patterns by category', icon: Icons.category_outlined),
    SpendingInsight(title: 'Merchant changes', detail: 'Spot new or growing merchants in wallet spend', icon: Icons.storefront_outlined),
    SpendingInsight(title: 'Unusual spending', detail: 'Review large transactions against wallet history', icon: Icons.warning_amber_outlined),
  ];
});

final feedbackReviewSummaryProvider = FutureProvider.autoDispose<FeedbackReviewSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final entries = await Future.value([]);
  final now = DateTime.now();
  final recentWindow = now.subtract(const Duration(days: 14));
  final categoryCounts = <String, int>{};
  final workflowCounts = <String, int>{};
  var recentBugReports = 0;
  var recentUxIssues = 0;
  var recentFeatureRequests = 0;
  var recentSmsIssues = 0;

  for (final entry in entries) {
    categoryCounts[entry.category.name] = (categoryCounts[entry.category.name] ?? 0) + 1;
    workflowCounts[entry.workflow] = (workflowCounts[entry.workflow] ?? 0) + 1;
    if (entry.createdAt.isAfter(recentWindow)) {
      switch (entry.category) {
        case FeedbackCategory.bug:
          recentBugReports++;
        case FeedbackCategory.improvement:
          recentUxIssues++;
        case FeedbackCategory.smsParsingIssue:
          recentFeatureRequests++;
          recentSmsIssues++;
      }
    }
  }

  return FeedbackReviewSummary(
    categoryCounts: categoryCounts,
    workflowCounts: workflowCounts,
    recentBugReports: recentBugReports,
    recentUxIssues: recentUxIssues,
    recentFeatureRequests: recentFeatureRequests,
    recentSmsIssues: recentSmsIssues,
  );
});

final workflowFrictionSummaryProvider = FutureProvider.autoDispose<WorkflowFrictionSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final smsMetric = await Future.value(null);
  final invitations = await (db.select(db.walletInvitations)..where((i) => i.walletId.equals(walletId))).get();

  return WorkflowFrictionSummary(
    abandonedInviteFlows: invitations.where((i) => i.status == WalletInvitationStatus.pending).length,
    abandonedSmsImports: (0),
    failedSplitCreations: 0,
    failedSettlementCreations: 0,
    totalFrictionSignals: invitations.where((i) => i.status == WalletInvitationStatus.pending).length +
        
        0,
  );
});

final onboardingProgressProvider = FutureProvider.autoDispose<OnboardingProgressSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final activities = await Future.value([]);
  return OnboardingProgressSummary(
    walletCreationStarted: activities.where((activity) => activity.action == 'wallet_creation_started').length,
    walletCreationCompleted: activities.where((activity) => activity.action == 'wallet_created').length,
    inviteFlowStarted: activities.where((activity) => activity.action == 'invite_flow_started').length,
    inviteFlowCompleted: activities.where((activity) => activity.action == 'invite_flow_completed').length,
    smsSetupStarted: activities.where((activity) => activity.action == 'sms_setup_started').length,
    smsSetupCompleted: activities.where((activity) => activity.action == 'sms_setup_completed').length,
  );
});

final betaHealthSummaryProvider = FutureProvider.autoDispose<BetaHealthSummary>((ref) async {
  final onboarding = await ref.watch(onboardingProgressProvider.future);
  final friction = await ref.watch(workflowFrictionSummaryProvider.future);
  final smsMetric = await Future.value(null);

  final onboardingDone = onboarding.walletCreationCompleted + onboarding.inviteFlowCompleted + onboarding.smsSetupCompleted;
  final onboardingTotal = (onboarding.walletCreationStarted + onboarding.inviteFlowStarted + onboarding.smsSetupStarted).clamp(1, 9999);
  final onboardingRate = onboardingDone / onboardingTotal;
  final smsRate = 0 /
      (0 + (0)).clamp(1, 9999);
  final frictionPenalty = (friction.totalFrictionSignals / 10).clamp(0, 1).toDouble();
  final score = ((onboardingRate * 45) + (smsRate * 35) + ((1 - frictionPenalty) * 20)).round().clamp(0, 100);
  final label = score >= 80
      ? 'Healthy'
      : score >= 60
          ? 'Watch'
          : 'Needs attention';
  return BetaHealthSummary(score: score, label: label);
});

final feedbackEntriesProvider = FutureProvider.autoDispose<List<FeedbackEntry>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  return [];
});

final smsImportMetricsProvider = FutureProvider.autoDispose<dynamic>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  return Future.value(null);
});

final betaMetricsSummaryProvider = FutureProvider.autoDispose<BetaMetricsSummary>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  final db = ref.watch(databaseProvider);
  final feedback = await Future.value([]);
  final smsMetric = await Future.value(null);
  final activities = await Future.value([]);
  final List<BudgetWithCategory> budgets = [];
  final goals = await db.goalDao.watchGoals(walletId).first;
  final splits = await (db.select(db.walletExpenseSplits)..where((s) => s.walletId.equals(walletId))).get();
  final settlements = await (db.select(db.walletSettlements)..where((s) => s.walletId.equals(walletId))).get();
  final invitations = await (db.select(db.walletInvitations)..where((i) => i.walletId.equals(walletId))).get();

  final feedbackCategories = <String, int>{};
  for (final entry in feedback) {
    feedbackCategories[entry.category.name] = (feedbackCategories[entry.category.name] ?? 0) + 1;
  }

  return BetaMetricsSummary(
    walletCreations: activities.where((a) => a.entityType == 'wallet').length,
    invitationAcceptances: activities.where((a) => a.action == 'invitation_accepted').length,
    smsImports: smsMetric?.acceptedImports ?? 0,
    budgetCreations: activities.where((a) => a.action == 'budget_created').length + budgets.length,
    goalCreations: activities.where((a) => a.action == 'goal_created').length + goals.length,
    splitCreations: activities.where((a) => a.action == 'expense_split_created').length + splits.length,
    settlementCreations: activities.where((a) => a.action == 'settlement_recorded').length + settlements.length,
    abandonedInviteFlows: invitations.where((i) => i.status == WalletInvitationStatus.pending).length,
    abandonedSmsImports: (0),
    failedSplitCreations: 0,
    failedSettlementCreations: 0,
    feedbackCategories: feedbackCategories,
    smsAccepted: smsMetric?.acceptedImports ?? 0,
    smsRejected: smsMetric?.rejectedImports ?? 0,
    smsDuplicates: smsMetric?.duplicateDetections ?? 0,
  );
});

