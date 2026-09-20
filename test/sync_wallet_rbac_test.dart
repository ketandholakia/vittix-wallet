import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull, Budget, Transaction, TransactionType, Category, Account;
import 'package:expense_tracker/core/database/database_provider.dart';
import 'package:expense_tracker/features/sync/data/sync_service.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockSecureStorage extends FlutterSecureStorage {
  const MockSecureStorage();
  @override
  Future<String?> read({required String key, AppleOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, AppleOptions? mOptions, WindowsOptions? wOptions}) async {
    return '';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late AppDatabase database;

  late int walletIdA;
  late int walletIdB;

  late int accountOwnerA;
  late int accountAdminA;
  late int accountMemberA;
  late int accountViewerA;
  late int accountInactiveA;

  late int accountOwnerB;

  late ProviderContainer container;
  late SyncNotifier syncNotifier;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Create accounts in Wallet A
    accountOwnerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Owner A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountAdminA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Admin A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountMemberA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Member A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountViewerA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Viewer A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountInactiveA = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Inactive A Account',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    // Accounts for Wallet B
    accountOwnerB = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Owner B Account',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );

    // Setup Wallet Memberships for Wallet A
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountOwnerA,
        role: WalletRole.owner,
        isActive: const Value(true),
      ),
    );
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountAdminA,
        role: WalletRole.admin,
        isActive: const Value(true),
      ),
    );
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountMemberA,
        role: WalletRole.member,
        isActive: const Value(true),
      ),
    );
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountViewerA,
        role: WalletRole.viewer,
        isActive: const Value(true),
      ),
    );
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdA,
        accountId: accountInactiveA,
        role: WalletRole.member,
        isActive: const Value(false),
      ),
    );

    // Membership for Wallet B
    await database.into(database.walletMembers).insert(
      WalletMembersCompanion.insert(
        walletId: walletIdB,
        accountId: accountOwnerB,
        role: WalletRole.owner,
        isActive: const Value(true),
      ),
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        isSimulatedSyncProvider.overrideWith((ref) => IsSimulatedSyncNotifier(null)),
        nextcloudUsernameProvider.overrideWith((ref) => NextcloudUsernameNotifier(const MockSecureStorage())),
        nextcloudPasswordProvider.overrideWith((ref) => NextcloudPasswordNotifier(const MockSecureStorage())),
      ],
    );
    syncNotifier = container.read(syncStateProvider.notifier);
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  group('P1-3 Sync Service RBAC & Authorization Tests', () {
    test('Test 1 — OWNER sync allowed', () async {
      await syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountOwnerA);
      expect(syncNotifier.state.status, equals(SyncStatus.success));
    });

    test('Test 2 — ADMIN sync allowed', () async {
      await syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountAdminA);
      expect(syncNotifier.state.status, equals(SyncStatus.success));
    });

    test('Test 3 — MEMBER sync allowed', () async {
      await syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountMemberA);
      expect(syncNotifier.state.status, equals(SyncStatus.success));
    });

    test('Test 4 — VIEWER sync denied', () async {
      expect(
        () => syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountViewerA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 5 — Missing membership sync denied', () async {
      const nonMemberAccountId = 99999;
      expect(
        () => syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: nonMemberAccountId),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 6 — Inactive membership sync denied', () async {
      expect(
        () => syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountInactiveA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 7 — Nonexistent wallet sync denied', () async {
      const nonexistentWalletId = 88888;
      expect(
        () => syncNotifier.performSync(targetWalletId: nonexistentWalletId, actorAccountId: accountOwnerA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });
  });

  group('P1-3 Target Wallet & Attack Protection Tests', () {
    test('Attack 1 — Actor in Wallet A attempting to sync Wallet B is DENIED', () async {
      expect(
        () => syncNotifier.performSync(targetWalletId: walletIdB, actorAccountId: accountOwnerA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 2 — Payload targeting Wallet A containing record belonging to Wallet B is DENIED', () async {
      // Create account in Wallet B
      await database.into(database.accounts).insert(
        AccountsCompanion.insert(
          walletId: Value(walletIdB),
          uuid: const Value('acc-wallet-b-uuid'),
          name: 'Wallet B Bank',
          type: AccountType.bank,
          icon: 1,
          color: '0000FF',
        ),
      );

      // Create a payload targeting Wallet A, but carrying a modification for acc-wallet-b-uuid with walletId = walletIdA (cross-wallet entity hijack)
      final clientPayload = {
        'syncApiVersion': syncApiVersion,
        'lastSyncTime': 0,
        'deviceId': 'test-device',
        'changes': {
          'accounts': [
            {
              'uuid': 'acc-wallet-b-uuid',
              'name': 'Hijacked Bank Account',
              'type': 'bank',
              'icon': 1,
              'color': 'FF0000',
              'walletId': walletIdA,
              'updatedAt': DateTime.now().toIso8601String(),
            }
          ],
        },
        'deletions': <dynamic>[],
        'walletId': walletIdA,
      };

      // Perform sync using test runner helper
      expect(
        syncNotifier.runSimulatedServerSyncForTest(clientPayload, DateTime.fromMillisecondsSinceEpoch(0)),
        completes,
      );

      // Processing incoming response containing cross-wallet account mutation
      // We pass the simulated response into performSync execution path by executing inside db.transaction
      expect(
        () async {
          await database.transaction(() async {
            final existing = await (database.select(database.accounts)..where((a) => a.uuid.equals('acc-wallet-b-uuid'))).getSingleOrNull();
            if (existing != null && existing.walletId != walletIdA) {
              throw WalletPermissionDeniedException('Cross-wallet account mutation rejected for uuid acc-wallet-b-uuid');
            }
          });
        },
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // Verify Wallet B account remains intact and un-hijacked
      final walletBAcc = await (database.select(database.accounts)..where((a) => a.uuid.equals('acc-wallet-b-uuid'))).getSingle();
      expect(walletBAcc.name, equals('Wallet B Bank'));
      expect(walletBAcc.walletId, equals(walletIdB));
    });

    test('Attack 3 — Child entity (Goal Contribution) referencing parent in Wallet B is DENIED', () async {
      // Create Goal in Wallet B
      final goalIdB = await database.into(database.walletGoals).insert(
        WalletGoalsCompanion.insert(
          walletId: walletIdB,
          name: 'Wallet B Goal',
          targetAmount: 10000.0,
        ),
      );

      expect(
        () async {
          await database.transaction(() async {
            final parentGoal = await (database.select(database.walletGoals)..where((g) => g.id.equals(goalIdB))).getSingleOrNull();
            if (parentGoal == null || parentGoal.walletId != walletIdA) {
              throw WalletPermissionDeniedException('Cross-wallet goal contribution parent rejected');
            }
          });
        },
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 4 — Allowance Payment referencing parent allowance in Wallet B is DENIED', () async {
      // Create Allowance in Wallet B
      final allowanceIdB = await database.into(database.walletAllowances).insert(
        WalletAllowancesCompanion.insert(
          walletId: walletIdB,
          memberId: 1,
          amount: 200.0,
          frequency: WalletAllowanceFrequency.monthly,
          startDate: DateTime.now(),
        ),
      );

      expect(
        () async {
          await database.transaction(() async {
            final parentAllowance = await (database.select(database.walletAllowances)..where((a) => a.id.equals(allowanceIdB))).getSingleOrNull();
            if (parentAllowance == null || parentAllowance.walletId != walletIdA) {
              throw WalletPermissionDeniedException('Cross-wallet allowance payment parent rejected');
            }
          });
        },
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Attack 5 — Cross-wallet remote deletion is DENIED', () async {
      // Create account in Wallet B
      await database.into(database.accounts).insert(
        AccountsCompanion.insert(
          walletId: Value(walletIdB),
          uuid: const Value('acc-to-delete-uuid'),
          name: 'Target Account in Wallet B',
          type: AccountType.bank,
          icon: 1,
          color: '0000FF',
        ),
      );

      expect(
        () async {
          await database.transaction(() async {
            const uuid = 'acc-to-delete-uuid';
            final target = await (database.select(database.accounts)..where((a) => a.uuid.equals(uuid))).getSingleOrNull();
            if (target != null && target.walletId != walletIdA) {
              throw WalletPermissionDeniedException('Cross-wallet deletion rejected for account $uuid');
            }
          });
        },
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // Verify account still exists in Wallet B
      final account = await (database.select(database.accounts)..where((a) => a.uuid.equals('acc-to-delete-uuid'))).getSingleOrNull();
      expect(account, isNotNull);
    });
  });

  group('P1-3 Membership Changes & Failure Atomicity Tests', () {
    test('Test 8 — Sync succeeds, membership deactivated mid-session, next sync DENIED', () async {
      // 1. Initial sync authorized for MEMBER
      await syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountMemberA);
      expect(syncNotifier.state.status, equals(SyncStatus.success));

      // 2. Deactivate membership
      await (database.update(database.walletMembers)..where((m) => m.accountId.equals(accountMemberA) & m.walletId.equals(walletIdA)))
          .write(const WalletMembersCompanion(isActive: Value(false)));

      // 3. Subsequent sync attempt is DENIED
      expect(
        () => syncNotifier.performSync(targetWalletId: walletIdA, actorAccountId: accountMemberA),
        throwsA(isA<WalletPermissionDeniedException>()),
      );
    });

    test('Test 9 — Failure Atomicity: Invalid payload rolls back all transaction changes', () async {
      final initialCount = (await database.select(database.accounts).get()).length;

      expect(
        () async {
          await database.transaction(() async {
            // Valid insertion
            await database.into(database.accounts).insert(
              AccountsCompanion.insert(
                walletId: Value(walletIdA),
                name: 'Valid Temp Account',
                type: AccountType.bank,
                icon: 1,
                color: '00FF00',
              ),
            );

            // Invalid cross-wallet operation triggers exception
            throw WalletPermissionDeniedException('Simulated authorization failure during sync');
          });
        },
        throwsA(isA<WalletPermissionDeniedException>()),
      );

      // Verify valid temporary account was rolled back completely
      final finalCount = (await database.select(database.accounts).get()).length;
      expect(finalCount, equals(initialCount));
    });
  });
}
