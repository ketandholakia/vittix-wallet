import 'package:vittix_wallet/data/local/app_database.dart' as db;
import 'package:vittix_wallet/data/local/mappers/category_mapper.dart';
import 'package:vittix_wallet/domain/entities/category.dart';
import 'package:vittix_wallet/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final db.CategoryDao _categoryDao;

  CategoryRepositoryImpl(this._categoryDao);

  @override
  Future<void> addCategory(Category category) {
    // When adding, Drift handles the auto-increment ID, so we use .insert
    final companion = category.toCompanion().copyWith(id: const db.Value.absent());
    return _categoryDao.insertCategory(companion);
  }

  @override
  Future<void> deleteCategory(int id) {
    return _categoryDao.deleteCategory(id);
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final categoryFromDb = await _categoryDao.getCategoryById(id);
    return categoryFromDb?.toDomain();
  }

  @override
  Future<void> updateCategory(Category category) {
    final companion = category.toCompanion();
    return _categoryDao.updateCategory(companion);
  }

  @override
  Stream<List<Category>> watchAllCategories() {
    return _categoryDao.watchAllCategories().map((dbCategories) {
      return dbCategories.map((dbCategory) => dbCategory.toDomain()).toList();
    });
  }
}