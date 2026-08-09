import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:expense_tracker/features/family/domain/family_finance_models.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationActionCenterScreen extends ConsumerWidget {
  const NotificationActionCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(walletNotificationsProvider);
    final permissions = ref.watch(walletPermissionServiceProvider);
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final preferencesAsync = ref.watch(walletNotificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Center'),
        actions: [
          IconButton(
            tooltip: 'Dismiss all',
            onPressed: () async {
              final walletId = ref.read(currentWalletIdProvider);
              await ref.read(notificationDaoProvider).bulkDismiss(walletId);
              ref.invalidate(walletNotificationsProvider);
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          notificationsAsync.when(
            data: (notifications) {
              final unread = notifications.where((n) => n.isUnread).toList();
              final upcoming = notifications.where((n) => !n.isUnread && n.dismissedAt == null).toList();
              final dismissed = notifications.where((n) => n.dismissedAt != null).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(title: 'Unread', children: unread),
                  const SizedBox(height: 16),
                  _Section(title: 'Upcoming', children: upcoming),
                  const SizedBox(height: 16),
                  _Section(title: 'Dismissed', children: dismissed),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Text('Notifications unavailable: $error'),
          ),
          const SizedBox(height: 24),
          roleAsync.when(
            data: (role) {
              final canManage = permissions.canManageBillsAndSchedules(role) || permissions.canManageAllowances(role) || permissions.canManageSettlements(role);
              if (!canManage) {
                return const SizedBox.shrink();
              }
              return preferencesAsync.when(
                data: (prefs) => Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Bill reminders'),
                        value: prefs?.billReminders ?? true,
                        onChanged: (value) async {
                          final walletId = ref.read(currentWalletIdProvider);
                          await ref.read(notificationPreferenceDaoProvider).upsertForWallet(walletId, billReminders: value);
                          ref.invalidate(walletNotificationPreferencesProvider);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Goal reminders'),
                        value: prefs?.goalReminders ?? true,
                        onChanged: (value) async {
                          final walletId = ref.read(currentWalletIdProvider);
                          await ref.read(notificationPreferenceDaoProvider).upsertForWallet(walletId, goalReminders: value);
                          ref.invalidate(walletNotificationPreferencesProvider);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Allowance reminders'),
                        value: prefs?.allowanceReminders ?? true,
                        onChanged: (value) async {
                          final walletId = ref.read(currentWalletIdProvider);
                          await ref.read(notificationPreferenceDaoProvider).upsertForWallet(walletId, allowanceReminders: value);
                          ref.invalidate(walletNotificationPreferencesProvider);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Settlement reminders'),
                        value: prefs?.settlementReminders ?? true,
                        onChanged: (value) async {
                          final walletId = ref.read(currentWalletIdProvider);
                          await ref.read(notificationPreferenceDaoProvider).upsertForWallet(walletId, settlementReminders: value);
                          ref.invalidate(walletNotificationPreferencesProvider);
                        },
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  final String title;
  final List<WalletNotificationViewModel> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (children.isEmpty) {
      return ListTile(
        title: Text(title),
        subtitle: const Text('No items yet. Alerts appear here when bills, goals, allowances, or invites need attention.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...children.map(
          (notification) => Card(
            child: ListTile(
              title: Text(notification.title),
              subtitle: Text('${notification.message}\n${notification.actionLabel}\n${DateFormat.yMMMd().add_Hm().format(notification.createdAt)}'),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  final dao = ref.read(notificationDaoProvider);
                  if (value == 'read') {
                    await dao.markRead(notification.id);
                  } else if (value == 'dismiss') {
                    await dao.dismiss(notification.id);
                  }
                  ref.invalidate(walletNotificationsProvider);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'read', child: Text('Mark read')),
                  PopupMenuItem(value: 'dismiss', child: Text('Dismiss')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
