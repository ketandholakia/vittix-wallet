part of '../app_database.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  /// Users are global: one person can belong to several wallets.
  Stream<List<User>> watchAllUsers() =>
      (select(users)..orderBy([(u) => OrderingTerm.asc(u.displayName)])).watch();

  Future<List<User>> getAllUsers() =>
      (select(users)..orderBy([(u) => OrderingTerm.asc(u.displayName)])).get();

  Future<User?> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  Future<User?> getUserByUuid(String uuid) =>
      (select(users)..where((u) => u.uuid.equals(uuid))).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  /// Finds an existing user with [displayName] or creates one, so callers do
  /// not have to care whether the identity already exists.
  Future<User> findOrCreateUser(String displayName, {String? email}) async {
    final trimmed = displayName.trim();
    final existing = await (select(users)
          ..where((u) => u.displayName.equals(trimmed))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing;

    final id = await insertUser(UsersCompanion.insert(
      displayName: trimmed,
      email: Value(email),
    ));
    return (await getUserById(id))!;
  }

  Future<bool> updateUser(UsersCompanion user) async {
    if (!user.id.present) return false;
    final updated = await (update(users)
          ..where((u) => u.id.equals(user.id.value)))
        .write(user.copyWith(updatedAt: Value(DateTime.now())));
    return updated > 0;
  }

  Future<int> deleteUser(int id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();
}

