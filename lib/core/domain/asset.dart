class Asset {
  final int id;
  final int walletId;
  final String name;
  final String type;
  final double quantity;
  final double currentPrice;
  final String currencyCode;
  final DateTime updatedAt;

  Asset({
    required this.id,
    required this.walletId,
    required this.name,
    required this.type,
    required this.quantity,
    required this.currentPrice,
    required this.currencyCode,
    required this.updatedAt,
  });

  double get totalValue => quantity * currentPrice;
}
