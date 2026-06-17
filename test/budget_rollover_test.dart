import 'package:expense_tracker/domain/entities/account.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/domain/usecases/budget/get_budget_status.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'budget_rollover_test.mocks.dart';

@GenerateMocks([BudgetRepository, TransactionRepository])
void main() {
  late GetBudgetStatus usecase;
  late MockBudgetRepository mockBudgetRepository;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockBudgetRepository = MockBudgetRepository();
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetBudgetStatus(mockBudgetRepository, mockTransactionRepository);
  });

  final testCategory = Category(id: 1, name: 'Food', icon: Icons.fastfood, color: Colors.red);
  final testAccount = Account(id: 1, name: 'Cash', type: AccountType.cash, icon: Icons.payments, color: Colors.green);

  group('Budget Rollover Tests', () {
    test('Scenario 1: Disabled Rollover', () async {
      final budgets = [
        Budget(id: 1, amount: 100, period: '2026-05', category: testCategory),
        Budget(id: 2, amount: 100, period: '2026-06', category: testCategory),
        Budget(id: 3, amount: 100, period: '2026-07', category: testCategory),
      ];

      final transactions = [
        Transaction(id: 1, amount: 80, date: DateTime(2026, 5, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Transaction(id: 2, amount: 90, date: DateTime(2026, 6, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];

      when(mockBudgetRepository.watchAllBudgets()).thenAnswer((_) => Stream.value(budgets));
      when(mockTransactionRepository.watchAllTransactions()).thenAnswer((_) => Stream.value(transactions));

      final stream = usecase(DateTime(2026, 7, 1), RolloverMode.disabled);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result.first.rolloverAmount, 0.0);
      expect(result.first.totalLimit, 100.0);
    });

    test('Scenario 2: Surplus Only Rollover', () async {
      final budgets = [
        Budget(id: 1, amount: 100, period: '2026-05', category: testCategory),
        Budget(id: 2, amount: 100, period: '2026-06', category: testCategory),
        Budget(id: 3, amount: 100, period: '2026-07', category: testCategory),
      ];

      final transactions = [
        Transaction(id: 1, amount: 80, date: DateTime(2026, 5, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()), // May: $20 surplus
        Transaction(id: 2, amount: 70, date: DateTime(2026, 6, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()), // June: spent $70 of ($100 + $20 May) = $50 surplus
      ];

      when(mockBudgetRepository.watchAllBudgets()).thenAnswer((_) => Stream.value(budgets));
      when(mockTransactionRepository.watchAllTransactions()).thenAnswer((_) => Stream.value(transactions));

      final stream = usecase(DateTime(2026, 7, 1), RolloverMode.surplusOnly);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result.first.rolloverAmount, 50.0);
      expect(result.first.totalLimit, 150.0);
    });

    test('Scenario 3: Overspent resets in Surplus Only', () async {
      final budgets = [
        Budget(id: 1, amount: 100, period: '2026-06', category: testCategory),
        Budget(id: 2, amount: 100, period: '2026-07', category: testCategory),
      ];

      final transactions = [
        Transaction(id: 1, amount: 120, date: DateTime(2026, 6, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()), // June: deficit -$20
      ];

      when(mockBudgetRepository.watchAllBudgets()).thenAnswer((_) => Stream.value(budgets));
      when(mockTransactionRepository.watchAllTransactions()).thenAnswer((_) => Stream.value(transactions));

      final stream = usecase(DateTime(2026, 7, 1), RolloverMode.surplusOnly);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result.first.rolloverAmount, 0.0);
    });

    test('Scenario 4: Surplus & Deficit carry-forward', () async {
      final budgets = [
        Budget(id: 1, amount: 100, period: '2026-06', category: testCategory),
        Budget(id: 2, amount: 100, period: '2026-07', category: testCategory),
      ];

      final transactions = [
        Transaction(id: 1, amount: 120, date: DateTime(2026, 6, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()), // June: deficit -$20
      ];

      when(mockBudgetRepository.watchAllBudgets()).thenAnswer((_) => Stream.value(budgets));
      when(mockTransactionRepository.watchAllTransactions()).thenAnswer((_) => Stream.value(transactions));

      final stream = usecase(DateTime(2026, 7, 1), RolloverMode.surplusAndDeficit);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result.first.rolloverAmount, -20.0);
      expect(result.first.totalLimit, 80.0);
    });

    test('Scenario 5: Gaps reset rollover', () async {
      final budgets = [
        Budget(id: 1, amount: 100, period: '2026-05', category: testCategory),
        // June has NO budget
        Budget(id: 3, amount: 100, period: '2026-07', category: testCategory),
      ];

      final transactions = [
        Transaction(id: 1, amount: 80, date: DateTime(2026, 5, 15), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()), // May: $20 surplus
      ];

      when(mockBudgetRepository.watchAllBudgets()).thenAnswer((_) => Stream.value(budgets));
      when(mockTransactionRepository.watchAllTransactions()).thenAnswer((_) => Stream.value(transactions));

      final stream = usecase(DateTime(2026, 7, 1), RolloverMode.surplusOnly);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result.first.rolloverAmount, 0.0); // Cascade reset due to gap in June
    });
  });
}
