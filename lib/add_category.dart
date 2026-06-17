import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(Category category) {
    return repository.addCategory(category);
  }
}