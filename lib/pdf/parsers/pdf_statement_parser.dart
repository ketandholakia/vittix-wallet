import 'package:expense_tracker/pdf/pdf_transaction_candidate.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Base interface for PDF statement parsers
abstract class PdfStatementParser {
  /// Check if the parser can handle the provided text block (usually the first few lines of the PDF)
  bool canHandle(String text);

  /// Parse the entire PDF text into a list of candidates
  List<PdfTransactionCandidate> parse(String text);

  /// Generates a hash for deduplication
  String buildHash({
    required String rawBlock,
    required String merchant,
    required double amount,
    required DateTime date,
  }) {
    final payload = '${merchant.toLowerCase()}_${amount.toStringAsFixed(2)}_${date.millisecondsSinceEpoch}_${rawBlock.length}';
    return md5.convert(utf8.encode(payload)).toString();
  }
}
