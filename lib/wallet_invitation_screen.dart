import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/wallet_invitation_repository.dart';
import 'package:expense_tracker/wallet_invitation_service.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

final walletInvitationRepositoryProvider = Provider<WalletInvitationRepository>((ref) {
  return WalletInvitationRepositoryImpl(ref.watch(walletDaoProvider));
});

final walletInvitationServiceProvider = Provider<WalletInvitationService>((ref) {
  return WalletInvitationService(ref.watch(walletInvitationRepositoryProvider));
});

final walletInvitationsProvider = FutureProvider<List<db.WalletInvitation>>((ref) async {
  final walletId = ref.watch(currentWalletIdProvider);
  return ref.watch(walletDaoProvider).watchInvitationsForWallet(walletId);
});

class WalletInvitationScreen extends ConsumerStatefulWidget {
  const WalletInvitationScreen({super.key});

  @override
  ConsumerState<WalletInvitationScreen> createState() => _WalletInvitationScreenState();
}

class _WalletInvitationScreenState extends ConsumerState<WalletInvitationScreen> {
  final m.TextEditingController _codeController = m.TextEditingController();
  db.WalletRole _selectedRole = db.WalletRole.member;
  Account? _selectedAccount;
  String? _lastCode;
  db.WalletInvitation? _preview;
  String? _previewMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    final walletId = ref.watch(currentWalletIdProvider);
    final currentWalletAsync = ref.watch(currentWalletProvider);
    final invitationsAsync = ref.watch(walletInvitationsProvider);
    final service = ref.watch(walletInvitationServiceProvider);
    final accountsStream = ref.watch(watchAccountsWithBalanceUseCaseProvider).call();

