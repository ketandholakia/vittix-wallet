import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:intl/intl.dart';

/// Escapes a single CSV field for RFC 4180 and neutralises spreadsheet formula
/// injection: a leading `=`, `+`, `-`, `@`, tab or CR would otherwise be
/// interpreted as a formula when the file is opened in Excel, LibreOffice or
/// Google Sheets. Such a value is prefixed with an apostrophe before quoting.
String escapeCsvField(String text) {
  var field = text;
  if (field.isNotEmpty && '=+-@\t\r'.contains(field[0])) {
    field = "'$field";
  }
  if (field.contains('"') ||
      field.contains(',') ||
      field.contains('\n') ||
      field.contains('\r')) {
    return '"${field.replaceAll('"', '""')}"';
  }
  return field;
}

/// Generates an RFC 4180 compliant CSV string from a list of transactions.
String generateCsv({
  required List<Transaction> transactions,
  required Map<int, Category> categoryMap,
  required String currencyCode,
}) {
  final buffer = StringBuffer();
  
  // CSV Header
  buffer.writeln('ID,Date,Type,Parent Category,Category,Account,Amount,Currency,Note');

  String escapeCsv(String text) => escapeCsvField(text);

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
