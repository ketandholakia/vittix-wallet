import 'package:expense_tracker/account.dart';
import 'package:expense_tracker/category.dart';

enum TransactionType {
  income,
  expense,
}

class Transaction {
  final int id;
  final double amount;
  final DateTime date;
  final String? note;
  final TransactionType type;
  final Category category;
  final Account account;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
    required this.type,
    required this.category,
    required this.account,
    required this.createdAt,
    required this.updatedAt,
  });
}