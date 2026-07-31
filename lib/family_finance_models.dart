class GoalViewModel {
  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final String createdBy;
  final String updatedBy;
  final bool archived;

  const GoalViewModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdBy,
    required this.updatedBy,
    this.archived = false,
  });

  double get progress => targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0.0, 1.0);
}

class GoalContributionViewModel {
  final String contributor;
  final double amount;
  final DateTime date;

  const GoalContributionViewModel({required this.contributor, required this.amount, required this.date});
}

class BudgetViewModel {
  final int id;
  final String category;
  final double budgetAmount;
  final double spent;
  final String createdBy;
  final String updatedBy;

  const BudgetViewModel({
    required this.id,
    required this.category,
    required this.budgetAmount,
    required this.spent,
    required this.createdBy,
    required this.updatedBy,
  });

  double get remaining => budgetAmount - spent;
  double get usage => budgetAmount <= 0 ? 0 : (spent / budgetAmount).clamp(0.0, 1.0);
}

class BudgetActivityViewModel {
  final String action;
  final String actor;
  final DateTime timestamp;
  final String details;

  const BudgetActivityViewModel({
    required this.action,
    required this.actor,
    required this.timestamp,
    required this.details,
  });
}

class WalletNotificationViewModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? dismissedAt;
  final String actionLabel;

  const WalletNotificationViewModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.readAt,
    required this.dismissedAt,
    required this.actionLabel,
  });

  bool get isUnread => readAt == null && dismissedAt == null;
}

class NotificationPreferenceViewModel {
  final bool billReminders;
  final bool goalReminders;
  final bool allowanceReminders;
  final bool settlementReminders;

  const NotificationPreferenceViewModel({
    required this.billReminders,
    required this.goalReminders,
    required this.allowanceReminders,
    required this.settlementReminders,
  });
}
