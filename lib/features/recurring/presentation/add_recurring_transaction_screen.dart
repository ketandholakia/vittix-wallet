import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/categories/domain/category.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';
import 'package:expense_tracker/features/transactions/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

class AddRecurringTransactionScreen extends ConsumerStatefulWidget {
  const AddRecurringTransactionScreen({super.key});

  @override
  ConsumerState<AddRecurringTransactionScreen> createState() =>
      _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState
    extends ConsumerState<AddRecurringTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  Account? _selectedAccount;
  RecurringInterval _selectedInterval = RecurringInterval.monthly;
  DateTime _selectedStartDate = DateTime.now();
  bool _isSaving = false;

  late final CurrencyTextInputFormatter _amountFormatter;

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedStartDate) {
      setState(() {
        _selectedStartDate = pickedDate;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_isSaving) return;

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final amount = _amountFormatter.getDouble();
      if (_selectedCategory == null || _selectedAccount == null) {
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final template = RecurringTransaction(
          id: 0,
          name: name,
          amount: amount,
          type: _selectedType,
          category: _selectedCategory!,
          account: _selectedAccount!,
          interval: _selectedInterval,
          startDate: _selectedStartDate,
          nextDueDate: _selectedStartDate, // Next due starts as start date
          isActive: true,
        );

        await ref.read(addRecurringUseCaseProvider).call(template);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving template: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesStream = ref.watch(watchAllCategoriesUseCaseProvider).call();
    final accountsStream = ref.watch(watchAllAccountsUseCaseProvider).call();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recurring Template'),
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
              // Segmented Type Button
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(value: TransactionType.expense, label: Text('Expense')),
                  ButtonSegment(value: TransactionType.income, label: Text('Income')),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Template Name',
                  prefixIcon: Icon(Icons.title),
                  hintText: 'e.g. Rent, Netflix subscription, Salary',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
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

              // Account Dropdown
              StreamBuilder<List<Account>>(
                stream: accountsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final accountList = snapshot.data!;
                  _selectedAccount ??= accountList.firstWhere(
                    (a) => a.type == AccountType.cash,
                    orElse: () => accountList.first,
                  );

                  return DropdownButtonFormField<Account>(
                    initialValue: _selectedAccount,
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
                            Text(account.name),
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

              // Category Dropdown
              StreamBuilder<List<Category>>(
                stream: categoriesStream,
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
                  if (_selectedCategory != null) {
                    dropdownValue = categoryList.firstWhere(
                      (c) => c.id == _selectedCategory!.id,
                      orElse: () => _selectedCategory!,
                    );
                  }

                  return DropdownButtonFormField<Category>(
                    initialValue: dropdownValue,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
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
                    onChanged: (value) => setState(() => _selectedCategory = value),
                    validator: (value) => value == null ? 'Please select a category.' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Interval Choice
              Text('Recurring Interval', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<RecurringInterval>(
                segments: const [
                  ButtonSegment(value: RecurringInterval.daily, label: Text('Daily')),
                  ButtonSegment(value: RecurringInterval.weekly, label: Text('Weekly')),
                  ButtonSegment(value: RecurringInterval.monthly, label: Text('Monthly')),
                  ButtonSegment(value: RecurringInterval.yearly, label: Text('Yearly')),
                ],
                selected: {_selectedInterval},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedInterval = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Start Date Picker
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _pickDate,
                  ),
                ),
                controller: TextEditingController(text: DateFormat.yMMMd().format(_selectedStartDate)),
                onTap: _pickDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
