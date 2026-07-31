import 'package:expense_tracker/dashboard_providers.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/monthly_report.dart';
import 'package:expense_tracker/transaction.dart' as domain;
import 'package:expense_tracker/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  // Create mock data
  final testCategory = Category(id: 1, name: 'Food', icon: Icons.fastfood, color: Colors.red);
  final testAccount = Account(id: 1, name: 'Cash', type: AccountType.cash, icon: Icons.payments, color: Colors.green);
  final mockTransactions = [
    domain.Transaction(
      id: 1,
      amount: 150,
      date: DateTime.now(),
      type: domain.TransactionType.expense,
      category: testCategory,
      account: testAccount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
  final mockReport = MonthlyReport(
    totalIncome: 1000,
    totalExpense: 150,
    transactions: mockTransactions,
  );

  testWidgets('DashboardScreen displays header, chart, and recent transactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override providers with mock data streams
          monthlyReportProvider.overrideWith((ref) => Future.value(mockReport)),
          recentTransactionsProvider.overrideWith((ref) => Stream.value(mockTransactions)),
          // Override currency for consistent test results
          currencyFormatProvider.overrideWithValue(NumberFormat.currency(locale: 'en_IN', symbol: '₹')),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Let the stream builders receive the data and rebuild the UI
    await tester.pump();

    // Verify header data is displayed correctly
    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.text('₹850.00'), findsOneWidget); // Balance: 1000 - 150
    expect(find.text('₹1,000.00'), findsOneWidget); // Income
    expect(find.text('₹150.00'), findsOneWidget); // Expense

    // Verify recent transaction list item is displayed
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget); // Category name from the mock transaction

    // Verify pie chart section is displayed
    expect(find.text('Top Spending'), findsOneWidget);
  });
}
