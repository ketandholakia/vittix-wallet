import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide isNull, isNotNull;
import 'package:expense_tracker/features/family/data/wallet_invitation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late WalletDao walletDao;
  late WalletInvitationRepository invitationRepo;

  late int walletIdA;
  late int walletIdB;
  late int accountIdA1;
  late int accountIdA2;
  late int accountIdA3;
  late int accountIdB1;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    walletDao = database.walletDao;
    invitationRepo = WalletInvitationRepositoryImpl(walletDao);

    // Create Wallet A & Wallet B
    walletIdA = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet A')),
    );
    walletIdB = await database.into(database.wallets).insert(
      const WalletsCompanion(name: Value('Wallet B')),
    );

    // Insert Accounts for members
    accountIdA1 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Account A1',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountIdA2 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Account A2',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );
    accountIdA3 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdA),
        name: 'Account A3',
        type: AccountType.bank,
        icon: 0,
        color: '00FF00',
      ),
    );

    accountIdB1 = await database.into(database.accounts).insert(
      AccountsCompanion.insert(
        walletId: Value(walletIdB),
        name: 'Account B1',
        type: AccountType.bank,
        icon: 0,
        color: '0000FF',
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('P0-4 Last-Owner Protection Tests', () {
    test('Test 1 — Wallet Starts With Owner', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );

      final count = await walletDao.countActiveOwners(walletIdA);
      expect(count, equals(1));

      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.length, equals(1));
      expect(members.first.role, equals(WalletRole.owner));
    });

    test('Test 2 — Multiple Owners', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.owner,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(2));

      // Deactivate one owner
      await walletDao.deactivateMember(walletIdA, accountIdA1);

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final activeMembers = await walletDao.getMembersForWallet(walletIdA);
      expect(activeMembers.length, equals(1));
      expect(activeMembers.first.accountId, equals(accountIdA2));
    });

    test('Test 3 — Cannot Remove Last Owner', () async {
      final ownerMemberId = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.member,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));

      // Attempt deactivateMember on last owner -> throws LastOwnerException
      expect(
        () => walletDao.deactivateMember(walletIdA, accountIdA1),
        throwsA(isA<LastOwnerException>()),
      );

      // Attempt deleteMember on last owner -> throws LastOwnerException
      expect(
        () => walletDao.deleteMember(ownerMemberId),
        throwsA(isA<LastOwnerException>()),
      );

      // Verify owner is still active
      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.any((m) => m.accountId == accountIdA1 && m.role == WalletRole.owner), isTrue);
    });

    test('Test 4 — Cannot Demote Last Owner', () async {
      final ownerMemberId = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.member,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));

      // Attempt to demote owner -> admin
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(ownerMemberId),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA1),
            role: const Value(WalletRole.admin),
          ),
        ),
        throwsA(isA<LastOwnerException>()),
      );

      // Attempt to demote owner -> member
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(ownerMemberId),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA1),
            role: const Value(WalletRole.member),
          ),
        ),
        throwsA(isA<LastOwnerException>()),
      );

      // Attempt to demote owner -> viewer
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(ownerMemberId),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA1),
            role: const Value(WalletRole.viewer),
          ),
        ),
        throwsA(isA<LastOwnerException>()),
      );

      // Verify owner role remains OWNER
      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.firstWhere((m) => m.id == ownerMemberId).role, equals(WalletRole.owner));
    });

    test('Test 5 — Can Demote One of Multiple Owners', () async {
      final owner1Id = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.owner,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(2));

      // Demote Owner 1 -> admin (succeeds because Owner 2 exists)
      await walletDao.updateMember(
        WalletMembersCompanion(
          id: Value(owner1Id),
          walletId: Value(walletIdA),
          accountId: Value(accountIdA1),
          role: const Value(WalletRole.admin),
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.firstWhere((m) => m.id == owner1Id).role, equals(WalletRole.admin));
    });

    test('Test 6 — Can Remove One of Multiple Owners', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.owner,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(2));

      // Deactivate Owner 1 (succeeds because Owner 2 remains)
      await walletDao.deactivateMember(walletIdA, accountIdA1);

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final activeMembers = await walletDao.getMembersForWallet(walletIdA);
      expect(activeMembers.single.accountId, equals(accountIdA2));
    });

    test('Test 7 — Removing Non-owner Still Works', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.member,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA3,
          role: WalletRole.viewer,
        ),
      );

      // Deactivate non-owner member
      await walletDao.deactivateMember(walletIdA, accountIdA2);

      final activeMembers = await walletDao.getMembersForWallet(walletIdA);
      expect(activeMembers.length, equals(2));
      expect(activeMembers.any((m) => m.accountId == accountIdA2), isFalse);
      expect(activeMembers.any((m) => m.accountId == accountIdA1 && m.role == WalletRole.owner), isTrue);
      expect(activeMembers.any((m) => m.accountId == accountIdA3 && m.role == WalletRole.viewer), isTrue);
    });

    test('Test 8 — Demoting Non-owner Still Works', () async {
      final adminMemberId = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.admin,
        ),
      );

      // Demote admin -> member
      await walletDao.updateMember(
        WalletMembersCompanion(
          id: Value(adminMemberId),
          walletId: Value(walletIdA),
          accountId: Value(accountIdA2),
          role: const Value(WalletRole.member),
        ),
      );

      final member = (await (database.select(database.walletMembers)..where((m) => m.id.equals(adminMemberId))).getSingle());
      expect(member.role, equals(WalletRole.member));
    });

    test('Test 9 — Multiple Wallet Isolation', () async {
      final ownerAId = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdB,
          accountId: accountIdB1,
          role: WalletRole.owner,
        ),
      );

      // Attempting to demote Wallet A owner fails
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(ownerAId),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA1),
            role: const Value(WalletRole.member),
          ),
        ),
        throwsA(isA<LastOwnerException>()),
      );

      // Verify Wallet B membership remains completely untouched
      expect(await walletDao.countActiveOwners(walletIdB), equals(1));
      final walletBMembers = await walletDao.getMembersForWallet(walletIdB);
      expect(walletBMembers.single.accountId, equals(accountIdB1));
      expect(walletBMembers.single.role, equals(WalletRole.owner));
    });

    test('Test 10 — Membership Count Accuracy', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.admin,
        ),
      );
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA3,
          role: WalletRole.viewer,
        ),
      );

      // Verified countActiveOwners only counts WalletRole.owner
      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
    });

    test('Test 11 — Invitation Acceptance Preserves Owner Count', () async {
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );

      // Create and accept an invitation for account A2 as member
      final invId = await invitationRepo.createInvitation(
        walletId: walletIdA,
        invitedAccountId: accountIdA2,
        role: WalletRole.member,
        invitedByAccountId: accountIdA1,
      );

      final invitation = await walletDao.getInvitationById(invId);
      await invitationRepo.acceptInvitation(
        invitationId: invId,
        token: invitation!.token,
        activeAccountId: accountIdA2,
        walletId: walletIdA,
      );

      // Verified owner count remains 1 and existing owner is intact
      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.length, equals(2));
      expect(members.any((m) => m.accountId == accountIdA1 && m.role == WalletRole.owner), isTrue);
      expect(members.any((m) => m.accountId == accountIdA2 && m.role == WalletRole.member), isTrue);
    });

    test('Test 12 — Wallet Creation Invariant', () async {
      final newWalletId = await database.into(database.wallets).insert(
        const WalletsCompanion(name: Value('New Family Wallet')),
      );

      // Insert initial owner member
      await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: newWalletId,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );

      expect(await walletDao.countActiveOwners(newWalletId), equals(1));
    });

    test('Test 13 — Sequential Role Demotions Rejection', () async {
      final owner1Id = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );
      final owner2Id = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA2,
          role: WalletRole.owner,
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(2));

      // First demotion succeeds (Owner 1 -> admin)
      await walletDao.updateMember(
        WalletMembersCompanion(
          id: Value(owner1Id),
          walletId: Value(walletIdA),
          accountId: Value(accountIdA1),
          role: const Value(WalletRole.admin),
        ),
      );

      expect(await walletDao.countActiveOwners(walletIdA), equals(1));

      // Second demotion fails (Owner 2 -> member)
      expect(
        () => walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(owner2Id),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA2),
            role: const Value(WalletRole.member),
          ),
        ),
        throwsA(isA<LastOwnerException>()),
      );

      // Final state: Owner 2 remains OWNER
      expect(await walletDao.countActiveOwners(walletIdA), equals(1));
      final members = await walletDao.getMembersForWallet(walletIdA);
      expect(members.firstWhere((m) => m.id == owner2Id).role, equals(WalletRole.owner));
    });

    test('Test 14 — No Partial Mutation on Failure', () async {
      final ownerId = await walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: walletIdA,
          accountId: accountIdA1,
          role: WalletRole.owner,
        ),
      );

      final originalMember = await (database.select(database.walletMembers)..where((m) => m.id.equals(ownerId))).getSingle();

      // Attempt invalid demotion
      try {
        await walletDao.updateMember(
          WalletMembersCompanion(
            id: Value(ownerId),
            walletId: Value(walletIdA),
            accountId: Value(accountIdA1),
            role: const Value(WalletRole.viewer),
          ),
        );
      } catch (_) {}

      // Verify no fields in DB were changed
      final afterMember = await (database.select(database.walletMembers)..where((m) => m.id.equals(ownerId))).getSingle();
      expect(afterMember.role, equals(WalletRole.owner));
      expect(afterMember.isActive, equals(originalMember.isActive));
      expect(afterMember.joinedAt, equals(originalMember.joinedAt));
    });
  });
}
