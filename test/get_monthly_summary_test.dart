import 'package:expense_tracker/domain/entities/account.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/domain/usecases/summary/get_monthly_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_monthly_summary_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetMonthlySummary usecase;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    usecase = GetMonthlySummary(mockTransactionRepository);
  });

  final testCategory = Category(id: 1, name: 'Food', icon: Icons.fastfood, color: Colors.red);
  final testAccount = Account(id: 1, name: 'Cash', type: AccountType.cash, icon: Icons.payments, color: Colors.green);
  final tTransactions = [
    Transaction(id: 1, amount: 100, date: DateTime.now(), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Transaction(id: 2, amount: 500, date: DateTime.now(), type: TransactionType.income, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    Transaction(id: 3, amount: 50, date: DateTime.now(), type: TransactionType.expense, category: testCategory, account: testAccount, createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];
  final tDateTime = DateTime.now();

  test('should get monthly summary from the repository and calculate totals correctly', () async {
    when(mockTransactionRepository.watchTransactionsInMonth(any)).thenAnswer((_) => Stream.value(tTransactions));
    when(mockTransactionRepository.getMonthlySummaryTotals(any)).thenAnswer((_) async => (500.0, 150.0));

    final resultStream = usecase(tDateTime);

    final report = await resultStream;
    expect(report.totalExpense, 150.0);
    expect(report.totalIncome, 500.0);
    expect(report.balance, 350.0);
    expect(report.transactions, tTransactions);
  });
}
