import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull;
import 'package:expense_tracker/features/goals/data/goal_repository_impl.dart';
import 'package:expense_tracker/features/bills/data/bill_repository_impl.dart';
import 'package:expense_tracker/features/family/data/allowance_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late GoalDao goalDao;
  late BillDao billDao;
  late AllowanceDao allowanceDao;

  late int walletIdA;
  late int walletIdB;

  late int accountOwnerA;
  late int accountAdminA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountInactiveA;

  late int accountOwnerB;

  late int memberIdA;

  late int goalA1;
  late int goalB1;
  late int contributionA1;
  late int contributionB1;
  late int scheduleA1;

  late int billA1;
  late int billB1;

  late int allowanceA1;
  late int allowanceB1;
  late int paymentA1;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;
    goalDao = database.goalDao;
    billDao = database.billDao;
    allowanceDao = database.allowanceDao;

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Create Accounts for Wallet A
    accountOwnerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Owner A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountAdminA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Admin A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountMemberA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Member A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountViewerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Viewer A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountInactiveA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Inactive A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    // Create Account for Wallet B
    accountOwnerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Owner B Account',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Seed Wallet A Memberships
    memberIdA = await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountOwnerA, role: WalletRole.owner),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountAdminA, role: WalletRole.admin),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountMemberA, role: WalletRole.member),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountViewerA, role: WalletRole.viewer),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountInactiveA,
        role: WalletRole.admin,
        isActive: const Value(false),
      ),
    );

    // Seed Wallet B Memberships
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountOwnerB, role: WalletRole.owner),
    );

    // --- Seed Goals ---
    goalA1 = await database.into(database.walletGoals).insert(
      WalletGoalsCompanion.insert(
        walletId: walletIdA,
        name: 'Goal A1 Vacation',
        targetAmount: 5000,
        currentAmount: const Value(1000),
      ),
    );
    goalB1 = await database.into(database.walletGoals).insert(
      WalletGoalsCompanion.insert(
        walletId: walletIdB,
        name: 'Goal B1 Car',
        targetAmount: 20000,
        currentAmount: const Value(5000),
      ),
    );

    contributionA1 = await database.into(database.walletGoalContributions).insert(
      WalletGoalContributionsCompanion.insert(
        walletId: walletIdA,
        goalId: goalA1,
        amount: 500,
      ),
    );
    contributionB1 = await database.into(database.walletGoalContributions).insert(
      WalletGoalContributionsCompanion.insert(
        walletId: walletIdB,
        goalId: goalB1,
        amount: 1000,
      ),
    );

    scheduleA1 = await database.into(database.walletGoalSchedules).insert(
      WalletGoalSchedulesCompanion.insert(
        walletGoalId: goalA1,
        memberId: memberIdA,
        amount: 250,
        frequency: WalletGoalScheduleFrequency.monthly,
        startDate: DateTime.now(),
        nextDueDate: DateTime.now().add(const Duration(days: 30)),
      ),
    );

    // --- Seed Bills ---
    billA1 = await database.into(database.walletBills).insert(
      WalletBillsCompanion.insert(
        walletId: walletIdA,
        name: 'Electricity Bill A1',
        amount: 150,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        recurrence: WalletBillRecurrence.monthly,
        category: 'Utilities',
      ),
    );
    billB1 = await database.into(database.walletBills).insert(
      WalletBillsCompanion.insert(
        walletId: walletIdB,
        name: 'Internet Bill B1',
        amount: 80,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        recurrence: WalletBillRecurrence.monthly,
        category: 'Utilities',
      ),
    );

    // --- Seed Allowances ---
    allowanceA1 = await database.into(database.walletAllowances).insert(
      WalletAllowancesCompanion.insert(
        walletId: walletIdA,
        memberId: memberIdA,
        amount: 200,
        frequency: WalletAllowanceFrequency.monthly,
        startDate: DateTime.now(),
      ),
    );
    allowanceB1 = await database.into(database.walletAllowances).insert(
      WalletAllowancesCompanion.insert(
        walletId: walletIdB,
        memberId: 1,
        amount: 300,
        frequency: WalletAllowanceFrequency.monthly,
        startDate: DateTime.now(),
      ),
    );

    paymentA1 = await database.into(database.walletAllowancePayments).insert(
      WalletAllowancePaymentsCompanion.insert(
        allowanceId: allowanceA1,
        memberId: memberIdA,
        amount: 200,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P1-2 Deferred Domains (Goals, Bills, Allowances) Wallet Isolation & RBAC Tests', () {
    // --- GOALS TESTS ---

    test('Test 1 — Goal Read Isolation by Wallet ID', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);
      final repoB = GoalRepositoryImpl(goalDao, walletIdB, walletDao);

      final goalsA = await repoA.getGoals();
      final goalsB = await repoB.getGoals();

      expect(goalsA.map((g) => g.id), contains(goalA1));
      expect(goalsA.map((g) => g.id), isNot(contains(goalB1)));

      expect(goalsB.map((g) => g.id), contains(goalB1));
      expect(goalsB.map((g) => g.id), isNot(contains(goalA1)));
    });

    test('Test 2 — Goal Lookup Cannot Cross Wallet Boundary', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      final foundA = await repoA.getGoalById(goalA1);
      expect(foundA, isNotNull);

      final foundB = await repoA.getGoalById(goalB1);
      expect(foundB, isNull);
    });

    test('Test 3 — Authorized Role (OWNER/ADMIN) Allowed to Create Goal', () async {
      final repo = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      final newGoalId = await repo.addGoal(
        WalletGoalsCompanion.insert(
          walletId: walletIdA,
          name: 'New Goal',
          targetAmount: 1000,
        ),
        actorAccountId: accountOwnerA,
      );

      expect(newGoalId, isPositive);
      final goals = await repo.getGoals();
      expect(goals.any((g) => g.id == newGoalId), isTrue);
    });

    test('Test 4 — Unauthorized Role (MEMBER/VIEWER) Denied Goal Creation', () async {
      final repo = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      expect(
        () => repo.addGoal(
          WalletGoalsCompanion.insert(
            walletId: walletIdA,
            name: 'Hacked Goal',
            targetAmount: 1000,
          ),
          actorAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      expect(
        () => repo.addGoal(
          WalletGoalsCompanion.insert(
            walletId: walletIdA,
            name: 'Hacked Goal 2',
            targetAmount: 1000,
          ),
          actorAccountId: accountViewerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 5 — Cross-Wallet Goal Update Rejected', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      // Attempt updating Wallet B goal using Wallet A repo
      final updated = await repoA.updateGoal(
        WalletGoalsCompanion(
          id: Value(goalB1),
          name: const Value('Attacked Goal Name'),
          targetAmount: const Value(99999),
        ),
        actorAccountId: accountOwnerA,
      );

      expect(updated, isFalse);

      final originalB = await goalDao.getGoalById(goalB1, walletIdB);
      expect(originalB!.name, equals('Goal B1 Car'));
    });

    test('Test 6 — Cross-Wallet Goal Deletion Rejected', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      await repoA.deleteGoal(goalB1, actorAccountId: accountOwnerA);

      final originalB = await goalDao.getGoalById(goalB1, walletIdB);
      expect(originalB, isNotNull);
    });

    test('Test 7 — Goal Contribution Scoped & Child Ownership Protected', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      final contribsA = await repoA.getContributions();
      expect(contribsA.map((c) => c.id), contains(contributionA1));
      expect(contribsA.map((c) => c.id), isNot(contains(contributionB1)));

      // Cross-wallet contribution attempt to goalB1 via repoA -> rejected
      expect(
        () => repoA.addContribution(
          WalletGoalContributionsCompanion.insert(
            walletId: walletIdA,
            goalId: goalB1,
            amount: 50,
          ),
          actorAccountId: accountOwnerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 8 — Goal Schedule Scoped & Child Ownership Protected', () async {
      final repoA = GoalRepositoryImpl(goalDao, walletIdA, walletDao);

      final schedulesA = await repoA.getSchedules();
      expect(schedulesA.map((s) => s.id), contains(scheduleA1));

      // Attempt adding schedule to goalB1 via repoA -> rejected
      expect(
        () => repoA.addSchedule(
          WalletGoalSchedulesCompanion.insert(
            walletGoalId: goalB1,
            memberId: memberIdA,
            amount: 100,
            frequency: WalletGoalScheduleFrequency.monthly,
            startDate: DateTime.now(),
            nextDueDate: DateTime.now(),
          ),
          actorAccountId: accountOwnerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    // --- BILLS TESTS ---

    test('Test 9 — Bill Read Isolation by Wallet ID', () async {
      final repoA = BillRepositoryImpl(billDao, walletIdA, walletDao);
      final repoB = BillRepositoryImpl(billDao, walletIdB, walletDao);

      final billsA = await repoA.getBills();
      final billsB = await repoB.getBills();

      expect(billsA.map((b) => b.id), contains(billA1));
      expect(billsA.map((b) => b.id), isNot(contains(billB1)));

      expect(billsB.map((b) => b.id), contains(billB1));
      expect(billsB.map((b) => b.id), isNot(contains(billA1)));
    });

    test('Test 10 — Bill Lookup Cannot Cross Wallet Boundary', () async {
      final repoA = BillRepositoryImpl(billDao, walletIdA, walletDao);

      final foundA = await repoA.getBillById(billA1);
      expect(foundA, isNotNull);

      final foundB = await repoA.getBillById(billB1);
      expect(foundB, isNull);
    });

    test('Test 11 — Authorized Role (OWNER/ADMIN) Allowed to Create/Update Bill', () async {
      final repo = BillRepositoryImpl(billDao, walletIdA, walletDao);

      final newBillId = await repo.addBill(
        WalletBillsCompanion.insert(
          walletId: walletIdA,
          name: 'Water Bill',
          amount: 60,
          dueDate: DateTime.now(),
          recurrence: WalletBillRecurrence.monthly,
          category: 'Utilities',
        ),
        actorAccountId: accountOwnerA,
      );

      expect(newBillId, isPositive);

      final updated = await repo.updateBill(
        WalletBillsCompanion(
          id: Value(newBillId),
          name: const Value('Water Bill Updated'),
        ),
        actorAccountId: accountAdminA,
      );

      expect(updated, isTrue);
    });

    test('Test 12 — Unauthorized Role (MEMBER/VIEWER) Denied Bill Mutation', () async {
      final repo = BillRepositoryImpl(billDao, walletIdA, walletDao);

      expect(
        () => repo.addBill(
          WalletBillsCompanion.insert(
            walletId: walletIdA,
            name: 'Hacked Bill',
            amount: 999,
            dueDate: DateTime.now(),
            recurrence: WalletBillRecurrence.monthly,
            category: 'Utilities',
          ),
          actorAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 13 — MEMBER Allowed to Mark Bill Paid', () async {
      final repo = BillRepositoryImpl(billDao, walletIdA, walletDao);

      final result = await repo.markBillPaid(billA1, actorAccountId: accountMemberA);
      expect(result, isTrue);

      final bill = await billDao.getBillById(billA1, walletIdA);
      expect(bill!.status, equals(WalletBillStatus.paid));
    });

    test('Test 14 — Cross-Wallet Bill Update & Deletion Rejected', () async {
      final repoA = BillRepositoryImpl(billDao, walletIdA, walletDao);

      final updated = await repoA.updateBill(
        WalletBillsCompanion(
          id: Value(billB1),
          name: const Value('Attacked Bill B1'),
        ),
        actorAccountId: accountOwnerA,
      );
      expect(updated, isFalse);

      await repoA.deleteBill(billB1, actorAccountId: accountOwnerA);

      final intact = await billDao.getBillById(billB1, walletIdB);
      expect(intact, isNotNull);
      expect(intact!.name, equals('Internet Bill B1'));
    });

    // --- ALLOWANCES TESTS ---

    test('Test 15 — Allowance Read Isolation by Wallet ID', () async {
      final repoA = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);
      final repoB = AllowanceRepositoryImpl(allowanceDao, walletIdB, walletDao);

      final allowancesA = await repoA.getAllowances();
      final allowancesB = await repoB.getAllowances();

      expect(allowancesA.map((a) => a.id), contains(allowanceA1));
      expect(allowancesA.map((a) => a.id), isNot(contains(allowanceB1)));

      expect(allowancesB.map((a) => a.id), contains(allowanceB1));
      expect(allowancesB.map((a) => a.id), isNot(contains(allowanceA1)));
    });

    test('Test 16 — Allowance Lookup Cannot Cross Wallet Boundary', () async {
      final repoA = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      final foundA = await repoA.getAllowanceById(allowanceA1);
      expect(foundA, isNotNull);

      final foundB = await repoA.getAllowanceById(allowanceB1);
      expect(foundB, isNull);
    });

    test('Test 17 — Authorized Role (OWNER/ADMIN) Allowed to Create Allowance', () async {
      final repo = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      final newAllowanceId = await repo.addAllowance(
        WalletAllowancesCompanion.insert(
          walletId: walletIdA,
          memberId: memberIdA,
          amount: 150,
          frequency: WalletAllowanceFrequency.weekly,
          startDate: DateTime.now(),
        ),
        actorAccountId: accountOwnerA,
      );

      expect(newAllowanceId, isPositive);
    });

    test('Test 18 — Unauthorized Role (MEMBER/VIEWER) Denied Allowance Management', () async {
      final repo = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      expect(
        () => repo.addAllowance(
          WalletAllowancesCompanion.insert(
            walletId: walletIdA,
            memberId: memberIdA,
            amount: 500,
            frequency: WalletAllowanceFrequency.monthly,
            startDate: DateTime.now(),
          ),
          actorAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 19 — Allowance Payment Scoped & Child Ownership Protected', () async {
      final repoA = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      final paymentsA = await repoA.getPayments();
      expect(paymentsA.map((p) => p.id), contains(paymentA1));

      // Attempt recording payment for allowanceB1 using repoA -> rejected
      expect(
        () => repoA.addPayment(
          WalletAllowancePaymentsCompanion.insert(
            allowanceId: allowanceB1,
            memberId: memberIdA,
            amount: 50,
          ),
          actorAccountId: accountOwnerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 20 — Cross-Wallet Allowance Update & Deletion Rejected', () async {
      final repoA = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      final updated = await repoA.updateAllowance(
        WalletAllowancesCompanion(
          id: Value(allowanceB1),
          amount: const Value(9999),
        ),
        actorAccountId: accountOwnerA,
      );
      expect(updated, isFalse);

      await repoA.deleteAllowance(allowanceB1, actorAccountId: accountOwnerA);

      final intact = await allowanceDao.getAllowanceById(allowanceB1, walletIdB);
      expect(intact, isNotNull);
      expect(intact!.amount, equals(300));
    });

    // --- MEMBERSHIP & ATOMICITY TESTS ---

    test('Test 21 — Missing & Inactive Membership Denied Across All Domains', () async {
      final repoGoal = GoalRepositoryImpl(goalDao, walletIdA, walletDao);
      final repoBill = BillRepositoryImpl(billDao, walletIdA, walletDao);
      final repoAllowance = AllowanceRepositoryImpl(allowanceDao, walletIdA, walletDao);

      // Inactive member
      expect(
        () => repoGoal.addGoal(
          WalletGoalsCompanion.insert(walletId: walletIdA, name: 'T', targetAmount: 100),
          actorAccountId: accountInactiveA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      expect(
        () => repoBill.addBill(
          WalletBillsCompanion.insert(
            walletId: walletIdA,
            name: 'T',
            amount: 100,
            dueDate: DateTime.now(),
            recurrence: WalletBillRecurrence.monthly,
            category: 'Utilities',
          ),
          actorAccountId: accountInactiveA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      expect(
        () => repoAllowance.addAllowance(
          WalletAllowancesCompanion.insert(
            walletId: walletIdA,
            memberId: memberIdA,
            amount: 100,
            frequency: WalletAllowanceFrequency.monthly,
            startDate: DateTime.now(),
          ),
          actorAccountId: accountInactiveA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 22 — Explicit Wallet Mismatch Attack Scenario Rejected', () async {
      // Direct DAO call with Wallet A ID supplied for Wallet B entities
      final goalUpdated = await goalDao.updateGoal(
        WalletGoalsCompanion(id: Value(goalB1), name: const Value('Attacked')),
        walletIdA,
      );
      expect(goalUpdated, isFalse);

      final billUpdated = await billDao.updateBill(
        WalletBillsCompanion(id: Value(billB1), name: const Value('Attacked')),
        walletIdA,
      );
      expect(billUpdated, isFalse);

      final allowanceUpdated = await allowanceDao.updateAllowance(
        WalletAllowancesCompanion(id: Value(allowanceB1), amount: const Value(9999)),
        walletIdA,
      );
      expect(allowanceUpdated, isFalse);
    });

    test('Test 23 — Wallet Deletion Cascades to Wallet Goals, Bills & Allowances Only', () async {
      // Delete Wallet B
      await walletDao.deleteWallet(walletIdB, actorAccountId: accountOwnerB);

      // Wallet B data removed
      expect(await goalDao.getGoalById(goalB1), isNull);
      expect(await billDao.getBillById(billB1), isNull);
      expect(await allowanceDao.getAllowanceById(allowanceB1), isNull);

      // Wallet A data intact
      expect(await goalDao.getGoalById(goalA1), isNotNull);
      expect(await billDao.getBillById(billA1), isNotNull);
      expect(await allowanceDao.getAllowanceById(allowanceA1), isNotNull);
    });
  });
}
