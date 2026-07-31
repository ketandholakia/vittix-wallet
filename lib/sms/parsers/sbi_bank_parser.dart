import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/sms/parsers/bank_sms_parser.dart';
import 'package:expense_tracker/sms/sms_transaction_parser.dart';

class SbiBankParser extends BankSmsParser {
  @override
  String get bankName => 'SBI';

  @override
  bool canHandle(String sender, String body) {
    final s = sender.toUpperCase();
    return s.contains('SBI') && (s.contains('INB') || s.contains('PSG') || s.contains('UPI') || s.contains('SBI'));
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
      type = domain.TransactionType.expense;
    } else if (lowerBody.contains('debited') || lowerBody.contains('withdrawn') || lowerBody.contains('paid') || lowerBody.contains('sent')) {
      type = domain.TransactionType.expense;
    } else if (lowerBody.contains('credited') || lowerBody.contains('received')) {
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
      RegExp(r'to\s+([^\.\n]+?)(?:\s+Ref|\s+UPI|\s+on)', caseSensitive: false),
      RegExp(r'from\s+([^\.\n]+?)(?:\s+Ref|\s+UPI|\s+on)', caseSensitive: false),
      RegExp(r'transfer\s+to\s+([^\.\n]+)', caseSensitive: false),
    ];

    for (final regex in merchantRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        merchant = cleanMerchantName(match.group(1)!);
        break;
      }
    }

    if (merchant == null || merchant.isEmpty) {
      merchant = 'SBI'; // Default fallback
    }

    // Extract account hint
    String? accountHint;
    final accountHintRegexes = [
      RegExp(r'A/c\s+No\.?\s+XX(\d{3,4})', caseSensitive: false),
      RegExp(r'A/c\s+X+(\d{3,4})', caseSensitive: false),
      RegExp(r'acct\s+X+(\d{3,4})', caseSensitive: false),
      RegExp(r'ending\s+(?:with\s+)?(\d{4})', caseSensitive: false),
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
      confidence: 0.8,
      isRecurringSetup: isMandate,
      recurringIntervalHint: isMandate ? 'Monthly' : null,
    );
  }
}
