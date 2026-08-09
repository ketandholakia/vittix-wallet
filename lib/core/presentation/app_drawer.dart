// BROKEN DEPENDENCY: Experimental
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen.dart';
import 'package:expense_tracker/receipt/receipt_scanner_screen.dart';
import 'package:expense_tracker/calendar/subscription_calendar_screen.dart';
import 'package:expense_tracker/features/accounts/presentation/account_screen.dart';
import 'package:expense_tracker/features/categories/presentation/category_screen.dart';
import 'package:expense_tracker/core/domain/brand_assets.dart';
import 'package:expense_tracker/api/api_server_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const BrandLogo(size: 56, showWordmark: false),
                  const SizedBox(height: 12),
                  Text(
                    'Vittix Wallet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Quick Access Tools',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.add_circle_outline,
                  title: 'New Transaction',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.document_scanner_outlined,
                  title: 'Scan Receipt',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: 'Subscriptions',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionCalendarScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Accounts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AccountScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.category_outlined,
                  title: 'Categories',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CategoryScreen()),
                    );
                  },
                ),
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'More Options',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final apiState = ref.watch(apiServerStateProvider);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Local API Server', style: TextStyle(fontWeight: FontWeight.bold)),
                                Switch(
                                  value: apiState.isRunning,
                                  onChanged: (val) {
                                    if (val) {
                                      ref.read(apiServerStateProvider.notifier).startServer();
                                    } else {
                                      ref.read(apiServerStateProvider.notifier).stopServer();
                                    }
                                  },
                                ),
                              ],
                            ),
                            if (apiState.isRunning && apiState.ipAddress != null)
                              Text(
                                'http://${apiState.ipAddress}:${apiState.port}',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    // Usually settings is available via BottomNavigationBar, 
                    // but we can provide quick access here or let it pop context.
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
    );
  }
}

*/