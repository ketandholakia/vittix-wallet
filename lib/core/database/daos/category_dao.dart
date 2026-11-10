part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // Get All: Returns a stream that automatically updates when the data changes.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  // Create
  Future<int> insertCategory(Insertable<Category> category) => into(categories).insert(category);

  // Update
  Future<bool> updateCategory(Insertable<Category> category) => update(categories).replace(category);

  // Delete
  Future<int> deleteCategory(int id) => (delete(categories)..where((c) => c.id.equals(id))).go();

  /// Deletes several categories in one statement.
  ///
  /// `PRAGMA foreign_keys` is not enabled, so the self-referencing
  /// `parentId` cascade never runs and a parent delete would leave its
  /// subcategories behind. Callers delete the whole subtree explicitly,
  /// deepest first.
  Future<int> deleteCategories(Iterable<int> ids) {
    final list = ids.toList(growable: false);
    if (list.isEmpty) return Future<int>.value(0);
    return (delete(categories)..where((c) => c.id.isIn(list))).go();
  }

  /// All categories, unordered. Used to resolve a category subtree.
  Future<List<Category>> getAllCategories() => select(categories).get();

  // Get by ID
  Future<Category?> getCategoryById(int id) => (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
}

