import 'package:vittix_wallet/features/accounts/domain/account.dart';
import 'package:vittix_wallet/features/categories/domain/category.dart';
import 'package:vittix_wallet/core/domain/payee.dart';
import 'package:vittix_wallet/core/domain/tag.dart';
import 'package:vittix_wallet/core/domain/attachment.dart';

enum TransactionType { income, expense }

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
