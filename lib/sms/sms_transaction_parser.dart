import 'dart:convert';

import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/sms/parsers/bank_sms_parser.dart';
import 'package:expense_tracker/sms/parsers/hdfc_bank_parser.dart';
import 'package:expense_tracker/sms/parsers/icici_bank_parser.dart';
import 'package:expense_tracker/sms/parsers/sbi_bank_parser.dart';

class SmsTransactionCandidate {
  final String smsId;
  final String smsHash;
  final String body;
  final String sender;
  final String merchant;
  final double amount;
  final domain.TransactionType type;
  final DateTime date;
  final String? accountHint;
  final String? suggestedCategoryName;
  final int? selectedAccountId;
  final bool isSelected;
  final double confidence;
  final bool isRecurringSetup;
  final String? recurringIntervalHint;

  SmsTransactionCandidate({
    required this.smsId,
    required this.smsHash,
    required this.body,
    required this.sender,
    required this.merchant,
    required this.amount,
    required this.type,
    required this.date,
    required this.isSelected,
    this.accountHint,
    this.suggestedCategoryName,
    this.selectedAccountId,
    required this.confidence,
    this.isRecurringSetup = false,
    this.recurringIntervalHint,
  });

  SmsTransactionCandidate copyWith({
    String? merchant,
    double? amount,
    domain.TransactionType? type,
    DateTime? date,
    String? accountHint,
    String? suggestedCategoryName,
    int? selectedAccountId,
    bool? isSelected,
    bool? isRecurringSetup,
    String? recurringIntervalHint,
  }) {
    return SmsTransactionCandidate(
      smsId: smsId,
      smsHash: smsHash,
      body: body,
      sender: sender,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      accountHint: accountHint ?? this.accountHint,
      suggestedCategoryName: suggestedCategoryName ?? this.suggestedCategoryName,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      isSelected: isSelected ?? this.isSelected,
      confidence: confidence,
      isRecurringSetup: isRecurringSetup ?? this.isRecurringSetup,
      recurringIntervalHint: recurringIntervalHint ?? this.recurringIntervalHint,
    );
  }
}

class SmsTransactionParser {
  final List<BankSmsParser> _bankParsers = [
    HdfcBankParser(),
    SbiBankParser(),
    IciciBankParser(),
  ];
  static String buildHash({required String sender, required String body}) {
    final normalized = body.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    return base64Url.encode(utf8.encode('$sender|$normalized'));
  }

  // --- Advanced Regex Patterns from pennywiseai ---

