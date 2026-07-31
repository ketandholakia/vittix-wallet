import 'package:expense_tracker/core/database/database_enums.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/default_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late TransactionDao transactionDao;
  late CategoryDao categoryDao;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    transactionDao = database.transactionDao;
    categoryDao = database.categoryDao;
    await database.batch((batch) {
      batch.insertAll(database.accounts, DefaultAccounts.defaultAccounts);
    });
  });

  tearDown(() async {
    await database.close();
  });

  test('DAO should insert and retrieve transactions for a specific month', () async {
    final categoryId = await categoryDao.insertCategory(
      const CategoriesCompanion(
        name: Value('Test'),
        icon: Value(0),
        color: Value('FFFFFF'),
      ),
    );

    final dateInMonth = DateTime(2024, 7, 15);
    final dateOutsideMonth = DateTime(2024, 8, 1);

    await transactionDao.insertTransaction(
      TransactionsCompanion(
        amount: const Value(100),
        date: Value(dateInMonth),
        type: const Value(TransactionType.expense),
        categoryId: Value(categoryId),
        accountId: const Value(1),
      ),
    );
    await transactionDao.insertTransaction(
      TransactionsCompanion(
        amount: const Value(200),
        date: Value(dateOutsideMonth),
        type: const Value(TransactionType.expense),
        categoryId: Value(categoryId),
        accountId: const Value(1),
      ),
    );

    final stream = transactionDao.watchTransactionsInMonth(dateInMonth);
    final result = await stream.first;

    expect(result.length, 1);
    expect(result.first.transaction.amount, 100);
    expect(result.first.category.name, 'Test');
  });
}
