import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(Category category) {
    return repository.updateCategory(category);
  }
}