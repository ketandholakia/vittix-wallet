import 'package:expense_tracker/core/utils/duplicate_detector.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/categories/domain/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final category = Category(
    id: 1,
    name: 'Food',
    icon: Icons.restaurant,
    color: const Color(0xFF112233),
  );

  Account account(int id) => Account(
        id: id,
        name: 'Account $id',
        type: AccountType.cash,
        icon: Icons.wallet,
        color: const Color(0xFF112233),
      );

  Transaction tx({
    required double amount,
    required DateTime date,
    required int accountId,
  }) =>
      Transaction(
        id: 0,
        amount: amount,
        date: date,
        type: TransactionType.expense,
        category: category,
        account: account(accountId),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

  group('looksLikeDuplicate', () {
    test('same amount, same day and same account is a duplicate', () {
      final existing = [
        tx(amount: 100, date: DateTime(2026, 3, 5, 9), accountId: 1),
      ];
      // Different time of day on the same calendar day still matches.
      final candidate = tx(amount: 100, date: DateTime(2026, 3, 5, 21, 30), accountId: 1);
      expect(looksLikeDuplicate(candidate, existing), isTrue);
    });

    test('different amount is not a duplicate', () {
      final existing = [tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 1)];
      final candidate = tx(amount: 101, date: DateTime(2026, 3, 5), accountId: 1);
      expect(looksLikeDuplicate(candidate, existing), isFalse);
    });

    test('different account is not a duplicate', () {
      final existing = [tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 1)];
      final candidate = tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 2);
      expect(looksLikeDuplicate(candidate, existing), isFalse);
    });

    test('a different day in the same month is not a duplicate', () {
      final existing = [tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 1)];
      final candidate = tx(amount: 100, date: DateTime(2026, 3, 6), accountId: 1);
      expect(looksLikeDuplicate(candidate, existing), isFalse);
    });

    test('the same day in a different month is not a duplicate', () {
      final existing = [tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 1)];
      final candidate = tx(amount: 100, date: DateTime(2026, 4, 5), accountId: 1);
      expect(looksLikeDuplicate(candidate, existing), isFalse);
    });

    test('an empty ledger never reports a duplicate', () {
      final candidate = tx(amount: 100, date: DateTime(2026, 3, 5), accountId: 1);
      expect(looksLikeDuplicate(candidate, const []), isFalse);
    });
  });
}
