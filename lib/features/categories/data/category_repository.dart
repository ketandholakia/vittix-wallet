import 'package:expense_tracker/domain/entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAllCategories();
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(int id);
  Future<Category?> getCategoryById(int id);
}