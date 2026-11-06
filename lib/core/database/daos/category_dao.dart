part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  // Get All: Returns a stream that automatically updates when the data changes.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  // Create
  Future<int> insertCategory(Insertable<Category> category) => into(categories).insert(category);

  // Update
  Future<bool> updateCategory(Insertable<Category> category) => update(categories).replace(category);

  // Delete
  Future<int> deleteCategory(int id) => (delete(categories)..where((c) => c.id.equals(id))).go();

  // Get by ID
  Future<Category?> getCategoryById(int id) => (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
}

