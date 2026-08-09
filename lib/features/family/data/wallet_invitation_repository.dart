import 'package:expense_tracker/core/database/app_database.dart';

abstract class WalletInvitationRepository {
  Future<int> createInvitation({
    required int walletId,
    required int invitedAccountId,
    required WalletRole role,
    int? invitedByAccountId,
    DateTime? expiresAt,
  });

  Future<List<WalletInvitation>> listInvitations(int walletId);
  Future<void> acceptInvitation(int invitationId);
  Future<void> revokeInvitation(int invitationId);
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
    int? invitedByAccountId,
    DateTime? expiresAt,
  }) {
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
    return _walletDao.watchInvitationsForWallet(walletId);
  }

  Future<void> _setStatus(int invitationId, WalletInvitationStatus status) async {
    final invitation = await _walletDao.getInvitationById(invitationId);
    if (invitation == null) {
      return;
    }
    await _walletDao.updateInvitation(
      invitation.copyWith(
        status: status,
        respondedAt: Value(status == WalletInvitationStatus.pending ? null : DateTime.now()),
      ),
    );
    if (status == WalletInvitationStatus.accepted) {
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
        action: 'invitation_accepted',
        actorAccountId: invitation.invitedByAccountId,
      );
      await _walletDao.logMemberAdded(
        walletId: invitation.walletId,
        accountId: invitation.accountId,
        actorAccountId: invitation.invitedByAccountId,
      );
    } else if (status == WalletInvitationStatus.revoked) {
      await _walletDao.logInvitationActivity(
        walletId: invitation.walletId,
        invitationId: invitation.id,
        action: 'invitation_rejected',
        actorAccountId: invitation.invitedByAccountId,
      );
      await _walletDao.logMemberRemoved(
        walletId: invitation.walletId,
        accountId: invitation.accountId,
        actorAccountId: invitation.invitedByAccountId,
      );
    } else if (status == WalletInvitationStatus.expired) {
      await _walletDao.logInvitationActivity(
        walletId: invitation.walletId,
        invitationId: invitation.id,
        action: 'invitation_expired',
        actorAccountId: invitation.invitedByAccountId,
      );
    }
  }

  @override
  Future<void> acceptInvitation(int invitationId) => _setStatus(invitationId, WalletInvitationStatus.accepted);

  @override
  Future<void> revokeInvitation(int invitationId) => _setStatus(invitationId, WalletInvitationStatus.revoked);

  @override
  Future<void> expireInvitation(int invitationId) => _setStatus(invitationId, WalletInvitationStatus.expired);
}
