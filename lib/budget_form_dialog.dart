import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

/// Shows a dialog to add or edit a budget.
/// Returns the [Budget] if the user saves, or `null` if cancelled.
Future<Budget?> showBudgetFormDialog(
  BuildContext context,
  WidgetRef ref, {
  Budget? budget,
}) {
  return showDialog<Budget>(
    context: context,
    builder: (context) => _BudgetFormDialog(budget: budget, ref: ref),
  );
}

class _BudgetFormDialog extends StatefulWidget {
  final Budget? budget;
  final WidgetRef ref;

  const _BudgetFormDialog({this.budget, required this.ref});

  @override
  State<_BudgetFormDialog> createState() => _BudgetFormDialogState();
}

class _BudgetFormDialogState extends State<_BudgetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final CurrencyTextInputFormatter _amountFormatter;
  Category? _selectedCategory;
  late int _selectedYear;
  late int _selectedMonth;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    
    final currency = widget.ref.read(currencyProvider);
    final info = currencyData[currency]!;
    _amountFormatter = CurrencyTextInputFormatter.currency(
      locale: info.locale,
      symbol: info.symbol,
      decimalDigits: 0,
    );

    final existing = widget.budget;
    _amountController = TextEditingController(
      text: existing != null ? _amountFormatter.formatDouble(existing.amount) : '',
    );
    if (existing != null) {
      _selectedCategory = existing.category;
      // Parse period string like "2024-07"
      final parts = existing.period.split('-');
      _selectedYear = int.parse(parts[0]);
      _selectedMonth = int.parse(parts[1]);
    } else {
      final now = DateTime.now();
      _selectedYear = now.year;
      _selectedMonth = now.month;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String get _periodString =>
      '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}';

  String get _periodLabel =>
      DateFormat.yMMMM().format(DateTime(_selectedYear, _selectedMonth));

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_selectedYear, _selectedMonth),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedYear = picked.year;
        _selectedMonth = picked.month;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    final amount = _amountFormatter.getDouble();

    Navigator.of(context).pop(
      Budget(
        id: widget.budget?.id ?? 0,
        amount: amount,
        period: _periodString,
        category: _selectedCategory!,
        spentAmount: widget.budget?.spentAmount ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesStream =
        widget.ref.watch(watchAllCategoriesUseCaseProvider).call();

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Budget' : 'Add Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category dropdown
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

                // Ensure the selected category is in the list
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
                  onChanged: _isEditing
                      ? null // Category is not editable when editing
                      : (value) {
                          setState(() => _selectedCategory = value);
                        },
                  validator: (value) =>
                      value == null ? 'Please select a category.' : null,
                );
              },
            ),
            const SizedBox(height: 12),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [_amountFormatter],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget amount.';
                }
                final amount = _amountFormatter.getDouble();
                if (amount <= 0) {
                  return 'Please enter a valid amount greater than 0.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Period (month picker)
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Period',
                prefixIcon: const Icon(Icons.calendar_month),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: _pickMonth,
                ),
              ),
              controller: TextEditingController(text: _periodLabel),
              onTap: _pickMonth,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
