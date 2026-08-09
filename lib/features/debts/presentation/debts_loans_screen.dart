import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Column;
import 'package:expense_tracker/features/debts/data/debts_dao.dart';
import 'package:expense_tracker/features/debts/data/tables/peer_debts_table.dart';
import 'package:expense_tracker/core/database/database_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/features/debts/presentation/debts_overview_widget.dart';

// Repayment calculation helper
double calculateEmi(double principal, double annualRate, int tenureMonths) {
  if (annualRate == 0 || tenureMonths == 0) return principal / (tenureMonths > 0 ? tenureMonths : 1);
  final double r = annualRate / 12 / 100;
  return principal * (r * math.pow(1 + r, tenureMonths)) / (math.pow(1 + r, tenureMonths) - 1);
}

// Stream providers for dynamic updates
final loansStreamProvider = StreamProvider<List<LoanDb>>((ref) {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return db.debtsDao.watchAllLoans(walletId);
});

final peerDebtsStreamProvider = StreamProvider<List<PeerDebtDb>>((ref) {
  final db = ref.watch(databaseProvider);
  final walletId = ref.watch(currentWalletIdProvider);
  return db.debtsDao.watchPeerDebts(walletId);
});

class DebtsLoansScreen extends ConsumerStatefulWidget {
  const DebtsLoansScreen({super.key});

  @override
  ConsumerState<DebtsLoansScreen> createState() => _DebtsLoansScreenState();
}

class _DebtsLoansScreenState extends ConsumerState<DebtsLoansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts & Loans'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.account_balance), text: 'Institutional Loans'),
            Tab(icon: Icon(Icons.people), text: 'Peer Debts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LoansTab(),
          _PeerDebtsTab(),
        ],
      ),
    );
  }
}

// ==========================================
// LOANS TAB
// ==========================================
class _LoansTab extends ConsumerWidget {
  const _LoansTab();

  Future<double> _getAccountBalance(AppDatabase db, int accountId, int walletId) async {
    final accounts = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
    final account = accounts.firstWhere((a) => a.id == accountId);
    return await db.accountDao.getBalanceForAccount(account);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansStreamProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider);
    final db = ref.watch(databaseProvider);
    final walletId = ref.watch(currentWalletIdProvider);

    return Scaffold(
      body: loansAsync.when(
        data: (loans) {
          final activeLoans = loans.where((l) => l.isActive).toList();
          final inactiveLoans = loans.where((l) => !l.isActive).toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (activeLoans.isEmpty) ...[
                const SizedBox(height: 64),
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.account_balance, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No active institutional loans',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create a loan to start tracking principal remaining and EMIs.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text('Active Loans', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...activeLoans.map((loan) {
                  return FutureBuilder<double>(
                    future: _getAccountBalance(db, loan.accountId, walletId),
                    builder: (context, snapshot) {
                      final outstanding = snapshot.data ?? loan.principalAmount;
                      final repaid = math.max(0.0, loan.principalAmount - outstanding);
                      final progress = loan.principalAmount > 0 ? repaid / loan.principalAmount : 0.0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      loan.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    currencyFormatter.format(outstanding),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Principal: ${currencyFormatter.format(loan.principalAmount)} @ ${loan.interestRate}% APR',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              
                              // Repayment Progress Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Repaid: ${currencyFormatter.format(repaid)} (${(progress * 100).toStringAsFixed(1)}%)',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  Text(
                                    'Remaining: ${currencyFormatter.format(outstanding)}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  color: Colors.teal,
                                  backgroundColor: Colors.teal.withValues(alpha: 0.1),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EMI: ${currencyFormatter.format(loan.emiAmount)} / mo',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      if (loan.nextEmiDate != null)
                                        Text(
                                          'Next Due: ${DateFormat('yyyy-MM-dd').format(loan.nextEmiDate!)}',
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.payment, size: 16),
                                        label: const Text('Log Repayment'),
                                        onPressed: () => _showRepaymentDialog(context, ref, loan, outstanding),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.check_circle_outline, color: Colors.grey),
                                        tooltip: 'Close Loan',
                                        onPressed: () => _confirmCloseLoan(context, ref, loan),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],

              if (inactiveLoans.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Closed Loans', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 8),
                ...inactiveLoans.map((loan) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.04)),
                    ),
                    child: ListTile(
                      title: Text(loan.name, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                      subtitle: Text('Paid off principal: ${currencyFormatter.format(loan.principalAmount)}', style: const TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.check, color: Colors.teal),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Loan'),
        onPressed: () => _showAddLoanSheet(context, ref),
      ),
    );
  }

  void _showAddLoanSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddLoanSheet(),
    );
  }

