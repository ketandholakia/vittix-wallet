import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/sms/parsers/bank_sms_parser.dart';
import 'package:expense_tracker/sms/sms_transaction_parser.dart';

class IciciBankParser extends BankSmsParser {
  @override
  String get bankName => 'ICICI Bank';

  @override
  bool canHandle(String sender, String body) {
    final s = sender.toUpperCase();
    return s.contains('ICICI');
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
    final bool isMandate = isEMandateNotification(body) || isFutureDebitNotification(body) || lowerBody.contains('autopay');

    // Determine type
    domain.TransactionType? type;
    if (isMandate) {
      type = domain.TransactionType.expense;
    } else if (lowerBody.contains('debited') || lowerBody.contains('spent') || lowerBody.contains('paid')) {
      type = domain.TransactionType.expense;
    } else if (lowerBody.contains('credited') || lowerBody.contains('deposited')) {
      type = domain.TransactionType.income;
    }

    if (type == null) return null;

    // Extract amount
    double? amount;
    final amountRegexes = [
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'amount\s+of\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
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
        RegExp(r'for\s+([^.\n]+?)(?:\s+mandate|\s+will\s+be|\s+subscription|\s+ID:|\s+Act:|\s*\.|$)', caseSensitive: false),
      ],
      RegExp(r'Info:?\s*([^\.\n]+?)(?:\s+Ref|\s+UPI|\s+on|\.|$)', caseSensitive: false), // ICICI often uses Info: <merchant>
      RegExp(r'to\s+([^.\n]+?)(?:\.|\s+UPI|\s+Ref)', caseSensitive: false),
      RegExp(r'at\s+([^.\n]+?)(?:\.|\s+on|\s+Ref)', caseSensitive: false),
    ];

    for (final regex in merchantRegexes) {
      final match = regex.firstMatch(body);
      if (match != null) {
        merchant = cleanMerchantName(match.group(1)!);
        break;
      }
    }

    if (merchant == null || merchant.isEmpty) {
      merchant = 'ICICI Bank'; // Default fallback
    }

    // Extract account hint
    String? accountHint;
    final accountHintRegexes = [
      RegExp(r'Acct\s+XX(\d{3,4})', caseSensitive: false),
      RegExp(r'a/c\s+no\.\s+XX(\d{3,4})', caseSensitive: false),
      RegExp(r'card\s+(?:ending\s+)?(\d{4})', caseSensitive: false),
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
