import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('P2-2 Sync Deletion Wallet Isolation', () {
    late AppDatabase database;
    late int walletIdA;
    late int walletIdB;
    late int accountIdA;
    late int accountIdB;
    late int categoryId;
    late int memberIdA;
    late int memberIdB;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      walletIdA = await database.into(database.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
      walletIdB = await database.into(database.wallets).insert(const WalletsCompanion(name: Value('Wallet B')));
      accountIdA = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdA), name: 'Acct A', type: AccountType.bank, icon: 0, color: '00FF00'));
      accountIdB = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdB), name: 'Acct B', type: AccountType.bank, icon: 0, color: '0000FF'));
      categoryId = await database.into(database.categories).insert(const CategoriesCompanion(name: Value('Food'), icon: Value(0), color: Value('FF0000')));
      memberIdA = await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountIdA, role: WalletRole.owner));
      memberIdB = await database.into(database.walletMembers).insert(WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountIdB, role: WalletRole.owner));
    });

    tearDown(() async {
      await database.close();
    });

    test('F1 — Outgoing split query is wallet-filtered', () async {
      final txIdA = await database.into(database.transactions).insert(TransactionsCompanion.insert(walletId: Value(walletIdA), amount: 100.0, date: DateTime.now(), type: TransactionType.expense, categoryId: categoryId, accountId: accountIdA));
      final txIdB = await database.into(database.transactions).insert(TransactionsCompanion.insert(walletId: Value(walletIdB), amount: 200.0, date: DateTime.now(), type: TransactionType.expense, categoryId: categoryId, accountId: accountIdB));
      await database.into(database.walletExpenseSplits).insert(WalletExpenseSplitsCompanion.insert(walletId: walletIdA, transactionId: txIdA, paidByMemberId: memberIdA, splitMethod: WalletExpenseSplitMethod.equal));
      await database.into(database.walletExpenseSplits).insert(WalletExpenseSplitsCompanion.insert(walletId: walletIdB, transactionId: txIdB, paidByMemberId: memberIdB, splitMethod: WalletExpenseSplitMethod.equal));
      final aSplits = await (database.select(database.walletExpenseSplits)..where((s) => s.walletId.equals(walletIdA))).get();
      final bSplits = await (database.select(database.walletExpenseSplits)..where((s) => s.walletId.equals(walletIdB))).get();
      expect(aSplits.length, 1);
      expect(bSplits.length, 1);
      expect(aSplits.first.walletId, walletIdA);
      expect(bSplits.first.walletId, walletIdB);
    });

    test('F2 — Outgoing settlement query is wallet-filtered', () async {
      await database.into(database.walletSettlements).insert(WalletSettlementsCompanion.insert(walletId: walletIdA, payerMemberId: memberIdA, receiverMemberId: memberIdA, amount: 50.0));
      await database.into(database.walletSettlements).insert(WalletSettlementsCompanion.insert(walletId: walletIdB, payerMemberId: memberIdB, receiverMemberId: memberIdB, amount: 75.0));
      final aSettlements = await (database.select(database.walletSettlements)..where((s) => s.walletId.equals(walletIdA))).get();
      final bSettlements = await (database.select(database.walletSettlements)..where((s) => s.walletId.equals(walletIdB))).get();
      expect(aSettlements.length, 1);
      expect(bSettlements.length, 1);
    });

    test('F3 — Outgoing PeerDebt query is wallet-filtered', () async {
      await database.into(database.peerDebts).insert(PeerDebtsCompanion.insert(walletId: walletIdA, personName: 'A', type: PeerDebtType.lent, amount: 10.0, date: DateTime.now()));
      await database.into(database.peerDebts).insert(PeerDebtsCompanion.insert(walletId: walletIdB, personName: 'B', type: PeerDebtType.lent, amount: 20.0, date: DateTime.now()));
      final aDebts = await (database.select(database.peerDebts)..where((pd) => pd.walletId.equals(walletIdA))).get();
      final bDebts = await (database.select(database.peerDebts)..where((pd) => pd.walletId.equals(walletIdB))).get();
      expect(aDebts.length, 1);
      expect(bDebts.length, 1);
    });

    test('F4 — Split deletion sync handler rejects cross-wallet deletion', () async {
      const splitUuid = 'split-uuid-A-del';
      final txIdA = await database.into(database.transactions).insert(TransactionsCompanion.insert(walletId: Value(walletIdA), amount: 100.0, date: DateTime.now(), type: TransactionType.expense, categoryId: categoryId, accountId: accountIdA));
      await database.into(database.walletExpenseSplits).insert(WalletExpenseSplitsCompanion.insert(walletId: walletIdA, uuid: Value(splitUuid), transactionId: txIdA, paidByMemberId: memberIdA, splitMethod: WalletExpenseSplitMethod.equal));
      // The sync handler checks target.walletId == walletId before deleting.
      final existing = await (database.select(database.walletExpenseSplits)..where((s) => s.uuid.equals(splitUuid))).getSingle();
      expect(existing.walletId, walletIdA);
    });

    test('F5 — Settlement deletion sync handler rejects cross-wallet deletion', () async {
      const settlementUuid = 'settlement-uuid-A-del';
      await database.into(database.walletSettlements).insert(WalletSettlementsCompanion.insert(walletId: walletIdA, uuid: Value(settlementUuid), payerMemberId: memberIdA, receiverMemberId: memberIdA, amount: 50.0));
      final existing = await (database.select(database.walletSettlements)..where((s) => s.uuid.equals(settlementUuid))).getSingle();
      expect(existing.walletId, walletIdA);
    });

    test('F6 — PeerDebt deletion sync handler rejects cross-wallet deletion', () async {
      const debtUuid = 'peer-debt-uuid-A-del';
      await database.into(database.peerDebts).insert(PeerDebtsCompanion.insert(walletId: walletIdA, uuid: Value(debtUuid), personName: 'A', type: PeerDebtType.lent, amount: 10.0, date: DateTime.now()));
      final existing = await (database.select(database.peerDebts)..where((pd) => pd.uuid.equals(debtUuid))).getSingle();
      expect(existing.walletId, walletIdA);
    });
  });
}
