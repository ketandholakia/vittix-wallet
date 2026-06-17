import 'package:expense_tracker/add_transaction_screen.dart';
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/core/providers/settings_providers.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
import 'package:expense_tracker/presentation/widgets/transaction_list_item.dart';
import 'package:expense_tracker/presentation/widgets/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  final Account? initialFilterAccount;

  const TransactionListScreen({super.key, this.initialFilterAccount});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState
    extends ConsumerState<TransactionListScreen> {
  late DateTime _selectedMonth;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Filters
  domain.TransactionType? _filterType;
  Category? _filterCategory;
  Account? _filterAccount;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  double? _filterMinAmount;
  double? _filterMaxAmount;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month, 1);
    _filterAccount = widget.initialFilterAccount;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
      // Clear date range on month change
      _filterStartDate = null;
      _filterEndDate = null;
    });
  }

  void _goToNextMonth() {
    final now = DateTime.now();
    final nextMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    // Don't go beyond current month
    if (nextMonth.isAfter(DateTime(now.year, now.month + 1, 0))) return;
    setState(() {
      _selectedMonth = nextMonth;
      // Clear date range on month change
      _filterStartDate = null;
      _filterEndDate = null;
    });
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year &&
        _selectedMonth.month == now.month;
  }

  List<domain.Transaction> _applyFilters(
      List<domain.Transaction> transactions) {
    return transactions.where((tx) {
      // Type filter
      if (_filterType != null && tx.type != _filterType) return false;

      // Category filter
      if (_filterCategory != null && tx.category.id != _filterCategory!.id) {
        return false;
      }

      // Account filter
      if (_filterAccount != null && tx.account.id != _filterAccount!.id) {
        return false;
      }

      // Date range filter
      if (_filterStartDate != null && tx.date.isBefore(_filterStartDate!)) {
        return false;
      }
      if (_filterEndDate != null &&
          tx.date.isAfter(_filterEndDate!.add(const Duration(days: 1)))) {
        return false;
      }

      // Amount range filter
      if (_filterMinAmount != null && tx.amount < _filterMinAmount!) return false;
      if (_filterMaxAmount != null && tx.amount > _filterMaxAmount!) return false;

      // Search query (note text or category name)
      if (_searchQuery.isNotEmpty) {
        final note = tx.note?.toLowerCase() ?? '';
        final categoryName = tx.category.name.toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!note.contains(query) && !categoryName.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool get _hasActiveFilters =>
      _filterType != null ||
      _filterCategory != null ||
      _filterAccount != null ||
      _filterStartDate != null ||
      _filterEndDate != null ||
      _filterMinAmount != null ||
      _filterMaxAmount != null;

  void _clearAllFilters() {
    setState(() {
      _filterType = null;
      _filterCategory = null;
      _filterAccount = null;
      _filterStartDate = null;
      _filterEndDate = null;
      _filterMinAmount = null;
      _filterMaxAmount = null;
      _searchQuery = '';
      _searchController.clear();
      _isSearching = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        domain.TransactionType? tempType = _filterType;
        Category? tempCategory = _filterCategory;
        Account? tempAccount = _filterAccount;
        DateTime? tempStartDate = _filterStartDate;
        DateTime? tempEndDate = _filterEndDate;
        final tempMinController = TextEditingController(
            text: _filterMinAmount != null ? _filterMinAmount.toString() : '');
        final tempMaxController = TextEditingController(
            text: _filterMaxAmount != null ? _filterMaxAmount.toString() : '');

        return StatefulBuilder(
          builder: (context, setModalState) {
            final monthStart = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
            final monthEnd = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter Transactions', style: Theme.of(context).textTheme.titleLarge),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempType = null;
                              tempCategory = null;
                              tempAccount = null;
                              tempStartDate = null;
                              tempEndDate = null;
                              tempMinController.clear();
                              tempMaxController.clear();
                            });
                          },
                          child: const Text('Reset All'),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Transaction Type
                    Text('Transaction Type', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<domain.TransactionType?>(
                        segments: const [
                          ButtonSegment(value: null, label: Text('All')),
                          ButtonSegment(value: domain.TransactionType.expense, label: Text('Expense')),
                          ButtonSegment(value: domain.TransactionType.income, label: Text('Income')),
                        ],
                        selected: {tempType},
                        onSelectionChanged: (newSelection) {
                          setModalState(() {
                            tempType = newSelection.first;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category
                    StreamBuilder<List<Category>>(
                      stream: ref.watch(watchAllCategoriesUseCaseProvider).call(),
                      builder: (context, snapshot) {
                        final rawCategories = snapshot.data ?? [];
                        // Flatten categories hierarchically
                        final topLevel = rawCategories.where((c) => c.parentId == null).toList();
                        final list = <Category>[];
                        for (final parent in topLevel) {
                          list.add(parent);
                          list.addAll(rawCategories.where((c) => c.parentId == parent.id));
                        }
                        for (final cat in rawCategories) {
                          if (cat.parentId != null && !topLevel.any((p) => p.id == cat.parentId)) {
                            list.add(cat);
                          }
                        }

                        // Find category matching the value
                        Category? dropdownValue;
                        if (tempCategory != null) {
                          dropdownValue = list.firstWhere(
                            (c) => c.id == tempCategory!.id,
                            orElse: () => tempCategory!,
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Category?>(
                              value: tempCategory != null ? dropdownValue : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.category),
                                border: OutlineInputBorder(),
                              ),
                              hint: const Text('All Categories'),
                              items: [
                                const DropdownMenuItem<Category?>(value: null, child: Text('All Categories')),
                                ...list.map((c) {
                                  final isSub = c.parentId != null;
                                  return DropdownMenuItem<Category?>(
                                    value: c,
                                    child: Row(
                                      children: [
                                        if (isSub) ...[
                                          const SizedBox(width: 16),
                                          Text('↳ ', style: TextStyle(color: Colors.grey[500])),
                                        ],
                                        Icon(c.icon, color: c.color, size: isSub ? 16 : 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          c.name,
                                          style: TextStyle(
                                            fontWeight: isSub ? FontWeight.normal : FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (val) {
                                setModalState(() {
                                  tempCategory = val;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Account
                    StreamBuilder<List<Account>>(
                      stream: ref.watch(watchAllAccountsUseCaseProvider).call(),
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Account', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Account?>(
                              value: tempAccount != null && list.contains(tempAccount) ? tempAccount : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                                border: OutlineInputBorder(),
                              ),
                              hint: const Text('All Accounts'),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Accounts')),
                                ...list.map((a) => DropdownMenuItem(
                                      value: a,
                                      child: Row(
                                        children: [
                                          Icon(a.icon, color: a.color, size: 20),
                                          const SizedBox(width: 8),
                                          Text(a.name),
                                        ],
                                      ),
                                    )),
                              ],
                              onChanged: (val) {
                                setModalState(() {
                                  tempAccount = val;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Range
                    Text('Date Range (within selected month)', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate ?? monthStart,
                                firstDate: monthStart,
                                lastDate: monthEnd,
                              );
                              if (picked != null) {
                                setModalState(() {
                                  tempStartDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today, size: 18),
                              ),
                              child: Text(
                                tempStartDate != null
                                    ? DateFormat.yMMMd().format(tempStartDate!)
                                    : 'Any Date',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate ?? monthEnd,
                                firstDate: monthStart,
                                lastDate: monthEnd,
                              );
                              if (picked != null) {
                                setModalState(() {
                                  tempEndDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today, size: 18),
                              ),
                              child: Text(
                                tempEndDate != null
                                    ? DateFormat.yMMMd().format(tempEndDate!)
                                    : 'Any Date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Amount Range
                    Text('Amount Range', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tempMinController,
                            decoration: const InputDecoration(
                              labelText: 'Min Amount',
                              border: OutlineInputBorder(),
                              prefixText: '₹',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: tempMaxController,
                            decoration: const InputDecoration(
                              labelText: 'Max Amount',
                              border: OutlineInputBorder(),
                              prefixText: '₹',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _filterType = tempType;
                            _filterCategory = tempCategory;
                            _filterAccount = tempAccount;
                            _filterStartDate = tempStartDate;
                            _filterEndDate = tempEndDate;
                            _filterMinAmount = double.tryParse(tempMinController.text);
                            _filterMaxAmount = double.tryParse(tempMaxController.text);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthlyTransactionsStream = ref.watch(transactionRepositoryProvider).watchTransactionsInMonth(_selectedMonth);
    final textTheme = Theme.of(context).textTheme;
    final monthLabel = DateFormat.yMMMM().format(_selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search by note or category...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              )
            : const Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter options',
            onPressed: _showFilterBottomSheet,
          ),
          if (_hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear all filters',
              onPressed: _clearAllFilters,
            ),
        ],
      ),
      body: StreamBuilder<List<domain.Transaction>>(
        stream: monthlyTransactionsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const ShimmerList();
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('An error occurred: ${snapshot.error}'));
          }

          final transactions = snapshot.data!;
          final currencyFormat = ref.watch(currencyFormatProvider);
          final filteredTransactions = _applyFilters(transactions);

          // Calculate totals from filtered transactions
          double filteredIncome = 0;
          double filteredExpense = 0;
          for (final tx in filteredTransactions) {
            if (tx.type == domain.TransactionType.income) {
              filteredIncome += tx.amount;
            } else {
              filteredExpense += tx.amount;
            }
          }

          return Column(
            children: [
              // Month Navigation
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _goToPreviousMonth,
                    ),
                    Text(
                      monthLabel,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _isCurrentMonth ? null : _goToNextMonth,
                    ),
                  ],
                ),
              ),

              // Summary Header
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryColumn(
                        'Income',
                        currencyFormat.format(filteredIncome),
                        Colors.green,
                        textTheme),
                    _buildSummaryColumn(
                        'Expense',
                        currencyFormat.format(filteredExpense),
                        Colors.red,
                        textTheme),
                    _buildSummaryColumn(
                        'Balance',
                        currencyFormat
                            .format(filteredIncome - filteredExpense),
                        Theme.of(context).colorScheme.primary,
                        textTheme),
                  ],
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.filter_list, size: 16),
                      label: const Text('Filters'),
                      onPressed: _showFilterBottomSheet,
                    ),
                    const SizedBox(width: 8),

                    // Type filter chip
                    if (_filterType != null) ...[
                      InputChip(
                        label: Text(_filterType == domain.TransactionType.income ? 'Income' : 'Expense'),
                        onDeleted: () => setState(() => _filterType = null),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Category filter chip
                    if (_filterCategory != null) ...[
                      InputChip(
                        avatar: Icon(_filterCategory!.icon, color: _filterCategory!.color, size: 16),
                        label: Text(_filterCategory!.name),
                        onDeleted: () => setState(() => _filterCategory = null),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Account filter chip
                    if (_filterAccount != null) ...[
                      InputChip(
                        avatar: Icon(_filterAccount!.icon, color: _filterAccount!.color, size: 16),
                        label: Text(_filterAccount!.name),
                        onDeleted: () => setState(() => _filterAccount = null),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Date range chip
                    if (_filterStartDate != null || _filterEndDate != null) ...[
                      InputChip(
                        label: Text(
                          _filterStartDate != null && _filterEndDate != null
                              ? '${DateFormat.Md().format(_filterStartDate!)} - ${DateFormat.Md().format(_filterEndDate!)}'
                              : _filterStartDate != null
                                  ? 'From ${DateFormat.Md().format(_filterStartDate!)}'
                                  : 'To ${DateFormat.Md().format(_filterEndDate!)}',
                        ),
                        onDeleted: () => setState(() {
                          _filterStartDate = null;
                          _filterEndDate = null;
                        }),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Amount range chip
                    if (_filterMinAmount != null || _filterMaxAmount != null) ...[
                      InputChip(
                        label: Text(
                          _filterMinAmount != null && _filterMaxAmount != null
                              ? '₹${_filterMinAmount!.toStringAsFixed(0)} - ₹${_filterMaxAmount!.toStringAsFixed(0)}'
                              : _filterMinAmount != null
                                  ? '≥ ₹${_filterMinAmount!.toStringAsFixed(0)}'
                                  : '≤ ₹${_filterMaxAmount!.toStringAsFixed(0)}',
                        ),
                        onDeleted: () => setState(() {
                          _filterMinAmount = null;
                          _filterMaxAmount = null;
                        }),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),

              // Transaction count
              if (_hasActiveFilters || _searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${filteredTransactions.length} of ${transactions.length} transactions',
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Transaction List
              Expanded(
                child: filteredTransactions.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        message: _hasActiveFilters || _searchQuery.isNotEmpty
                            ? 'No matching transactions'
                            : 'No transactions this month',
                        subMessage: _hasActiveFilters ||
                                _searchQuery.isNotEmpty
                            ? 'Try adjusting your filters or search.'
                            : 'Tap the + button to add your first one.',
                      )
                    : GroupedListView<domain.Transaction, DateTime>(
                        elements: filteredTransactions,
                        groupBy: (tx) => DateTime(tx.date.year, tx.date.month, tx.date.day),
                        groupHeaderBuilder: (domain.Transaction tx) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            _formatDateHeader(tx.date),
                            style: textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        itemBuilder: (context, tx) => TransactionListItem(transaction: tx),
                        useStickyGroupSeparators: false,
                        order: GroupedListOrder.DESC,
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryColumn(
      String title, String amount, Color color, TextTheme textTheme) {
    return Column(
      children: [
        Text(title,
            style:
                textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(amount,
            style: textTheme.titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) {
      return 'Today';
    } else if (compareDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }
}
