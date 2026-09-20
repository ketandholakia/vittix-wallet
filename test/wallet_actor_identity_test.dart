import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:flutter_test/flutter_test.dart';

/// A7 step 3, slice 1 — RBAC understands a real user identity, while the
/// legacy money-account actor path keeps working.
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
    userId = await db.userDao.insertUser(
      const UsersCompanion(displayName: Value('Asha')),
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addMember({
    required WalletRole role,
    int? user,
    bool isActive = true,
  }) {
    return db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: accountId,
        role: role,
        userId: Value(user),
        isActive: Value(isActive),
      ),
    );
  }

  test('a member is recognised by their user identity', () async {
    await addMember(role: WalletRole.owner, user: userId);

    expect(
      await db.walletDao.getRoleInWallet(walletId, actorUserId: userId),
      WalletRole.owner,
    );
  });

  test('the legacy account-based lookup still works', () async {
    await addMember(role: WalletRole.admin, user: userId);

    expect(
      await db.walletDao.getRoleInWallet(walletId, actorAccountId: accountId),
      WalletRole.admin,
    );
  });

  test('an unmapped user has no role in the wallet', () async {
    await addMember(role: WalletRole.owner, user: userId);

    final stranger = await db.userDao.insertUser(
      const UsersCompanion(displayName: Value('Stranger')),
    );

    expect(
      await db.walletDao.getRoleInWallet(walletId, actorUserId: stranger),
      isNull,
    );
  });

  test('an inactive membership is rejected for a user actor', () async {
    await addMember(role: WalletRole.owner, user: userId, isActive: false);

    expect(
      await db.walletDao.getRoleInWallet(walletId, actorUserId: userId),
      isNull,
    );
    expect(await db.walletDao.isWalletValid(walletId, actorUserId: userId), isFalse);
  });

  test('checkPermission denies a viewer by user identity', () async {
    await addMember(role: WalletRole.viewer, user: userId);

    await expectLater(
      db.walletDao.checkPermission(
        walletId: walletId,
        actorUserId: userId,
        permissionCheck: (service, role) => service.canAddTransactions(role),
        actionName: 'add transactions',
      ),
      throwsA(isA<WalletPermissionDeniedException>()),
    );
  });

  test('checkPermission allows an owner by user identity', () async {
    await addMember(role: WalletRole.owner, user: userId);

    await db.walletDao.checkPermission(
      walletId: walletId,
      actorUserId: userId,
      permissionCheck: (service, role) => service.canAddTransactions(role),
      actionName: 'add transactions',
    );
  });
}
