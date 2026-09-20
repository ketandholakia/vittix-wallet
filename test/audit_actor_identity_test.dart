import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:flutter_test/flutter_test.dart';

/// A7 step 3, slice 2 — an audit event can be attributed to a real user
/// identity, while the legacy account-based attribution keeps working.
///
/// Note: `insertMember` writes its own MEMBER_ADDED audit row, so these tests
/// filter on the action they care about rather than counting all activity.
void main() {
  late AppDatabase db;
  late int walletId;
  late int accountId;
  late int userId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    walletId = await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Wallet A')));
    accountId = await db.into(db.accounts).insert(AccountsCompanion.insert(
          walletId: Value(walletId),
          name: 'Cash',
          type: db_enums.AccountType.cash,
          icon: 0,
          color: '00FF00',
        ));
    userId = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Asha')));

    // Asha is an owner, so she is allowed to create audit events.
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: accountId,
        role: WalletRole.owner,
        userId: Value(userId),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  WalletActivitiesCompanion activity() => WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: 'TRANSFER_CREATED',
        entityType: 'transaction',
        entityId: 1,
        source: 'user',
      );

  Future<WalletActivity> onlyTransferEvent() async {
    final events = await db.walletDao
        .getActivityForWallet(walletId, action: 'TRANSFER_CREATED');
    expect(events, hasLength(1));
    return events.single;
  }

  test('an audit event records the acting user identity', () async {
    await db.walletDao.insertActivity(activity(), walletId, actorUserId: userId);

    final event = await onlyTransferEvent();
    expect(event.actorUserId, userId);
    expect(
      event.actorAccountId,
      isNull,
      reason: 'the legacy column is untouched when a user actor is given',
    );
  });

  test('the legacy account-based attribution still works', () async {
    await db.walletDao.insertActivity(
      activity(),
      walletId,
      actorAccountId: accountId,
    );

    final event = await onlyTransferEvent();
    expect(event.actorAccountId, accountId);
    expect(event.actorUserId, isNull);
  });

  test('a user who is not a member cannot create audit events', () async {
    final stranger = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Stranger')));

    await expectLater(
      db.walletDao.insertActivity(activity(), walletId, actorUserId: stranger),
      throwsA(isA<WalletPermissionDeniedException>()),
    );
  });

  test('adding a member records the acting user identity', () async {
    // A brand new member, added by Asha (an owner) acting as a user.
    final newAccount = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Second Account',
            type: db_enums.AccountType.cash,
            icon: 0,
            color: '00FFFF',
          ),
        );
    final newUser = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Ravi')));

    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: newAccount,
        role: WalletRole.member,
        userId: Value(newUser),
      ),
      actorUserId: userId,
    );

    final events = await db.walletDao
        .getActivityForWallet(walletId, action: 'MEMBER_ADDED');

    // The member being added is Ravi; the actor who added them is Asha.
    expect(events, isNotEmpty);
    expect(
      events.map((e) => e.actorUserId),
      contains(userId),
      reason: 'the audit event must be attributed to the acting user',
    );
    expect(events.map((e) => e.actorUserId), isNot(contains(newUser)));
  });

  test('a role change is attributed to the acting user', () async {
    // A second member to change the role of, so the owner is untouched.
    final memberAccount = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Member Account',
            type: db_enums.AccountType.cash,
            icon: 0,
            color: '00FFFF',
          ),
        );
    final memberUser = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Ravi')));
    final memberId = await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: memberAccount,
        role: WalletRole.member,
        userId: Value(memberUser),
      ),
    );

    // Asha (owner) promotes Ravi, acting as a user.
    await db.walletDao.updateMember(
      WalletMembersCompanion(
        id: Value(memberId),
        walletId: Value(walletId),
        accountId: Value(memberAccount),
        role: const Value(WalletRole.admin),
      ),
      actorUserId: userId,
    );

    final events = await db.walletDao
        .getActivityForWallet(walletId, action: 'MEMBER_ROLE_CHANGED');

    expect(events, hasLength(1));
    expect(
      events.single.actorUserId,
      userId,
      reason: 'the role change must name the acting admin, not the member changed',
    );
    expect(events.single.actorUserId, isNot(memberUser));
  });

  test('a member removal is attributed to the acting user', () async {
    final secondAccount = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Second Account',
            type: db_enums.AccountType.cash,
            icon: 0,
            color: '00FFFF',
          ),
        );
    final secondUser = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Ravi')));
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: secondAccount,
        role: WalletRole.member,
        userId: Value(secondUser),
      ),
    );

    await db.walletDao.deactivateMember(
      walletId,
      secondAccount,
      actorUserId: userId,
    );

    final events = await db.walletDao
        .getActivityForWallet(walletId, action: 'MEMBER_DEACTIVATED');

    expect(events, hasLength(1));
    expect(events.single.actorUserId, userId);
  });

  test('a viewer cannot create audit events', () async {
    // A second member, so the wallet keeps an owner.
    final viewerAccount = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            walletId: Value(walletId),
            name: 'Viewer Account',
            type: db_enums.AccountType.cash,
            icon: 0,
            color: '0000FF',
          ),
        );
    final viewerUser = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Viewer')));
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: viewerAccount,
        role: WalletRole.viewer,
        userId: Value(viewerUser),
      ),
    );

    await expectLater(
      db.walletDao.insertActivity(activity(), walletId, actorUserId: viewerUser),
      throwsA(isA<WalletPermissionDeniedException>()),
    );
  });
}
