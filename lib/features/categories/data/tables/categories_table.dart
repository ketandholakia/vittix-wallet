import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/database_enums.dart';

import 'package:uuid/uuid.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get icon => integer()(); // Storing icon codepoint
  TextColumn get color => text()(); // Storing color as a hex string (e.g., "FF0000")
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get parentId => integer().nullable().references(Categories, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