  static final List<RegExp> _amountRegexes = [
    RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'₹\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'(?:Rs\.?|INR|\u20B9)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false), // Fallback
  ];

  static final RegExp _upiAmountRegex = RegExp(r'UPI.*?(?:Rs\.?|INR|\u20B9)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false);

  static final List<RegExp> _merchantRegexes = [
    RegExp(r'to\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)', caseSensitive: false),
    RegExp(r'from\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)', caseSensitive: false),
    RegExp(r'at\s+([^\.\n]+?)(?:\s+on|\s+Ref)', caseSensitive: false),
    RegExp(r'for\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref)', caseSensitive: false),
    RegExp(r'\bpaid\s+to\s+([A-Z0-9][A-Z0-9 &._/-]{2,})', caseSensitive: false),
    RegExp(r'\bspent\s+on\s+([A-Z0-9][A-Z0-9 &._/-]{2,})', caseSensitive: false),
  ];

  static final List<RegExp> _accountHintRegexes = [
    RegExp(r'(?:A/c|Account|Acct)(?:\s+No)?\.?\s+(\S+)', caseSensitive: false),
    RegExp(r'Card\s+(\S+)', caseSensitive: false),
    RegExp(r'(?:ending|ends with|ending with)\s+(\d{4})', caseSensitive: false),
    RegExp(r'(?<![/])AC\s+(\S+)', caseSensitive: false),
    RegExp(r'(?:debit|credit)\s+card\s+(\S+)', caseSensitive: false),
    RegExp(r'Your\s+(?:a/c|account|acct|card|#)\s*(\S+)', caseSensitive: false),
    RegExp(r'linked\s+(?:a/c|account|acct)\s+(\S+)', caseSensitive: false),
    RegExp(r'XX?(\d{2,4})', caseSensitive: false), // Fallback
  ];

  static final List<RegExp> _cleaningRegexes = [
    RegExp(r'\s*\(.*?\)\s*$'), // Trailing parentheses
    RegExp(r'\s+Ref\s+No.*', caseSensitive: false), // Ref Number suffix
    RegExp(r'\s+on\s+\d{2}.*'), // Date suffix
    RegExp(r'\s+UPI.*', caseSensitive: false), // UPI suffix
    RegExp(r'\s+at\s+\d{2}:\d{2}.*'), // Time suffix
    RegExp(r'\s*-\s*$'), // Trailing dash
    RegExp(r'(\s+PVT\.?\s*LTD\.?|\s+PRIVATE\s+LIMITED)$', caseSensitive: false),
    RegExp(r'(\s+LTD\.?|\s+LIMITED)$', caseSensitive: false),
  ];

  static final List<RegExp> _expenseKeywords = [
    RegExp(r'debited', caseSensitive: false),
    RegExp(r'spent', caseSensitive: false),
    RegExp(r'withdrawn', caseSensitive: false),
    RegExp(r'paid', caseSensitive: false),
    RegExp(r'purchase', caseSensitive: false),
    RegExp(r'payment', caseSensitive: false),
    RegExp(r'deducted', caseSensitive: false),
    RegExp(r'\bdr\b', caseSensitive: false),
    RegExp(r'\bpos\b', caseSensitive: false),
  ];

  static final List<RegExp> _incomeKeywords = [
    RegExp(r'credited', caseSensitive: false),
    RegExp(r'received', caseSensitive: false),
    RegExp(r'refund', caseSensitive: false),
    RegExp(r'salary', caseSensitive: false),
    RegExp(r'deposit', caseSensitive: false),
    RegExp(r'\bcr\b', caseSensitive: false),
  ];

  static final Map<RegExp, String> _categoryHints = {
    RegExp(r'\bswiggy\b', caseSensitive: false): 'Food',
    RegExp(r'\bzomato\b', caseSensitive: false): 'Food',
    RegExp(r'\buber\b', caseSensitive: false): 'Transport',
    RegExp(r'\bola\b', caseSensitive: false): 'Transport',
    RegExp(r'\bamazon\b', caseSensitive: false): 'Shopping',
    RegExp(r'\bflipkart\b', caseSensitive: false): 'Shopping',
    RegExp(r'\bbigbasket\b', caseSensitive: false): 'Shopping',
    RegExp(r'\bdmart\b', caseSensitive: false): 'Shopping',
    RegExp(r'\bmedical\b', caseSensitive: false): 'Medical',
    RegExp(r'\bhospital\b', caseSensitive: false): 'Medical',
  };

  SmsTransactionCandidate? parse({
    required String smsId,
    required String body,
    required String sender,
    required DateTime date,
    required Set<String> knownHashes,
  }) {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return null;

    final normalized = trimmedBody.replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    final smsHash = buildHash(sender: sender, body: trimmedBody);
    if (knownHashes.contains(smsHash)) return null;

    // Try bank specific parsers first
    for (final parser in _bankParsers) {
      if (parser.canHandle(sender, trimmedBody)) {
        final candidate = parser.parse(smsId, smsHash, sender, trimmedBody, date);
        if (candidate != null) {
          // Add category hint logic from fallback if the bank parser couldn't
          final categoryHint = _inferCategory(candidate.merchant, trimmedBody);
          if (categoryHint != null && candidate.suggestedCategoryName == null) {
            return candidate.copyWith(suggestedCategoryName: categoryHint);
          }
          return candidate;
        }
      }
    }

    final keywordsMatch = _expenseKeywords.any((r) => r.hasMatch(normalized)) || _incomeKeywords.any((r) => r.hasMatch(normalized));
    if (!keywordsMatch) return null;

    final amount = _extractAmount(trimmedBody);
    if (amount == null || amount <= 0) return null;

    final type = _inferType(normalized);
    final merchant = _extractMerchant(trimmedBody) ?? _fallbackMerchant(sender);
    final accountHint = _extractAccountHint(trimmedBody);
    final categoryHint = _inferCategory(merchant, trimmedBody);
    final confidence = _computeConfidence(merchant, categoryHint, accountHint, amount, trimmedBody);

    return SmsTransactionCandidate(
      smsId: smsId,
      smsHash: smsHash,
      body: trimmedBody,
      sender: sender,
      merchant: merchant,
      amount: amount,
      type: type,
      date: date,
      accountHint: accountHint,
      suggestedCategoryName: categoryHint,
      isSelected: true,
      confidence: confidence,
    );
  }

  double? _extractAmount(String body) {
    final upiMatch = _upiAmountRegex.firstMatch(body);
    if (upiMatch != null) {
      return double.tryParse(upiMatch.group(1)!.replaceAll(',', ''));
    }
    for (final regex in _amountRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        return double.tryParse(match.group(1)!.replaceAll(',', ''));
      }
    }
    return null;
  }

  domain.TransactionType _inferType(String normalized) {
    final hasDebit = _expenseKeywords.any((r) => r.hasMatch(normalized));
    final hasCredit = _incomeKeywords.any((r) => r.hasMatch(normalized));
    if (hasCredit && !hasDebit) return domain.TransactionType.income;
    return domain.TransactionType.expense;
  }

  String? _extractMerchant(String body) {
    for (final regex in _merchantRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        return _cleanMerchant(match.group(1)!);
      }
    }
    final upperTokens = body
        .split(RegExp(r'[\s,.;:()]+'))
        .where((token) => token.length >= 3)
        .where((token) => token == token.toUpperCase())
        .toList();
    if (upperTokens.isNotEmpty) {
      return _cleanMerchant(upperTokens.first);
    }
    return null;
  }

  String _fallbackMerchant(String sender) {
    return sender.isEmpty ? 'SMS Import' : sender;
  }

  String? _extractAccountHint(String body) {
    for (final regex in _accountHintRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        return 'XX${match.group(1)!.replaceAll(RegExp(r'[^A-Z0-9]', caseSensitive: false), '')}';
      }
    }
    return null;
  }

  String? _inferCategory(String merchant, String body) {
    final text = '$merchant $body';
    for (final entry in _categoryHints.entries) {
      if (entry.key.hasMatch(text)) return entry.value;
    }
    return null;
  }

  String _cleanMerchant(String merchant) {
    var cleaned = merchant;
    for (final regex in _cleaningRegexes) {
      cleaned = cleaned.replaceAll(regex, '');
    }
    return cleaned
        .replaceAll(RegExp(r'[^A-Z0-9 &._/-]', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  double _computeConfidence(String merchant, String? categoryHint, String? accountHint, double amount, String body) {
    var confidence = 0.45;
    if (merchant.isNotEmpty && merchant != 'SMS Import') confidence += 0.2;
    if (categoryHint != null) confidence += 0.15;
    if (accountHint != null) confidence += 0.1;
    if (amount > 0) confidence += 0.05;
    if (_upiAmountRegex.hasMatch(body)) confidence += 0.05;
    return confidence.clamp(0.0, 1.0);
  }
}
