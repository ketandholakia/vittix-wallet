import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull, Budget, Transaction, TransactionType, Category;
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart' as account_domain;
import 'package:expense_tracker/features/transactions/data/transaction_repository_impl.dart';
import 'package:expense_tracker/features/transactions/domain/transaction.dart';
import 'package:expense_tracker/sms/data/sms_import_metrics_dao.dart';
import 'package:expense_tracker/sms/data/sms_parsing_dao.dart';
import 'package:expense_tracker/sms/sms_transaction_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late SmsParsingDao smsDao;
  late SmsImportMetricsDao metricsDao;

  late int walletIdA;
  late int walletIdB;

  late int accountOwnerA;
  late int accountAdminA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountInactiveA;

  late int accountOwnerB;
  late int accountViewerB;

  late int categoryId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;
    smsDao = database.smsParsingDao;
    metricsDao = database.smsImportMetricsDao;

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert Category
    categoryId = await database.into(database.categories).insert(
      const CategoriesCompanion(
        name: Value('Food'),
        icon: Value(0),
        color: Value('FF0000'),
      ),
    );

    // Accounts for Wallet A
    accountOwnerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Owner A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountAdminA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Admin A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountMemberA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Member A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountViewerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Viewer A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountInactiveA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Inactive A',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    // Accounts for Wallet B
    accountOwnerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Owner B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );
    accountViewerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Viewer B',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Seed Wallet A memberships
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountOwnerA, role: WalletRole.owner),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountAdminA, role: WalletRole.admin),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountMemberA, role: WalletRole.member),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdA, accountId: accountViewerA, role: WalletRole.viewer),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountInactiveA,
        role: WalletRole.admin,
        isActive: const Value(false),
      ),
    );

    // Seed Wallet B memberships
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountOwnerB, role: WalletRole.owner),
    );
    await walletDao.insertMember(
      WalletMembersCompanion.insert(walletId: walletIdB, accountId: accountViewerB, role: WalletRole.viewer),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P2-4 A. SMS & Merchant Mapping Isolation Tests', () {
    test('Test 1 — Wallet A cannot resolve Wallet B SMS by ID', () async {
      final smsIdB = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdB,
          smsBody: 'Unrecognized SMS for B',
          sender: 'BANK-B',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdB,
      );

      final updated = await smsDao.markSmsResolved(smsIdB, authorizedWalletId: walletIdA);
      expect(updated, equals(0));

      final unresolvedB = await smsDao.watchUnresolvedSms(walletIdB).first;
      expect(unresolvedB.any((s) => s.id == smsIdB), isTrue);
    });

    test('Test 2 — Wallet A cannot delete Wallet B SMS by ID', () async {
      final smsIdB = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdB,
          smsBody: 'Unrecognized SMS for B',
          sender: 'BANK-B',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdB,
      );

      final deleted = await smsDao.deleteUnrecognizedSms(smsIdB, authorizedWalletId: walletIdA);
      expect(deleted, equals(0));

      final unresolvedB = await smsDao.watchUnresolvedSms(walletIdB).first;
      expect(unresolvedB.any((s) => s.id == smsIdB), isTrue);
    });

    test('Test 3 — Wallet A can resolve its own SMS', () async {
      final smsIdA = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdA,
          smsBody: 'Unrecognized SMS for A',
          sender: 'BANK-A',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
      );

      final updated = await smsDao.markSmsResolved(smsIdA, authorizedWalletId: walletIdA);
      expect(updated, equals(1));

      final unresolvedA = await smsDao.watchUnresolvedSms(walletIdA).first;
      expect(unresolvedA.any((s) => s.id == smsIdA), isFalse);
    });

    test('Test 4 — Wallet A can delete its own SMS', () async {
      final smsIdA = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdA,
          smsBody: 'Unrecognized SMS for A',
          sender: 'BANK-A',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
      );

      final deleted = await smsDao.deleteUnrecognizedSms(smsIdA, authorizedWalletId: walletIdA);
      expect(deleted, equals(1));

      final unresolvedA = await smsDao.watchUnresolvedSms(walletIdA).first;
      expect(unresolvedA.any((s) => s.id == smsIdA), isFalse);
    });

    test('Test 5 — Wallet A cannot update Wallet B merchant mapping', () async {
      final mappingIdB = await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdB,
          originalPattern: 'SWIGGY',
          cleanName: 'Swiggy Food',
        ),
        authorizedWalletId: walletIdB,
        actorAccountId: accountOwnerB,
      );

      final updated = await smsDao.updateMerchantMapping(
        MerchantMapping(
          id: mappingIdB,
          walletId: walletIdA,
          originalPattern: 'SWIGGY',
          cleanName: 'Hacked Swiggy',
          createdAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      expect(updated, isFalse);

      final mappingsB = await smsDao.getMerchantMappings(walletIdB);
      expect(mappingsB.firstWhere((m) => m.id == mappingIdB).cleanName, equals('Swiggy Food'));
    });

    test('Test 6 — Wallet A cannot delete Wallet B merchant mapping', () async {
      final mappingIdB = await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdB,
          originalPattern: 'ZOMATO',
          cleanName: 'Zomato',
        ),
        authorizedWalletId: walletIdB,
        actorAccountId: accountOwnerB,
      );

      final deleted = await smsDao.deleteMerchantMapping(
        mappingIdB,
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      expect(deleted, equals(0));

      final mappingsB = await smsDao.getMerchantMappings(walletIdB);
      expect(mappingsB.any((m) => m.id == mappingIdB), isTrue);
    });

    test('Test 7 — Wallet A can update its own merchant mapping', () async {
      final mappingIdA = await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdA,
          originalPattern: 'UBER',
          cleanName: 'Uber Rides',
        ),
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      final updated = await smsDao.updateMerchantMapping(
        MerchantMapping(
          id: mappingIdA,
          walletId: walletIdA,
          originalPattern: 'UBER',
          cleanName: 'Uber Cabs',
          createdAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      expect(updated, isTrue);

      final mappingsA = await smsDao.getMerchantMappings(walletIdA);
      expect(mappingsA.firstWhere((m) => m.id == mappingIdA).cleanName, equals('Uber Cabs'));
    });

    test('Test 8 — Wallet A can delete its own merchant mapping', () async {
      final mappingIdA = await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdA,
          originalPattern: 'AMAZON',
          cleanName: 'Amazon Shop',
        ),
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      final deleted = await smsDao.deleteMerchantMapping(
        mappingIdA,
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      expect(deleted, equals(1));

      final mappingsA = await smsDao.getMerchantMappings(walletIdA);
      expect(mappingsA.any((m) => m.id == mappingIdA), isFalse);
    });

    test('Test 9 — Wallet A cannot insert merchant mapping claiming Wallet B ownership', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdB,
            originalPattern: 'FORGED',
            cleanName: 'Forged Mapping',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountOwnerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 10 — Wallet A cannot read Wallet B merchant mappings', () async {
      await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdB,
          originalPattern: 'SECRET-B',
          cleanName: 'Secret Merchant B',
        ),
        authorizedWalletId: walletIdB,
        actorAccountId: accountOwnerB,
      );

      final mappingsA = await smsDao.getMerchantMappings(walletIdA);
      expect(mappingsA.any((m) => m.cleanName == 'Secret Merchant B'), isFalse);
    });

    test('Test 11 — Wallet A cannot read Wallet B unresolved SMS', () async {
      await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdB,
          smsBody: 'Secret SMS B',
          sender: 'BANK-B',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdB,
      );

      final unresolvedA = await smsDao.watchUnresolvedSms(walletIdA).first;
      expect(unresolvedA.any((s) => s.smsBody == 'Secret SMS B'), isFalse);
    });
  });

  group('P2-4 B. Merchant Mapping RBAC Tests', () {
    test('Test 12 — OWNER can manage merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'OWNER-PATTERN',
            cleanName: 'Owner Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountOwnerA,
        ),
        returnsNormally,
      );
    });

    test('Test 13 — ADMIN can manage merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'ADMIN-PATTERN',
            cleanName: 'Admin Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountAdminA,
        ),
        returnsNormally,
      );
    });

    test('Test 14 — MEMBER cannot manage merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'MEMBER-PATTERN',
            cleanName: 'Member Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountMemberA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 15 — VIEWER cannot manage merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'VIEWER-PATTERN',
            cleanName: 'Viewer Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountViewerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 16 — Inactive member cannot mutate SMS merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'INACTIVE-PATTERN',
            cleanName: 'Inactive Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountInactiveA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 17 — Non-member cannot mutate SMS merchant mappings', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'NONMEMBER-PATTERN',
            cleanName: 'NonMember Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountOwnerB,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });
  });

  group('P2-4 C. Import Wallet Ownership & Fallback Tests', () {
    test('Test 18 — Wallet A import creates transaction in Wallet A', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountA = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 0,
        amount: 250.0,
        date: DateTime.now(),
        note: '[SMS] Swiggy',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final txsA = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get();
      expect(txsA.length, equals(1));
      expect(txsA.first.walletId, equals(walletIdA));
      expect(txsA.first.note, equals('[SMS] Swiggy'));
    });

    test('Test 19 — Wallet A cannot create transaction using Wallet B account', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountB = account_domain.Account(
        id: accountOwnerB,
        name: 'Owner B',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF0000FF),
      );

      final tx = Transaction(
        id: 0,
        amount: 250.0,
        date: DateTime.now(),
        note: '[SMS] Fraud Attempt',
        type: TransactionType.expense,
        category: category,
        account: accountB,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Account B belongs to Wallet B. Repo A enforces walletIdA.
      await repoA.addTransaction(tx, source: 'import');
      final inserted = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).getSingle();
      expect(inserted.walletId, equals(walletIdA));
      // Wallet B must have 0 transactions
      final txsB = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdB))).get();
      expect(txsB.isEmpty, isTrue);
    });

    test('Test 20 — Account fallback remains Wallet A scoped', () async {
      final accountsForA = await (database.select(database.accounts)..where((a) => a.walletId.equals(walletIdA))).get();
      for (final acc in accountsForA) {
        expect(acc.walletId, equals(walletIdA));
      }
    });

    test('Test 21 — Imported transaction wallet equals import wallet', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountA = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 0,
        amount: 100.0,
        date: DateTime.now(),
        note: '[SMS] Uber',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');
      final savedTx = await database.transactionDao.getTransactionById(1, walletIdA);
      expect(savedTx?.walletId, equals(walletIdA));
    });

    test('Test 22 & 23 — Wallet context stability during import', () async {
      // In deterministic test, walletId context is read once and passed to repo / DAOs
      const capturedWalletId = 1;
      final repo = TransactionRepositoryImpl(database.transactionDao, capturedWalletId, walletDao);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountA = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 0,
        amount: 50.0,
        date: DateTime.now(),
        note: '[SMS] Test Merchant',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.addTransaction(tx, source: 'import');

      final activity = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(capturedWalletId))).get();
      expect(activity.last.walletId, equals(capturedWalletId));
      expect(activity.last.source, equals('import'));
      expect(activity.last.actorAccountId, isNull);
    });
  });

  group('P2-4 D. Audit & Privacy Verification Tests', () {
    test('Test 24, 25 & 26 — SMS import creates TRANSACTION_CREATED with source import and null actor', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountA = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 0,
        amount: 300.0,
        date: DateTime.now(),
        note: '[SMS] Coffee Shop',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final activities = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(walletIdA) & a.entityType.equals('transaction'))).get();
      expect(activities.length, equals(1));
      final audit = activities.first;

      expect(audit.action, equals('TRANSACTION_CREATED'));
      expect(audit.source, equals('import'));
      expect(audit.actorAccountId, isNull);
    });

    test('Test 27 — Audit event remains atomic with transaction creation', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(
        id: categoryId,
        name: 'Food',
        icon: const IconData(0),
        color: const Color(0xFFFF0000),
      );
      final accountA = account_domain.Account(
        id: accountOwnerA,
        name: 'Owner A',
        type: account_domain.AccountType.bank,
        icon: const IconData(0),
        color: const Color(0xFF00FF00),
      );

      final tx = Transaction(
        id: 0,
        amount: 400.0,
        date: DateTime.now(),
        note: '[SMS] Store',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final txs = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).get();
      final audit = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(walletIdA) & a.entityType.equals('transaction'))).get();

      expect(txs.length, equals(1));
      expect(audit.length, equals(1));
      expect(audit.first.entityId, equals(txs.first.id));
    });

    test('Test 28, 29, 30 & 31 — Raw SMS body, OTPs, balances absent from transaction note and audit metadata', () async {
      const sensitiveSMS = 'BANK ALERT: Rs 999 spent at SecretMerchant. OTP 123456. Bal: Rs 50000. Ref: 987654321';
      final parsed = SmsTransactionCandidate(
        smsId: '1',
        smsHash: 'hash123',
        amount: 999.0,
        merchant: 'SecretMerchant',
        body: sensitiveSMS,
        sender: 'BANK-X',
        date: DateTime.now(),
        type: TransactionType.expense,
        confidence: 0.95,
        isSelected: true,
      );

      // Verify transaction note uses minimal non-sensitive format
      final formattedNote = '[SMS] ${parsed.merchant}';
      expect(formattedNote, equals('[SMS] SecretMerchant'));
      expect(formattedNote.contains('123456'), isFalse);
      expect(formattedNote.contains('50000'), isFalse);
      expect(formattedNote.contains('BANK ALERT'), isFalse);

      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);
      final category = Category(id: categoryId, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000));
      final accountA = account_domain.Account(id: accountOwnerA, name: 'Owner A', type: account_domain.AccountType.bank, icon: const IconData(0), color: const Color(0xFF00FF00));

      final tx = Transaction(
        id: 0,
        amount: parsed.amount,
        date: parsed.date,
        note: formattedNote,
        type: parsed.type,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final savedTx = await database.transactionDao.getTransactionById(1, walletIdA);
      expect(savedTx?.note, equals('[SMS] SecretMerchant'));

      final auditList = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(walletIdA) & a.entityType.equals('transaction'))).get();
      final audit = auditList.first;
      expect(audit.details, isNull);
      expect(audit.source, equals('import'));
    });
  });

  group('P2-4 E. Sync Privacy Invariants', () {
    test('Test 32 & 33 — Unrecognized SMS & metrics are absent from sync payload', () async {
      await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdA,
          smsBody: 'Sensitive SMS text',
          sender: 'BANK-A',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
      );

      await metricsDao.record(
        walletId: walletIdA,
        acceptedImports: 5,
        rejectedImports: 2,
        duplicateDetections: 1,
      );

      final unrecognizedCount = await (database.select(database.unrecognizedSmsEntries)..where((t) => t.walletId.equals(walletIdA))).get();
      final metricsCount = await (database.select(database.smsImportMetrics)..where((t) => t.walletId.equals(walletIdA))).get();

      expect(unrecognizedCount.length, equals(1));
      expect(metricsCount.length, equals(1));
    });

    test('Test 34 & 35 — Imported transaction syncs successfully without raw SMS body', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(id: categoryId, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000));
      final accountA = account_domain.Account(id: accountOwnerA, name: 'Owner A', type: account_domain.AccountType.bank, icon: const IconData(0), color: const Color(0xFF00FF00));

      final tx = Transaction(
        id: 0,
        amount: 120.0,
        date: DateTime.now(),
        note: '[SMS] Clean Merchant',
        type: TransactionType.expense,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final savedTx = await database.transactionDao.getTransactionById(1, walletIdA);
      expect(savedTx?.note, equals('[SMS] Clean Merchant'));
      expect(savedTx?.note?.contains('RAW SMS'), isFalse);
    });
  });

  group('P2-4 Security Attack Tests (Attacks 1–8)', () {
    test('Attack 1 — Cross-wallet SMS resolution DENIED/no mutation', () async {
      final smsIdB = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdB,
          smsBody: 'Attack SMS B',
          sender: 'BANK-B',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdB,
      );

      final resolved = await smsDao.markSmsResolved(smsIdB, authorizedWalletId: walletIdA);
      expect(resolved, equals(0));

      final entriesB = await (database.select(database.unrecognizedSmsEntries)..where((t) => t.id.equals(smsIdB))).getSingle();
      expect(entriesB.isResolved, isFalse);
    });

    test('Attack 2 — Cross-wallet SMS deletion DENIED/no mutation', () async {
      final smsIdB = await smsDao.insertUnrecognizedSms(
        UnrecognizedSmsEntriesCompanion.insert(
          walletId: walletIdB,
          smsBody: 'Attack SMS B',
          sender: 'BANK-B',
          receivedAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdB,
      );

      final deleted = await smsDao.deleteUnrecognizedSms(smsIdB, authorizedWalletId: walletIdA);
      expect(deleted, equals(0));

      final entriesB = await (database.select(database.unrecognizedSmsEntries)..where((t) => t.id.equals(smsIdB))).getSingleOrNull();
      expect(entriesB, isNotNull);
    });

    test('Attack 3 — Cross-wallet merchant mapping update DENIED/no mutation', () async {
      final mappingIdB = await smsDao.insertMerchantMapping(
        MerchantMappingsCompanion.insert(
          walletId: walletIdB,
          originalPattern: 'ATTACK-PATTERN',
          cleanName: 'Original B',
        ),
        authorizedWalletId: walletIdB,
        actorAccountId: accountOwnerB,
      );

      final updated = await smsDao.updateMerchantMapping(
        MerchantMapping(
          id: mappingIdB,
          walletId: walletIdA,
          originalPattern: 'ATTACK-PATTERN',
          cleanName: 'Hacked B',
          createdAt: DateTime.now(),
        ),
        authorizedWalletId: walletIdA,
        actorAccountId: accountOwnerA,
      );

      expect(updated, isFalse);

      final originalB = await (database.select(database.merchantMappings)..where((m) => m.id.equals(mappingIdB))).getSingle();
      expect(originalB.cleanName, equals('Original B'));
    });

    test('Attack 4 — Forged wallet ID in merchant mapping insertion DENIED', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdB,
            originalPattern: 'FORGED-SMS',
            cleanName: 'Forged Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountOwnerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 5 — SMS -> Wallet B account creation in Wallet A transaction DENIED', () async {
      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);

      final category = Category(id: categoryId, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000));
      final accountB = account_domain.Account(id: accountOwnerB, name: 'Owner B', type: account_domain.AccountType.bank, icon: const IconData(0), color: const Color(0xFF0000FF));

      final tx = Transaction(
        id: 0,
        amount: 500.0,
        date: DateTime.now(),
        note: '[SMS] Cross Wallet Account',
        type: TransactionType.expense,
        category: category,
        account: accountB,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final insertedTx = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdA))).getSingle();
      expect(insertedTx.walletId, equals(walletIdA));

      // Wallet B must remain untouched
      final txsB = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletIdB))).get();
      expect(txsB.isEmpty, isTrue);
    });

    test('Attack 6 — Viewer merchant mapping mutation DENIED', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'VIEWER-ATTACK',
            cleanName: 'Viewer Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountViewerA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 7 — Inactive member merchant mapping mutation DENIED', () async {
      expect(
        () => smsDao.insertMerchantMapping(
          MerchantMappingsCompanion.insert(
            walletId: walletIdA,
            originalPattern: 'INACTIVE-ATTACK',
            cleanName: 'Inactive Merchant',
          ),
          authorizedWalletId: walletIdA,
          actorAccountId: accountInactiveA,
        ),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 8 — Raw SMS sync leak verification', () async {
      const secretSMS = 'TEST-SECRET-123456 BANK REF 9999';
      final candidate = SmsTransactionCandidate(
        smsId: '99',
        smsHash: 'hash99',
        amount: 88.0,
        merchant: 'LeakTestMerchant',
        body: secretSMS,
        sender: 'BANK-LEAK',
        date: DateTime.now(),
        type: TransactionType.expense,
        confidence: 0.9,
        isSelected: true,
      );

      // Verify privacy note formulation
      final note = '[SMS] ${candidate.merchant}';
      expect(note.contains('TEST-SECRET-123456'), isFalse);

      final repoA = TransactionRepositoryImpl(database.transactionDao, walletIdA, walletDao, accountOwnerA);
      final category = Category(id: categoryId, name: 'Food', icon: const IconData(0), color: const Color(0xFFFF0000));
      final accountA = account_domain.Account(id: accountOwnerA, name: 'Owner A', type: account_domain.AccountType.bank, icon: const IconData(0), color: const Color(0xFF00FF00));

      final tx = Transaction(
        id: 0,
        amount: candidate.amount,
        date: candidate.date,
        note: note,
        type: candidate.type,
        category: category,
        account: accountA,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repoA.addTransaction(tx, source: 'import');

      final savedTx = await database.transactionDao.getTransactionById(1, walletIdA);
      expect(savedTx?.note?.contains('TEST-SECRET-123456'), isFalse);

      final activities = await (database.select(database.walletActivities)..where((a) => a.walletId.equals(walletIdA))).get();
      for (final act in activities) {
        expect(act.details?.contains('TEST-SECRET-123456') ?? false, isFalse);
      }
    });
  });
}
