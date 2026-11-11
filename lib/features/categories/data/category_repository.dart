import 'package:vittix_wallet/domain/entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAllCategories();
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(int id);
  Future<Category?> getCategoryById(int id);

  /// Number of transactions filed under [categoryId] or any of its
  /// subcategories.
  Future<int> countTransactionsForCategory(int categoryId);

  /// Moves every transaction filed under [fromCategoryId] (and its
  /// subcategories) onto [toCategoryId], then deletes [fromCategoryId] and its
  /// subcategories, atomically.
  ///
  /// Returns the number of transactions moved. Throws [ArgumentError] when
  /// [toCategoryId] is inside the subtree being deleted.
  Future<int> reassignAndDeleteCategory(int fromCategoryId, int toCategoryId);
}
