// BROKEN DEPENDENCY RESOLVED

import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/database/database_provider.dart';
import 'package:expense_tracker/core/domain/payee.dart' as domain_payee;
import 'package:expense_tracker/core/domain/tag.dart' as domain_tag;
import 'package:expense_tracker/core/domain/attachment.dart' as domain_attachment;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final domain.Transaction? existingTransaction;
  final domain.TransactionType? initialType;
  final double? initialAmount;
  final String? initialMerchant;

  const AddTransactionScreen({
    super.key,
    this.existingTransaction,
    this.initialType,
    this.initialAmount,
    this.initialMerchant,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  domain.TransactionType _selectedType = domain.TransactionType.expense;
  Category? _selectedCategory;
  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();
  bool _categorySuggested = false;
  
  domain_payee.Payee? _selectedPayee;
  List<domain_tag.Tag> _selectedTags = [];
  List<domain_attachment.Attachment> _attachments = [];

  late final CurrencyTextInputFormatter _amountFormatter;

  bool get _isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    
    final currency = ref.read(currencyProvider);
    final info = currencyData[currency]!;
    _amountFormatter = CurrencyTextInputFormatter.currency(
      locale: info.locale,
      symbol: info.symbol,
      decimalDigits: 0,
    );

    final tx = widget.existingTransaction;
    if (tx != null) {
      _amountController.text = _amountFormatter.formatDouble(tx.amount);
      _noteController.text = tx.note ?? '';
      _selectedType = tx.type;
      _selectedCategory = tx.category;
      _selectedAccount = tx.account;
      _selectedDate = tx.date;
      _selectedPayee = tx.payee;
      _selectedTags = List.from(tx.tags);
      _attachments = List.from(tx.attachments);
    } else {
      if (widget.initialType != null) {
        _selectedType = widget.initialType!;
      }
      if (widget.initialAmount != null) {
        _amountController.text = _amountFormatter.formatDouble(widget.initialAmount!);
      }
      if (widget.initialMerchant != null) {
        _noteController.text = widget.initialMerchant!;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Look up the most commonly used category for notes matching [noteText]
  /// from past transactions and suggest it.
  Future<void> _suggestCategoryFromNote(String noteText) async {
    if (noteText.length < 3 || _isEditing || _categorySuggested) return;
    final query = noteText.toLowerCase();
    try {
      final recentStream = ref.read(watchRecentTransactionsUseCaseProvider).call(limit: 200);
      final recentList = await recentStream.first;
      // Find transactions with similar notes
      final matching = recentList.where((tx) {
        final txNote = tx.note?.toLowerCase() ?? '';
        return txNote.contains(query) || query.contains(txNote);
      }).toList();
      if (matching.isEmpty) return;
      // Count category frequency
      final categoryCount = <int, int>{};
      Category? bestCategory;
      int bestCount = 0;
      for (final tx in matching) {
        final count = (categoryCount[tx.category.id] ?? 0) + 1;
        categoryCount[tx.category.id] = count;
        if (count > bestCount) {
          bestCount = count;
          bestCategory = tx.category;
        }
      }
      if (bestCategory != null && _selectedCategory?.id != bestCategory.id && mounted) {
        setState(() {
          _selectedCategory = bestCategory;
          _categorySuggested = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category auto-set to "${bestCategory.name}" based on similar notes'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _categorySuggested = false;
                });
              },
            ),
          ),
        );
      }
    } catch (_) {
      // Silently fail - this is a convenience feature
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final amount = _amountFormatter.getDouble();
      if (_selectedCategory == null || _selectedAccount == null) {
        return;
      }

      final existing = widget.existingTransaction;

      final transaction = domain.Transaction(
        id: existing?.id ?? 0,
        amount: amount,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        type: _selectedType,
        category: _selectedCategory!,
        account: _selectedAccount!,
        payee: _selectedPayee,
        tags: _selectedTags,
        attachments: _attachments,
        createdAt: existing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_isEditing) {
        ref.read(updateTransactionUseCaseProvider).call(transaction);
      } else {
        // Duplicate detection: check recent transactions for same amount, date, account
        final recentStream = ref.read(watchRecentTransactionsUseCaseProvider).call(limit: 50);
        final recentList = await recentStream.first;
        final isDuplicate = recentList.any((tx) =>
            tx.amount == amount &&
            tx.date.year == _selectedDate.year &&
            tx.date.month == _selectedDate.month &&
            tx.date.day == _selectedDate.day &&
            tx.account.id == _selectedAccount!.id);

        if (isDuplicate && mounted) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
              title: const Text('Possible Duplicate'),
              content: const Text(
                'A transaction with the same amount, date, and account already exists. Add it anyway?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Add Anyway'),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
        }

        ref.read(addTransactionUseCaseProvider).call(transaction);
        ref.read(lastSelectedAccountIdProvider.notifier).updateLastSelectedAccountId(_selectedAccount!.id);
        ref.read(lastSelectedCategoryIdProvider.notifier).updateLastSelectedCategoryId(_selectedCategory!.id);
      }
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(watchAllCategoriesUseCaseProvider).call();
    final accounts = ref.watch(watchAllAccountsUseCaseProvider).call();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Type Toggle
              SegmentedButton<domain.TransactionType>(
                segments: const [
                  ButtonSegment(value: domain.TransactionType.expense, label: Text('Expense')),
                  ButtonSegment(value: domain.TransactionType.income, label: Text('Income')),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount', prefixIcon: Icon(Icons.payments_outlined)),
                keyboardType: TextInputType.number,
                inputFormatters: [_amountFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  final amount = _amountFormatter.getDouble();
                  if (amount <= 0) {
                    return 'Please enter a valid amount greater than 0.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Account
              StreamBuilder<List<Account>>(
                stream: accounts,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final accountList = snapshot.data!;
                  if (_selectedAccount == null) {
                    final lastId = ref.read(lastSelectedAccountIdProvider);
                    if (lastId != null) {
                      try {
                        _selectedAccount = accountList.firstWhere((a) => a.id == lastId);
                      } catch (e) {
                        _selectedAccount = accountList.firstWhere(
                          (a) => a.type == AccountType.cash,
                          orElse: () => accountList.first,
                        );
                      }
                    } else {
                      _selectedAccount = accountList.firstWhere(
                        (a) => a.type == AccountType.cash,
                        orElse: () => accountList.first,
                      );
                    }
                  }
                  return DropdownButtonFormField<Account>(
                    value: _selectedAccount,
                    decoration: const InputDecoration(
                      labelText: 'Account',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: accountList.map((account) {
                      return DropdownMenuItem(
                        value: account,
                        child: Row(
                          children: [
                            Icon(account.icon, color: account.color),
                            const SizedBox(width: 8),
                            Text('${account.name} (${account.type.label})'),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedAccount = value),
                    validator: (value) => value == null ? 'Please select an account.' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Category
              StreamBuilder<List<Category>>(
                stream: categories,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rawCategories = snapshot.data!;
                  // Flatten categories hierarchically
                  final topLevel = rawCategories.where((c) => c.parentId == null).toList();
                  final categoryList = <Category>[];
                  for (final parent in topLevel) {
                    categoryList.add(parent);
                    categoryList.addAll(rawCategories.where((c) => c.parentId == parent.id));
                  }
                  for (final cat in rawCategories) {
                    if (cat.parentId != null && !topLevel.any((p) => p.id == cat.parentId)) {
                      categoryList.add(cat);
                    }
                  }

                  // Find active category matching the value
                  Category? dropdownValue;
                  if (_selectedCategory == null && !_isEditing) {
                    final lastId = ref.read(lastSelectedCategoryIdProvider);
                    if (lastId != null) {
                      try {
                        _selectedCategory = categoryList.firstWhere((c) => c.id == lastId);
                      } catch (e) {
                        // ignore
                      }
                    }
                  }

                  if (_selectedCategory != null) {
                    dropdownValue = categoryList.firstWhere(
                      (c) => c.id == _selectedCategory!.id,
                      orElse: () => _selectedCategory!,
                    );
                  }

                  return DropdownButtonFormField<Category>(
                    value: dropdownValue,
                    decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                    items: categoryList.map((category) {
                      final isSub = category.parentId != null;
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            if (isSub) ...[
                              const SizedBox(width: 16),
                              Text('↳ ', style: TextStyle(color: Colors.grey[500])),
                            ],
                            Icon(
                              category.icon, 
                              color: category.color,
                              size: isSub ? 16 : 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontWeight: isSub ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category.' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Date
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _pickDate,
                  ),
                ),
                controller: TextEditingController(text: DateFormat.yMMMd().format(_selectedDate)),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (Optional)', prefixIcon: Icon(Icons.note)),
                maxLines: 2,
                onChanged: (value) {
                  _suggestCategoryFromNote(value);
                },
              ),
              const SizedBox(height: 16),
              // Payee
              StreamBuilder<List<domain_payee.Payee>>(
                stream: Stream.value(<domain_payee.Payee>[]),
                builder: (context, snapshot) {
                  final payees = snapshot.data ?? [];
                  return DropdownButtonFormField<domain_payee.Payee>(
                    value: _selectedPayee,
                    decoration: const InputDecoration(labelText: 'Payee (Optional)', prefixIcon: Icon(Icons.person)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      ...payees.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name),
                          )),
                    ],
                    onChanged: (value) => setState(() => _selectedPayee = value),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Tags (Simplified multi-select visual representation)
              StreamBuilder<List<domain_tag.Tag>>(
                stream: Stream.value(<domain_tag.Tag>[]),
                builder: (context, snapshot) {
                  final tags = snapshot.data ?? [];
                  return InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tags (Optional)',
                      prefixIcon: Icon(Icons.label),
                      border: OutlineInputBorder(),
                    ),
                    child: Wrap(
                      spacing: 8,
                      children: tags.map((t) {
                        final isSelected = _selectedTags.any((st) => st.id == t.id);
                        return FilterChip(
                          label: Text(t.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(t);
                              } else {
                                _selectedTags.removeWhere((st) => st.id == t.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Attachments (Mock Add button for now)
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Attachments',
                  prefixIcon: Icon(Icons.attachment),
                  border: OutlineInputBorder(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_attachments.isEmpty) const Text('No attachments'),
                    ..._attachments.map((a) => Text(a.filePath)),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Attachment'),
                      onPressed: () {
                        // Mock adding an attachment
                        setState(() {
                          _attachments.add(domain_attachment.Attachment(
                            id: 0,
                            filePath: 'dummy_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg',
                          ));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
