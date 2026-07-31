// BROKEN DEPENDENCY: Experimental
/*
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/family_automation_service.dart';

class NotificationCenterService {
  const NotificationCenterService();

  Future<List<WalletNotification>> generateNotifications({
    required int walletId,
    required WalletNotificationPreference? preference,
    required List<WalletBill> bills,
    required List<WalletAllowance> allowances,
    required List<WalletGoal> goals,
    required List<WalletGoalSchedule> schedules,
    required List<WalletSettlement> settlements,
    required List<WalletInvitation> invitations,
  }) async {
    final now = DateTime.now();
    final notifications = <WalletNotification>[];
    final allowBills = preference?.billReminders ?? true;
    final allowGoals = preference?.goalReminders ?? true;
    final allowAllowances = preference?.allowanceReminders ?? true;
    final allowSettlements = preference?.settlementReminders ?? true;

    if (allowBills) {
      for (final bill in bills.where((bill) => bill.walletId == walletId && bill.isActive)) {
      final forecast = bill.dueDate.difference(now).inDays;
      if (bill.status == WalletBillStatus.overdue || forecast < 0) {
        notifications.add(_build(walletId, WalletNotificationType.billOverdue, 'Bill overdue', bill.name, bill.id));
      } else if (forecast <= 7) {
        notifications.add(_build(walletId, WalletNotificationType.billDue, 'Bill due soon', bill.name, bill.id));
      }
    }
    }

    if (allowAllowances) {
      for (final allowance in allowances.where((allowance) => allowance.walletId == walletId && allowance.isActive)) {
        if (allowance.startDate.difference(now).inDays <= 7) {
          notifications.add(_build(walletId, WalletNotificationType.allowanceDue, 'Allowance due', 'Allowance for member ${allowance.memberId}', allowance.id));
        }
      }
    }

    if (allowGoals) {
      for (final goal in goals.where((goal) => goal.walletId == walletId)) {
        final goalSchedules = schedules.where((schedule) => schedule.walletGoalId == goal.id && schedule.isActive).toList();
        final forecast = const FamilyAutomationService().forecastGoal(goal, goalSchedules, const []);
        if (forecast.projectedCompletionDate != null && forecast.projectedCompletionDate!.isBefore(now.add(const Duration(days: 120)))) {
          notifications.add(_build(walletId, WalletNotificationType.goalForecastRisk, 'Goal forecast risk', goal.name, goal.id));
        }
      }
    }

    if (allowSettlements) {
      for (final settlement in settlements.where((settlement) => settlement.walletId == walletId)) {
        final age = now.difference(settlement.settlementDate).inDays;
        if (age <= 3) {
          notifications.add(_build(walletId, WalletNotificationType.settlementPending, 'Settlement pending', 'Settlement of ${settlement.amount.toStringAsFixed(0)}', settlement.id));
        }
      }
    }

    for (final invitation in invitations.where((invitation) => invitation.walletId == walletId)) {
      if (invitation.status == WalletInvitationStatus.pending) {
        notifications.add(_build(walletId, WalletNotificationType.invitationPending, 'Invitation pending', 'Invite for role ${invitation.role.name}', invitation.id));
      }
    }

    return notifications;
  }

  WalletNotification _build(int walletId, WalletNotificationType type, String title, String message, int relatedId) {
    return WalletNotification(
      id: 0,
      walletId: walletId,
      memberId: null,
      type: type,
      title: title,
      message: message,
      relatedEntityId: relatedId,
      createdAt: DateTime.now(),
      readAt: null,
      dismissedAt: null,
    );
  }
}

*/