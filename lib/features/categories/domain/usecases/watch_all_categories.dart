import 'package:vittix_wallet/domain/entities/category.dart';
import 'package:vittix_wallet/domain/repositories/category_repository.dart';

class WatchAllCategories {
  final CategoryRepository repository;

  WatchAllCategories(this.repository);

  Stream<List<Category>> call() {
    return repository.watchAllCategories();
  }
}
