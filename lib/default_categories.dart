import 'package:drift/drift.dart';
import 'package:expense_tracker/app_database.dart';
import 'package:material_symbols_icons/symbols.dart';

class DefaultCategories {
  static final List<CategoriesCompanion> defaultCategories = [
    CategoriesCompanion.insert(
      name: 'Food',
      icon: Symbols.restaurant.codePoint,
      color: 'FF45D4A3',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Shopping',
      icon: Symbols.shopping_bag.codePoint,
      color: 'FFFF9D43',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Fuel',
      icon: Symbols.local_gas_station.codePoint,
      color: 'FF569BFF',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Bills',
      icon: Symbols.receipt_long.codePoint,
      color: 'FFFF7A6B',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Salary',
      icon: Symbols.payments.codePoint,
      color: 'FF2196F3',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Investment',
      icon: Symbols.trending_up.codePoint,
      color: 'FF9C27B0',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Medical',
      icon: Symbols.medical_services.codePoint,
      color: 'FFE91E63',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Travel',
      icon: Symbols.flight.codePoint,
      color: 'FF00BCD4',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Education',
      icon: Symbols.school.codePoint,
      color: 'FF8BC34A',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Entertainment',
      icon: Symbols.movie.codePoint,
      color: 'FFFFC107',
      isDefault: const Value(true),
    ),
    CategoriesCompanion.insert(
      name: 'Transfer',
      icon: Symbols.swap_horiz.codePoint,
      color: 'FF9E9E9E',
      isDefault: const Value(true),
    ),
  ];
}
