import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull, Budget, Transaction, TransactionType, Category, Account;
import 'package:expense_tracker/features/accounts/data/account_repository_impl.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart' as account_domain;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late AccountDao accountDao;

  late int walletIdA;
  late int walletIdB;

  late int accountOwnerA;
  late int accountAdminA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountInactiveA;

  late int accountOwnerB;

  late int testAccA1;
  late int testAccA2;
  late int testAccB1;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;
    accountDao = database.accountDao;

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Accounts for Wallet A
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

    // Accounts for Wallet B
    accountOwnerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Owner B Account',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Additional accounts for isolation tests
    testAccA1 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Savings A1',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    testAccA2 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Credit A2',
        type: AccountType.creditCard,
        icon: 0,
        color: '00FF00',
      ),
    );
    testAccB1 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Savings B1',
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
  });

  tearDown(() async {
    await database.close();
  });

  group('P1-1 Account Wallet Isolation & RBAC Tests', () {
    test('Test 1 — Account Read Isolation by Wallet ID', () async {
      final repoA = AccountRepositoryImpl(accountDao, walletIdA, walletDao);
      final repoB = AccountRepositoryImpl(accountDao, walletIdB, walletDao);

      final accountsA = await repoA.watchAllAccounts().first;
      final accountsB = await repoB.watchAllAccounts().first;

      final idsA = accountsA.map((a) => a.id).toList();
      final idsB = accountsB.map((a) => a.id).toList();

      expect(idsA, containsAll([accountOwnerA, accountAdminA, accountMemberA, accountViewerA, accountInactiveA, testAccA1, testAccA2]));
      expect(idsA, isNot(contains(testAccB1)));

      expect(idsB, containsAll([accountOwnerB, testAccB1]));
      expect(idsB, isNot(contains(testAccA1)));
    });

    test('Test 2 — Account Lookup Cannot Cross Wallet Boundary', () async {
      final repoA = AccountRepositoryImpl(accountDao, walletIdA, walletDao);

      final foundA = await repoA.getAccountById(testAccA1);
      expect(foundA, isNotNull);
      expect(foundA!.id, equals(testAccA1));

      // Attempt looking up Wallet B account via Wallet A repository
      final foundB = await repoA.getAccountById(testAccB1);
      expect(foundB, isNull);
    });

    test('Test 3 — Cross-Wallet Account Update Rejected', () async {
      final repoA = AccountRepositoryImpl(accountDao, walletIdA, walletDao);

      final crossWalletAccount = account_domain.Account(
        id: testAccB1, // Account belonging to Wallet B
        name: 'Hacked Name',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      // Attempt updating Wallet B account using Wallet A repo
      await repoA.updateAccount(crossWalletAccount);

      // Verify Wallet B account remains unchanged in database
      final originalB = await accountDao.getAccountById(testAccB1, walletIdB);
      expect(originalB!.name, equals('Savings B1'));
    });

    test('Test 4 — Cross-Wallet Account Deletion Rejected', () async {
      final repoA = AccountRepositoryImpl(accountDao, walletIdA, walletDao);

      // Attempt deleting Wallet B account using Wallet A repo
      await repoA.deleteAccount(testAccB1);

      // Verify Wallet B account still exists in database
      final stillExists = await accountDao.getAccountById(testAccB1, walletIdB);
      expect(stillExists, isNotNull);
    });

    test('Test 5 — Authorized Role (OWNER/ADMIN) Allowed to Create Account', () async {
      // Test checkPermission for OWNER
      await walletDao.checkPermission(
        walletId: walletIdA,
        permissionCheck: (s, r) => s.canManageAccounts(r),
        actorAccountId: accountOwnerA,
        actionName: 'manage accounts',
      );

      final repoOwner = AccountRepositoryImpl(accountDao, walletIdA, walletDao);
      final newAcc = account_domain.Account(
        id: 0,
        name: 'New Owner Bank',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      await repoOwner.addAccount(newAcc);
      final accounts = await repoOwner.watchAllAccounts().first;
      expect(accounts.any((a) => a.name == 'New Owner Bank'), isTrue);
    });

    test('Test 6 — Unauthorized Role (MEMBER/VIEWER) Denied Account Mutation', () async {
      // Test checkPermission for MEMBER -> denied
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageAccounts(r),
          actorAccountId: accountMemberA,
          actionName: 'manage accounts',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // Test checkPermission for VIEWER -> denied
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageAccounts(r),
          actorAccountId: accountViewerA,
          actionName: 'manage accounts',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 7 — Missing & Inactive Membership Denied Account Permission', () async {
      // Non-member (accountOwnerB in Wallet A) -> denied
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageAccounts(r),
          actorAccountId: accountOwnerB,
          actionName: 'manage accounts',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // Inactive member (accountInactiveA in Wallet A) -> denied
      expect(
        () => walletDao.checkPermission(
          walletId: walletIdA,
          permissionCheck: (s, r) => s.canManageAccounts(r),
          actorAccountId: accountInactiveA,
          actionName: 'manage accounts',
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 8 — Cross-Wallet Mismatch Attack Scenario Rejected', () async {
      // User A attempts to update testAccB1 in Wallet B using Wallet A context
      final result = await accountDao.updateAccount(
        AccountsCompanion(
          id: Value(testAccB1),
          name: const Value('Attacked Name'),
        ),
        walletIdA, // Supplying Wallet A ID for Wallet B account
      );

      expect(result, isFalse);

      final intact = await accountDao.getAccountById(testAccB1, walletIdB);
      expect(intact!.name, equals('Savings B1'));
    });

    test('Test 9 — Wallet Deletion Cascades to Wallet Accounts Only', () async {
      // Delete Wallet B
      await walletDao.deleteWallet(walletIdB, actorAccountId: accountOwnerB);

      // Wallet B accounts removed
      final deletedAcc = await accountDao.getAccountById(testAccB1);
      expect(deletedAcc, isNull);

      // Wallet A accounts intact
      final intactAcc = await accountDao.getAccountById(testAccA1);
      expect(intactAcc, isNotNull);
    });
  });
}
