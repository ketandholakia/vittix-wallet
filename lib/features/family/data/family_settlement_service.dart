// BROKEN DEPENDENCY: Experimental

import 'package:expense_tracker/core/database/app_database.dart';

class WalletMemberBalance {
  final int memberId;
  final double totalPaid;
  final double totalOwed;
  final double totalSettled;

  const WalletMemberBalance({
    required this.memberId,
    required this.totalPaid,
    required this.totalOwed,
    required this.totalSettled,
  });

  double get netBalance => totalPaid - totalOwed - totalSettled;
}

class FamilySettlementService {
  const FamilySettlementService();

  List<WalletMemberBalance> calculateBalances({
    required List<WalletMember> members,
    required List<WalletExpenseSplit> splits,
    required List<WalletExpenseSplitMember> splitMembers,
    required List<WalletSettlement> settlements,
  }) {
    final memberIds = members.map((m) => m.id).toSet();
    final balances = {
      for (final id in memberIds) id: const WalletMemberBalance(memberId: 0, totalPaid: 0, totalOwed: 0, totalSettled: 0),
    };

    for (final member in members) {
      balances[member.id] = WalletMemberBalance(memberId: member.id, totalPaid: 0, totalOwed: 0, totalSettled: 0);
    }

    for (final split in splits) {
      final current = balances[split.paidByMemberId];
      if (current != null) {
        balances[split.paidByMemberId] = WalletMemberBalance(
          memberId: current.memberId,
          totalPaid: current.totalPaid + splitMembers.where((m) => m.splitId == split.id).fold<double>(0, (s, m) => s + m.amountOwed),
          totalOwed: current.totalOwed,
          totalSettled: current.totalSettled,
        );
      }
      for (final member in splitMembers.where((m) => m.splitId == split.id)) {
        final currentMember = balances[member.memberId];
        if (currentMember != null) {
          balances[member.memberId] = WalletMemberBalance(
            memberId: currentMember.memberId,
            totalPaid: currentMember.totalPaid,
            totalOwed: currentMember.totalOwed + member.amountOwed,
            totalSettled: currentMember.totalSettled + member.settledAmount,
          );
        }
      }
    }

    for (final settlement in settlements) {
      final payer = balances[settlement.payerMemberId];
      final receiver = balances[settlement.receiverMemberId];
      if (payer != null) {
        balances[settlement.payerMemberId] = WalletMemberBalance(
          memberId: payer.memberId,
          totalPaid: payer.totalPaid,
          totalOwed: payer.totalOwed,
          totalSettled: payer.totalSettled + settlement.amount,
        );
      }
      if (receiver != null) {
        balances[settlement.receiverMemberId] = WalletMemberBalance(
          memberId: receiver.memberId,
          totalPaid: receiver.totalPaid,
          totalOwed: receiver.totalOwed,
          totalSettled: receiver.totalSettled - settlement.amount,
        );
      }
    }

    return balances.values.toList();
  }
}

