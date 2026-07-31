import 'package:drift/drift.dart';

enum AccountType { bank, cash, creditCard, income, loan }
enum FeedbackCategory { bug, improvement, smsParsingIssue }
enum FeedbackResolutionStatus { open, closed }
enum FeedbackSeverity { low, medium, high }
enum PeerDebtType { borrowed, lent }
enum TransactionType { expense, income }
enum WalletAllowanceFrequency { custom, monthly, weekly }
enum WalletBillRecurrence { monthly, once, quarterly, weekly, yearly }
enum WalletBillStatus { overdue, paid, unpaid }
enum WalletExpenseSplitMethod { equal, exact, percentage, shares }
enum WalletGoalScheduleFrequency { monthly, quarterly, weekly }
enum WalletInvitationStatus { accepted, expired, pending, revoked }
enum WalletNotificationType { activityMention, allowanceDue, billDue, billOverdue, goalDue, goalForecastRisk, invitationPending, settlementPending }
enum WalletRole { admin, member, owner, viewer }

// We also need WalletGoalContributionType which wasn't used in tables but might be in GoalDao!
enum WalletGoalContributionType { contribution }

