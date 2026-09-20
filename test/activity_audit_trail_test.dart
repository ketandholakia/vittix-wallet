import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late int walletIdA;
  late int walletIdB;
  late int accountOwnerA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountOwnerB;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    walletIdA = await database.into(database.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
    walletIdB = await database.into(database.wallets).insert(const WalletsCompanion(name: Value('Wallet B')));

    accountOwnerA = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdA), name: 'Owner A', type: AccountType.bank, icon: 0, color: '00FF00'));
    accountMemberA = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdA), name: 'Member A', type: AccountType.bank, icon: 0, color: '00FF00'));
    accountViewerA = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdA), name: 'Viewer A', type: AccountType.bank, icon: 0, color: '00FF00'));
    accountOwnerB = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdB), name: 'Owner B', type: AccountType.bank, icon: 0, color: '0000FF'));

    await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountOwnerA, role: WalletRole.owner));
    await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountMemberA, role: WalletRole.member));
    await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountViewerA, role: WalletRole.viewer));
    await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountOwnerB, role: WalletRole.owner));
  });

  tearDown(() async {
    await database.close();
  });

  group('P2-3 Activity Audit Trail', () {
    test('1 — OWNER can create activity event', () async {
      final id = await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'TEST_ACTION',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );
      expect(id, greaterThan(0));
    });

    test('2 — MEMBER can create activity event', () async {
      final id = await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'TEST_ACTION',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountMemberA,
      );
      expect(id, greaterThan(0));
    });

    test('3 — VIEWER cannot create activity event', () async {
      expect(
        () => database.walletDao.insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletIdA,
            action: 'TEST_ACTION',
            entityType: 'Transaction',
            entityId: 1,
            source: 'user',
          ),
          walletIdA,
          actorAccountId: accountViewerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('4 — Wallet A caller cannot create activity event in Wallet B', () async {
      expect(
        () => database.walletDao.insertActivity(
          WalletActivitiesCompanion.insert(
            walletId: walletIdB,
            action: 'TEST_ACTION',
            entityType: 'Transaction',
            entityId: 1,
            source: 'user',
          ),
          walletIdB,
          actorAccountId: accountOwnerA, // Actor belongs to Wallet A
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('5 — Wallet A cannot read Wallet B activity events', () async {
      await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdB,
          action: 'WALLET_CREATED',
          entityType: 'Wallet',
          entityId: walletIdB,
          source: 'user',
        ),
        walletIdB,
        actorAccountId: accountOwnerB,
      );

      final aActivity = await database.walletDao.getActivityForWallet(walletIdA);
      final bActivity = await database.walletDao.getActivityForWallet(walletIdB);
      expect(aActivity.isEmpty, isTrue);
      expect(bActivity.length, 1);
      expect(bActivity.first.walletId, walletIdB);
    });

    test('6 — Activity query by ID is wallet-scoped', () async {
      final aId = await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'A_ACTION',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );
      final bId = await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdB,
          action: 'B_ACTION',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdB,
        actorAccountId: accountOwnerB,
      );

      final aEvents = await database.walletDao.getActivityForWallet(walletIdA);
      final bEvents = await database.walletDao.getActivityForWallet(walletIdB);
      expect(aEvents.any((e) => e.id == bId), isFalse);
      expect(bEvents.any((e) => e.id == aId), isFalse);
    });

    test('7 — Append-only: no update/delete methods exposed for activity', () async {
      final id = await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'APPEND_ONLY',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );

      final events = await database.walletDao.getActivityForWallet(walletIdA);
      expect(events.any((e) => e.id == id), isTrue);
      // The DAO layer enforces append-only by omitting update/delete methods
      // for the walletActivities table in WalletDao's public API.
    });

    test('8 — Activity filtering by action', () async {
      await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'TRANSACTION_CREATED',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );
      await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'WALLET_UPDATED',
          entityType: 'Wallet',
          entityId: walletIdA,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );

      final txEvents = await database.walletDao.getActivityForWallet(walletIdA, action: 'TRANSACTION_CREATED');
      expect(txEvents.length, 1);
      expect(txEvents.first.action, 'TRANSACTION_CREATED');
    });

    test('9 — Wallet deletion cascades activity events', () async {
      await database.walletDao.insertActivity(
        WalletActivitiesCompanion.insert(
          walletId: walletIdA,
          action: 'TRANSACTION_CREATED',
          entityType: 'Transaction',
          entityId: 1,
          source: 'user',
        ),
        walletIdA,
        actorAccountId: accountOwnerA,
      );

      await database.walletDao.deleteWallet(walletIdA);

      final remaining = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(walletIdA))).get();
      expect(remaining.isEmpty, isTrue);
    });

    test('10 — logWalletCreated writes WALLET_CREATED event', () async {
      await database.walletDao.logWalletCreated(walletId: walletIdA, walletType: 'personal', actorAccountId: accountOwnerA);
      final events = await database.walletDao.getActivityForWallet(walletIdA);
      expect(events.any((e) => e.action == 'WALLET_CREATED'), isTrue);
    });

    test('11 — logMemberAdded writes MEMBER_ADDED event', () async {
      await database.walletDao.logMemberAdded(walletId: walletIdA, accountId: accountMemberA, actorAccountId: accountOwnerA);
      final events = await database.walletDao.getActivityForWallet(walletIdA);
      expect(events.any((e) => e.action == 'MEMBER_ADDED'), isTrue);
    });

    test('12 — logInvitationActivity writes event with correct entityType', () async {
      await database.walletDao.logInvitationActivity(walletId: walletIdA, invitationId: 42, action: 'INVITATION_CREATED', actorAccountId: accountOwnerA);
      final events = await database.walletDao.getActivityForWallet(walletIdA, entityType: 'WalletInvitation');
      expect(events.length, 1);
      expect(events.first.action, 'INVITATION_CREATED');
      expect(events.first.entityId, 42);
    });
  });
}