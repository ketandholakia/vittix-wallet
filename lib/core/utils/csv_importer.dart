import 'dart:io';

import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/features/accounts/domain/account_repository.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/category_repository.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CsvImportSummary {
  final int imported;
  final int duplicates;
  final int skipped;
  final int wouldCreateAccounts;
  final int wouldCreateCategories;
  final List<String> previewMissingAccounts;
  final List<String> previewMissingCategories;
  final String delimiter;
  final String dateFormat;
  final List<CsvPreviewRow> previewRows;

  const CsvImportSummary({
    required this.imported,
    required this.duplicates,
    required this.skipped,
    this.wouldCreateAccounts = 0,
    this.wouldCreateCategories = 0,
    this.previewMissingAccounts = const [],
    this.previewMissingCategories = const [],
    this.delimiter = ',',
    this.dateFormat = 'yyyy-MM-dd',
    this.previewRows = const [],
  });
}

class CsvPreviewRow {
  final String date;
  final String type;
  final String category;
  final String account;
  final String amount;
  final String note;
  final String status;

  const CsvPreviewRow({
    required this.date,
    required this.type,
    required this.category,
    required this.account,
    required this.amount,
    required this.note,
    required this.status,
  });
}

class CsvTransactionImporter {
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  CsvTransactionImporter({
    required this.transactionRepository,
    required this.accountRepository,
    required this.categoryRepository,
  });

