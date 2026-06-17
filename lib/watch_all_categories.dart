import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/repositories/category_repository.dart';

class WatchAllCategories {
  final CategoryRepository repository;

  WatchAllCategories(this.repository);

  Stream<List<Category>> call() {
    return repository.watchAllCategories();
  }
}