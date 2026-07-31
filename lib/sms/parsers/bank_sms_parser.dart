import 'package:expense_tracker/sms/sms_transaction_parser.dart';

/// Base class for all bank-specific SMS parsers
abstract class BankSmsParser {
  /// Unique identifier for the parser (e.g. 'HDFC Bank', 'SBI')
  String get bankName;

  /// Check if this parser can handle the given sender and message body
  bool canHandle(String sender, String body);

  /// Parse the message into a candidate
  SmsTransactionCandidate? parse(
    String smsId,
    String smsHash,
    String sender,
    String body,
    DateTime date,
  );

  /// Checks if this is an E-Mandate notification (not a transaction).
  bool isEMandateNotification(String body) {
    final lowerBody = body.toLowerCase();
    return lowerBody.contains('e-mandate') ||
        lowerBody.contains('upi-mandate') ||
        (lowerBody.contains('mandate') && lowerBody.contains('successfully created'));
  }

  /// Checks if this is a future debit notification (subscription alert, not a current transaction).
  bool isFutureDebitNotification(String body) {
    final lowerBody = body.toLowerCase();
    return lowerBody.contains('will be debited') ||
        lowerBody.contains('mandate set for') ||
        (lowerBody.contains('upcoming') && lowerBody.contains('mandate'));
  }

  /// Common utility to clean merchant name
  String cleanMerchantName(String merchant) {
    var cleaned = merchant;
    final cleaningRegexes = [
      RegExp(r'\s*\(.*?\)\s*$'), // Trailing parentheses
      RegExp(r'\s+Ref\s+No.*', caseSensitive: false),
      RegExp(r'\s+on\s+\d{2}.*'),
      RegExp(r'\s+UPI.*', caseSensitive: false),
      RegExp(r'\s+at\s+\d{2}:\d{2}.*'),
      RegExp(r'\s*-\s*$'),
      RegExp(r'(\s+PVT\.?\s*LTD\.?|\s+PRIVATE\s+LIMITED)$', caseSensitive: false),
      RegExp(r'(\s+LTD\.?|\s+LIMITED)$', caseSensitive: false),
    ];
    for (final regex in cleaningRegexes) {
      cleaned = cleaned.replaceAll(regex, '');
    }
    return cleaned
        .replaceAll(RegExp(r'[^A-Z0-9 &._/-]', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
