import 'package:drift/drift.dart';
import 'package:expense_tracker/account.dart' as domain;
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/category_mapper.dart';
import 'package:expense_tracker/shared/icon_codepoint.dart';

extension AccountDBMapper on db.Account {
  domain.Account toDomain() {
    return domain.Account(
      id: id,
      name: name,
      type: domain.AccountType.values.byName(type.name),
      icon: iconFromCodePoint(icon),
      color: colorFromHex(color),
      openingBalance: openingBalance,
      isDefault: isDefault,
    );
  }
}

extension AccountDomainMapper on domain.Account {
  db.AccountsCompanion toCompanion() {
    return db.AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(db.AccountType.values.byName(type.name)),
      icon: Value(icon.codePoint),
      color: Value(colorToHex(color)),
      openingBalance: Value(openingBalance),
      isDefault: Value(isDefault),
    );
  }
}
