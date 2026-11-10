import 'package:drift/drift.dart';
import 'package:vittix_wallet/features/accounts/domain/account.dart' as domain;
import 'package:vittix_wallet/data/local/app_database.dart' as db;
import 'package:vittix_wallet/data/local/mappers/category_mapper.dart';
import 'package:vittix_wallet/shared/icon_codepoint.dart';

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
      // currencyCode: currencyCode,
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
      // currencyCode
    );
  }
}
