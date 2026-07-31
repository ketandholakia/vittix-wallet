import 'package:expense_tracker/features/transactions/domain/transaction.dart';
import 'package:flutter/material.dart';

enum AccountType {
  bank,
  creditCard,
  loan,
  cash,
  income,
}

extension AccountTypeX on AccountType {
  String get label => switch (this) {
        AccountType.bank => 'Bank Account',
        AccountType.creditCard => 'Credit Card',
        AccountType.loan => 'Loan',
        AccountType.cash => 'Cash',
        AccountType.income => 'Income Account',
      };

  bool get isLiability => this == AccountType.creditCard || this == AccountType.loan;
}

class Account {
  final int id;
  final String name;
  final AccountType type;
  final IconData icon;
  final Color color;
  final double openingBalance;
  final bool isDefault;
  final String? currencyCode;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.openingBalance = 0,
    this.isDefault = false,
    this.currencyCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class AccountWithBalance {
  final Account account;
  final double balance;

  const AccountWithBalance({
    required this.account,
    required this.balance,
  });
}

double accountTransactionEffect(AccountType accountType, TransactionType txType, double amount) {
  if (accountType.isLiability) {
    return txType == TransactionType.expense ? amount : -amount;
  }
  return txType == TransactionType.income ? amount : -amount;
}
