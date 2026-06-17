import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isDefault;
  final int? parentId;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isDefault = false,
    this.parentId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}