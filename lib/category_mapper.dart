import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/domain/entities/category.dart' as domain;
import 'package:expense_tracker/shared/icon_codepoint.dart';
import 'package:flutter/material.dart';

// Helper to convert hex string to Color
Color colorFromHex(String hexColor) {
  return Color(int.parse(hexColor, radix: 16));
}

// Helper to convert Color to hex string
String colorToHex(Color color) {
  return color.value.toRadixString(16).toUpperCase();
}

extension CategoryDBMapper on db.Category {
  domain.Category toDomain() {
    return domain.Category(
      id: id,
      name: name,
      icon: iconFromCodePoint(icon),
      color: colorFromHex(color),
      isDefault: isDefault,
      parentId: parentId,
    );
  }
}

extension CategoryDomainMapper on domain.Category {
  db.CategoriesCompanion toCompanion() {
    // Use Value() for non-nullable fields, even when updating
    return db.CategoriesCompanion(
        id: Value(id), name: Value(name), icon: Value(icon.codePoint), color: Value(colorToHex(color)), isDefault: Value(isDefault), parentId: Value(parentId));
  }
}
