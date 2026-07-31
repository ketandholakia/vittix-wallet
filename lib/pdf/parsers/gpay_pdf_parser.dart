import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/pdf/parsers/pdf_statement_parser.dart';
import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart';
import 'package:intl/intl.dart';

class GPayPdfParser extends PdfStatementParser {
  static const _dateFormatPattern = 'dd MMM yyyy hh:mm a';

  final _merchantAnchorRegex = RegExp(r'^Paid\s+to\s+(.+)$', caseSensitive: false);
  final _receivedAnchorRegex = RegExp(r'^Received\s+from\s+(.+)$', caseSensitive: false);
  final _bankAccountLineRegex = RegExp(r'^Paid\s+(?:by|to)\s+(.+)\s+(Bank|Card|A/c)\s+(\d{4})$', caseSensitive: false);
  final _amountRegex = RegExp(r'^(?:₹|Rs\.?)\s*([0-9][0-9,]*(?:\.[0-9]{1,2})?)$');
  final _dateLineRegex = RegExp(r'^(\d{1,2})\s+(\w{3}),?$');
  final _fullDateLineRegex = RegExp(r'^(\d{1,2}\s+\w{3},\s+20\d{2})$');
  final _datePrefixedRowRegex = RegExp(r'^(\d{1,2}\s+\w{3},\s+20\d{2})\s+(.+)$');
  final _yearLineRegex = RegExp(r'^(20\d{2})$');
  final _timeLineRegex = RegExp(r'^(\d{1,2}:\d{2})\s*([AaPp][Mm])(?:\s+(.+))?$');

  @override
  bool canHandle(String text) {
    final lower = text.toLowerCase();
    return (lower.contains('google pay') || lower.contains('gpay')) &&
        lower.contains('upi transaction id');
  }

  @override
  List<PdfTransactionCandidate> parse(String text) {
    final blocks = _splitIntoBlocks(text);
    final transactions = <PdfTransactionCandidate>[];

    for (final block in blocks) {
      final parsed = _parseBlock(block);
      if (parsed != null) {
        transactions.add(parsed);
      }
    }
    return transactions;
  }

  List<String> _splitIntoBlocks(String text) {
    final blocks = <String>[];
    final current = StringBuffer();
    String? pendingDate;
    String? pendingYear;
    String? pendingTime;
    bool inBlock = false;

    for (var rawLine in text.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      final isDate = _dateLineRegex.hasMatch(line);
      final isFullDate = _fullDateLineRegex.hasMatch(line);
      final isYear = _yearLineRegex.hasMatch(line);
      final isTime = _timeLineRegex.hasMatch(line);

      final datePrefixedMatch = _datePrefixedRowRegex.firstMatch(line);
      if (datePrefixedMatch != null) {
        final fullDate = datePrefixedMatch.group(1)!;
        final rest = datePrefixedMatch.group(2)!.trim();
        final rowParts = _splitAnchorAndAmount(rest);
        if (_isTransactionAnchor(rowParts.key)) {
          if (inBlock && current.isNotEmpty) {
            blocks.add(current.toString().trim());
            current.clear();
          }
          current.writeln(fullDate);
          current.writeln(rowParts.key);
          if (rowParts.value != null) current.writeln(rowParts.value);
          pendingDate = null;
          pendingYear = null;
          pendingTime = null;
          inBlock = true;
          continue;
        }
      }

      if (_isTransactionAnchor(line)) {
        if (inBlock && current.isNotEmpty) {
          blocks.add(current.toString().trim());
          current.clear();
        }
        if (pendingDate != null) current.writeln(pendingDate);
        if (pendingYear != null) current.writeln(pendingYear);
        if (pendingTime != null) current.writeln(pendingTime);
        pendingDate = null;
        pendingYear = null;
        pendingTime = null;
        current.writeln(line);
        inBlock = true;
        continue;
      }

      if (isDate) {
        pendingDate = line;
        continue;
      }
      if (isFullDate) {
        pendingDate = line;
        pendingYear = null;
        continue;
      }
      if (isYear) {
        pendingYear = line;
        continue;
      }
      if (isTime && inBlock) {
        final match = _timeLineRegex.firstMatch(line);
        if (match != null && match.groupCount >= 3 && match.group(3) != null && match.group(3)!.trim().isNotEmpty) {
          current.writeln(line);
          continue;
        }
      }
      if (isTime) {
        pendingTime = line;
        continue;
      }

      if (inBlock) current.writeln(line);
    }

    if (current.isNotEmpty) blocks.add(current.toString().trim());
    return blocks;
  }

