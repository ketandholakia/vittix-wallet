import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:intl/intl.dart';

/// Generates an RFC 4180 compliant CSV string from a list of transactions.
String generateCsv({
  required List<Transaction> transactions,
  required Map<int, Category> categoryMap,
  required String currencyCode,
}) {
  final buffer = StringBuffer();
  
  // CSV Header
  buffer.writeln('ID,Date,Type,Parent Category,Category,Account,Amount,Currency,Note');

  String escapeCsv(String text) {
    if (text.contains('"') || text.contains(',') || text.contains('\n') || text.contains('\r')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }

  for (final tx in transactions) {
    final parentId = tx.category.parentId;
    final parentName = parentId != null ? (categoryMap[parentId]?.name ?? '') : '';

    final row = [
      tx.id.toString(),
      DateFormat('yyyy-MM-dd').format(tx.date),
      tx.type == TransactionType.expense ? 'Expense' : 'Income',
      escapeCsv(parentName),
      escapeCsv(tx.category.name),
      escapeCsv(tx.account.name),
      tx.amount.toString(),
      currencyCode,
      escapeCsv(tx.note ?? ''),
    ];
    buffer.writeln(row.join(','));
  }
  
  return buffer.toString();
}
