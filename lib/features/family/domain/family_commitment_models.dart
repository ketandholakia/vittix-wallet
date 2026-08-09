class GoalScheduleViewModel {
  final int id;
  final int walletGoalId;
  final int memberId;
  final double amount;
  final String frequency;
  final DateTime startDate;
  final DateTime nextDueDate;
  final bool isActive;

  const GoalScheduleViewModel({
    required this.id,
    required this.walletGoalId,
    required this.memberId,
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.nextDueDate,
    required this.isActive,
  });
}

class BillViewModel {
  final int id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final String recurrence;
  final String category;
  final String notes;
  final String status;
  final bool isActive;

  const BillViewModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.recurrence,
    required this.category,
    required this.notes,
    required this.status,
    required this.isActive,
  });
}

class FamilyCommitmentSummaryViewModel {
  final int activeGoals;
  final int recurringContributions;
  final List<BillViewModel> upcomingBills;
  final int overdueBills;

  const FamilyCommitmentSummaryViewModel({
    required this.activeGoals,
    required this.recurringContributions,
    required this.upcomingBills,
    required this.overdueBills,
  });
}
