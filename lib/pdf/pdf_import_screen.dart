
import 'dart:io';

import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/categories/domain/category.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/core/utils/duplicate_detector.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/pdf/pdf_text_extractor.dart';
import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart';
import 'package:expense_tracker/pdf/parsers/pdf_statement_parser.dart';
import 'package:expense_tracker/pdf/parsers/gpay_pdf_parser.dart';
import 'package:expense_tracker/pdf/parsers/phonepe_pdf_parser.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfImportScreen extends ConsumerStatefulWidget {
  const PdfImportScreen({super.key});

  @override
  ConsumerState<PdfImportScreen> createState() => _PdfImportScreenState();
}

class _PdfImportScreenState extends ConsumerState<PdfImportScreen> {
  final List<PdfStatementParser> _parsers = [
    GPayPdfParser(),
    PhonePePdfParser(),
  ];

  final Set<String> _knownHashes = <String>{};
  final List<PdfTransactionCandidate> _candidates = <PdfTransactionCandidate>[];
  
  int _duplicateDetections = 0;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadKnownHashes();
  }

  Account _guessAccount(PdfTransactionCandidate candidate, List<Account> accounts) {
    if (candidate.selectedAccountId != null) {
      return accounts.firstWhere((a) => a.id == candidate.selectedAccountId, orElse: () => accounts.first);
    }
    final hint = candidate.accountHint;
    if (hint != null && hint.isNotEmpty) {
      final hintLower = hint.toLowerCase().replaceAll('xx', '');
      final digits = RegExp(r'\d+').firstMatch(hintLower)?.group(0);
      for (final a in accounts) {
        final nameLower = a.name.toLowerCase();
        if (digits != null && nameLower.contains(digits)) return a;
        if (hintLower.isNotEmpty && nameLower.contains(hintLower)) return a;
      }
    }
    return accounts.firstWhere((a) => a.type == AccountType.cash, orElse: () => accounts.first);
  }

  Future<void> _loadKnownHashes() async {
    final prefs = await SharedPreferences.getInstance();
    final importedHashes = prefs.getStringList('pdf_imported_hashes') ?? <String>[];
    setState(() {
      _knownHashes.addAll(importedHashes);
    });
  }

  Future<void> _pickAndParsePdf() async {
    setState(() {
      _loading = true;
      _error = null;
      _candidates.clear();
      _duplicateDetections = 0;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        setState(() => _loading = false);
        return;
      }

      final file = File(result.files.single.path!);
      final text = await PdfTextExtractorUtil.extractText(file);

      PdfStatementParser? selectedParser;
      for (final parser in _parsers) {
        if (parser.canHandle(text)) {
          selectedParser = parser;
          break;
        }
      }

      if (selectedParser == null) {
        setState(() {
          _loading = false;
          _error = 'Unsupported PDF format. Currently only GPay and PhonePe statements are supported.';
        });
        return;
      }

      final parsedCandidates = selectedParser.parse(text);
      
      final currentWalletId = ref.read(currentWalletIdProvider);
      final mappings = await ref.read(smsParsingDaoProvider).getMerchantMappings(currentWalletId);
      final categories = await ref.read(watchAllCategoriesUseCaseProvider).call().first;
      final categoryById = {for (final c in categories) c.id: c};

      for (var candidate in parsedCandidates) {
        final hash = selectedParser.buildHash(
          rawBlock: candidate.rawBlock,
          merchant: candidate.merchant,
          amount: candidate.amount,
          date: candidate.date,
        );

        if (_knownHashes.contains(hash)) {
          _duplicateDetections++;
          continue;
        }

        // Apply merchant mappings if any
        for (final mapping in mappings) {
          try {
            if (RegExp(mapping.originalPattern, caseSensitive: false).hasMatch(candidate.merchant)) {
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

        _candidates.add(candidate);
      }

    } catch (e) {
      setState(() {
        _error = 'Error parsing PDF: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveSelected() async {
    final categories = await ref.read(watchAllCategoriesUseCaseProvider).call().first;
    final accounts = await ref.read(watchAllAccountsUseCaseProvider).call().first;
    final prefs = await SharedPreferences.getInstance();
    final importedHashes = prefs.getStringList('pdf_imported_hashes') ?? <String>[];

    final categoryByName = {for (final c in categories) c.name.toLowerCase(): c};

    int savedCount = 0;
    int skippedDuplicates = 0;
    // Existing ledger entries, so re-importing a statement that is already
    // recorded does not silently double up. Same rule as manual entry.
    final existingTransactions =
        await ref.read(watchRecentTransactionsUseCaseProvider).call(limit: 200).first;

    // We need to re-find the parser to generate the hash again
    // Or we could have stored the hash in the candidate. Let's just generate a simple hash.
    for (final candidate in _candidates.where((item) => item.isSelected)) {
      final category = candidate.suggestedCategoryName == null
          ? categories.first
          : categoryByName[candidate.suggestedCategoryName!.toLowerCase()] ?? categories.first;

      final transaction = domain.Transaction(
        id: 0,
        amount: candidate.amount,
        date: candidate.date,
        note: '[PDF] ${candidate.merchant}',
        type: candidate.type,
        category: category,
        account: _guessAccount(candidate, accounts),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (looksLikeDuplicate(transaction, existingTransactions)) {
        skippedDuplicates++;
        continue;
      }

      await ref.read(addTransactionUseCaseProvider).call(transaction);
      
      // Basic hash
      final hash = '${candidate.merchant.toLowerCase()}_${candidate.amount.toStringAsFixed(2)}_${candidate.date.millisecondsSinceEpoch}_${candidate.rawBlock.length}';
      importedHashes.add(hash);
      savedCount++;
    }

    await prefs.setStringList('pdf_imported_hashes', importedHashes);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $savedCount PDF transactions'
              '${skippedDuplicates > 0 ? ' ($skippedDuplicates skipped as likely duplicates)' : ''}'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import PDF Statement'),
        actions: [
          if (_candidates.isNotEmpty)
            IconButton(
              onPressed: _pickAndParsePdf,
              icon: const Icon(Icons.file_open),
              tooltip: 'Select another PDF',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _candidates.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _error ?? 'Select a bank statement PDF to import transactions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _error != null ? Colors.red : Colors.grey[700]),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _pickAndParsePdf,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Select PDF'),
                        ),
                      ],
                    ),
                  ),
                )
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: ListTile(
                                    title: const Text('Review first'),
                                    subtitle: Text('Candidates: ${_candidates.length}  •  Duplicates: $_duplicateDetections'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        const SizedBox(height: 8),
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
                                      Text(
                                        candidate.rawBlock.replaceAll('\n', ' '), 
                                        maxLines: 2, 
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      ),
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
                                        initialValue: _guessAccount(candidate, accounts),
                                        decoration: const InputDecoration(labelText: 'Account'),
                                        items: accounts
                                            .map(
                                              (a) => DropdownMenuItem(
                                                value: a,
                                                child: Text(a.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _candidates[index] = candidate.copyWith(selectedAccountId: value.id);
                                          });
                                        },
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