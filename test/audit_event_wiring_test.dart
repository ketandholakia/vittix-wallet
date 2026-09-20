import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:expense_tracker/data/local/app_database.dart' hide RecurringTransaction, RecurringTransactionDb, Category, Account, TransactionType, Budget, isNull, isNotNull;
import 'package:expense_tracker/features/accounts/data/account_repository_impl.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart' as acct;
import 'package:expense_tracker/features/budgets/data/budget_repository_impl.dart';
import 'package:expense_tracker/features/budgets/domain/budget.dart' as budget_domain;
import 'package:expense_tracker/features/transactions/data/transaction_repository_impl.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/domain/entities/category.dart' as cat;
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';
import 'package:expense_tracker/core/database/database_enums.dart' as db_enums;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late int walletIdA;
  late int walletIdB;
  late int accountIdA;
  late int accountIdB;
  late int categoryIdA;
  late int memberIdA;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;

    walletIdA = await database.into(database.wallets).insert(
      WalletsCompanion.insert(name: 'Wallet A', type: Value('family')),
    );
    walletIdB = await database.into(database.wallets).insert(
      WalletsCompanion.insert(name: 'Wallet B', type: Value('family')),
    );

    accountIdA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(walletId: Value(walletIdA), name: 'Account A', type: AccountType.bank, icon: 0, color: 'FF0000'),
    );
    accountIdB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(walletId: Value(walletIdB), name: 'Account B', type: AccountType.bank, icon: 0, color: '0000FF'),
    );

    categoryIdA = await database.into(database.categories).insert(
      const CategoriesCompanion(name: Value('Food'), icon: Value(0), color: Value('FF0000')),
    );

    memberIdA = await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountIdA, role: WalletRole.owner),
    );

    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountIdB, role: WalletRole.owner),
    );
  });

  tearDown(() async => database.close());

  Future<int> countAuditEvents(int walletId, String action) async {
    final events = await walletDao.getActivityForWallet(walletId, action: action);
    return events.length;
  }

  Future<WalletActivity?> latestEvent(int walletId, {String? action}) async {
    final events = await walletDao.getActivityForWallet(walletId, action: action, limit: 1);
    return events.isEmpty ? null : events.first;
  }

  // --- Account Audit ---
  group('Account Audit Events', () {
    test('ACCOUNT_CREATED — one event, correct wallet', () async {
      final repo = AccountRepositoryImpl(database.accountDao, walletIdA, walletDao);
      await repo.addAccount(acct.Account(id: 0, name: 'Savings', type: acct.AccountType.bank, icon: const IconData(1), color: const Color(0xFF00FF00), openingBalance: 0));
      expect(await countAuditEvents(walletIdA, 'ACCOUNT_CREATED'), 1);
      final event = await latestEvent(walletIdA, action: 'ACCOUNT_CREATED');
      expect(event!.walletId, walletIdA);
      expect(event.entityType, 'account');
      expect(event.source, 'user');
    });

    test('ACCOUNT_UPDATED — one event', () async {
      final repo = AccountRepositoryImpl(database.accountDao, walletIdA, walletDao);
      await repo.updateAccount(acct.Account(id: accountIdA, name: 'Updated', type: acct.AccountType.bank, icon: const IconData(0), color: const Color(0xFFFF0000), openingBalance: 0));
      expect(await countAuditEvents(walletIdA, 'ACCOUNT_UPDATED'), 1);
    });

    test('ACCOUNT_DELETED — one event', () async {
      final repo = AccountRepositoryImpl(database.accountDao, walletIdA, walletDao);
      await repo.deleteAccount(accountIdA);
      expect(await countAuditEvents(walletIdA, 'ACCOUNT_DELETED'), 1);
      final event = await latestEvent(walletIdA, action: 'ACCOUNT_DELETED');
      expect(event!.walletId, walletIdA);
    });

    test('Wallet A events do not appear in Wallet B', () async {
      final repoA = AccountRepositoryImpl(database.accountDao, walletIdA, walletDao);
      await repoA.addAccount(acct.Account(id: 0, name: 'X', type: acct.AccountType.cash, icon: const IconData(3), color: const Color(0xFFABCDEF), openingBalance: 0));
      final bEvents = await walletDao.getActivityForWallet(walletIdB, action: 'ACCOUNT_CREATED');
      expect(bEvents, isEmpty);
    });
  });

  // --- Budget Audit ---
  group('Budget Audit Events', () {
    test('BUDGET_CREATED — one event', () async {
      final repo = BudgetRepositoryImpl(database.budgetDao, walletIdA, walletDao);
      await repo.addBudget(budget_domain.Budget(id: 0, walletId: walletIdA, amount: 500, period: '2026-01', category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000))));
      expect(await countAuditEvents(walletIdA, 'BUDGET_CREATED'), 1);
      final event = await latestEvent(walletIdA, action: 'BUDGET_CREATED');
      expect(event!.walletId, walletIdA);
      expect(event.entityType, 'budget');
    });

    test('BUDGET_DELETED — one event', () async {
      final repo = BudgetRepositoryImpl(database.budgetDao, walletIdA, walletDao);
      await repo.addBudget(budget_domain.Budget(id: 0, walletId: walletIdA, amount: 100, period: '2026-01', category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000))));
      final budgets = await (database.select(database.budgets)..where((b) => b.walletId.equals(walletIdA))).get();
      await repo.deleteBudget(budgets.first.id);
      expect(await countAuditEvents(walletIdA, 'BUDGET_DELETED'), 1);
    });
  });

  // --- Transaction Audit ---
  group('Transaction Audit Events', () {
    test('TRANSACTION_CREATED — one event', () async {
      final repo = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao);
      final tx = domain.Transaction(id: 0, amount: 50.0, date: DateTime(2026, 1, 15), note: 'Lunch', type: domain.TransactionType.expense, category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000)), account: acct.Account(id: accountIdA, name: 'A', type: acct.AccountType.bank, icon: const IconData(0), color: const Color(0xFFFF0000)), createdAt: DateTime.now(), updatedAt: DateTime.now());
      await repo.addTransaction(tx);
      expect(await countAuditEvents(walletIdA, 'TRANSACTION_CREATED'), 1);
      final event = await latestEvent(walletIdA, action: 'TRANSACTION_CREATED');
      expect(event!.walletId, walletIdA);
      expect(event.entityType, 'transaction');
    });

    test('TRANSACTION_DELETED — one event with uuid', () async {
      final repo = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao);
      final tx = domain.Transaction(id: 0, amount: 25.0, date: DateTime(2026, 1, 10), note: 'Coffee', type: domain.TransactionType.expense, category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000)), account: acct.Account(id: accountIdA, name: 'A', type: acct.AccountType.bank, icon: const IconData(0), color: const Color(0xFFFF0000)), createdAt: DateTime.now(), updatedAt: DateTime.now());
      await repo.addTransaction(tx);
      final txns = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get();
      await repo.deleteTransaction(txns.first.id);
      expect(await countAuditEvents(walletIdA, 'TRANSACTION_DELETED'), 1);
      final event = await latestEvent(walletIdA, action: 'TRANSACTION_DELETED');
      expect(event!.entityUuid, isNotNull);
    });

    test('Recurring generation — source is recurring, no actor', () async {
      final repo = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao);
      final tx = domain.Transaction(id: 0, amount: 15.0, date: DateTime(2026, 1, 1), note: 'Recurring', type: domain.TransactionType.expense, category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000)), account: acct.Account(id: accountIdA, name: 'A', type: acct.AccountType.bank, icon: const IconData(0), color: const Color(0xFFFF0000)), createdAt: DateTime.now(), updatedAt: DateTime.now());
      await repo.addTransaction(tx, source: 'recurring');
      final event = await latestEvent(walletIdA, action: 'RECURRING_GENERATED');
      expect(event, isNotNull);
      expect(event!.source, 'recurring');
      expect(event.actorAccountId, isNull);
    });
  });

  // --- Split Audit ---
  group('Split Audit Events', () {
    test('SPLIT_CREATED — one event', () async {
      final txnId = await database.into(database.transactions).insert(TransactionsCompanion.insert(walletId: Value(walletIdA), accountId: accountIdA, categoryId: categoryIdA, amount: 100.0, type: db_enums.TransactionType.expense, date: DateTime.now()));
      final splitId = await walletDao.insertSplit(WalletExpenseSplitsCompanion.insert(walletId: walletIdA, transactionId: txnId, paidByMemberId: memberIdA, splitMethod: WalletExpenseSplitMethod.equal), walletIdA);
      expect(await countAuditEvents(walletIdA, 'SPLIT_CREATED'), 1);
      final event = await latestEvent(walletIdA, action: 'SPLIT_CREATED');
      expect(event!.entityType, 'split');
    });

    test('SPLIT_DELETED — one event', () async {
      final txnId = await database.into(database.transactions).insert(TransactionsCompanion.insert(walletId: Value(walletIdA), accountId: accountIdA, categoryId: categoryIdA, amount: 100.0, type: db_enums.TransactionType.expense, date: DateTime.now()));
      final splitId = await walletDao.insertSplit(WalletExpenseSplitsCompanion.insert(walletId: walletIdA, transactionId: txnId, paidByMemberId: memberIdA, splitMethod: WalletExpenseSplitMethod.equal), walletIdA);
      await walletDao.deleteSplit(splitId, walletIdA);
      expect(await countAuditEvents(walletIdA, 'SPLIT_DELETED'), 1);
    });
  });

  // --- Settlement Audit ---
  group('Settlement Audit Events', () {
    test('SETTLEMENT_CREATED — one event', () async {
      await walletDao.insertSettlement(WalletSettlementsCompanion.insert(walletId: walletIdA, payerMemberId: memberIdA, receiverMemberId: memberIdA, amount: 50.0), walletIdA);
      expect(await countAuditEvents(walletIdA, 'SETTLEMENT_CREATED'), 1);
    });

    test('SETTLEMENT_DELETED — one event', () async {
      final id = await walletDao.insertSettlement(WalletSettlementsCompanion.insert(walletId: walletIdA, payerMemberId: memberIdA, receiverMemberId: memberIdA, amount: 50.0), walletIdA);
      await walletDao.deleteSettlement(id, walletIdA);
      expect(await countAuditEvents(walletIdA, 'SETTLEMENT_DELETED'), 1);
    });
  });

  // --- PeerDebt Audit ---
  group('PeerDebt Audit Events', () {
    test('PEER_DEBT_CREATED — one event', () async {
      await walletDao.insertPeerDebt(PeerDebtsCompanion.insert(walletId: walletIdA, personName: 'Alice', type: db_enums.PeerDebtType.lent, amount: 200.0, date: DateTime(2026, 1, 1)), walletIdA);
      expect(await countAuditEvents(walletIdA, 'PEER_DEBT_CREATED'), 1);
    });

    test('PEER_DEBT_DELETED — one event', () async {
      final id = await walletDao.insertPeerDebt(PeerDebtsCompanion.insert(walletId: walletIdA, personName: 'Alice', type: db_enums.PeerDebtType.lent, amount: 200.0, date: DateTime(2026, 1, 1)), walletIdA);
      await walletDao.deletePeerDebt(id, walletIdA);
      expect(await countAuditEvents(walletIdA, 'PEER_DEBT_DELETED'), 1);
    });
  });

  // --- Membership Audit ---
  group('Membership Audit Events', () {
    test('MEMBER_DEACTIVATED — one event', () async {
      final acctId = await database.into(database.accounts).insert(AccountsCompanion.insert(walletId: Value(walletIdA), name: 'U2', type: AccountType.bank, icon: 1, color: '00FF00'));
      await walletDao.insertMember(WalletMembersCompanion.insert(walletId: walletIdA, accountId: acctId, role: WalletRole.member));
      await walletDao.deactivateMember(walletIdA, acctId);
      expect(await countAuditEvents(walletIdA, 'MEMBER_DEACTIVATED'), 1);
    });
  });

  // --- Wallet Isolation ---
  group('Wallet Isolation', () {
    test('Audit event wallet matches business entity wallet', () async {
      final repo = AccountRepositoryImpl(database.accountDao, walletIdA, walletDao);
      await repo.addAccount(acct.Account(id: 0, name: 'Isolated', type: acct.AccountType.cash, icon: const IconData(0), color: const Color(0xFF000000), openingBalance: 0));
      final eventsA = await walletDao.getActivityForWallet(walletIdA, action: 'ACCOUNT_CREATED');
      expect(eventsA.length, 1);
      expect(eventsA.first.walletId, walletIdA);
      // Wallet B has no events.
      final eventsB = await walletDao.getActivityForWallet(walletIdB, action: 'ACCOUNT_CREATED');
      expect(eventsB, isEmpty);
    });
  });

  // --- Sensitive Data ---
  group('Sensitive Data', () {
    test('Transaction audit does not store amount or notes', () async {
      final repo = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao);
      final tx = domain.Transaction(id: 0, amount: 999999.0, date: DateTime(2026, 1, 1), note: 'SECRET: SSN 123-45-6789', type: domain.TransactionType.expense, category: cat.Category(id: categoryIdA, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000)), account: acct.Account(id: accountIdA, name: 'A', type: acct.AccountType.bank, icon: const IconData(0), color: const Color(0xFFFF0000)), createdAt: DateTime.now(), updatedAt: DateTime.now());
      await repo.addTransaction(tx);
      final event = await latestEvent(walletIdA, action: 'TRANSACTION_CREATED');
      expect(event, isNotNull);
      expect(event!.details, isNull);
    });
  });
}

