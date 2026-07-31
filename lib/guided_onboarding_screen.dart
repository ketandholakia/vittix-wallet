import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuidedOnboardingScreen extends ConsumerStatefulWidget {
  const GuidedOnboardingScreen({super.key});

  @override
  ConsumerState<GuidedOnboardingScreen> createState() => _GuidedOnboardingScreenState();
}

class _GuidedOnboardingScreenState extends ConsumerState<GuidedOnboardingScreen> {
  final _walletNameController = TextEditingController(text: 'My Wallet');
  bool _sharedWallet = false;
  bool _walletCreated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(databaseProvider).walletDao.logOnboardingActivity(
            walletId: ref.read(currentWalletIdProvider),
            action: 'wallet_creation_started',
          );
    });
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  Future<void> _createWallet() async {
    final name = _walletNameController.text.trim();
    if (name.isEmpty) return;
    final db = ref.read(databaseProvider);
    final walletId = await db.into(db.wallets).insert(
          WalletsCompanion.insert(
            name: name,
            type: Value(_sharedWallet ? 'shared' : 'personal'),
          ),
        );
    await db.walletDao.logWalletCreated(walletId: walletId, walletType: _sharedWallet ? 'shared' : 'personal');
    ref.read(currentWalletIdProvider.notifier).selectWallet(walletId);
    ref.invalidate(availableWalletsProvider);
    setState(() => _walletCreated = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet created locally')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Started')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.tour_outlined),
              title: Text('Create your first wallet'),
              subtitle: Text(
                'A wallet is the boundary for your money, members, budgets, goals, and shared finance data. '
                'Start with a personal wallet unless you need to collaborate right away.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined),
              title: Text('What is a wallet?'),
              subtitle: Text('A wallet keeps one set of transactions, budgets, goals, and family members together.'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.groups_outlined),
              title: Text('Personal vs shared'),
              subtitle: Text('Personal wallets are for one person. Shared wallets are for a family or group.'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _walletNameController,
            decoration: const InputDecoration(labelText: 'Wallet name'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _sharedWallet,
            onChanged: (value) => setState(() => _sharedWallet = value),
            title: const Text('Shared wallet'),
            subtitle: const Text('Turn this on only if multiple people will use the same wallet.'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _walletCreated ? null : _createWallet,
            icon: const Icon(Icons.check),
            label: const Text('Create wallet'),
          ),
          if (_walletCreated) ...[
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.verified_outlined),
                title: Text('Wallet created'),
                subtitle: Text('Next, invite members if this is shared, or import SMS transactions for local review.'),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text('Invite acceptance'),
              subtitle: Text('Review the wallet name, role, expiry status, and access that will be granted before accepting.'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.sms_outlined),
              title: Text('SMS setup'),
              subtitle: Text('SMS permission is only used to scan inbox messages on-device. Every candidate stays in review until you save it.'),
            ),
          ),
        ],
      ),
    );
  }
}