  bool _isTransactionAnchor(String line) {
    if (_receivedAnchorRegex.hasMatch(line)) return true;
    if (_merchantAnchorRegex.hasMatch(line)) {
      return !_bankAccountLineRegex.hasMatch(line);
    }
    return false;
  }

  PdfTransactionCandidate? _parseBlock(String block) {
    final lines = block.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final anchorLine = lines.firstWhere(
      (line) => _isTransactionAnchor(line),
      orElse: () => '',
    );

    if (anchorLine.isEmpty) return null;

    final isExpense = _merchantAnchorRegex.hasMatch(anchorLine);
    final type = isExpense ? domain.TransactionType.expense : domain.TransactionType.income;
    final merchant = _extractMerchant(anchorLine, isExpense);

    if (merchant == null) return null;

    final amount = _extractAmount(lines);
    if (amount == null) return null;

    final timestamp = _extractTimestamp(lines, merchant);
    if (timestamp == null) return null;

    return PdfTransactionCandidate(
      merchant: merchant,
      amount: amount,
      type: type,
      date: timestamp,
      sourceFile: 'GPay PDF',
      rawBlock: block,
      confidence: 0.9,
    );
  }

  String? _extractMerchant(String anchorLine, bool isExpense) {
    final regex = isExpense ? _merchantAnchorRegex : _receivedAnchorRegex;
    final match = regex.firstMatch(anchorLine);
    final val = match?.group(1)?.trim();
    return (val != null && val.isNotEmpty) ? val : null;
  }

  double? _extractAmount(List<String> lines) {
    for (var line in lines) {
      final match = _amountRegex.firstMatch(line);
      if (match != null) {
        final raw = match.group(1);
        if (raw != null) {
          final cleaned = raw.replaceAll(',', '');
          return double.tryParse(cleaned);
        }
      }
    }
    return null;
  }

  DateTime? _extractTimestamp(List<String> lines, String merchant) {
    String? dateLine;
    String? yearLine;
    String? timeLine;

    for (var line in lines) {
      if (dateLine == null && (_dateLineRegex.hasMatch(line) || _fullDateLineRegex.hasMatch(line))) {
        dateLine = line;
      } else if (yearLine == null && _yearLineRegex.hasMatch(line)) {
        yearLine = line;
      } else if (timeLine == null && _timeLineRegex.hasMatch(line)) {
        final match = _timeLineRegex.firstMatch(line);
        if (match != null) {
          timeLine = '${match.group(1)} ${match.group(2)}';
        }
      }
      if (dateLine != null && (yearLine != null || _fullDateLineRegex.hasMatch(dateLine)) && timeLine != null) {
        break;
      }
    }

    if (dateLine == null || timeLine == null || (yearLine == null && !_fullDateLineRegex.hasMatch(dateLine))) {
      return null;
    }

    final dateClean = dateLine.replaceAll(RegExp(r'[, ]+$'), '');
    final timeClean = timeLine.replaceAll(RegExp(r'\s+'), ' ').toUpperCase();
    
    final combined = _fullDateLineRegex.hasMatch(dateLine)
        ? '$dateClean $timeClean'
        : '$dateClean $yearLine $timeClean';

    try {
      // Need to replace " 202" with "202" inside parsing logic if required, but DateFormat can handle spaces
      // e.g. "01 Sep 2025 03:02 PM"
      final cleanCombined = combined.replaceAll(',', '');
      final formatter = DateFormat(_dateFormatPattern, 'en_US');
      return formatter.parseStrict(cleanCombined);
    } catch (e) {
      return null;
    }
  }

  MapEntry<String, String?> _splitAnchorAndAmount(String value) {
    final amountRegex = RegExp(r'\s+((?:₹|Rs\.?)\s*[0-9][0-9,]*(?:\.[0-9]{1,2})?)$');
    final match = amountRegex.firstMatch(value);
    if (match == null) return MapEntry(value.trim(), null);

    final anchorLine = value.substring(0, match.start).trim();
    return MapEntry(anchorLine, match.group(1)?.trim());
  }
}
