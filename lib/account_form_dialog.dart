import 'package:expense_tracker/account.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expense_tracker/settings_providers.dart';

IconData iconForAccountType(AccountType type) => switch (type) {
      AccountType.bank => Symbols.account_balance,
      AccountType.creditCard => Symbols.credit_card,
      AccountType.loan => Symbols.real_estate_agent,
      AccountType.cash => Symbols.payments,
      AccountType.income => Symbols.savings,
    };

Color colorForAccountType(AccountType type) => switch (type) {
      AccountType.bank => const Color(0xFF569BFF),
      AccountType.creditCard => const Color(0xFFFF7A6B),
      AccountType.loan => const Color(0xFF9C27B0),
      AccountType.cash => const Color(0xFF45D4A3),
      AccountType.income => const Color(0xFF2196F3),
    };

Future<Account?> showAccountFormDialog(
  BuildContext context,
  WidgetRef ref, {
  Account? account,
}) {
  return showDialog<Account>(
    context: context,
    builder: (context) => _AccountFormDialog(account: account, ref: ref),
  );
}

class _AccountFormDialog extends ConsumerStatefulWidget {
  final Account? account;
  final WidgetRef ref;

  const _AccountFormDialog({this.account, required this.ref});

  @override
  ConsumerState<_AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends ConsumerState<_AccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountType _selectedType;

  late final CurrencyTextInputFormatter _balanceFormatter;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final currency = widget.ref.read(currencyProvider);
    final info = currencyData[currency]!;
    _balanceFormatter = CurrencyTextInputFormatter.currency(
      locale: info.locale,
      symbol: info.symbol,
      decimalDigits: 0,
    );

    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? _balanceFormatter.formatDouble(widget.account!.openingBalance)
          : '0',
    );
    _selectedType = widget.account?.type ?? AccountType.bank;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final openingBalance = _balanceFormatter.getDouble();
    Navigator.of(context).pop(
      Account(
        id: widget.account?.id ?? 0,
        name: _nameController.text.trim(),
        type: _selectedType,
        icon: iconForAccountType(_selectedType),
        color: widget.account?.color ?? colorForAccountType(_selectedType),
        openingBalance: openingBalance,
        isDefault: widget.account?.isDefault ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Account' : 'Add Account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AccountType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Account Type',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              items: AccountType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _balanceController,
              decoration: InputDecoration(
                labelText: _selectedType.isLiability ? 'Amount Owed' : 'Opening Balance',
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [_balanceFormatter],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value.';
                }
                return null;
              },
            ),
            if (_selectedType.isLiability) ...[
              const SizedBox(height: 8),
              Text(
                'For credit cards and loans, enter how much you currently owe.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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
