class AllowanceViewModel {
  final int id;
  final int memberId;
  final String memberName;
  final double amount;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String createdBy;
  final String updatedBy;

  const AllowanceViewModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
  });
}

class AllowancePaymentViewModel {
  final int allowanceId;
  final int memberId;
  final String memberName;
  final double amount;
  final DateTime paidDate;
  final String notes;

  const AllowancePaymentViewModel({
    required this.allowanceId,
    required this.memberId,
    required this.memberName,
    required this.amount,
    required this.paidDate,
    required this.notes,
  });
}

class AllowanceSummaryViewModel {
  final int activeAllowances;
  final double monthlyTotal;
  final String? nextDue;
  final List<AllowanceViewModel> recentPayments;

  const AllowanceSummaryViewModel({
    required this.activeAllowances,
    required this.monthlyTotal,
    required this.nextDue,
    required this.recentPayments,
  });
}

class AllowanceSpendingSummaryViewModel {
  final int memberId;
  final String memberName;
  final double allowanceReceived;
  final double expensesRecorded;
  final double remainingAllowance;
  final double savingsAmount;

  const AllowanceSpendingSummaryViewModel({
    required this.memberId,
    required this.memberName,
    required this.allowanceReceived,
    required this.expensesRecorded,
    required this.remainingAllowance,
    required this.savingsAmount,
  });
}
