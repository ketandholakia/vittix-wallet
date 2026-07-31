import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/pdf/parsers/pdf_statement_parser.dart';
import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart';
import 'package:intl/intl.dart';

class PhonePePdfParser extends PdfStatementParser {
  static const _phonePeKeywords = ['phonepe', 'phone pe'];

  final _amountPattern = RegExp(r'[₹Rs.]+\s*([\d,]+(?:\.\d{1,2})?)');
  final _datePattern = RegExp(r'(\d{1,2}\s+\w{3}[,]?\s+\d{4}|\w{3}\s+\d{1,2}[,]?\s+\d{4})');
  final _merchantPattern = RegExp(r'(?:Paid\s+to|Sent\s+to|Transferred\s+to|Received\s+from)\s+(.+?)(?:\n|$)', caseSensitive: false);

  final List<DateFormat> _dateFormats = [
    DateFormat('MMM dd, yyyy', 'en_US'),
    DateFormat('dd MMM, yyyy', 'en_US'),
    DateFormat('MMM dd yyyy', 'en_US'),
    DateFormat('dd MMM yyyy', 'en_US'),
  ];

  @override
  bool canHandle(String text) {
    final lower = text.toLowerCase();
    return _phonePeKeywords.any((keyword) => lower.contains(keyword));
  }

  @override
  List<PdfTransactionCandidate> parse(String text) {
    final transactions = <PdfTransactionCandidate>[];
    final blocks = _splitIntoTransactionBlocks(text);

    for (final block in blocks) {
      final parsed = _parseBlock(block);
      if (parsed != null) {
        transactions.add(parsed);
      }
    }

    return transactions;
  }

  List<String> _splitIntoTransactionBlocks(String text) {
    final blocks = <String>[];
    final lines = text.split('\n');
    final currentBlock = StringBuffer();
    bool inTransaction = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      final lowerLine = trimmed.toLowerCase();
      final isDebit = lowerLine == 'debit' || lowerLine.startsWith('debit ');
      final isCredit = lowerLine == 'credit' || lowerLine.startsWith('credit ');
      final isPaidTo = lowerLine.startsWith('paid to') ||
          lowerLine.startsWith('sent to') ||
          lowerLine.startsWith('transferred to');
      final isReceivedFrom = lowerLine.startsWith('received from');

      if (isDebit || isCredit || isPaidTo || isReceivedFrom) {
        if (inTransaction && currentBlock.isNotEmpty) {
          blocks.add(currentBlock.toString().trim());
          currentBlock.clear();
        }
        inTransaction = true;
      }

      if (inTransaction) {
        currentBlock.writeln(line);
      }
    }

    if (currentBlock.isNotEmpty) {
      blocks.add(currentBlock.toString().trim());
    }

    return blocks;
  }

  PdfTransactionCandidate? _parseBlock(String block) {
    final amount = _extractAmount(block);
    if (amount == null) return null;

    final type = _extractTransactionType(block);
    if (type == null) return null;

    final merchant = _extractMerchant(block);
    if (merchant == null) return null;

    final timestamp = _extractTimestamp(block) ?? DateTime.now();

    return PdfTransactionCandidate(
      merchant: merchant.trim(),
      amount: amount,
      type: type,
      date: timestamp,
      sourceFile: 'PhonePe PDF',
      rawBlock: block.trim(),
      confidence: 0.9,
    );
  }

  double? _extractAmount(String block) {
    final match = _amountPattern.firstMatch(block);
    if (match == null) return null;
    final amountStr = match.group(1)?.replaceAll(',', '');
    if (amountStr == null) return null;
    return double.tryParse(amountStr);
  }

  domain.TransactionType? _extractTransactionType(String block) {
    final lines = block.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (lines.isEmpty) return null;

    final firstLine = lines.first.toUpperCase();
    if (firstLine.startsWith('DEBIT')) {
      return domain.TransactionType.expense;
    }
    if (firstLine.startsWith('CREDIT')) {
      return domain.TransactionType.income;
    }
    if (firstLine.startsWith('PAID TO') ||
        firstLine.startsWith('SENT TO') ||
        firstLine.startsWith('TRANSFERRED TO')) {
      return domain.TransactionType.expense;
    }
    if (firstLine.startsWith('RECEIVED FROM')) {
      return domain.TransactionType.income;
    }

    final upperBlock = block.toUpperCase();
    if (upperBlock.contains('DEBIT')) {
      return domain.TransactionType.expense;
    }
    if (upperBlock.contains('CREDIT')) {
      return domain.TransactionType.income;
    }

    return null;
  }

  String? _extractMerchant(String block) {
    final match = _merchantPattern.firstMatch(block);
    if (match != null) {
      return match.group(1)?.trim();
    }

    final lines = block.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (lines.length >= 2) {
      final secondLine = lines[1];
      if (!RegExp(r'^[₹Rs.\d,]+.*').hasMatch(secondLine) &&
          !secondLine.toLowerCase().startsWith('transaction') &&
          !secondLine.toLowerCase().startsWith('utr')) {
        return secondLine;
      }
    }

    return null;
  }

  DateTime? _extractTimestamp(String block) {
    final match = _datePattern.firstMatch(block);
    if (match == null) return null;
    final dateStr = match.group(1)?.trim();
    if (dateStr == null) return null;

    for (final format in _dateFormats) {
      try {
        return format.parseStrict(dateStr);
      } catch (_) {
        // Try next format
      }
    }
    return null;
  }
}
