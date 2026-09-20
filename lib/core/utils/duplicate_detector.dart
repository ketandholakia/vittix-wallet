import 'package:expense_tracker/domain/entities/transaction.dart';

/// "Looks like a duplicate" detection shared by every entry path.
///
/// A candidate is treated as a likely duplicate when its amount, calendar day
/// and account all match an existing entry. This is the rule the manual entry
/// form has always applied; sharing it keeps the SMS, PDF and receipt paths
/// consistent instead of each inventing its own check.
bool looksLikeDuplicate(
  Transaction candidate,
  Iterable<Transaction> existing,
) {
  return existing.any((tx) =>
      tx.amount == candidate.amount &&
      tx.account.id == candidate.account.id &&
      tx.date.year == candidate.date.year &&
      tx.date.month == candidate.date.month &&
      tx.date.day == candidate.date.day);
}
