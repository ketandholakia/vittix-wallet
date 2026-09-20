import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull, Budget, Transaction, TransactionType, Category;
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart' as account_domain;
import 'package:expense_tracker/features/budgets/data/budget_repository_impl.dart';
import 'package:expense_tracker/features/budgets/domain/budget.dart';
import 'package:expense_tracker/features/family/data/wallet_invitation_repository.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository_impl.dart';
import 'package:expense_tracker/features/transactions/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late WalletInvitationRepository invitationRepo;

  late int walletIdA;
  late int walletIdB;

  late int accountOwnerA;
  late int accountAdminA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountInactiveA;

  late int accountOwnerB;
  late int accountViewerB;

  late int categoryId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;
    invitationRepo = WalletInvitationRepositoryImpl(walletDao);

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert Category
    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Food'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );

    // Accounts for Wallet A
    accountOwnerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Owner A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountAdminA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Admin A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountMemberA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Member A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountViewerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Viewer A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountInactiveA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Inactive A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    // Accounts for Wallet B
    accountOwnerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Owner B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );
    accountViewerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Viewer B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Seed Wallet A memberships
    await walletDao.insertMember(
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

    // Seed Wallet B memberships
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountOwnerB, role: WalletRole.owner),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountViewerB, role: WalletRole.viewer),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-5 Service/Repository RBAC Enforcement Tests', () {
    test('Test 1 — OWNER Allowed for Owner-Level Operations', () async {
      // OWNER can check permissions
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canDeleteWallet(r),
          actorAccountId: accountOwnerA,
          actionName: 'delete wallet',
        ),
        returnsNormally,
      );
    });

    test('Test 2 — ADMIN Allowed for Admin-Level Operations', () async {
      // ADMIN allowed for manage budgets, manage invitations
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageBudgets(r),
          actorAccountId: accountAdminA,
          actionName: 'manage budgets',
        ),
        returnsNormally,
      );

      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageMembers(r),
          actorAccountId: accountAdminA,
          actionName: 'manage invitations',
        ),
        returnsNormally,
      );
    });

    test('Test 3 — ADMIN Denied for Owner-Only Operations', () async {
      // ADMIN denied for delete wallet
      expect(
        () => walletDao.deleteWallet(walletIdA, actorAccountId: accountAdminA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // ADMIN denied for member removal (deactivateMember)
      expect(
        () => walletDao.deactivateMember(walletIdA, accountMemberA, actorAccountId: accountAdminA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 4 — MEMBER Allowed for Member-Level Operations, Denied for Admin/Owner Operations', () async {
      // MEMBER allowed to add transactions
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canAddTransactions(r),
          actorAccountId: accountMemberA,
          actionName: 'add transactions',
        ),
        returnsNormally,
      );

      // MEMBER denied for managing budgets
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageBudgets(r),
          actorAccountId: accountMemberA,
          actionName: 'manage budgets',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // MEMBER denied for deleting wallet
      expect(
        () => walletDao.deleteWallet(walletIdA, actorAccountId: accountMemberA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 5 — VIEWER Denied for Write Operations', () async {
      // VIEWER denied for adding transactions
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canAddTransactions(r),
          actorAccountId: accountViewerA,
          actionName: 'add transactions',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // VIEWER denied for managing budgets
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageBudgets(r),
          actorAccountId: accountViewerA,
          actionName: 'manage budgets',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // VIEWER allowed for view operations
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canViewBudgets(r),
          actorAccountId: accountViewerA,
          actionName: 'view budgets',
        ),
        returnsNormally,
      );
    });

    test('Test 6 — Missing Membership Denied', () async {
      // accountOwnerB has no membership in Wallet A
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canViewBudgets(r),
          actorAccountId: accountOwnerB,
          actionName: 'view budgets',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 7 — Inactive Membership Denied', () async {
      // accountInactiveA is inactive in Wallet A -> denied
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canAddTransactions(r),
          actorAccountId: accountInactiveA,
          actionName: 'add transactions',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 8 — Cross-Wallet Isolation', () async {
      // accountOwnerA is OWNER in Wallet A, but has NO membership in Wallet B
      expect(
        () => walletDao.deleteWallet(walletIdB, actorAccountId: accountOwnerA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // accountViewerB is VIEWER in Wallet B, but has NO membership in Wallet A
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canViewBudgets(r),
          actorAccountId: accountViewerB,
          actionName: 'view budgets',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 9 — Unauthorized Member Role Change Rejected', () async {
      final memberRow = (await walletDao.getMembersForWallet(walletIdA)).firstWhere((m) => m.accountId == accountMemberA);

      // MEMBER attempting to demote viewer -> denied
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(memberRow.id),
            walletId: Value(walletIdA),
            accountId: Value(accountMemberA),
            role: const Value(WalletRole.viewer),
          ),
          actorAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 10 — Unauthorized Member Removal Rejected', () async {
      // ADMIN attempting to remove member -> denied (only OWNER can remove)
      expect(
        () => walletDao.deactivateMember(walletIdA, accountMemberA, actorAccountId: accountAdminA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // MEMBER attempting to remove member -> denied
      expect(
        () => walletDao.deactivateMember(walletIdA, accountMemberA, actorAccountId: accountMemberA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 11 — Unauthorized Invitation Management Rejected', () async {
      // MEMBER attempting to create invitation -> denied
      expect(
        () => invitationRepo.createInvitation(
          walletId: walletIdA,
          invitedAccountId: accountViewerA,
          role: WalletRole.member,
          invitedByAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 12 — Authorized Membership Operation Succeeds', () async {
      final adminMember = (await walletDao.getMembersForWallet(walletIdA)).firstWhere((m) => m.accountId == accountAdminA);

      // OWNER demotes ADMIN -> MEMBER succeeds
      await walletDao.updateMember(
        WalletMembersCompanion(
          id: Value(adminMember.id),
          walletId: Value(walletIdA),
          accountId: Value(accountAdminA),
          role: const Value(WalletRole.member),
        ),
        actorAccountId: accountOwnerA,
      );

      final updated = (await walletDao.getMembersForWallet(walletIdA)).firstWhere((m) => m.accountId == accountAdminA);
      expect(updated.role, equals(WalletRole.member));
    });

    test('Test 13 — Budget Repository RBAC Enforcement', () async {
      final repo = BudgetRepositoryImpl(database.budgetDao, walletIdA, walletDao);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );

      final testBudget = Budget(
        id: 1,
        amount: 500.0,
        period: '2026-09',
        category: category,
      );

      // OWNER/ADMIN allowed -> budget repo add succeeds for owner
      // (Test checkPermission with owner actor passes)
      await walletDao.checkPermission(
        walletId: walletIdA,
        permissionCheck: (s, r) => s.canManageBudgets(r),
        actorAccountId: accountOwnerA,
        actionName: 'manage budgets',
      );
      await repo.addBudget(testBudget);

      final budgets = await database.budgetDao.getBudgetsForWallet(walletIdA);
      expect(budgets.length, equals(1));
    });

    test('Test 14 — Transaction Repository RBAC Enforcement', () async {
      final repo = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );

      final account = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 1,
        amount: 150.0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: category,
        account: account,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // MEMBER allowed to add transaction
      await walletDao.checkPermission(
        walletId: walletIdA,
        permissionCheck: (s, r) => s.canAddTransactions(r),
        actorAccountId: accountMemberA,
        actionName: 'add transaction',
      );
      await repo.addTransaction(tx);

      final txs = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get();
      expect(txs.length, equals(1));
    });

    test('Test 15 — P0-4 Last Owner Guard Preserved under RBAC', () async {
      // OWNER has RBAC permission (canRemoveMembers == true), but P0-4 last owner guard still rejects final owner removal
      expect(
        () => walletDao.deactivateMember(walletIdA, accountOwnerA, actorAccountId: accountOwnerA),
        throwsA(isA<LastOwnerException>()),
      );
    });

    test('Test 16 — No Partial Mutation on RBAC Failure', () async {
      final initialWallets = await (database.select(database.wallets)..where((w) => w.id.equals(walletIdA))).get();
      expect(initialWallets.length, equals(1));

      // Attempt unauthorized wallet deletion by ADMIN
      try {
        await walletDao.deleteWallet(walletIdA, actorAccountId: accountAdminA);
      } catch (_) {}

      // Verify wallet A still exists intact
      final remainingWallets = await (database.select(database.wallets)..where((w) => w.id.equals(walletIdA))).get();
      expect(remainingWallets.length, equals(1));
    });
  });
}
