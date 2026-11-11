import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vittix_wallet/core/database/app_database.dart';
import 'package:vittix_wallet/features/sync/data/sync_service.dart';
import 'package:vittix_wallet/core/providers/database_provider.dart';
import 'package:vittix_wallet/features/debts/presentation/debts_loans_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Loans & Debts Mathematical Calculations', () {
    test('calculateEmi calculates correct EMI amounts with interest', () {
      // Principal = 10000, Annual Rate = 12%, Tenure = 12 months
      // EMI = 10000 * 0.01 * (1.01)^12 / ((1.01)^12 - 1) = ~888.487
      final emi = calculateEmi(10000.0, 12.0, 12);
      expect(emi, closeTo(888.49, 0.05));
    });

    test('calculateEmi calculates correct EMI amounts with zero interest', () {
      final emi = calculateEmi(10000.0, 0.0, 10);
      expect(emi, 1000.0);
    });
  });

  group('Loans & Debts Database Deletion Triggers', () {
    late AppDatabase db;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'Trigger after_loan_delete logs deleted loan to deleted_records',
      () async {
        // Create Account first due to foreign key
        final accId = await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(
                uuid: const Value('acc-uuid-loan'),
                name: 'Loan Account',
                type: AccountType.loan,
                icon: 1,
                color: '000000',
              ),
            );

        // Insert Loan
        final loanId = await db
            .into(db.loans)
            .insert(
              LoansCompanion.insert(
                uuid: const Value('loan-uuid-1'),
                name: 'Car Loan',
                accountId: accId,
                principalAmount: 15000.0,
                interestRate: 5.0,
                tenureMonths: 36,
                startDate: DateTime.now(),
                emiAmount: 450.0,
              ),
            );

        // Delete Loan
        await (db.delete(db.loans)..where((l) => l.id.equals(loanId))).go();

        // Check deleted_records
        final deleted = await db.select(db.deletedRecords).get();
        expect(deleted.length, 1);
        expect(deleted.first.uuid, 'loan-uuid-1');
        expect(deleted.first.deletedTable, 'loans');
      },
    );

    test(
      'Trigger after_peer_debt_delete logs deleted peer debt to deleted_records',
      () async {
        // Insert Peer Debt
        final debtId = await db
            .into(db.peerDebts)
            .insert(
              PeerDebtsCompanion.insert(
                walletId: 1,
                uuid: const Value('peer-debt-uuid-1'),
                personName: 'Dave',
                type: PeerDebtType.lent,
                amount: 100.0,
                date: DateTime.now(),
              ),
            );

        // Delete Peer Debt
        await (db.delete(
          db.peerDebts,
        )..where((pd) => pd.id.equals(debtId))).go();

        // Check deleted_records
        final deleted = await db.select(db.deletedRecords).get();
        expect(deleted.length, 1);
        expect(deleted.first.uuid, 'peer-debt-uuid-1');
        expect(deleted.first.deletedTable, 'peer_debts');
      },
    );
  });

  group('Loans & Debts Sync & Conflict Resolution (LWW)', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'isSimulatedSync': true});

      db = AppDatabase.forTesting(NativeDatabase.memory());

      // Sync requires a valid active wallet with at least one member, and
      // currentWalletIdProvider defaults to wallet 1.
      final walletId = await db
          .into(db.wallets)
          .insert(const WalletsCompanion(name: Value('Debts Wallet')));
      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              walletId: Value(walletId),
              name: 'Debts Account',
              type: AccountType.bank,
              icon: 0,
              color: '000000',
            ),
          );
      await db
          .into(db.walletMembers)
          .insert(
            WalletMembersCompanion.insert(
              walletId: walletId,
              accountId: accountId,
              role: WalletRole.owner,
            ),
          );

      container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
    });

    tearDown(() async {
      await db.close();
      container.dispose();
    });

    test('LWW - should merge newer remote loan details locally', () async {
      final originalTime = DateTime(2026, 6, 1, 10, 0, 0);
      final newerTime = DateTime(2026, 6, 1, 12, 0, 0);

      // 1. Insert local linked account
      final accId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              uuid: const Value('acc-uuid-loan-2'),
              name: 'Home Loan Account',
              type: AccountType.loan,
              icon: 1,
              color: '000000',
            ),
          );

      // 2. Insert local loan (updated at 10:00)
      await db
          .into(db.loans)
          .insert(
            LoansCompanion.insert(
              uuid: const Value('loan-lww-1'),
              name: 'Old Home Loan Name',
              accountId: accId,
              principalAmount: 200000.0,
              interestRate: 4.5,
              tenureMonths: 180,
              startDate: DateTime(2026, 1, 1),
              emiAmount: 1530.0,
              updatedAt: Value(originalTime),
            ),
          );

      // Set up simulated server with same loan uuid, but newer updatedAt and different name
      final prefs = await SharedPreferences.getInstance();
      final serverState = <String, dynamic>{
        'accounts': [
          {
            'uuid': 'acc-uuid-loan-2',
            'name': 'Home Loan Account',
            'type': 'loan',
            'icon': 1,
            'color': '000000',
            'openingBalance': 200000.0,
            'isDefault': false,
            'updatedAt': originalTime.millisecondsSinceEpoch,
          },
        ],
        'categories': <dynamic>[],
        'transactions': <dynamic>[],
        'budgets': <dynamic>[],
        'recurring_transactions': <dynamic>[],
        'loans': <dynamic>[
          {
            'uuid': 'loan-lww-1',
            'name': 'Refinanced Home Loan',
            'accountUuid': 'acc-uuid-loan-2',
            'principalAmount': 200000.0,
            'interestRate': 4.0, // interest rate dropped!
            'tenureMonths': 180,
            'startDate': DateTime(2026, 1, 1).millisecondsSinceEpoch,
            'nextEmiDate': null,
            'emiAmount': 1478.0,
            'isActive': true,
            'updatedAt': newerTime.millisecondsSinceEpoch,
          },
        ],
        'peer_debts': <dynamic>[],
        'deletions': <dynamic>[],
      };
      await prefs.setString('simulated_server_state', jsonEncode(serverState));

      // Run sync
      await container.read(syncStateProvider.notifier).performSync();
      expect(container.read(syncStateProvider).status, SyncStatus.success);

      // Verify local database loan updated to newer remote values
      final updatedLoan = await (db.select(
        db.loans,
      )..where((l) => l.uuid.equals('loan-lww-1'))).getSingle();
      expect(updatedLoan.name, 'Refinanced Home Loan');
      expect(updatedLoan.interestRate, 4.0);
      expect(updatedLoan.emiAmount, 1478.0);
    });

    test('LWW - should merge newer remote peer debts locally', () async {
      final originalTime = DateTime(2026, 6, 1, 10, 0, 0);
      final newerTime = DateTime(2026, 6, 1, 12, 0, 0);

      // 1. Insert local Peer Debt (updated at 10:00)
      await db
          .into(db.peerDebts)
          .insert(
            PeerDebtsCompanion.insert(
              walletId: 1,
              uuid: const Value('peer-debt-lww-1'),
              personName: 'Bob',
              type: PeerDebtType.lent,
              amount: 50.0,
              date: DateTime(2026, 5, 1),
              isSettled: const Value(false),
              updatedAt: Value(originalTime),
            ),
          );

      // Set up simulated server with same peer debt uuid, but newer updatedAt and marked as settled
      final prefs = await SharedPreferences.getInstance();
      final serverState = <String, dynamic>{
        'accounts': <dynamic>[],
        'categories': <dynamic>[],
        'transactions': <dynamic>[],
        'budgets': <dynamic>[],
        'recurring_transactions': <dynamic>[],
        'loans': <dynamic>[],
        'peer_debts': <dynamic>[
          {
            'uuid': 'peer-debt-lww-1',
            'personName': 'Bob',
            'type': 'lent',
            'amount': 50.0,
            'note': null,
            'date': DateTime(2026, 5, 1).millisecondsSinceEpoch,
            'isSettled': true, // Settled!
            'transactionUuid': null,
            'updatedAt': newerTime.millisecondsSinceEpoch,
          },
        ],
        'deletions': <dynamic>[],
      };
      await prefs.setString('simulated_server_state', jsonEncode(serverState));

      // Run sync
      await container.read(syncStateProvider.notifier).performSync();
      expect(container.read(syncStateProvider).status, SyncStatus.success);

      // Verify local peer debt has been marked settled
      final updatedDebt = await (db.select(
        db.peerDebts,
      )..where((pd) => pd.uuid.equals('peer-debt-lww-1'))).getSingle();
      expect(updatedDebt.isSettled, true);
    });
  });
}
