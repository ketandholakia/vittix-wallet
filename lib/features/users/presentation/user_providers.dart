import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves the real user identity behind an account inside a wallet
/// (backlog item A7).
///
/// The UI knows the *active account*, not a person — that conflation is what
/// blocked collaboration. Membership rows carry both: `accountId` (legacy) and
/// `userId` (the bridge column). This provider performs the lookup, so every
/// feature can turn its `activeAccountId` into an `actorUserId` before calling
/// a repository:
///
/// ```dart
/// final actorUserId = await ref.read(
///   userIdForAccountProvider((walletId: walletId, accountId: activeAccountId)).future,
/// );
/// await repo.revokeInvitation(..., actorUserId: actorUserId);
/// ```
///
/// Returns null for a legacy membership that only has `accountId`, and for an
/// account with no active membership — callers should then fall back to the
/// account-based actor, which is why both parameters coexist during the
/// migration.
final userIdForAccountProvider =
    FutureProvider.family<int?, ({int walletId, int accountId})>(
  (ref, args) async {
    final members = await ref
        .watch(walletDaoProvider)
        .getMembersForWallet(args.walletId);

    for (final member in members) {
      if (member.accountId == args.accountId) {
        return member.userId;
      }
    }
    return null;
  },
);

/// The user identity of the current actor: the membership for [accountId] in
/// the wallet currently being viewed.
final currentUserIdProvider = FutureProvider.family<int?, int>((ref, accountId) {
  final walletId = ref.watch(currentWalletIdProvider);
  return ref.watch(
    userIdForAccountProvider((walletId: walletId, accountId: accountId)).future,
  );
});
