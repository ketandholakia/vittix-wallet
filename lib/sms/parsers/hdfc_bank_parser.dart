import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/sms/parsers/bank_sms_parser.dart';
import 'package:expense_tracker/sms/sms_transaction_parser.dart';

class HdfcBankParser extends BankSmsParser {
  @override
  String get bankName => 'HDFC Bank';

  @override
  bool canHandle(String sender, String body) {
    final s = sender.toUpperCase();
    return s.contains('HDFC');
  }

  @override
  SmsTransactionCandidate? parse(
    String smsId,
    String smsHash,
    String sender,
    String body,
    DateTime date,
  ) {
    final lowerBody = body.toLowerCase();
    
    // Check for mandates/subscriptions first
    final bool isMandate = isEMandateNotification(body) || isFutureDebitNotification(body);

    // Determine type
    domain.TransactionType? type;
    if (isMandate) {
      type = domain.TransactionType.expense; // Mandates are always expenses
    } else if (lowerBody.contains('debited') || lowerBody.contains('spent') || lowerBody.contains('withdrawn') || lowerBody.contains('paid')) {
      type = domain.TransactionType.expense;
    } else if (lowerBody.contains('credited') || lowerBody.contains('deposited') || lowerBody.contains('received')) {
      type = domain.TransactionType.income;
    }

    if (type == null) return null;

    // Extract amount
    double? amount;
    final amountRegexes = [
      RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];
    for (final regex in amountRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        amount = double.tryParse(match.group(1)!.replaceAll(',', ''));
        if (amount != null) break;
      }
    }
    
    if (amount == null || amount <= 0) return null;

    // Extract merchant
    String? merchant;
    final merchantRegexes = [
      if (isMandate) ...[
        RegExp(r'towards\s+([^.\n]+?)(?:\s+from|\s+A/c|\s+UMRN|\s+ID:|\s+Alert:|\s*\.|$)', caseSensitive: false),
        RegExp(r'for\s+([^.\n]+?)(?:\s+mandate|\s+will\s+be|\s+ID:|\s+Act:|\s*\.|$)', caseSensitive: false),
      ],
      RegExp(r'at\s+([^@\s]+(?:@[^\s]+)?)(?:\s+by\s+|\s+on\s+|$)', caseSensitive: false), // UPI
      RegExp(r'to\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)', caseSensitive: false),
      RegExp(r'from\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)', caseSensitive: false),
      RegExp(r'VPA\s+([a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+)', caseSensitive: false), // VPA
    ];

    for (final regex in merchantRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        merchant = cleanMerchantName(match.group(1)!);
        break;
      }
    }

    if (merchant == null || merchant.isEmpty) {
      merchant = 'HDFC Bank'; // Default fallback
    }

    // Extract account hint
    String? accountHint;
    final accountHintRegexes = [
      RegExp(r'a/c\s+(?:ending\s+)?(\d{4})', caseSensitive: false),
      RegExp(r'card\s+(?:ending\s+)?(\d{4})', caseSensitive: false),
      RegExp(r'HDFC\s+Bank\s+(?:Credit|Debit)\s+Card\s+(\d{4})', caseSensitive: false),
    ];

    for (final regex in accountHintRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        accountHint = 'XX${match.group(1)}';
        break;
      }
    }

    return SmsTransactionCandidate(
      smsId: smsId,
      smsHash: smsHash,
      body: body,
      sender: sender,
      merchant: merchant,
      amount: amount,
      type: type,
      date: date,
      accountHint: accountHint,
      isSelected: true,
      confidence: 0.8, // Specific bank parsers have higher confidence
      isRecurringSetup: isMandate,
      recurringIntervalHint: isMandate ? 'Monthly' : null,
    );
  }
}
