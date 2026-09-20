import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late int walletIdA;
  late int walletIdB;
  late int accountIdA;
  late int accountIdB;
  late int categoryId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    // Insert Wallet A (id = 1) and Wallet B (id = 2)
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert Accounts for testing
    accountIdA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Account A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    accountIdB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Account B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Insert Category for testing
    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Shopping'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-3 Wallet Deletion Cleanup Completeness Tests', () {
    test('Test 1 — Empty Wallet Deletion', () async {
      await database.walletDao.deleteWallet(walletIdA);

      final wallet = await (database.select(database.wallets)..where((w) => w.id.equals(walletIdA))).getSingleOrNull();
      expect(wallet, equals(null));
    });

    test('Test 2 — Transaction Cleanup', () async {
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 100.0,
          date: DateTime.now(),
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );

      expect((await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get()).length, 1);

      await database.walletDao.deleteWallet(walletIdA);

      final txs = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get();
      expect(txs.isEmpty, isTrue);
    });

    test('Test 3 — Budget Cleanup', () async {
      await database.into(database.budgets).insert(
        BudgetsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 500.0,
          period: '2026-09',
          categoryId: categoryId,
        ),
      );

      expect((await database.budgetDao.getBudgetsForWallet(walletIdA)).length, 1);

      await database.walletDao.deleteWallet(walletIdA);

      expect((await database.budgetDao.getBudgetsForWallet(walletIdA)).isEmpty, isTrue);
    });

    test('Test 4 — Goals and Children Cleanup', () async {
      final goalId = await database.into(database.walletGoals).insert(
        WalletGoalsCompanion.insert(
          walletId: walletIdA,
          name: 'New Laptop',
          targetAmount: 80000.0,
        ),
      );

      final memberId = await database.into(database.walletMembers).insert(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA,
          role: WalletRole.owner,
        ),
      );

      await database.into(database.walletGoalContributions).insert(
        WalletGoalContributionsCompanion.insert(
          walletId: walletIdA,
          goalId: goalId,
          amount: 5000.0,
        ),
      );

      await database.into(database.walletGoalSchedules).insert(
        WalletGoalSchedulesCompanion.insert(
          walletGoalId: goalId,
          memberId: memberId,
          amount: 1000.0,
          frequency: WalletGoalScheduleFrequency.monthly,
          startDate: DateTime.now(),
          nextDueDate: DateTime.now(),
        ),
      );

      await database.walletDao.deleteWallet(walletIdA);

      final goals = await (database.select(database.walletGoals)..where((g) => g.walletId.equals(walletIdA))).get();
      final contributions = await (database.select(database.walletGoalContributions)..where((c) => c.walletId.equals(walletIdA))).get();
      final schedules = await (database.select(database.walletGoalSchedules)..where((s) => s.walletGoalId.equals(goalId))).get();

      expect(goals.isEmpty, isTrue);
      expect(contributions.isEmpty, isTrue);
      expect(schedules.isEmpty, isTrue);
    });

    test('Test 5 — Allowances and Payments Cleanup', () async {
      final memberId = await database.into(database.walletMembers).insert(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA,
          role: WalletRole.member,
        ),
      );

      final allowanceId = await database.into(database.walletAllowances).insert(
        WalletAllowancesCompanion.insert(
          walletId: walletIdA,
          memberId: memberId,
          amount: 2000.0,
          frequency: WalletAllowanceFrequency.monthly,
          startDate: DateTime.now(),
        ),
      );

      await database.into(database.walletAllowancePayments).insert(
        WalletAllowancePaymentsCompanion.insert(
          allowanceId: allowanceId,
          memberId: memberId,
          amount: 2000.0,
        ),
      );

      await database.walletDao.deleteWallet(walletIdA);

      final allowances = await (database.select(database.walletAllowances)..where((a) => a.walletId.equals(walletIdA))).get();
      final payments = await (database.select(database.walletAllowancePayments)..where((p) => p.allowanceId.equals(allowanceId))).get();

      expect(allowances.isEmpty, isTrue);
      expect(payments.isEmpty, isTrue);
    });

    test('Test 6 — Splits and Members Cleanup', () async {
      final memberId = await database.into(database.walletMembers).insert(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA,
          role: WalletRole.owner,
        ),
      );

      final txId = await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 600.0,
          date: DateTime.now(),
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );

      final splitId = await database.into(database.walletExpenseSplits).insert(
        WalletExpenseSplitsCompanion.insert(
          walletId: walletIdA,
          transactionId: txId,
          paidByMemberId: memberId,
          splitMethod: WalletExpenseSplitMethod.equal,
        ),
      );

      await database.into(database.walletExpenseSplitMembers).insert(
        WalletExpenseSplitMembersCompanion.insert(
          splitId: splitId,
          memberId: memberId,
          amountOwed: 300.0,
        ),
      );

      await database.walletDao.deleteWallet(walletIdA);

      final splits = await (database.select(database.walletExpenseSplits)..where((s) => s.walletId.equals(walletIdA))).get();
      final splitMembers = await (database.select(database.walletExpenseSplitMembers)..where((m) => m.splitId.equals(splitId))).get();

      expect(splits.isEmpty, isTrue);
      expect(splitMembers.isEmpty, isTrue);
    });

    test('Test 7 — Bills, Recurring, Notifications Cleanup', () async {
      await database.into(database.walletBills).insert(
        WalletBillsCompanion.insert(
          walletId: walletIdA,
          name: 'Electricity Bill',
          amount: 1500.0,
          dueDate: DateTime.now(),
          recurrence: WalletBillRecurrence.monthly,
          category: 'Utilities',
        ),
      );

      await database.into(database.recurringTransactions).insert(
        RecurringTransactionsCompanion.insert(
          name: 'Netflix',
          amount: 499.0,
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
          interval: 'monthly',
          startDate: DateTime.now(),
          nextDueDate: DateTime.now(),
        ),
      );

      await database.into(database.walletNotifications).insert(
        WalletNotificationsCompanion.insert(
          walletId: walletIdA,
          type: WalletNotificationType.billDue,
          title: 'Bill Due',
          message: 'Electricity bill is due tomorrow',
        ),
      );

      await database.into(database.walletNotificationPreferences).insert(
        WalletNotificationPreferencesCompanion.insert(
          walletId: walletIdA,
        ),
      );

      await database.walletDao.deleteWallet(walletIdA);

      final bills = await (database.select(database.walletBills)..where((b) => b.walletId.equals(walletIdA))).get();
      final recurrings = await (database.select(database.recurringTransactions)..where((r) => r.accountId.equals(accountIdA))).get();
      final notifications = await (database.select(database.walletNotifications)..where((n) => n.walletId.equals(walletIdA))).get();
      final preferences = await (database.select(database.walletNotificationPreferences)..where((p) => p.walletId.equals(walletIdA))).get();

      expect(bills.isEmpty, isTrue);
      expect(recurrings.isEmpty, isTrue);
      expect(notifications.isEmpty, isTrue);
      expect(preferences.isEmpty, isTrue);
    });

    test('Test 8 — Membership and Invitations Cleanup', () async {
      await database.into(database.walletMembers).insert(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA,
          role: WalletRole.owner,
        ),
      );

      await database.into(database.walletInvitations).insert(
        WalletInvitationsCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA,
          status: WalletInvitationStatus.pending,
          role: WalletRole.member,
        ),
      );

      await database.walletDao.deleteWallet(walletIdA);

      final members = await (database.select(database.walletMembers)..where((m) => m.walletId.equals(walletIdA))).get();
      final invitations = await (database.select(database.walletInvitations)..where((i) => i.walletId.equals(walletIdA))).get();

      expect(members.isEmpty, isTrue);
      expect(invitations.isEmpty, isTrue);
    });

    test('Test 9 — Multiple Wallet Isolation during Deletion', () async {
      // Add data to Wallet A
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 100.0,
          date: DateTime.now(),
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );
      await database.into(database.budgets).insert(
        BudgetsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 500.0,
          period: '2026-09',
          categoryId: categoryId,
        ),
      );

      // Add data to Wallet B
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdB),
          amount: 250.0,
          date: DateTime.now(),
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdB,
        ),
      );
      await database.into(database.budgets).insert(
        BudgetsCompanion.insert(
          walletId: Value(walletIdB),
          amount: 1200.0,
          period: '2026-09',
          categoryId: categoryId,
        ),
      );

      // Delete Wallet A
      await database.walletDao.deleteWallet(walletIdA);

      // Verify Wallet A and its records are deleted
      expect(await (database.select(database.wallets)..where((w) => w.id.equals(walletIdA))).getSingleOrNull(), equals(null));
      expect((await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get()).isEmpty, isTrue);
      expect((await database.budgetDao.getBudgetsForWallet(walletIdA)).isEmpty, isTrue);

      // Verify Wallet B and its records remain completely untouched
      expect(await (database.select(database.wallets)..where((w) => w.id.equals(walletIdB))).getSingleOrNull(), isNotNull);
      expect((await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdB))).get()).length, 1);
      expect((await database.budgetDao.getBudgetsForWallet(walletIdB)).length, 1);
    });

    test('Test 10 — Broad Wallet-Owned Data Cleanup (Comprehensive Inventory Audit)', () async {
      // Seed wallet-owned entities across all 21 wallet-owned table structures
      final memberId = await database.into(database.walletMembers).insert(
        WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountIdA, role: WalletRole.owner),
      );
      await database.into(database.walletInvitations).insert(
        WalletInvitationsCompanion.insert(walletId: walletIdA, accountId: accountIdA, status: WalletInvitationStatus.pending, role: WalletRole.member),
      );
      final txId = await database.into(database.transactions).insert(
        TransactionsCompanion.insert(walletId: Value(walletIdA), amount: 300.0, date: DateTime.now(), type: TransactionType.expense, categoryId: categoryId, accountId: accountIdA),
      );
      await database.into(database.attachments).insert(
        AttachmentsCompanion.insert(transactionId: txId, filePath: '/tmp/receipt.jpg'),
      );
      await database.into(database.budgets).insert(
        BudgetsCompanion.insert(walletId: Value(walletIdA), amount: 1000.0, period: '2026-09', categoryId: categoryId),
      );
      final goalId = await database.into(database.walletGoals).insert(
        WalletGoalsCompanion.insert(walletId: walletIdA, name: 'Vacation', targetAmount: 50000.0),
      );
      await database.into(database.walletGoalContributions).insert(
        WalletGoalContributionsCompanion.insert(walletId: walletIdA, goalId: goalId, amount: 2500.0),
      );
      await database.into(database.walletGoalSchedules).insert(
        WalletGoalSchedulesCompanion.insert(walletGoalId: goalId, memberId: memberId, amount: 1000.0, frequency: WalletGoalScheduleFrequency.monthly, startDate: DateTime.now(), nextDueDate: DateTime.now()),
      );
      final allowanceId = await database.into(database.walletAllowances).insert(
        WalletAllowancesCompanion.insert(walletId: walletIdA, memberId: memberId, amount: 1500.0, frequency: WalletAllowanceFrequency.monthly, startDate: DateTime.now()),
      );
      await database.into(database.walletAllowancePayments).insert(
        WalletAllowancePaymentsCompanion.insert(allowanceId: allowanceId, memberId: memberId, amount: 1500.0),
      );
      await database.into(database.walletSettlements).insert(
        WalletSettlementsCompanion.insert(walletId: walletIdA, payerMemberId: memberId, receiverMemberId: memberId, amount: 500.0),
      );
      await database.into(database.walletBills).insert(
        WalletBillsCompanion.insert(walletId: walletIdA, name: 'Internet', amount: 999.0, dueDate: DateTime.now(), recurrence: WalletBillRecurrence.monthly, category: 'Utilities'),
      );
      final splitId = await database.into(database.walletExpenseSplits).insert(
        WalletExpenseSplitsCompanion.insert(walletId: walletIdA, transactionId: txId, paidByMemberId: memberId, splitMethod: WalletExpenseSplitMethod.equal),
      );
      await database.into(database.walletExpenseSplitMembers).insert(
        WalletExpenseSplitMembersCompanion.insert(splitId: splitId, memberId: memberId, amountOwed: 150.0),
      );
      await database.into(database.recurringTransactions).insert(
        RecurringTransactionsCompanion.insert(name: 'SIP', amount: 5000.0, type: TransactionType.expense, categoryId: categoryId, accountId: accountIdA, interval: 'monthly', startDate: DateTime.now(), nextDueDate: DateTime.now()),
      );
      await database.into(database.walletNotifications).insert(
        WalletNotificationsCompanion.insert(walletId: walletIdA, type: WalletNotificationType.activityMention, title: 'Alert', message: 'Hello'),
      );
      await database.into(database.walletNotificationPreferences).insert(
        WalletNotificationPreferencesCompanion.insert(walletId: walletIdA),
      );
      await database.into(database.feedbackEntries).insert(
        FeedbackEntriesCompanion.insert(walletId: walletIdA, category: FeedbackCategory.bug, severity: FeedbackSeverity.low, workflow: 'Onboarding', description: 'Small UI issue', resolutionStatus: FeedbackResolutionStatus.open),
      );
      await database.into(database.loans).insert(
        LoansCompanion.insert(walletId: Value(walletIdA), name: 'Home Loan', accountId: accountIdA, principalAmount: 500000.0, interestRate: 8.5, tenureMonths: 240, startDate: DateTime.now(), emiAmount: 4300.0),
      );
      await database.into(database.peerDebts).insert(
        PeerDebtsCompanion.insert(walletId: walletIdA, personName: 'Alice', type: PeerDebtType.lent, amount: 200.0, date: DateTime.now()),
      );
      await database.into(database.merchantMappings).insert(
        MerchantMappingsCompanion.insert(walletId: walletIdA, originalPattern: 'AMZN*', cleanName: 'Amazon'),
      );
      await database.into(database.unrecognizedSmsEntries).insert(
        UnrecognizedSmsEntriesCompanion.insert(walletId: walletIdA, smsBody: 'Sample text', sender: 'VM-HDFCBK', receivedAt: DateTime.now()),
      );
      await database.into(database.smsImportMetrics).insert(
        SmsImportMetricsCompanion.insert(walletId: walletIdA, acceptedImports: const Value(5), rejectedImports: const Value(1)),
      );
      await database.into(database.payees).insert(
        PayeesCompanion.insert(walletId: Value(walletIdA), name: 'Walmart'),
      );
      await database.into(database.tags).insert(
        TagsCompanion.insert(walletId: Value(walletIdA), name: 'VacationTag'),
      );

      // Perform wallet deletion
      await database.walletDao.deleteWallet(walletIdA);

      // Directly query database to confirm 0 records remaining for all wallet-owned tables
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallets WHERE id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM transactions WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM accounts WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM budgets WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_goals WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_goal_contributions WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_goal_schedules WHERE wallet_goal_id = ?', variables: [Variable<int>(goalId)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_allowances WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_allowance_payments WHERE allowance_id = ?', variables: [Variable<int>(allowanceId)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_settlements WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_bills WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_expense_splits WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_expense_split_members WHERE split_id = ?', variables: [Variable<int>(splitId)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_members WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_invitations WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_notifications WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM wallet_notification_preferences WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM feedback_entries WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM loans WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM peer_debts WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM merchant_mappings WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM unrecognized_sms_entries WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM sms_import_metrics WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM payees WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM tags WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c'), 0);
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM attachments WHERE transaction_id = ?', variables: [Variable<int>(txId)]).getSingle()).read<int>('c'), 0);

      // Verify global categories remain intact
      expect((await database.customSelect('SELECT COUNT(*) AS c FROM categories WHERE id = ?', variables: [Variable<int>(categoryId)]).getSingle()).read<int>('c'), 1);
    });

    test('Test 11 — Transactional Deletion (Atomic Transaction)', () async {
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          walletId: Value(walletIdA),
          amount: 500.0,
          date: DateTime.now(),
          type: TransactionType.expense,
          categoryId: categoryId,
          accountId: accountIdA,
        ),
      );

      // Perform atomic delete
      await database.walletDao.deleteWallet(walletIdA);

      // Verify atomic completion
      final count = (await database.customSelect('SELECT COUNT(*) AS c FROM transactions WHERE wallet_id = ?', variables: [Variable<int>(walletIdA)]).getSingle()).read<int>('c');
      expect(count, 0);
    });
  });
}
