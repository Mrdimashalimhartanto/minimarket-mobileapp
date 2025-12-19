class AdjustStockRequest {
  final int productId;
  final int qty;
  final String type; // in/out
  final String reason; // ex: purchase, correction, damaged...
  final String? note;

  const AdjustStockRequest({
    required this.productId,
    required this.qty,
    required this.type,
    required this.reason,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'qty': qty,
    'type': type,
    'reason': reason,
    if (note != null) 'note': note,
  };
}