  Future<CsvImportSummary> importFromFile(File file) async {
    final analysis = await previewFromFile(file);
    if (analysis.imported + analysis.duplicates + analysis.skipped == 0) {
      return analysis;
    }

    final csv = await file.readAsString();
    final rows = _parseCsv(csv, delimiter: analysis.delimiter);
    if (rows.isEmpty) {
      return const CsvImportSummary(imported: 0, duplicates: 0, skipped: 0);
    }

    final header = rows.first.map(_normalize).toList();
    final columnIndex = <String, int>{
      for (var i = 0; i < header.length; i++) header[i]: i,
    };

    int requiredIndex(List<String> names, String label) {
      for (final name in names) {
        final index = columnIndex[_normalize(name)];
        if (index != null) {
          return index;
        }
      }
      throw FormatException('Missing required CSV column: $label');
    }

    final dateIndex = requiredIndex(['date', 'txn_date', 'transaction date', 'transaction_date'], 'date');
    final typeIndex = requiredIndex(['type', 'transaction type', 'txn_type'], 'type');
    final categoryIndex = requiredIndex(['category', 'category name', 'category_name'], 'category');
    final accountIndex = requiredIndex(['account', 'account name', 'account_name'], 'account');
    final amountIndex = requiredIndex(['amount', 'transaction amount', 'txn_amount'], 'amount');
    final noteIndex = _firstMatchingIndex(
      columnIndex,
      ['note', 'notes', 'description', 'memo'],
    );

    final existingTransactions = await transactionRepository.watchAllTransactions().first;
    final existingFingerprints = {
      for (final tx in existingTransactions) _fingerprintFromTransaction(tx),
    };
    final seenFingerprints = <String>{};

    final accounts = await accountRepository.watchAllAccounts().first;
    final categories = await categoryRepository.watchAllCategories().first;
    final accountByName = {for (final account in accounts) _normalize(account.name): account};
    final categoryByName = {for (final category in categories) _normalize(category.name): category};

    var imported = 0;
    var duplicates = 0;
    var skipped = 0;

    for (final row in rows.skip(1)) {
      if (row.isEmpty || row.every((value) => value.trim().isEmpty)) {
        continue;
      }
      try {
        final date = _parseDate(row[dateIndex], analysis.dateFormat);
        final type = _parseTransactionType(row[typeIndex]);
        final categoryName = row[categoryIndex].trim();
        final accountName = row[accountIndex].trim();
        if (categoryName.isEmpty || accountName.isEmpty) {
          skipped++;
          continue;
        }

        final category = await _resolveCategory(
          name: categoryName,
          categoryByName: categoryByName,
        );
        final account = await _resolveAccount(
          name: accountName,
          accountByName: accountByName,
        );

        final amount = _parseAmount(row[amountIndex]);
        final note = noteIndex == null ? null : row[noteIndex].trim().isEmpty ? null : row[noteIndex].trim();
        final fingerprint = _fingerprint(
          date: date,
          type: type,
          amount: amount,
          categoryId: category.id,
          accountId: account.id,
          note: note,
        );

        if (!seenFingerprints.add(fingerprint) || existingFingerprints.contains(fingerprint)) {
          duplicates++;
          continue;
        }

        await transactionRepository.addTransaction(
          Transaction(
            id: 0,
            amount: amount,
            date: date,
            note: note,
            type: type,
            category: category,
            account: account,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        imported++;
      } catch (_) {
        skipped++;
      }
    }

    return CsvImportSummary(
      imported: imported,
      duplicates: duplicates,
      skipped: skipped,
      wouldCreateAccounts: analysis.wouldCreateAccounts,
      wouldCreateCategories: analysis.wouldCreateCategories,
      previewMissingAccounts: analysis.previewMissingAccounts,
      previewMissingCategories: analysis.previewMissingCategories,
    );
  }

  Future<CsvImportSummary> previewFromFile(File file) async {
    final csv = await file.readAsString();
    final delimiter = _detectDelimiter(csv);
    final rows = _parseCsv(csv, delimiter: delimiter);
    if (rows.isEmpty) {
      return const CsvImportSummary(imported: 0, duplicates: 0, skipped: 0);
    }

    final header = rows.first.map(_normalize).toList();
    final columnIndex = <String, int>{
      for (var i = 0; i < header.length; i++) header[i]: i,
    };

    int requiredIndex(List<String> names, String label) {
      for (final name in names) {
        final index = columnIndex[_normalize(name)];
        if (index != null) {
          return index;
        }
      }
      throw FormatException('Missing required CSV column: $label');
    }

    final dateIndex = requiredIndex(['date', 'txn_date', 'transaction date', 'transaction_date'], 'date');
    final typeIndex = requiredIndex(['type', 'transaction type', 'txn_type'], 'type');
    final categoryIndex = requiredIndex(['category', 'category name', 'category_name'], 'category');
    final accountIndex = requiredIndex(['account', 'account name', 'account_name'], 'account');
    final amountIndex = requiredIndex(['amount', 'transaction amount', 'txn_amount'], 'amount');
    final noteIndex = _firstMatchingIndex(columnIndex, ['note', 'notes', 'description', 'memo']);
    final detectedDateFormat = _detectDateFormat(rows.skip(1), dateIndex);

    final existingTransactions = await transactionRepository.watchAllTransactions().first;
    final existingFingerprints = {
      for (final tx in existingTransactions) _fingerprintFromTransaction(tx),
    };
    final accounts = await accountRepository.watchAllAccounts().first;
    final categories = await categoryRepository.watchAllCategories().first;
    final accountByName = {for (final account in accounts) _normalize(account.name): account};
    final categoryByName = {for (final category in categories) _normalize(category.name): category};
    final seenFingerprints = <String>{};
    final missingAccounts = <String>{};
    final missingCategories = <String>{};
    final previewRows = <CsvPreviewRow>[];
    var imported = 0;
    var duplicates = 0;
    var skipped = 0;

    for (final row in rows.skip(1)) {
      if (row.isEmpty || row.every((value) => value.trim().isEmpty)) continue;
      try {
        final date = _parseDate(row[dateIndex], detectedDateFormat);
        final type = _parseTransactionType(row[typeIndex]);
        final categoryName = row[categoryIndex].trim();
        final accountName = row[accountIndex].trim();
        if (categoryName.isEmpty || accountName.isEmpty) {
          skipped++;
          continue;
        }

        final categoryKey = _normalize(categoryName);
        final accountKey = _normalize(accountName);
        if (!categoryByName.containsKey(categoryKey)) missingCategories.add(categoryName);
        if (!accountByName.containsKey(accountKey)) missingAccounts.add(accountName);

        final amount = _parseAmount(row[amountIndex]);
        final note = noteIndex == null ? null : row[noteIndex].trim().isEmpty ? null : row[noteIndex].trim();
        final categoryId = categoryByName[categoryKey]?.id ?? 0;
        final accountId = accountByName[accountKey]?.id ?? 0;
        final fingerprint = _fingerprint(
          date: date,
          type: type,
          amount: amount,
          categoryId: categoryId,
          accountId: accountId,
          note: note,
        );
        final duplicate = !seenFingerprints.add(fingerprint) || existingFingerprints.contains(fingerprint);
        if (duplicate) {
          duplicates++;
          _appendPreviewRow(
            previewRows,
            date: date,
            type: type,
            category: categoryName,
            account: accountName,
            amount: amount,
            note: note,
            status: 'duplicate',
          );
          continue;
        }
        _appendPreviewRow(
          previewRows,
          date: date,
          type: type,
          category: categoryName,
          account: accountName,
          amount: amount,
          note: note,
          status: 'import',
        );
        imported++;
      } catch (_) {
        skipped++;
      }
    }

    return CsvImportSummary(
      imported: imported,
      duplicates: duplicates,
      skipped: skipped,
      wouldCreateAccounts: missingAccounts.length,
      wouldCreateCategories: missingCategories.length,
      previewMissingAccounts: missingAccounts.toList()..sort(),
      previewMissingCategories: missingCategories.toList()..sort(),
      delimiter: delimiter,
      dateFormat: detectedDateFormat,
      previewRows: previewRows.take(5).toList(),
    );
  }

  Future<Category> _resolveCategory({
    required String name,
    required Map<String, Category> categoryByName,
  }) async {
    final key = _normalize(name);
    final existing = categoryByName[key];
    if (existing != null) return existing;

    final created = Category(
      id: 0,
      name: name,
      icon: Icons.category,
      color: Colors.blueGrey,
    );
    await categoryRepository.addCategory(created);
    final refreshed = await categoryRepository.watchAllCategories().first;
    Category? match;
    for (final category in refreshed) {
      if (_normalize(category.name) == key) {
        match = category;
        break;
      }
    }
    if (match == null) {
      throw StateError('Failed to create category: $name');
    }
    categoryByName[key] = match;
    return match;
  }

  Future<Account> _resolveAccount({
    required String name,
    required Map<String, Account> accountByName,
  }) async {
    final key = _normalize(name);
    final existing = accountByName[key];
    if (existing != null) return existing;

    final created = Account(
      id: 0,
      name: name,
      type: AccountType.bank,
      icon: Icons.account_balance,
      color: Colors.blue,
    );
    await accountRepository.addAccount(created);
    final refreshed = await accountRepository.watchAllAccounts().first;
    Account? match;
    for (final account in refreshed) {
      if (_normalize(account.name) == key) {
        match = account;
        break;
      }
    }
    if (match == null) {
      throw StateError('Failed to create account: $name');
    }
    accountByName[key] = match;
    return match;
  }

  String _fingerprintFromTransaction(Transaction tx) {
    return _fingerprint(
      date: DateTime(tx.date.year, tx.date.month, tx.date.day),
      type: tx.type,
      amount: tx.amount,
      categoryId: tx.category.id,
      accountId: tx.account.id,
      note: tx.note,
    );
  }

  String _fingerprint({
    required DateTime date,
    required TransactionType type,
    required double amount,
    required int categoryId,
    required int accountId,
    required String? note,
  }) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return [
      normalizedDate.toIso8601String(),
      type.name,
      amount.toStringAsFixed(2),
      categoryId,
      accountId,
      _normalize(note ?? ''),
    ].join('|');
  }

  static TransactionType _parseTransactionType(String value) {
    final normalized = _normalize(value);
    if (normalized == 'income') return TransactionType.income;
    if (normalized == 'expense') return TransactionType.expense;
    throw FormatException('Unknown transaction type: $value');
  }

  static DateTime _parseDate(String value, String formatId) {
    final input = value.trim();
    final format = _dateFormats[formatId];
    if (format != null) {
      try {
        return format.parseStrict(input);
      } catch (_) {}
    }
    return DateTime.parse(input);
  }

  static double _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9,\.\-]'), '').trim();
    if (cleaned.isEmpty) {
      throw FormatException('Invalid amount: $value');
    }
    final normalized = cleaned.contains(',') && cleaned.contains('.')
        ? cleaned.replaceAll(',', '')
        : cleaned.contains(',') && !cleaned.contains('.')
            ? cleaned.replaceAll(',', '.')
            : cleaned;
    return double.parse(normalized);
  }

  static String _normalize(String input) {
    return input.trim().toLowerCase();
  }

  static String _detectDelimiter(String csv) {
    final firstLine = csv.split(RegExp(r'\r?\n')).first;
    final commas = _countOutsideQuotes(firstLine, ',');
    final semicolons = _countOutsideQuotes(firstLine, ';');
    return semicolons > commas ? ';' : ',';
  }

  static String _detectDateFormat(Iterable<List<String>> rows, int dateIndex) {
    final candidates = <String, int>{
      'yyyy-MM-dd': 0,
      'yyyy/MM/dd': 0,
      'dd/MM/yyyy': 0,
      'MM/dd/yyyy': 0,
      'dd-MM-yyyy': 0,
      'MM-dd-yyyy': 0,
    };
    for (final row in rows) {
      if (dateIndex >= row.length) continue;
      final value = row[dateIndex].trim();
      for (final entry in candidates.keys) {
        try {
          _dateFormats[entry]!.parseStrict(value);
          candidates[entry] = candidates[entry]! + 1;
        } catch (_) {}
      }
    }
    if (rows.isEmpty) return 'yyyy-MM-dd';
    return candidates.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  static void _appendPreviewRow(
    List<CsvPreviewRow> previewRows, {
    required DateTime date,
    required TransactionType type,
    required String category,
    required String account,
    required double amount,
    required String? note,
    required String status,
  }) {
    previewRows.add(
      CsvPreviewRow(
        date: DateFormat('yyyy-MM-dd').format(date),
        type: type.name,
        category: category,
        account: account,
        amount: amount.toStringAsFixed(2),
        note: note ?? '',
        status: status,
      ),
    );
  }

  static int _countOutsideQuotes(String input, String needle) {
    var count = 0;
    var inQuotes = false;
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (!inQuotes && char == needle) {
        count++;
      }
    }
    return count;
  }

  static final Map<String, DateFormat> _dateFormats = <String, DateFormat>{
    'yyyy-MM-dd': DateFormat('yyyy-MM-dd'),
    'yyyy/MM/dd': DateFormat('yyyy/MM/dd'),
    'dd/MM/yyyy': DateFormat('dd/MM/yyyy'),
    'MM/dd/yyyy': DateFormat('MM/dd/yyyy'),
    'dd-MM-yyyy': DateFormat('dd-MM-yyyy'),
    'MM-dd-yyyy': DateFormat('MM-dd-yyyy'),
  };

  static int? _firstMatchingIndex(Map<String, int> columnIndex, List<String> names) {
    for (final name in names) {
      final index = columnIndex[_normalize(name)];
      if (index != null) {
        return index;
      }
    }
    return null;
  }

  static List<List<String>> _parseCsv(String input, {required String delimiter}) {
    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var inQuotes = false;

    void endField() {
      row.add(field.toString());
      field.clear();
    }

    void endRow() {
      endField();
      rows.add(row);
      row = <String>[];
    }

    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      final next = i + 1 < input.length ? input[i + 1] : null;
      if (inQuotes) {
        if (char == '"' && next == '"') {
          field.write('"');
          i++;
        } else if (char == '"') {
          inQuotes = false;
        } else {
          field.write(char);
        }
        continue;
      }

      if (char == '"') {
        inQuotes = true;
      } else if (char == delimiter) {
        endField();
      } else if (char == '\n') {
        endRow();
      } else if (char == '\r') {
        continue;
      } else {
        field.write(char);
      }
    }

    if (inQuotes) {
      throw const FormatException('Unterminated quoted CSV field');
    }
    if (field.isNotEmpty || row.isNotEmpty) {
      endField();
      rows.add(row);
    }
    return rows;
  }
}
