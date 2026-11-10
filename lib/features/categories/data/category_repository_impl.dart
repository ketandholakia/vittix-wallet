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
  Future<void> deleteCategory(int id) async {
    // `PRAGMA foreign_keys` is off, so the self-referencing `parentId`
    // cascade does not run; delete the subtree explicitly, deepest first.
    final ids = await _subtreeIds(id);
    await _categoryDao.attachedDatabase.transaction(() async {
      await _categoryDao.deleteCategories(ids.reversed);
    });
  }

  /// Collects [rootId] plus every descendant category id.
  ///
  /// Iterative so a corrupt self-referencing row cannot spin forever.
  Future<List<int>> _subtreeIds(int rootId) async {
    final all = await _categoryDao.getAllCategories();
    final childrenOf = <int, List<int>>{};
    for (final category in all) {
      final parent = category.parentId;
      if (parent == null) continue;
      childrenOf.putIfAbsent(parent, () => <int>[]).add(category.id);
    }

    final ordered = <int>[rootId];
    final seen = <int>{rootId};
    var frontier = <int>[rootId];
    while (frontier.isNotEmpty) {
      final next = <int>[];
      for (final id in frontier) {
        for (final child in childrenOf[id] ?? const <int>[]) {
          if (seen.add(child)) {
            ordered.add(child);
            next.add(child);
          }
        }
      }
      frontier = next;
    }
    return ordered;
  }

  @override
  Future<int> countTransactionsForCategory(int categoryId) async {
    final ids = await _subtreeIds(categoryId);
    return _categoryDao.attachedDatabase.transactionDao
        .countTransactionsForCategories(ids);
  }

  @override
  Future<int> reassignAndDeleteCategory(int fromCategoryId, int toCategoryId) async {
    if (fromCategoryId == toCategoryId) {
      throw ArgumentError.value(
        toCategoryId,
        'toCategoryId',
        'must differ from the category being deleted',
      );
    }
    final ids = await _subtreeIds(fromCategoryId);
    if (ids.contains(toCategoryId)) {
      throw ArgumentError.value(
        toCategoryId,
        'toCategoryId',
        'is inside the category subtree being deleted',
      );
    }
    // Without this guard a stale or hostile id would move every transaction to
    // a category that does not exist, silently orphaning the history.
    final target = await _categoryDao.getCategoryById(toCategoryId);
    if (target == null) {
      throw ArgumentError.value(
        toCategoryId,
        'toCategoryId',
        'does not exist',
      );
    }

    final database = _categoryDao.attachedDatabase;
    var moved = 0;
    await database.transaction(() async {
      moved = await database.transactionDao
          .reassignTransactionsForCategories(ids, toCategoryId);
      // Deepest first, so the operation stays correct if foreign keys are
      // enabled later and the `parentId` cascade starts running.
      await _categoryDao.deleteCategories(ids.reversed);
    });
    return moved;
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