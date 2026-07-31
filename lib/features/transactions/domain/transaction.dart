import 'package:expense_tracker/features/accounts/domain/account.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/payee.dart';
import 'package:expense_tracker/tag.dart';
import 'package:expense_tracker/attachment.dart';

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
  final Payee? payee;
  final List<Tag> tags;
  final List<Attachment> attachments;
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
    this.payee,
    this.tags = const [],
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}