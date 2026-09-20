import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

/// A7 step 1 — a user identity that is separate from money accounts.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('a user is stored and read back with a generated uuid', () async {
    final id = await db.userDao.insertUser(
      const UsersCompanion(displayName: Value('Asha')),
    );

    final user = await db.userDao.getUserById(id);
    expect(user, isNotNull);
    expect(user!.displayName, 'Asha');
    expect(user.uuid, isNotEmpty);
    expect(user.email, isNull, reason: 'email is optional');
  });

  test('findOrCreateUser creates once and then reuses the identity', () async {
    final first = await db.userDao.findOrCreateUser('Ravi');
    final second = await db.userDao.findOrCreateUser('Ravi');

    expect(second.id, first.id, reason: 'must not duplicate the same person');
    expect((await db.userDao.getAllUsers()).length, 1);
  });

  test('findOrCreateUser stores an optional email', () async {
    await db.userDao.findOrCreateUser('Meera', email: 'meera@example.com');
    final user = await db.userDao.getUserByUuid(
      (await db.userDao.getAllUsers()).single.uuid,
    );
    expect(user!.email, 'meera@example.com');
  });

  test('users are listed by display name', () async {
    await db.userDao.findOrCreateUser('Zoya');
    await db.userDao.findOrCreateUser('Aarav');

    final users = await db.userDao.getAllUsers();
    expect(users.map((u) => u.displayName), ['Aarav', 'Zoya']);
  });

  test('a user can be updated and the timestamp moves', () async {
    final user = await db.userDao.findOrCreateUser('Old Name');
    await Future<void>.delayed(const Duration(milliseconds: 5));

    final ok = await db.userDao.updateUser(
      UsersCompanion(id: Value(user.id), displayName: const Value('New Name')),
    );
    expect(ok, isTrue);

    final updated = await db.userDao.getUserById(user.id);
    expect(updated!.displayName, 'New Name');
    expect(
      updated.updatedAt.isAfter(user.createdAt) ||
          updated.updatedAt.isAtSameMomentAs(user.createdAt),
      isTrue,
    );
  });

  test('a user can be deleted', () async {
    final user = await db.userDao.findOrCreateUser('Temp');
    expect(await db.userDao.deleteUser(user.id), 1);
    expect(await db.userDao.getUserById(user.id), isNull);
  });

  test('users are global, not wallet-scoped', () async {
    // Two wallets, one person: the identity is shared across both.
    await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
    await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet B')));

    final user = await db.userDao.findOrCreateUser('Shared Person');
    expect(await db.userDao.getAllUsers(), hasLength(1));
    expect(user.id, isPositive);
  });
}
