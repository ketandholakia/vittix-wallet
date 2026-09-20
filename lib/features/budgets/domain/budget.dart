import 'package:expense_tracker/domain/entities/category.dart';

class Budget {
  final int id;
  final int walletId;
  final double amount;
  final String period; // e.g., "2024-07"
  final Category category;
  final double spentAmount;
  final double rolloverAmount;

  Budget({
    required this.id,
    this.walletId = 0,
    required this.amount,
    required this.period,
    required this.category,
    this.spentAmount = 0.0,
    this.rolloverAmount = 0.0,
  });

  double get totalLimit => amount + rolloverAmount;
  double get remainingAmount => totalLimit - spentAmount;
}