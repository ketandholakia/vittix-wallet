import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/accounts/presentation/account_screen.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/transfer_form_screen.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AccountsOverviewWidget extends ConsumerWidget {
  const AccountsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsStream = ref.watch(watchAccountsWithBalanceUseCaseProvider).call();
    final currencyFormat = ref.watch(currencyFormatProvider);
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<List<AccountWithBalance>>(
      stream: accountsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final accounts = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accounts', style: textTheme.titleLarge),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TransferFormScreen()),
                          );
                        },
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Transfer'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AccountScreen()),
                          );
                        },
                        child: const Text('Manage'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = accounts[index];
                  final account = item.account;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TransactionListScreen(initialFilterAccount: account),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(account.icon, color: account.color, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  account.name,
                                  style: textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            account.type.isLiability ? 'Owed' : 'Balance',
                            style: textTheme.bodySmall,
                          ),
                          Builder(
                            builder: (context) {
                              var format = currencyFormat;
                              if (account.currencyCode != null) {
                                try {
                                  final currency = Currency.values.byName(account.currencyCode!);
                                  final info = currencyData[currency]!;
                                  format = NumberFormat.currency(locale: info.locale, symbol: info.symbol);
                                } catch (_) {}
                              }
                              return Text(
                                format.format(item.balance),
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: account.type.isLiability && item.balance > 0
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              ),
            ),
          ],
        );
      },
    );
  }
}
