import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/sms/sms_transaction_parser.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_sms_reader/android_sms_reader.dart';

class SmsImportScreen extends ConsumerStatefulWidget {
  const SmsImportScreen({super.key});

  @override
  ConsumerState<SmsImportScreen> createState() => _SmsImportScreenState();
}

class _SmsImportScreenState extends ConsumerState<SmsImportScreen> {
  final SmsTransactionParser _parser = SmsTransactionParser();
  final Set<String> _knownHashes = <String>{};
  final List<SmsTransactionCandidate> _candidates = <SmsTransactionCandidate>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    try {
      final granted = await AndroidSMSReader.requestPermissions();
      if (!granted) {
        setState(() {
          _loading = false;
          _error = 'SMS permission is required to read inbox messages.';
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final importedHashes = prefs.getStringList('sms_imported_hashes') ?? <String>[];
      _knownHashes.addAll(importedHashes);

      final inbox = await AndroidSMSReader.fetchMessages(
        type: AndroidSMSType.inbox,
        start: 0,
        count: 500,
      );

      for (final sms in inbox) {
        final id = sms.id?.toString() ?? '${sms.date}${sms.address}';
        final body = sms.body ?? '';
        final sender = sms.address ?? '';
        final date = DateTime.fromMillisecondsSinceEpoch(sms.date ?? 0);
        final candidate = _parser.parse(
          smsId: id,
          body: body,
          sender: sender,
          date: date,
          knownHashes: _knownHashes,
        );
        if (candidate != null) {
          _candidates.add(candidate);
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _saveSelected() async {
    final categories = await ref.read(watchAllCategoriesUseCaseProvider).call().first;
    final accounts = await ref.read(watchAllAccountsUseCaseProvider).call().first;
    final prefs = await SharedPreferences.getInstance();
    final importedHashes = prefs.getStringList('sms_imported_hashes') ?? <String>[];

    final categoryByName = {for (final c in categories) c.name.toLowerCase(): c};
    final cashAccount = accounts.firstWhere(
      (account) => account.type == AccountType.cash,
      orElse: () => accounts.first,
    );

    for (final candidate in _candidates.where((item) => item.isSelected)) {
      final category = candidate.suggestedCategoryName == null
          ? categories.first
          : categoryByName[candidate.suggestedCategoryName!.toLowerCase()] ?? categories.first;

      final transaction = domain.Transaction(
        id: 0,
        amount: candidate.amount,
        date: candidate.date,
        note: '[SMS] ${candidate.merchant} - ${candidate.body}',
        type: candidate.type,
        category: category,
        account: cashAccount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(addTransactionUseCaseProvider).call(transaction);
      importedHashes.add(candidate.smsHash);
    }

    await prefs.setStringList('sms_imported_hashes', importedHashes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved ${_candidates.where((c) => c.isSelected).length} SMS transactions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import SMS Transactions'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadCandidates,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : FutureBuilder<List<Object>>(
                  future: Future.wait<Object>([
                    ref.read(watchAllCategoriesUseCaseProvider).call().first,
                    ref.read(watchAllAccountsUseCaseProvider).call().first,
                  ]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final categories = snapshot.data![0] as List<Category>;
                    final accounts = snapshot.data![1] as List<Account>;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_candidates.length} candidates found', style: Theme.of(context).textTheme.titleMedium),
                              FilledButton.icon(
                                onPressed: _candidates.any((c) => c.isSelected) ? _saveSelected : null,
                                icon: const Icon(Icons.save),
                                label: const Text('Save Selected'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _candidates.length,
                            itemBuilder: (context, index) {
                              final candidate = _candidates[index];
                              final category = candidate.suggestedCategoryName == null
                                  ? null
                                  : categories.firstWhere(
                                      (c) => c.name.toLowerCase() == candidate.suggestedCategoryName!.toLowerCase(),
                                      orElse: () => categories.first,
                                    );
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: candidate.isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                _candidates[index] = candidate.copyWith(isSelected: value ?? false);
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Rs ${candidate.amount.toStringAsFixed(0)} - ${candidate.merchant}',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ),
                                          Text(
                                            candidate.type == domain.TransactionType.expense ? 'Expense' : 'Income',
                                            style: Theme.of(context).textTheme.labelLarge,
                                          ),
                                        ],
                                      ),
                                      Text(candidate.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<Category>(
                                        value: category,
                                        decoration: const InputDecoration(labelText: 'Category'),
                                        items: categories
                                            .map(
                                              (c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(c.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _candidates[index] = candidate.copyWith(suggestedCategoryName: value.name);
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<Account>(
                                        value: accounts.firstWhere(
                                          (a) => a.type == AccountType.cash,
                                          orElse: () => accounts.first,
                                        ),
                                        decoration: const InputDecoration(labelText: 'Account'),
                                        items: accounts
                                            .map(
                                              (a) => DropdownMenuItem(
                                                value: a,
                                                child: Text(a.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