  void _showRepaymentDialog(BuildContext context, WidgetRef ref, LoanDb loan, double outstanding) {
    showDialog(
      context: context,
      builder: (context) => _RepaymentDialog(loan: loan, outstanding: outstanding),
    );
  }

  void _confirmCloseLoan(BuildContext context, WidgetRef ref, LoanDb loan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close Loan?'),
        content: Text('Are you sure you want to mark "${loan.name}" as closed/fully repaid? This will set its status to inactive.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await (db.update(db.loans)
                ..where((l) => l.id.equals(loan.id)))
                .write(LoansCompanion(
                  isActive: const Value(false),
                  updatedAt: Value(DateTime.now()),
                ));
              if (context.mounted) Navigator.of(context).pop();
              
            },
            child: const Text('Close Loan', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
}

class _AddLoanSheet extends ConsumerStatefulWidget {
  const _AddLoanSheet();

  @override
  ConsumerState<_AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends ConsumerState<_AddLoanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _tenureController = TextEditingController();
  DateTime _startDate = DateTime.now();

  double _calculatedEmi = 0;

  @override
  void initState() {
    super.initState();
    _principalController.addListener(_updateCalculatedEmi);
    _rateController.addListener(_updateCalculatedEmi);
    _tenureController.addListener(_updateCalculatedEmi);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _updateCalculatedEmi() {
    final double p = double.tryParse(_principalController.text) ?? 0;
    final double r = double.tryParse(_rateController.text) ?? 0;
    final int n = int.tryParse(_tenureController.text) ?? 0;
    setState(() {
      _calculatedEmi = calculateEmi(p, r, n);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final currencyFormatter = ref.watch(currencyFormatProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 20.0,
        bottom: mediaQuery.viewInsets.bottom + 20.0,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Institutional Loan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Loan Name',
                hintText: 'e.g. Home Loan, Car Loan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a loan name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _principalController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: const InputDecoration(
                      labelText: 'Principal Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    validator: (val) => val == null || double.tryParse(val) == null || double.parse(val) <= 0
                        ? 'Enter valid principal'
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: const InputDecoration(
                      labelText: 'Interest Rate (%)',
                      hintText: 'Annual %',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent),
                    ),
                    validator: (val) => val == null || double.tryParse(val) == null || double.parse(val) < 0
                        ? 'Enter valid rate'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tenureController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Tenure (Months)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (val) => val == null || int.tryParse(val) == null || int.parse(val) <= 0
                        ? 'Enter valid tenure'
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      'Start: ${DateFormat('yyyy-MM-dd').format(_startDate)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            // EMI Calculator Preview Card
            if (_calculatedEmi > 0) ...[
              const SizedBox(height: 20),
              Card(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Calculated Monthly EMI:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(_calculatedEmi),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submit,
              child: const Text('Save & Create Loan Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);
    final String name = _nameController.text.trim();
    final double principal = double.parse(_principalController.text);
    final double rate = double.parse(_rateController.text);
    final int tenure = int.parse(_tenureController.text);

    // 1. Create a matching Loan Account inside a Transaction
    await db.transaction(() async {
      final accId = await db.into(db.accounts).insert(
        AccountsCompanion.insert(
          
          name: '$name (Loan)',
          type: AccountType.loan,
          icon: Icons.account_balance.codePoint,
          color: 'FFFF5722', // Deep Orange for Loan liability
          openingBalance: Value(principal),
          isDefault: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 2. Insert Loan detail record
      final nextEmiDate = DateTime(_startDate.year, _startDate.month + 1, _startDate.day);
      await db.into(db.loans).insert(
        LoansCompanion.insert(
          
          name: name,
          accountId: accId,
          principalAmount: principal,
          interestRate: rate,
          tenureMonths: tenure,
          startDate: _startDate,
          nextEmiDate: Value(nextEmiDate),
          emiAmount: _calculatedEmi,
          isActive: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });

    if (mounted) Navigator.of(context).pop();
  }
}

class _RepaymentDialog extends ConsumerStatefulWidget {
  final LoanDb loan;
  final double outstanding;
  const _RepaymentDialog({required this.loan, required this.outstanding});

  @override
  ConsumerState<_RepaymentDialog> createState() => _RepaymentDialogState();
}

class _RepaymentDialogState extends ConsumerState<_RepaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  Account? _selectedAccount;
  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.loan.emiAmount.toStringAsFixed(2);
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final db = ref.read(databaseProvider);
    final walletId = ref.read(currentWalletIdProvider);
    final list = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
    setState(() {
      // Repayments should come from bank, cash, or credit accounts (not loan accounts themselves)
      _accounts = list.where((a) => a.type! != AccountType.loan).toList();
      if (_accounts.isNotEmpty) {
        _selectedAccount = _accounts.firstWhere((a) => a.isDefault, orElse: () => _accounts.first);
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(content: SizedBox(height: 80, child: Center(child: CircularProgressIndicator())));
    }

    return AlertDialog(
      title: const Text('Log Repayment'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Make repayment for: ${widget.loan.name}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: const InputDecoration(
                labelText: 'Repayment Amount',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || double.tryParse(val) == null || double.parse(val) <= 0
                  ? 'Enter valid amount'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Account>(
              initialValue: _selectedAccount,
              decoration: const InputDecoration(
                labelText: 'Pay From Account',
                border: OutlineInputBorder(),
              ),
              items: _accounts.map((acc) {
                return DropdownMenuItem(
                  value: acc,
                  child: Text(acc.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedAccount = val;
                });
              },
              validator: (val) => val == null ? 'Please select an account' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Submit Payment'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAccount == null) return;

    final db = ref.read(databaseProvider);
    final double payAmount = double.parse(_amountController.text);
    final int sourceAccountId = _selectedAccount!.id;
    final int loanAccountId = widget.loan.accountId;

    // Find the 'Transfer' category
    final categories = await db.select(db.categories).get();
    final transferCategory = categories.firstWhere(
      (c) => c.name.toLowerCase() == 'transfer',
      orElse: () => categories.first,
    );

    await db.transaction(() async {
      // Repayment is logged as a Dual Transfer transaction pair:
      final String note = 'EMI repayment for: ${widget.loan.name}';
      final now = DateTime.now();

      // Transaction 1: Expense from source account
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          amount: payAmount,
          date: now,
          note: Value(note),
          type: TransactionType.expense,
          categoryId: transferCategory.id,
          accountId: sourceAccountId,
          updatedAt: Value(now),
        ),
      );

      // Transaction 2: Income (Repayment reducer) to Loan Account
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          amount: payAmount,
          date: now,
          note: Value(note),
          type: TransactionType.income,
          categoryId: transferCategory.id,
          accountId: loanAccountId,
          updatedAt: Value(now),
        ),
      );

      // Update next payment date in Loans table
      final currentNextEmi = widget.loan.nextEmiDate ?? now;
      final newNextEmi = DateTime(currentNextEmi.year, currentNextEmi.month + 1, currentNextEmi.day);

      await (db.update(db.loans)..where((l) => l.id.equals(widget.loan.id)))
        .write(LoansCompanion(
          nextEmiDate: Value(newNextEmi),
          updatedAt: Value(now),
        ));
    });

    if (mounted) Navigator.of(context).pop();
  }
}

// ==========================================
// PEER DEBTS TAB
// ==========================================
class _PeerDebtsTab extends ConsumerStatefulWidget {
  const _PeerDebtsTab();

  @override
  ConsumerState<_PeerDebtsTab> createState() => _PeerDebtsTabState();
}

class _PeerDebtsTabState extends ConsumerState<_PeerDebtsTab> {
  bool _showSettled = false;

  @override
  Widget build(BuildContext context) {
    final debtsAsync = ref.watch(peerDebtsStreamProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider);

    return Scaffold(
      body: debtsAsync.when(
        data: (debts) {
          final filteredDebts = debts.where((d) => d.isSettled! == _showSettled).toList();

          // Calculate summary cards
          double totalOwedToYou = 0; // Lent and active
          double totalYouOwe = 0;   // Borrowed and active
          for (final d in debts.where((d) => !d.isSettled!)) {
            if (d.type! == PeerDebtType.lent) {
              totalOwedToYou += d.amount!;
            } else {
              totalYouOwe += d.amount!;
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Net balance card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Peer Net Balances', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                currencyFormatter.format(totalOwedToYou),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                              ),
                              const Text('Owed to You', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 32, child: VerticalDivider()),
                          Column(
                            children: [
                              Text(
                                currencyFormatter.format(totalYouOwe),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                              ),
                              const Text('You Owe', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Toggle row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showSettled ? 'Settled History' : 'Active Peer Debts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    icon: Icon(_showSettled ? Icons.history : Icons.check_circle),
                    label: Text(_showSettled ? 'Show Active' : 'Show Settled'),
                    onPressed: () {
                      setState(() {
                        _showSettled = !_showSettled;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (filteredDebts.isEmpty) ...[
                const SizedBox(height: 48),
                Center(
                  child: Text(
                    _showSettled ? 'No settled debts history' : 'No active peer debts',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ] else ...[
                ...filteredDebts.map((debt) {
                  final isLent = debt.type! == PeerDebtType.lent;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.06)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isLent ? Colors.teal.withValues(alpha: 0.08) : Colors.deepOrange.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLent ? Icons.arrow_outward : Icons.arrow_downward,
                          color: isLent ? Colors.teal : Colors.deepOrange,
                          size: 20,
                        ),
                      ),
                      title: Text(debt.personName!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((debt.note ?? '') != null && (debt.note ?? '')!.isNotEmpty) ...[
                            Text((debt.note ?? '')!, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            '${DateFormat('yyyy-MM-dd').format(debt.date!)} • ${isLent ? 'Lent' : 'Borrowed'}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currencyFormatter.format(debt.amount!),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isLent ? Colors.teal : Colors.deepOrange,
                            ),
                          ),
                          if (!debt.isSettled!) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.done_all, color: Colors.teal),
                              tooltip: 'Settle Up',
                              onPressed: () => _settleDebt(context, debt),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Log Peer Debt'),
        onPressed: () => _showAddPeerDebtSheet(context),
      ),
    );
  }

  void _showAddPeerDebtSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddPeerDebtSheet(),
    );
  }

  void _settleDebt(BuildContext context, PeerDebtDb debt) {
    showDialog(
      context: context,
      builder: (context) => _SettlePeerDebtDialog(debt: debt),
    );
  }
}

class _AddPeerDebtSheet extends ConsumerStatefulWidget {
  const _AddPeerDebtSheet();

  @override
  ConsumerState<_AddPeerDebtSheet> createState() => _AddPeerDebtSheetState();
}

class _AddPeerDebtSheetState extends ConsumerState<_AddPeerDebtSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  PeerDebtType _debtType = PeerDebtType.lent;
  DateTime _debtDate = DateTime.now();

  bool _linkAccount = true;
  Account? _selectedAccount;
  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final db = ref.read(databaseProvider);
    final walletId = ref.read(currentWalletIdProvider);
    final list = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
    setState(() {
      _accounts = list.where((a) => a.type! != AccountType.loan).toList();
      if (_accounts.isNotEmpty) {
        _selectedAccount = _accounts.firstWhere((a) => a.isDefault, orElse: () => _accounts.first);
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (_isLoading) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 20.0,
        bottom: mediaQuery.viewInsets.bottom + 20.0,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log Peer Debt',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<PeerDebtType>(
              segments: const [
                ButtonSegment(value: PeerDebtType.lent, label: Text('Lent (Owed to me)'), icon: Icon(Icons.arrow_outward)),
                ButtonSegment(value: PeerDebtType.borrowed, label: Text('Borrowed (I owe)'), icon: Icon(Icons.arrow_downward)),
              ],
              selected: {_debtType},
              onSelectionChanged: (set) {
                setState(() {
                  _debtType = set.first;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Person Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                    ),
                    validator: (val) => val == null || double.tryParse(val) == null || double.parse(val) <= 0
                        ? 'Enter valid amount'
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(DateFormat('yyyy-MM-dd').format(_debtDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _debtDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _debtDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 16),
            
            // Link account switch
            SwitchListTile(
              title: const Text('Adjust Account Balance'),
              subtitle: const Text('Log a transaction to track the actual cash movement'),
              value: _linkAccount,
              onChanged: (val) {
                setState(() {
                  _linkAccount = val;
                });
              },
            ),
            if (_linkAccount && _selectedAccount != null) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<Account>(
                initialValue: _selectedAccount,
                decoration: const InputDecoration(
                  labelText: 'Account to Adjust',
                  border: OutlineInputBorder(),
                ),
                items: _accounts.map((acc) {
                  return DropdownMenuItem(
                    value: acc,
                    child: Text(acc.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedAccount = val;
                  });
                },
                validator: (val) => _linkAccount && val == null ? 'Please select an account' : null,
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submit,
              child: const Text('Save Peer Debt'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);
    final String name = _nameController.text.trim();
    final double amount = double.parse(_amountController.text);
    final String note = _noteController.text.trim();

    await db.transaction(() async {
      int? transactionId;

      if (_linkAccount && _selectedAccount != null) {
        // Find the 'Transfer' category as a fallback, or fallback to first category
        final categories = await db.select(db.categories).get();
        final transferCategory = categories.firstWhere(
          (c) => c.name.toLowerCase() == 'transfer',
          orElse: () => categories.first,
        );

        // Auto log transaction:
        // Lent: you gave cash -> Expense
        // Borrowed: you received cash -> Income
        final txType = _debtType == PeerDebtType.lent ? TransactionType.expense : TransactionType.income;
        final txNote = '${_debtType == PeerDebtType.lent ? 'Lent to' : 'Borrowed from'} $name ${note.isNotEmpty ? '($note)' : ''}';

        transactionId = await db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            amount: amount,
            date: _debtDate,
            note: Value(txNote),
            type: txType,
            categoryId: transferCategory.id,
            accountId: _selectedAccount!.id,
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // Create Peer Debt entry
      await db.into(db.peerDebts).insert(
        PeerDebtsCompanion.insert(
          
          personName: name,
          type: _debtType,
          amount: amount,
          note: Value(note.isNotEmpty ? note : null),
          date: _debtDate,
          isSettled: const Value(false),
          transactionId: Value(transactionId),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });

    if (mounted) Navigator.of(context).pop();
  }
}

class _SettlePeerDebtDialog extends ConsumerStatefulWidget {
  final PeerDebtDb debt;
  const _SettlePeerDebtDialog({required this.debt});

  @override
  ConsumerState<_SettlePeerDebtDialog> createState() => _SettlePeerDebtDialogState();
}

class _SettlePeerDebtDialogState extends ConsumerState<_SettlePeerDebtDialog> {
  bool _linkAccount = true;
  Account? _selectedAccount;
  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final db = ref.read(databaseProvider);
    final walletId = ref.read(currentWalletIdProvider);
    final list = await (db.select(db.accounts)..where((a) => a.walletId.equals(walletId))).get();
    setState(() {
      _accounts = list.where((a) => a.type! != AccountType.loan).toList();
      if (_accounts.isNotEmpty) {
        _selectedAccount = _accounts.firstWhere((a) => a.isDefault, orElse: () => _accounts.first);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(content: SizedBox(height: 80, child: Center(child: CircularProgressIndicator())));
    }

    final isLent = widget.debt.type! == PeerDebtType.lent;

    return AlertDialog(
      title: const Text('Settle Debt?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLent
                ? 'Mark that ${widget.debt.personName!} paid you back?'
                : 'Mark that you paid back ${widget.debt.personName!}?',
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Log Repayment Transaction'),
            subtitle: const Text('Record cash receipt/payment inside an account'),
            contentPadding: EdgeInsets.zero,
            value: _linkAccount,
            onChanged: (val) {
              setState(() {
                _linkAccount = val;
              });
            },
          ),
          if (_linkAccount && _selectedAccount != null) ...[
            const SizedBox(height: 8),
            DropdownButtonFormField<Account>(
              initialValue: _selectedAccount,
              decoration: const InputDecoration(
                labelText: 'Account to Adjust',
                border: OutlineInputBorder(),
              ),
              items: _accounts.map((acc) {
                return DropdownMenuItem(
                  value: acc,
                  child: Text(acc.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedAccount = val;
                });
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Settle Up', style: TextStyle(color: Colors.teal)),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    await db.transaction(() async {
      if (_linkAccount && _selectedAccount != null) {
        // Original Lent -> Settlement is Income (getting money back)
        // Original Borrowed -> Settlement is Expense (paying money back)
        final txType = widget.debt.type! == PeerDebtType.lent ? TransactionType.income : TransactionType.expense;
        final note = 'Settlement for peer debt: ${widget.debt.personName!}';

        // Find the 'Transfer' category
        final categories = await db.select(db.categories).get();
        final transferCategory = categories.firstWhere(
          (c) => c.name.toLowerCase() == 'transfer',
          orElse: () => categories.first,
        );

        await db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            amount: widget.debt.amount!,
            date: now,
            note: Value(note),
            type: txType,
            categoryId: transferCategory.id,
            accountId: _selectedAccount!.id,
            updatedAt: Value(now),
          ),
        );
      }

      // Mark debt settled
      await (db.update(db.peerDebts)..where((pd) => pd.id.equals(widget.debt.id)))
        .write(PeerDebtsCompanion(
          isSettled: const Value(true),
          updatedAt: Value(now),
        ));
    });

    if (mounted) Navigator.of(context).pop();
  }
}
