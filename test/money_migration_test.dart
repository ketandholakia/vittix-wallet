import 'package:drift/native.dart';
import 'package:vittix_wallet/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

/// P1-6 — legacy REAL money columns are converted to exact integer minor units.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> declaredType(String table, String column) async {
    final info = await db.customSelect("PRAGMA table_info('$table')").get();
    final row = info.firstWhere((r) => r.read<String>('name') == column);
    return row.read<String>('type').toUpperCase();
  }

  test('rounds seeded REAL values half away from zero into minor units',
      () async {
    // Simulate a pre-v13 database where money was physically stored as REAL.
    await db.customStatement(
      'CREATE TABLE legacy_money '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL NOT NULL)',
    );
    for (final value in <double>[
      0.1 + 0.2, // 0.30000000000000004
      1234.565, // 123456.50000000001 paise -> 123457
      -(0.1 + 0.2), // -30.000000000000004 paise -> -30
      0.005, // half -> 1
    ]) {
      await db.customStatement(
        'INSERT INTO legacy_money (amount) VALUES (?)',
        [value],
      );
    }

    await db.convertLegacyMoneyColumns(
      columns: const {
        'legacy_money': ['amount'],
      },
    );

    final rows = await db
        .customSelect('SELECT amount FROM legacy_money ORDER BY id')
        .get();
    expect(
      rows.map((row) => row.read<int>('amount')).toList(),
      [30, 123457, -30, 1],
    );
    expect(await declaredType('legacy_money', 'amount'), 'INTEGER');
  });

  test('is idempotent: INTEGER columns are left alone', () async {
    await db.customStatement(
      'CREATE TABLE legacy_money '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL NOT NULL)',
    );
    await db.customStatement(
      'INSERT INTO legacy_money (amount) VALUES (?)',
      [12.34],
    );

    const columns = {
      'legacy_money': ['amount'],
    };
    await db.convertLegacyMoneyColumns(columns: columns);
    await db.convertLegacyMoneyColumns(columns: columns);

    final rows =
        await db.customSelect('SELECT amount FROM legacy_money').get();
    expect(rows.single.read<int>('amount'), 1234);
    expect(await declaredType('legacy_money', 'amount'), 'INTEGER');
  });

  test('the live schema already stores money as INTEGER', () async {
    expect(await declaredType('transactions', 'amount'), 'INTEGER');
    expect(await declaredType('accounts', 'opening_balance'), 'INTEGER');

    // Running the production conversion on a current database changes nothing.
    await db.convertLegacyMoneyColumns(columns: const {
      'transactions': ['amount'],
      'accounts': ['opening_balance'],
    });
    expect(await declaredType('transactions', 'amount'), 'INTEGER');
    expect(await declaredType('accounts', 'opening_balance'), 'INTEGER');
  });

  test('covers every money column that stores minor units', () {
    expect(kMoneyColumns['transactions'], contains('amount'));
    expect(kMoneyColumns['recurring_transactions'], contains('amount'));
    expect(kMoneyColumns['budgets'], contains('amount'));
    expect(kMoneyColumns['accounts'], contains('opening_balance'));
    expect(kMoneyColumns['peer_debts'], contains('amount'));
    expect(kMoneyColumns['loans'], containsAll(['principal_amount', 'emi_amount']));
    expect(kMoneyColumns['wallet_bills'], contains('amount'));
    expect(kMoneyColumns['wallet_settlements'], contains('amount'));
    expect(kMoneyColumns['wallet_allowances'], contains('amount'));
    expect(kMoneyColumns['wallet_allowance_payments'], contains('amount'));
    expect(kMoneyColumns['wallet_goals'],
        containsAll(['target_amount', 'current_amount']));
    expect(kMoneyColumns['wallet_goal_contributions'], contains('amount'));
    expect(kMoneyColumns['wallet_goal_schedules'], contains('amount'));
    expect(kMoneyColumns['wallet_expense_split_members'],
        containsAll(['amount_owed', 'settled_amount']));
  });
}
