import 'package:drift/drift.dart';
import 'package:expense_tracker/app_database.dart';
import 'package:material_symbols_icons/symbols.dart';

class DefaultAccounts {
  static final List<AccountsCompanion> defaultAccounts = [
    AccountsCompanion.insert(
      name: 'Cash',
      type: AccountType.cash,
      icon: Symbols.payments.codePoint,
      color: 'FF45D4A3',
      isDefault: const Value(true),
    ),
    AccountsCompanion.insert(
      name: 'Bank Account',
      type: AccountType.bank,
      icon: Symbols.account_balance.codePoint,
      color: 'FF569BFF',
      isDefault: const Value(true),
    ),
    AccountsCompanion.insert(
      name: 'Credit Card',
      type: AccountType.creditCard,
      icon: Symbols.credit_card.codePoint,
      color: 'FFFF7A6B',
      isDefault: const Value(true),
    ),
  ];
}
