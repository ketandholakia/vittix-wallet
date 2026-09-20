import 'package:expense_tracker/core/database/app_database.dart' hide isNotNull, isNull;
import 'package:expense_tracker/features/family/data/wallet_invitation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift/native.dart';

void main() {
  late AppDatabase db;
  late WalletInvitationRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.resetDatabase();
    repository = WalletInvitationRepositoryImpl(db.walletDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('createInvitation throws if actor does not have OWNER role but tries to invite OWNER', () async {
    // Setup
    final walletId = await db.into(db.wallets).insert(
      const WalletsCompanion(name: Value('Test Wallet')),
    );
    
    // Add an admin member
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 2,
      role: WalletRole.admin,
    ));

    // Admin tries to invite another as owner
    expect(
      () => repository.createInvitation(
        walletId: walletId,
        invitedAccountId: 3,
        role: WalletRole.owner,
        invitedByAccountId: 2,
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Only OWNER can grant'))),
    );
  });

  test('acceptInvitation fails if activeAccountId mismatches target account', () async {
    final walletId = await db.into(db.wallets).insert(
      const WalletsCompanion(name: Value('Test Wallet')),
    );
    
    // Add owner
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 1,
      role: WalletRole.owner,
    ));

    final invitationId = await repository.createInvitation(
      walletId: walletId,
      invitedAccountId: 2,
      role: WalletRole.member,
      invitedByAccountId: 1, // 1 is OWNER
    );

    final invitation = await db.walletDao.getInvitationById(invitationId);
    expect(invitation, isNotNull);

    // Try to accept with accountId 3 instead of 2
    expect(
      () => repository.acceptInvitation(
        invitationId: invitationId,
        token: invitation!.token,
        activeAccountId: 3,
        walletId: walletId,
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Target account identity mismatch'))),
    );
  });

  test('acceptInvitation fails if token is incorrect', () async {
    final walletId = await db.into(db.wallets).insert(
      const WalletsCompanion(name: Value('Test Wallet')),
    );
    
    // Add owner
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 1,
      role: WalletRole.owner,
    ));

    final invitationId = await repository.createInvitation(
      walletId: walletId,
      invitedAccountId: 2,
      role: WalletRole.member,
      invitedByAccountId: 1,
    );

    // Try to accept with wrong token
    expect(
      () => repository.acceptInvitation(
        invitationId: invitationId,
        token: 'invalid-token',
        activeAccountId: 2,
        walletId: walletId,
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('not found or invalid token'))),
    );
  });

  test('acceptInvitation works when correct and logs actor correctly', () async {
    final walletId = await db.into(db.wallets).insert(
      const WalletsCompanion(name: Value('Test Wallet')),
    );
    
    // Add owner
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 1,
      role: WalletRole.owner,
    ));

    final invitationId = await repository.createInvitation(
      walletId: walletId,
      invitedAccountId: 2,
      role: WalletRole.member,
      invitedByAccountId: 1,
    );

    final invitation = await db.walletDao.getInvitationById(invitationId);
    
    await repository.acceptInvitation(
      invitationId: invitationId,
      token: invitation!.token,
      activeAccountId: 2,
      walletId: walletId,
    );

    final accepted = await db.walletDao.getInvitationById(invitationId);
    expect(accepted!.status, equals(WalletInvitationStatus.accepted));

    final activities = await db.select(db.walletActivities).get();
    final acceptLog = activities.where((a) => a.action == 'INVITATION_ACCEPTED').first;
    expect(acceptLog.actorAccountId, equals(2)); // Target account accepted it
  });

  test('revokeInvitation requires manage member permissions', () async {
    final walletId = await db.into(db.wallets).insert(
      const WalletsCompanion(name: Value('Test Wallet')),
    );
    
    // Account 1 is owner
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 1,
      role: WalletRole.owner,
    ));

    // Account 2 is just a member
    await db.walletDao.insertMember(WalletMembersCompanion.insert(
      walletId: walletId,
      accountId: 2,
      role: WalletRole.member,
    ));

    final invitationId = await repository.createInvitation(
      walletId: walletId,
      invitedAccountId: 3,
      role: WalletRole.member,
      invitedByAccountId: 1, // 1 is OWNER
    );

    // Account 2 tries to revoke
    expect(
      () => repository.revokeInvitation(
        invitationId: invitationId,
        activeAccountId: 2,
        walletId: walletId,
      ),
      throwsA(isA<WalletPermissionDeniedException>()),
    );
  });

  test('accepted invitation cannot be replayed', () async {
    final walletId = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Test Wallet')));
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: walletId, accountId: 1, role: WalletRole.owner));

    final invitationId = await repository.createInvitation(
      walletId: walletId, invitedAccountId: 2, role: WalletRole.member, invitedByAccountId: 1,
    );
    final invitation = await db.walletDao.getInvitationById(invitationId);
    
    // First accept works
    await repository.acceptInvitation(invitationId: invitationId, token: invitation!.token, activeAccountId: 2, walletId: walletId);
    
    // Replay fails
    expect(
      () => repository.acceptInvitation(invitationId: invitationId, token: invitation.token, activeAccountId: 2, walletId: walletId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('failed due to invalid state or concurrency conflict'))),
    );
  });

  test('revoked invitation cannot be accepted', () async {
    final walletId = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Test Wallet')));
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: walletId, accountId: 1, role: WalletRole.owner));

    final invitationId = await repository.createInvitation(
      walletId: walletId, invitedAccountId: 2, role: WalletRole.member, invitedByAccountId: 1,
    );
    
    await repository.revokeInvitation(invitationId: invitationId, activeAccountId: 1, walletId: walletId);
    final invitation = await db.walletDao.getInvitationById(invitationId);
    
    expect(
      () => repository.acceptInvitation(invitationId: invitationId, token: invitation!.token, activeAccountId: 2, walletId: walletId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('failed due to invalid state or concurrency conflict'))),
    );
  });

  test('expired invitation cannot be accepted', () async {
    final walletId = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Test Wallet')));
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: walletId, accountId: 1, role: WalletRole.owner));

    // Create an invitation that expires in the past
    final invitationId = await db.walletDao.insertInvitation(
      WalletInvitationsCompanion.insert(
        walletId: walletId,
        invitedByAccountId: const Value(1),
        accountId: 2,
        status: WalletInvitationStatus.pending,
        role: WalletRole.member,
        token: const Value('test-token'),
        expiresAt: Value(DateTime.now().subtract(const Duration(days: 1))),
      ),
    );
    
    expect(
      () => repository.acceptInvitation(invitationId: invitationId, token: 'test-token', activeAccountId: 2, walletId: walletId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('failed due to invalid state or concurrency conflict'))),
    );
  });

  test('cross-wallet invitation manipulation is rejected', () async {
    final wallet1 = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet 1')));
    final wallet2 = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet 2')));
    
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: wallet1, accountId: 1, role: WalletRole.owner));
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: wallet2, accountId: 1, role: WalletRole.owner));

    final invitationId = await repository.createInvitation(
      walletId: wallet1, invitedAccountId: 2, role: WalletRole.member, invitedByAccountId: 1,
    );
    final invitation = await db.walletDao.getInvitationById(invitationId);

    // Try to accept in context of wallet 2
    expect(
      () => repository.acceptInvitation(invitationId: invitationId, token: invitation!.token, activeAccountId: 2, walletId: wallet2),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Invitation does not belong to this wallet'))),
    );
  });

  test('invitation token is absent from audit metadata', () async {
    final walletId = await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Test Wallet')));
    await db.walletDao.insertMember(WalletMembersCompanion.insert(walletId: walletId, accountId: 1, role: WalletRole.owner));

    final invitationId = await repository.createInvitation(
      walletId: walletId, invitedAccountId: 2, role: WalletRole.member, invitedByAccountId: 1,
    );
    final invitation = await db.walletDao.getInvitationById(invitationId);
    
    await repository.acceptInvitation(invitationId: invitationId, token: invitation!.token, activeAccountId: 2, walletId: walletId);
    
    final activities = await db.select(db.walletActivities).get();
    final acceptLog = activities.where((a) => a.action == 'INVITATION_ACCEPTED').first;
    
    expect(acceptLog.details, isNull);
    
    // Also explicitly check string representation just in case
    expect(acceptLog.toString().contains(invitation.token), isFalse);
  });
}
