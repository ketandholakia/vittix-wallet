import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransferFormScreen extends ConsumerStatefulWidget {
  const TransferFormScreen({super.key});

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  Account? _fromAccount;
  Account? _toAccount;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

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

  Future<Category> _getOrCreateTransferCategory() async {
    final categories = await ref.read(categoryRepositoryProvider).watchAllCategories().first;
    final transferCategory = categories.firstWhere(
      (c) => c.name.toLowerCase() == 'transfer',
      orElse: () => Category(
        id: 0,
        name: 'Transfer',
        icon: Symbols.swap_horiz,
        color: const Color(0xFF9E9E9E),
        isDefault: true,
      ),
    );

    if (transferCategory.id == 0) {
      await ref.read(categoryRepositoryProvider).addCategory(transferCategory);
      final updatedCategories = await ref.read(categoryRepositoryProvider).watchAllCategories().first;
      return updatedCategories.firstWhere((c) => c.name.toLowerCase() == 'transfer');
    }

    return transferCategory;
  }

  Future<void> _saveForm() async {
    if (_isSaving) return;

    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || _fromAccount == null || _toAccount == null) {
        return;
      }

      if (_fromAccount!.id == _toAccount!.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Source and destination accounts must be different.')),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final transferCategory = await _getOrCreateTransferCategory();
        final userNote = _noteController.text.trim();

        // 1. Create Expense from Source Account
        final expenseTx = domain.Transaction(
          id: 0,
          amount: amount,
          date: _selectedDate,
          note: '[Transfer] → ${_toAccount!.name}${userNote.isNotEmpty ? ': $userNote' : ''}',
          type: domain.TransactionType.expense,
          category: transferCategory,
          account: _fromAccount!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // 2. Create Income to Destination Account
        final incomeTx = domain.Transaction(
          id: 0,
          amount: amount,
          date: _selectedDate,
          note: '[Transfer] ← ${_fromAccount!.name}${userNote.isNotEmpty ? ': $userNote' : ''}',
          type: domain.TransactionType.income,
          category: transferCategory,
          account: _toAccount!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await ref.read(addTransactionUseCaseProvider).call(expenseTx);
        await ref.read(addTransactionUseCaseProvider).call(incomeTx);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error making transfer: $e')),
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
    final accountsStream = ref.watch(watchAllAccountsUseCaseProvider).call();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveForm,
            ),
        ],
      ),
      body: StreamBuilder<List<Account>>(
        stream: accountsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final accountList = snapshot.data!;
          if (accountList.isEmpty) {
            return const Center(child: Text('Please create accounts first.'));
          }

          // Set default accounts if not set
          _fromAccount ??= accountList.first;
          _toAccount ??= accountList.length > 1 ? accountList[1] : accountList.first;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount.';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid amount greater than 0.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // From Account
                  DropdownButtonFormField<Account>(
                    initialValue: _fromAccount,
                    decoration: const InputDecoration(
                      labelText: 'From Account',
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
                    onChanged: (value) {
                      setState(() {
                        _fromAccount = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select source account.' : null,
                  ),
                  const SizedBox(height: 16),

                  // To Account
                  DropdownButtonFormField<Account>(
                    initialValue: _toAccount,
                    decoration: const InputDecoration(
                      labelText: 'To Account',
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
                    onChanged: (value) {
                      setState(() {
                        _toAccount = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select destination account.';
                      if (value.id == _fromAccount?.id) {
                        return 'Destination account must be different.';
                      }
                      return null;
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
                    decoration: const InputDecoration(
                      labelText: 'Note (Optional)',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
