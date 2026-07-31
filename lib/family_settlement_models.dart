class MemberBalanceViewModel {
  final int memberId;
  final String memberName;
  final double totalPaid;
  final double totalOwed;
  final double totalSettled;

  const MemberBalanceViewModel({
    required this.memberId,
    required this.memberName,
    required this.totalPaid,
    required this.totalOwed,
    required this.totalSettled,
  });

  double get netBalance => totalPaid - totalOwed - totalSettled;
}

class SettlementHistoryViewModel {
  final String payer;
  final String receiver;
  final double amount;
  final DateTime settlementDate;
  final String notes;

  const SettlementHistoryViewModel({
    required this.payer,
    required this.receiver,
    required this.amount,
    required this.settlementDate,
    required this.notes,
  });
}

class SplitMemberViewModel {
  final int memberId;
  final String memberName;
  final double amountOwed;
  final double percentage;
  final double settledAmount;

  const SplitMemberViewModel({
    required this.memberId,
    required this.memberName,
    required this.amountOwed,
    required this.percentage,
    required this.settledAmount,
  });
}

class SplitExpenseViewModel {
  final int id;
  final int transactionId;
  final int paidByMemberId;
  final String splitMethod;
  final List<SplitMemberViewModel> members;

  const SplitExpenseViewModel({
    required this.id,
    required this.transactionId,
    required this.paidByMemberId,
    required this.splitMethod,
    required this.members,
  });
}
