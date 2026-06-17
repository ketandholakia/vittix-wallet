import 'dart:convert';
import 'dart:math';

import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;

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
  final bool isSelected;

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
  });

  SmsTransactionCandidate copyWith({
    String? merchant,
    double? amount,
    domain.TransactionType? type,
    DateTime? date,
    String? accountHint,
    String? suggestedCategoryName,
    bool? isSelected,
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
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class SmsTransactionParser {
  static final RegExp _amountRegex = RegExp(r'(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false);
  static final RegExp _upiAmountRegex = RegExp(r'UPI.*?(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false);
  static final RegExp _merchantAfterAtRegex = RegExp(r'\bat\s+([A-Z0-9][A-Z0-9 &._/-]{2,})', caseSensitive: false);
  static final RegExp _merchantAfterToRegex = RegExp(r'\bto\s+([A-Z0-9][A-Z0-9 &._/-]{2,})', caseSensitive: false);
  static final RegExp _merchantAfterFromRegex = RegExp(r'\bfrom\s+([A-Z0-9][A-Z0-9 &._/-]{2,})', caseSensitive: false);

  static const _expenseKeywords = [
    'debited',
    'spent',
    'withdrawn',
    'paid',
    'purchase',
    'payment',
    'deducted',
    'dr',
    'pos',
  ];

  static const _incomeKeywords = [
    'credited',
    'received',
    'refund',
    'salary',
    'deposit',
    'cr',
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
    final smsHash = base64Url.encode(utf8.encode('$sender|$normalized'));
    if (knownHashes.contains(smsHash)) return null;

    final keywordsMatch = _expenseKeywords.any(normalized.contains) || _incomeKeywords.any(normalized.contains);
    if (!keywordsMatch) return null;

    final amount = _extractAmount(trimmedBody);
    if (amount == null || amount <= 0) return null;

    final type = _inferType(normalized);
    final merchant = _extractMerchant(trimmedBody) ?? _fallbackMerchant(sender);
    final accountHint = _extractAccountHint(trimmedBody);
    final categoryHint = _inferCategory(merchant, trimmedBody);

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
    );
  }

  double? _extractAmount(String body) {
    final upiMatch = _upiAmountRegex.firstMatch(body);
    final match = upiMatch ?? _amountRegex.firstMatch(body);
    if (match == null) return null;
    final value = match.group(1)!.replaceAll(',', '');
    return double.tryParse(value);
  }

  domain.TransactionType _inferType(String normalized) {
    final hasDebit = _expenseKeywords.any(normalized.contains);
    final hasCredit = _incomeKeywords.any(normalized.contains);
    if (hasCredit && !hasDebit) return domain.TransactionType.income;
    return domain.TransactionType.expense;
  }

  String? _extractMerchant(String body) {
    for (final regex in [_merchantAfterAtRegex, _merchantAfterToRegex, _merchantAfterFromRegex]) {
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
    final match = RegExp(r'XX?(\d{2,4})', caseSensitive: false).firstMatch(body);
    if (match != null) return 'XX${match.group(1)}';
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
    return merchant
        .replaceAll(RegExp(r'[^A-Z0-9 &._/-]', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
