import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/users/presentation/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A7 — resolving the user identity behind an account, which is how the UI
/// turns its active account into an actor user id.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int walletId;
  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

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
  });

  tearDown(() async {
    await db.close();
  });

  Future<int?> resolve() => container.read(
        userIdForAccountProvider((walletId: walletId, accountId: accountId)).future,
      );

  test('resolves the user identity of a mapped membership', () async {
    final userId = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Asha')));
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: accountId,
        role: WalletRole.owner,
        userId: Value(userId),
      ),
    );

    expect(await resolve(), userId);
  });

  test('returns null for a legacy membership with no user identity', () async {
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: accountId,
        role: WalletRole.owner,
      ),
    );

    expect(
      await resolve(),
      isNull,
      reason: 'callers must fall back to the account-based actor',
    );
  });

  test('returns null when the account is not a member', () async {
    expect(await resolve(), isNull);
  });

  test('returns null for an inactive membership', () async {
    final userId = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Asha')));
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletId,
        accountId: accountId,
        role: WalletRole.owner,
        userId: Value(userId),
        isActive: const Value(false),
      ),
    );

    expect(await resolve(), isNull);
  });

  test('resolves per wallet, not globally', () async {
    final otherWallet = await db
        .into(db.wallets)
        .insert(const WalletsCompanion(name: Value('Wallet B')));
    final otherUser = await db.userDao
        .insertUser(const UsersCompanion(displayName: Value('Ravi')));

    // Reuse the same account id in a different wallet.
    await db.walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: otherWallet,
        accountId: accountId,
        role: WalletRole.owner,
        userId: Value(otherUser),
      ),
    );

    // Wallet A has no such member yet.
    expect(await resolve(), isNull);

    final inOther = await container.read(
      userIdForAccountProvider(
        (walletId: otherWallet, accountId: accountId),
      ).future,
    );
    expect(inOther, otherUser);
  });
}
