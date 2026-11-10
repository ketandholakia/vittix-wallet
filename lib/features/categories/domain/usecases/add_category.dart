import 'package:vittix_wallet/domain/entities/category.dart';
import 'package:vittix_wallet/domain/repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(Category category) {
    return repository.addCategory(category);
  }
}