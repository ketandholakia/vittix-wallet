import 'dart:convert';

import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/family/data/wallet_invitation_repository.dart';

class WalletInvitationService {
  final WalletInvitationRepository _repository;

  WalletInvitationService(this._repository);

  String buildInvitationCode(WalletInvitation invitation) {
    final payload = {
      'id': invitation.id,
      'walletId': invitation.walletId,
      'accountId': invitation.accountId,
      'role': invitation.role.name,
      'status': invitation.status.name,
      'expiresAt': invitation.expiresAt?.toIso8601String(),
    };
    return base64UrlEncode(utf8.encode(jsonEncode(payload)));
  }

  Future<WalletInvitation?> resolveInvitation(String code) async {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(utf8.decode(base64Url.decode(code))) as Map<String, dynamic>;
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
    final invitationId = payload['id'];
    if (invitationId is! int) return null;
    final walletId = payload['walletId'];
    if (walletId is! int) return null;
    final invitations = await _repository.listInvitations(walletId);
    final invitation = invitations.where((item) => item.id == invitationId).firstOrNull;
    if (invitation == null) return null;
    if (invitation.status != WalletInvitationStatus.pending) return null;
    if (invitation.expiresAt != null && invitation.expiresAt!.isBefore(DateTime.now())) return null;
    return invitation;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
