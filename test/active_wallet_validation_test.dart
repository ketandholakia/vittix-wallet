import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull, Budget, Transaction, TransactionType, Category;
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;

  late int walletIdA;
  late int walletIdB;
  late int walletIdC;

  late int accountUserA;
  late int accountUserB;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;

    // Create Wallet A, B, C
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );
    walletIdC = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet C')),
    );

    // Create Account User A and Account User B
    accountUserA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'User A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountUserB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'User B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Seed Wallet A memberships (User A = Owner)
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountUserA,
        role: WalletRole.owner,
      ),
    );

    // Seed Wallet B memberships (User B = Owner, User A = Member)
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdB,
        accountId: accountUserB,
        role: WalletRole.owner,
      ),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdB,
        accountId: accountUserA,
        role: WalletRole.member,
      ),
    );

    // Wallet C has User B as active, but User A is INACTIVE member
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdC,
        accountId: accountUserB,
        role: WalletRole.owner,
      ),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdC,
        accountId: accountUserA,
        role: WalletRole.member,
        isActive: const Value(false),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-6 Active-Wallet Validation & Startup Integrity Tests', () {
    test('Test 1 — Valid Active Wallet + Active Membership Accepted', () async {
      final isValid = await walletDao.isWalletValid(walletIdA, actorAccountId: accountUserA);
      expect(isValid, isTrue);
    });

    test('Test 2 — Non-Existent Wallet Rejected', () async {
      final isValid = await walletDao.isWalletValid(9999, actorAccountId: accountUserA);
      expect(isValid, isFalse);
    });

    test('Test 3 — Membership Missing Rejected', () async {
      // User B has no membership in Wallet A
      final isValid = await walletDao.isWalletValid(walletIdA, actorAccountId: accountUserB);
      expect(isValid, isFalse);
    });

    test('Test 4 — Inactive Membership Rejected', () async {
      // User A is inactive in Wallet C
      final isValid = await walletDao.isWalletValid(walletIdC, actorAccountId: accountUserA);
      expect(isValid, isFalse);
    });

    test('Test 5 — Valid Persisted Wallet Restored', () async {
      final restored = await walletDao.validateActiveWallet(walletIdA, actorAccountId: accountUserA);
      expect(restored, equals(walletIdA));
    });

    test('Test 6 — Deleted Persisted Wallet Rejected and Fallback Selected', () async {
      // Wallet 999 does not exist, should fall back to first accessible wallet for User A (Wallet A)
      final restored = await walletDao.validateActiveWallet(9999, actorAccountId: accountUserA);
      expect(restored, equals(walletIdA));
    });

    test('Test 7 — Inaccessible Persisted Wallet Rejected for Actor', () async {
      // Wallet C is inaccessible for User A (inactive). Should resolve to accessible wallet (Wallet A)
      final restored = await walletDao.validateActiveWallet(walletIdC, actorAccountId: accountUserA);
      expect(restored, equals(walletIdA));
    });

    test('Test 8 — No Accessible Wallets Yields Null / Safe State', () async {
      final newAccountId = await database.into(database.accounts).insert(
        AccountsCompanion.insert(
          walletId: Value(walletIdA),
          name: 'New Lonely User',
          type: AccountType.bank,
          icon: 0,
          color: 'FFFFFF',
        ),
      );

      final restored = await walletDao.validateActiveWallet(walletIdA, actorAccountId: newAccountId);
      expect(restored, isNull);
    });

    test('Test 9 — User A Wallet Cannot Become User B Active Wallet', () async {
      // User B attempting to validate/select Wallet A (User B is not member in A)
      final restored = await walletDao.validateActiveWallet(walletIdA, actorAccountId: accountUserB);
      expect(restored, isNot(equals(walletIdA)));
      expect(restored, equals(walletIdB));
    });

    test('Test 10 — Valid Wallet Switch Succeeds', () async {
      final notifier = CurrentWalletIdNotifier(null, walletDao);
      notifier.forceSetStateForTest(walletIdA);

      final success = await notifier.selectWallet(walletIdB, actorAccountId: accountUserA);
      expect(success, isTrue);
      expect(notifier.state, equals(walletIdB));
    });

    test('Test 11 — Invalid Wallet Switch Rejected and Keeps Previous Valid Wallet', () async {
      final notifier = CurrentWalletIdNotifier(null, walletDao);
      notifier.forceSetStateForTest(walletIdA);

      expect(
        () => notifier.selectWallet(9999, actorAccountId: accountUserA),
        throwsA(isA<InvalidActiveWalletException>()),
      );
      expect(notifier.state, equals(walletIdA));
    });

    test('Test 12 — Deleting Active Wallet Triggers Revalidation to Next Valid Wallet', () async {
      final notifier = CurrentWalletIdNotifier(null, walletDao);
      notifier.forceSetStateForTest(walletIdA);

      // User A deletes Wallet A
      await walletDao.deleteWallet(walletIdA, actorAccountId: accountUserA);
      await notifier.revalidate(actorAccountId: accountUserA);

      // User A is also a member of Wallet B -> notifier switches to Wallet B
      expect(notifier.state, equals(walletIdB));
    });

    test('Test 13 — Deleting Only Accessible Wallet Results in Null / Safe State', () async {
      final notifier = CurrentWalletIdNotifier(null, walletDao);
      notifier.forceSetStateForTest(walletIdB);

      // User B deletes Wallet B and Wallet C (all accessible wallets for User B)
      await walletDao.deleteWallet(walletIdB, actorAccountId: accountUserB);
      await walletDao.deleteWallet(walletIdC, actorAccountId: accountUserB);
      await notifier.revalidate(actorAccountId: accountUserB);

      expect(notifier.state, equals(0));
    });

    test('Test 14 — Deactivating Active Membership Invalidates Active Wallet', () async {
      final notifier = CurrentWalletIdNotifier(null, walletDao);
      notifier.forceSetStateForTest(walletIdB);

      // User B deactivates User A in Wallet B
      await walletDao.deactivateMember(walletIdB, accountUserA, actorAccountId: accountUserB);

      // Revalidate for User A -> Wallet B is no longer valid for User A -> switches back to Wallet A
      await notifier.revalidate(actorAccountId: accountUserA);
      expect(notifier.state, equals(walletIdA));
    });

    test('Test 15 — Accessible Wallets List Only Contains User-Accessible Active Wallets', () async {
      final accessibleForUserA = await walletDao.getAccessibleWallets(actorAccountId: accountUserA);
      final accessibleIdsA = accessibleForUserA.map((w) => w.id).toList();

      expect(accessibleIdsA, containsAll([walletIdA, walletIdB]));
      expect(accessibleIdsA, isNot(contains(walletIdC)));

      final accessibleForUserB = await walletDao.getAccessibleWallets(actorAccountId: accountUserB);
      final accessibleIdsB = accessibleForUserB.map((w) => w.id).toList();

      expect(accessibleIdsB, containsAll([walletIdB, walletIdC]));
      expect(accessibleIdsB, isNot(contains(walletIdA)));
    });
  });
}