    return m.Scaffold(
      appBar: m.AppBar(title: const m.Text('Wallet invitations')),
      body: m.ListView(
        padding: const m.EdgeInsets.all(16),
        children: [
          currentWalletAsync.when(
            data: (wallet) => m.Card(
              child: m.ListTile(
                leading: const m.Icon(m.Icons.account_balance_wallet_outlined),
                title: m.Text(wallet == null ? 'Current wallet' : wallet.name),
                subtitle: const m.Text(
                  'Invite a family member or collaborator account into this wallet. The wallet is the sharing boundary.',
                ),
              ),
            ),
            loading: () => const m.Card(
              child: m.ListTile(
                leading: m.Icon(m.Icons.account_balance_wallet_outlined),
                title: m.Text('Loading current wallet...'),
              ),
            ),
            error: (error, stack) => m.Card(
              child: m.ListTile(
                leading: const m.Icon(m.Icons.error_outline),
                title: const m.Text('Current wallet unavailable'),
                subtitle: m.Text('$error'),
              ),
            ),
          ),
          const m.SizedBox(height: 12),
          m.StreamBuilder<List<AccountWithBalance>>(
            stream: accountsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return m.Text('Unable to load accounts: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const m.Padding(
                  padding: m.EdgeInsets.symmetric(vertical: 8),
                  child: m.LinearProgressIndicator(),
                );
              }
              final accounts = snapshot.data!;
              if (accounts.isEmpty) {
                return const m.ListTile(
                  contentPadding: m.EdgeInsets.zero,
                  leading: m.Icon(m.Icons.info_outline),
                  title: m.Text('No member accounts available'),
                  subtitle: m.Text('Create an account first, then invite that account into this wallet as a member.'),
                );
              }
              _selectedAccount ??= accounts.first.account;
              return m.DropdownButtonFormField<Account>(
                initialValue: _selectedAccount,
                decoration: const m.InputDecoration(labelText: 'Member account to invite'),
                items: accounts
                    .map(
                      (item) => m.DropdownMenuItem(
                        value: item.account,
                        child: m.Text('${item.account.name} (#${item.account.id})'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedAccount = value),
              );
            },
          ),
          const m.SizedBox(height: 12),
          const m.Text(
            'Roles control what the invited account can do inside this wallet. Invite the person to the current wallet, then assign their role.',
          ),
          const m.SizedBox(height: 8),
          m.DropdownButton<db.WalletRole>(
            value: _selectedRole,
            items: db.WalletRole.values
                .map((role) => m.DropdownMenuItem(value: role, child: m.Text(role.name.toUpperCase())))
                .toList(),
            onChanged: (value) => setState(() => _selectedRole = value ?? _selectedRole),
          ),
          const m.SizedBox(height: 12),
          m.TextField(
            controller: _codeController,
            decoration: const m.InputDecoration(labelText: 'Invitation code'),
          ),
          const m.SizedBox(height: 8),
          m.ElevatedButton.icon(
            onPressed: () async {
              final accountId = _selectedAccount?.id;
              if (accountId == null) return;
              final invitationId = await ref.read(walletInvitationRepositoryProvider).createInvitation(
                    walletId: walletId,
                    invitedAccountId: accountId,
                    role: _selectedRole,
                  );
              await ref.read(walletDaoProvider).logInvitationActivity(
                    walletId: walletId,
                    invitationId: invitationId,
                    action: 'wallet_invite_flow_started',
                  );
              final invitation = await ref.read(walletDaoProvider).getInvitationById(invitationId);
              if (invitation == null) return;
              final code = service.buildInvitationCode(invitation);
              setState(() {
                _lastCode = code;
                _preview = invitation;
              });
              ref.invalidate(walletInvitationsProvider);
            },
            icon: const m.Icon(m.Icons.send),
            label: const m.Text('Create member invite'),
          ),
          const m.SizedBox(height: 8),
          m.ElevatedButton.icon(
            onPressed: () async {
              final code = _codeController.text.trim();
              if (code.isEmpty) return;
              final invitation = await service.resolveInvitation(code);
              setState(() {
                _preview = invitation;
                _previewMessage = invitation == null ? 'Invalid or expired invitation code.' : null;
              });
            },
            icon: const m.Icon(m.Icons.visibility),
            label: const m.Text('Preview member code'),
          ),
          if (_previewMessage != null) ...[
            const m.SizedBox(height: 8),
            m.Text(_previewMessage!, style: m.TextStyle(color: m.Theme.of(context).colorScheme.error)),
          ],
          if (_preview != null) ...[
            const m.SizedBox(height: 12),
            m.Card(
              child: m.ListTile(
                leading: const m.Icon(m.Icons.info_outline),
                title: m.Text('Wallet ${_preview!.walletId}'),
                        subtitle: m.Text(
                  'Wallet: ${_preview!.walletId} | Role: ${_preview!.role.name.toUpperCase()} | Status: ${_preview!.status.name.toUpperCase()}',
                ),
                trailing: m.TextButton(
                  onPressed: _preview!.status == db.WalletInvitationStatus.pending
                      ? () async {
                    await ref.read(walletInvitationRepositoryProvider).acceptInvitation(_preview!.id);
                        await ref.read(walletDaoProvider).logInvitationActivity(
                          walletId: walletId,
                          invitationId: _preview!.id,
                          action: 'wallet_invitation_accepted',
                        );
                        await ref.read(walletDaoProvider).logInvitationActivity(
                          walletId: walletId,
                          invitationId: _preview!.id,
                          action: 'wallet_invite_flow_completed',
                        );
                    ref.invalidate(walletInvitationsProvider);
                    setState(() {
                      _preview = null;
                      _previewMessage = 'Wallet invitation accepted successfully.';
                    });
                  }
                      : null,
                  child: const m.Text('Accept'),
                ),
              ),
            ),
          ],
          if (_lastCode != null) ...[
            const m.SizedBox(height: 16),
            m.SelectableText(_lastCode!),
            const m.SizedBox(height: 12),
            QrImageView(data: _lastCode!, size: 200),
            m.TextButton.icon(
              onPressed: () async {
                await SharePlus.instance.share(ShareParams(text: _lastCode!));
              },
              icon: const m.Icon(m.Icons.share),
              label: const m.Text('Share member code'),
            ),
            m.TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _lastCode!));
              },
              icon: const m.Icon(m.Icons.copy),
              label: const m.Text('Copy member code'),
            ),
          ],
          const m.Divider(height: 32),
          invitationsAsync.when(
            data: (invitations) => m.Column(
              children: invitations
                  .map(
                    (invitation) => m.ListTile(
                      leading: const m.Icon(m.Icons.mail_outline),
                      title: m.Text('Account #${invitation.accountId}'),
                      subtitle: m.Text(invitation.status.name.toUpperCase()),
                      trailing: m.Row(
                        mainAxisSize: m.MainAxisSize.min,
                        children: [
                          m.TextButton(
                            onPressed: invitation.status == db.WalletInvitationStatus.pending
                                ? () async {
                    await ref.read(walletInvitationRepositoryProvider).acceptInvitation(invitation.id);
                    await ref.read(walletDaoProvider).logInvitationActivity(
                          walletId: walletId,
                          invitationId: invitation.id,
                          action: 'invite_flow_completed',
                        );
                    ref.invalidate(walletInvitationsProvider);
                    setState(() {
                      _preview = invitation;
                      _previewMessage = 'Invitation accepted successfully.';
                    });
                  }
                                : null,
                            child: const m.Text('Accept'),
                          ),
                          m.TextButton(
                            onPressed: invitation.status == db.WalletInvitationStatus.pending
                                ? () async {
                                    await ref.read(walletInvitationRepositoryProvider).revokeInvitation(invitation.id);
                                    ref.invalidate(walletInvitationsProvider);
                                  }
                                : null,
                            child: const m.Text('Revoke'),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const m.Center(child: m.CircularProgressIndicator()),
            error: (error, stack) => m.Text('Unable to load invitations: $error'),
          ),
        ],
      ),
    );
  }
}
