// BROKEN DEPENDENCY: db.debtsDao.peerDebts
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/core/database/database_provider.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Column;
import 'package:expense_tracker/features/debts/data/debts_dao.dart';
import 'package:expense_tracker/features/debts/data/tables/peer_debts_table.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/features/debts/presentation/debts_loans_screen.dart';

final debtsSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);

  final peerDebtsFuture =
      (db.select(db.debtsDao.peerDebts)..where((pd) => pd.walletId.equals(walletId) & pd.isSettled!.equals(false))).get();
  final activeLoansFuture = (db.select(db.debtsDao.loans)..where((l) => l.walletId.equals(walletId) & l.isActive.equals(true))).get();

  final peerDebts = await peerDebtsFuture;
  final activeLoans = await activeLoansFuture;

  double lentTotal = 0;
  double borrowedTotal = 0;
  for (final pd in peerDebts) {
    if (pd.type! == PeerDebtType.lent) {
      lentTotal += pd.amount!;
    } else {
      borrowedTotal += pd.amount!;
    }
  }

  final accounts = await (db.select(db.accounts)
        ..where((a) => a.walletId.equals(walletId) & a.id.isIn(activeLoans.map((loan) => loan.accountId).toList())))
      .get();
  final balancesByAccountId = await db.accountDao.getBalancesForAccounts(accounts, walletId);

  double loanTotal = 0;
  DateTime? nextEmiDate;
  for (final loan in activeLoans) {
    loanTotal += balancesByAccountId[loan.accountId] ?? loan.principalAmount;
    if (loan.nextEmiDate != null && (nextEmiDate == null || loan.nextEmiDate!.isBefore(nextEmiDate))) {
      nextEmiDate = loan.nextEmiDate;
    }
  }

  return {
    'lentTotal': lentTotal,
    'borrowedTotal': borrowedTotal,
    'loanTotal': loanTotal,
    'nextEmiDate': nextEmiDate,
    'hasActiveLoans': activeLoans.isNotEmpty,
    'hasActivePeerDebts': peerDebts.isNotEmpty,
  };
});

class DebtsOverviewWidget extends ConsumerWidget {
  const DebtsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = const AsyncValue.data(null);
    final currencyFormatter = ref.watch(currencyFormatProvider);

    return summaryAsync.when(
      data: (summary) {
        final double lent = summary['lentTotal'] as double;
        final double borrowed = summary['borrowedTotal'] as double;
        final double institutional = summary['loanTotal'] as double;
        final DateTime? nextEmi = summary['nextEmiDate'] as DateTime?;
        final bool hasLoans = summary['hasActiveLoans'] as bool;
        final bool hasPeer = summary['hasActivePeerDebts'] as bool;

        if (!hasLoans && !hasPeer) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.account_balance_outlined, color: Theme.of(context).colorScheme.primary),
              ),
              title: const Text('Track Loans & Debts'),
              subtitle: const Text('Manage EMIs and peer lent/borrowed balances'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DebtsLoansScreen()),
                ).then((_) => ref.invalidate(debtsSummaryProvider));
              },
            ),
          );
        }

        final netOwed = lent - borrowed;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DebtsLoansScreen()),
              ).then((_) => ref.invalidate(debtsSummaryProvider));
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.handshake_outlined, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Debts & Loans',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peer Balances',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  netOwed >= 0 ? '+' : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: netOwed >= 0 ? Colors.teal : Colors.deepOrange,
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(netOwed.abs()),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: netOwed >= 0 ? Colors.teal : Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              netOwed >= 0 ? 'Owed to you (Net)' : 'You owe (Net)',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(
                        height: 40,
                        child: VerticalDivider(width: 1),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Institutional Debt',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormatter.format(institutional),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: institutional > 0 ? Colors.redAccent : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              nextEmi != null
                                  ? 'Next EMI: ${DateFormat('MMM dd').format(nextEmi)}'
                                  : 'No upcoming EMIs',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading debts: $err'),
        ),
      ),
    );
  }
}

*/