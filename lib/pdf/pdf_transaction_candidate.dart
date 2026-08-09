import 'package:expense_tracker/domain/entities/transaction.dart' as domain;

class PdfTransactionCandidate {
  final String merchant;
  final double amount;
  final domain.TransactionType type;
  final DateTime date;
  final String? accountHint;
  final String? suggestedCategoryName;
  final int? selectedAccountId;
  final bool isSelected;
  final double confidence;
  final String sourceFile; // e.g., "GPay PDF"
  final String rawBlock; // Original text block for reference

  PdfTransactionCandidate({
    required this.merchant,
    required this.amount,
    required this.type,
    required this.date,
    this.accountHint,
    this.suggestedCategoryName,
    this.selectedAccountId,
    this.isSelected = true,
    this.confidence = 1.0,
    required this.sourceFile,
    required this.rawBlock,
  });

  PdfTransactionCandidate copyWith({
    String? merchant,
    double? amount,
    domain.TransactionType? type,
    DateTime? date,
    String? accountHint,
    String? suggestedCategoryName,
    int? selectedAccountId,
    bool? isSelected,
    double? confidence,
    String? sourceFile,
    String? rawBlock,
  }) {
    return PdfTransactionCandidate(
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      accountHint: accountHint ?? this.accountHint,
      suggestedCategoryName: suggestedCategoryName ?? this.suggestedCategoryName,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      isSelected: isSelected ?? this.isSelected,
      confidence: confidence ?? this.confidence,
      sourceFile: sourceFile ?? this.sourceFile,
      rawBlock: rawBlock ?? this.rawBlock,
    );
  }
}
