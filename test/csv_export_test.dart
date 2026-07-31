import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/core/utils/csv_exporter.dart';

void main() {
  group('CSV Exporter Tests', () {
    final foodCategory = Category(
      id: 1,
      name: 'Food',
      icon: Icons.restaurant,
      color: Colors.red,
    );

    final diningOutCategory = Category(
      id: 2,
      name: 'Dining Out',
      icon: Icons.fastfood,
      color: Colors.orange,
      parentId: 1,
    );

    final salaryCategory = Category(
      id: 3,
      name: 'Salary',
      icon: Icons.money,
      color: Colors.green,
    );

    final bankAccount = Account(
      id: 1,
      name: 'Bank Account',
      type: AccountType.bank,
      icon: Icons.account_balance,
      color: Colors.blue,
    );

    final categoryMap = {
      1: foodCategory,
      2: diningOutCategory,
      3: salaryCategory,
    };

    test('generates valid CSV header and formatted rows', () {
      final transactions = [
        Transaction(
          id: 101,
          amount: 50.5,
          date: DateTime(2026, 6, 12),
          type: TransactionType.expense,
          category: diningOutCategory,
          account: bankAccount,
          note: 'Dinner at restaurant',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Transaction(
          id: 102,
          amount: 1000.0,
          date: DateTime(2026, 6, 1),
          type: TransactionType.income,
          category: salaryCategory,
          account: bankAccount,
          note: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final csv = generateCsv(
        transactions: transactions,
        categoryMap: categoryMap,
        currencyCode: 'INR',
      );

      final lines = csv.trim().split('\n');
      expect(lines.length, 3); // Header + 2 data rows
      expect(lines[0], 'ID,Date,Type,Parent Category,Category,Account,Amount,Currency,Note');
      
      // First transaction line
      expect(lines[1], '101,2026-06-12,Expense,Food,Dining Out,Bank Account,50.5,INR,Dinner at restaurant');
      
      // Second transaction line
      expect(lines[2], '102,2026-06-01,Income,,Salary,Bank Account,1000.0,INR,');
    });

    test('escapes special characters correctly in CSV fields', () {
      final trickyCategory = Category(
        id: 4,
        name: 'Misc, Tricky Category',
        icon: Icons.error,
        color: Colors.purple,
      );

      final transactions = [
        Transaction(
          id: 201,
          amount: 25.0,
          date: DateTime(2026, 6, 12),
          type: TransactionType.expense,
          category: trickyCategory,
          account: Account(
            id: 3,
            name: 'My "Super" Bank',
            type: AccountType.bank,
            icon: Icons.stars,
            color: Colors.blue,
          ),
          note: 'Purchased apple, banana, & "peaches"\nNext line note.',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )
      ];

      final csv = generateCsv(
        transactions: transactions,
        categoryMap: {4: trickyCategory},
        currencyCode: 'USD',
      );

      final lines = csv.trim().split('\n');
      // Due to a newline in the note field, split('\n') returns 3 lines
      expect(lines.length, 3); 
      
      // First line should be header
      expect(lines[0], 'ID,Date,Type,Parent Category,Category,Account,Amount,Currency,Note');
      
      // Data row starts on line 1, continues to line 2
      expect(lines[1], startsWith('201,2026-06-12,Expense,,"Misc, Tricky Category","My ""Super"" Bank",25.0,USD,"Purchased apple, banana, & ""peaches""'));
      expect(lines[2], 'Next line note."');
    });
  });
}
