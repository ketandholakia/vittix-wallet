import 'package:expense_tracker/core/database/app_database.dart';

abstract class WalletInvitationRepository {
  Future<int> createInvitation({
    required int walletId,
    required int invitedAccountId,
    required WalletRole role,
    required int invitedByAccountId,
    DateTime? expiresAt,
  });

  Future<List<WalletInvitation>> listInvitations(int walletId);

  Future<void> acceptInvitation({
    required int invitationId,
    required String token,
    required int activeAccountId,
    required int walletId,
  });

  Future<void> revokeInvitation({
    required int invitationId,
    required int activeAccountId,
    required int walletId,
  });

  Future<void> expireInvitation(int invitationId);
}

class WalletInvitationRepositoryImpl implements WalletInvitationRepository {
  final WalletDao _walletDao;

  WalletInvitationRepositoryImpl(this._walletDao);

  @override
  Future<int> createInvitation({
    required int walletId,
    required int invitedAccountId,
    required WalletRole role,
    required int invitedByAccountId,
    DateTime? expiresAt,
  }) async {
    final inviterRole = await _walletDao.getRoleInWallet(walletId, actorAccountId: invitedByAccountId);

    await _walletDao.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageMembers(r),
      actorAccountId: invitedByAccountId,
      actionName: 'manage invitations',
    );

    if (role == WalletRole.owner || role == WalletRole.admin) {
      if (inviterRole != WalletRole.owner) {
        throw Exception('Permission denied: Only OWNER can grant $role role');
      }
    }

    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
      throw Exception('Invalid expiration date');
    }

    return _walletDao.insertInvitation(
      WalletInvitationsCompanion.insert(
        walletId: walletId,
        invitedByAccountId: Value(invitedByAccountId),
        accountId: invitedAccountId,
        status: WalletInvitationStatus.pending,
        role: role,
        expiresAt: Value(expiresAt),
      ),
    );
  }

  @override
  Future<List<WalletInvitation>> listInvitations(int walletId) {
    return _walletDao.getInvitationsForWallet(walletId);
  }

  @override
  Future<void> acceptInvitation({
    required int invitationId,
    required String token,
    required int activeAccountId,
    required int walletId,
  }) async {
    final invitation = await _walletDao.getInvitationByIdAndToken(invitationId, token);
    if (invitation == null) {
      throw Exception('Invitation not found or invalid token');
    }

    if (invitation.walletId != walletId) {
      throw Exception('Invitation does not belong to this wallet');
    }

    if (invitation.accountId != activeAccountId) {
      throw Exception('Target account identity mismatch');
    }

    await _walletDao.attachedDatabase.transaction(() async {
      final rowsUpdated = await _walletDao.consumeInvitationAtomically(invitationId, token, WalletInvitationStatus.accepted);
      if (rowsUpdated != 1) {
        throw Exception('Invitation acceptance failed due to invalid state or concurrency conflict');
      }

      await _walletDao.insertMember(
        WalletMembersCompanion.insert(
          walletId: invitation.walletId,
          accountId: invitation.accountId,
          role: invitation.role,
        ),
      );

      await _walletDao.logInvitationActivity(
        walletId: invitation.walletId,
        invitationId: invitation.id,
        action: 'INVITATION_ACCEPTED',
        actorAccountId: activeAccountId,
      );

      await _walletDao.logMemberAdded(
        walletId: invitation.walletId,
        accountId: invitation.accountId,
        actorAccountId: activeAccountId,
      );
    });
  }

  @override
  Future<void> revokeInvitation({
    required int invitationId,
    required int activeAccountId,
    required int walletId,
  }) async {
    await _walletDao.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageMembers(r),
      actorAccountId: activeAccountId,
      actionName: 'revoke invitation',
    );

    final invitation = await _walletDao.getInvitationById(invitationId);
    if (invitation == null || invitation.walletId != walletId) {
      throw Exception('Invitation not found in this wallet');
    }

    if (invitation.status != WalletInvitationStatus.pending) {
      throw Exception('Cannot revoke non-pending invitation');
    }

    await _walletDao.attachedDatabase.transaction(() async {
      final rowsUpdated = await _walletDao.consumeInvitationAtomically(invitationId, invitation.token, WalletInvitationStatus.revoked);
      if (rowsUpdated != 1) {
        throw Exception('Revocation failed due to state conflict');
      }

      await _walletDao.logInvitationActivity(
        walletId: invitation.walletId,
        invitationId: invitation.id,
        action: 'INVITATION_REVOKED',
        actorAccountId: activeAccountId,
      );
    });
  }

  @override
  Future<void> expireInvitation(int invitationId) async {
    final invitation = await _walletDao.getInvitationById(invitationId);
    if (invitation == null) return;
    if (invitation.status != WalletInvitationStatus.pending) return;

    await _walletDao.attachedDatabase.transaction(() async {
      final rowsUpdated = await _walletDao.consumeInvitationAtomically(invitationId, invitation.token, WalletInvitationStatus.expired);
      if (rowsUpdated == 1) {
        await _walletDao.logInvitationActivity(
          walletId: invitation.walletId,
          invitationId: invitation.id,
          action: 'INVITATION_EXPIRED',
          actorAccountId: null,
        );
      }
    });
  }
}
