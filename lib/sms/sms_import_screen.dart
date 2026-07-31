// BROKEN DEPENDENCY: smsParsingDao
/*
import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/recurring_transaction.dart';
import 'package:expense_tracker/sms/sms_transaction_parser.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/core/database/app_database.dart' hide Column, Category, Account, AccountType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_sms_reader/android_sms_reader.dart';

class SmsImportScreen extends ConsumerStatefulWidget {
  const SmsImportScreen({super.key});

  @override
  ConsumerState<SmsImportScreen> createState() => _SmsImportScreenState();
}

class _SmsImportScreenState extends ConsumerState<SmsImportScreen> {
  static const MethodChannel _smsChannel = MethodChannel('expense_tracker/sms_capture');
  final SmsTransactionParser _parser = SmsTransactionParser();
  final Set<String> _knownHashes = <String>{};
  final List<SmsTransactionCandidate> _candidates = <SmsTransactionCandidate>[];
  int _duplicateDetections = 0;
  int _rejectedImports = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    try {
      _candidates.clear();
      _duplicateDetections = 0;
      _rejectedImports = 0;
      await ref.read(walletDaoProvider).logOnboardingActivity(
            walletId: ref.read(currentWalletIdProvider),
            action: 'sms_setup_started',
          );
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

      final liveQueue = await _pullCapturedSms();
      final sources = <dynamic>[...liveQueue, ...inbox];
      
      final currentWalletId = ref.read(currentWalletIdProvider);
      final mappings = await ref.read(smsParsingDaoProvider).getMerchantMappings(currentWalletId);
      final categories = await ref.read(watchAllCategoriesUseCaseProvider).call().first;
      final categoryById = {for (final c in categories) c.id: c};

      for (final sms in sources) {
        final id = (sms is Map ? sms['id'] : sms.id).toString();
        final body = (sms is Map ? sms['body'] : sms.body).toString();
        final sender = (sms is Map ? sms['address'] : sms.address).toString();
        final rawDate = sms is Map ? sms['date'] : sms.date;
        final date = DateTime.fromMillisecondsSinceEpoch((rawDate as num).toInt());
        final hash = SmsTransactionParser.buildHash(sender: sender, body: body);
        if (_knownHashes.contains(hash)) {
          _duplicateDetections++;
          continue;
        }
        var candidate = _parser.parse(
          smsId: id,
          body: body,
          sender: sender,
          date: date,
          knownHashes: _knownHashes,
        );
        if (candidate != null) {
          for (final mapping in mappings) {
            try {
              if (RegExp(mapping.originalPattern, caseSensitive: false).hasMatch(candidate!.merchant)) {
                candidate = candidate.copyWith(
                  merchant: mapping.cleanName,
                  suggestedCategoryName: mapping.defaultCategoryId != null 
                      ? categoryById[mapping.defaultCategoryId]?.name 
                      : candidate.suggestedCategoryName,
                );
                break;
              }
            } catch (_) {}
          }
          _candidates.add(candidate!);
        } else {
          _rejectedImports++;
          try {
            await ref.read(smsParsingDaoProvider).insertUnrecognizedSms(
              UnrecognizedSmsEntriesCompanion.insert(
                walletId: currentWalletId,
                smsBody: body,
                sender: sender,
                receivedAt: date,
              ),
            );
          } catch (_) {
            // Ignore constraint errors (e.g., if we re-import without resolving)
          }
        }
      }

      setState(() {
        _loading = false;
      });
      await ref.read(walletDaoProvider).logOnboardingActivity(
            walletId: ref.read(currentWalletIdProvider),
            action: 'sms_setup_completed',
          );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<List<Map<String, dynamic>>> _pullCapturedSms() async {
    try {
      final raw = await _smsChannel.invokeMethod<List<dynamic>>('pullCapturedSms');
      return raw
              ?.whereType<Map>()
              .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
              .toList() ??
          <Map<String, dynamic>>[];
    } on MissingPluginException {
      return <Map<String, dynamic>>[];
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

      if (candidate.isRecurringSetup) {
        final recurringTransaction = RecurringTransaction(
          id: 0,
          name: candidate.merchant,
          amount: candidate.amount,
          type: candidate.type,
          category: category,
          account: cashAccount,
          interval: RecurringInterval.monthly,
          startDate: candidate.date,
          nextDueDate: candidate.date,
        );
        await ref.read(addRecurringUseCaseProvider).call(recurringTransaction);
      } else {
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
      }
      importedHashes.add(candidate.smsHash);
    }

    await prefs.setStringList('sms_imported_hashes', importedHashes);
    await ref.read(smsImportMetricsDaoProvider).record(
          walletId: ref.read(currentWalletIdProvider),
          acceptedImports: _candidates.where((c) => c.isSelected).length,
          rejectedImports: _rejectedImports,
          duplicateDetections: _duplicateDetections,
        );
    await ref.read(walletDaoProvider).logOnboardingActivity(
          walletId: ref.read(currentWalletIdProvider),
          action: 'sms_import_completed',
        );
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.sms_outlined),
                              title: Text('SMS Import Introduction'),
                              subtitle: Text(
                                'SMS permission is used only to scan inbox messages on-device. '
                                'The app shows a review queue first, so nothing is saved until you choose it. '
                                'Duplicates and rejected messages stay local.',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: ListTile(
                                    title: const Text('Review first'),
                                    subtitle: Text('Candidates: ${_candidates.length}  •  Rejected: $_rejectedImports  •  Duplicates: $_duplicateDetections'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                          const SizedBox(width: 8),
                                          Chip(label: Text('${(candidate.confidence * 100).toStringAsFixed(0)}%')),
                                          if (candidate.isRecurringSetup)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Chip(
                                                label: Text('Subscription'),
                                                backgroundColor: Colors.blue,
                                                labelStyle: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(candidate.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<Category>(
                                        initialValue: category,
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
                                        initialValue: accounts.firstWhere(
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

*/