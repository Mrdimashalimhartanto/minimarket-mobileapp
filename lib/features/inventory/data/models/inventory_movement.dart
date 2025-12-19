class InventoryMovement {
  final int id;
  final int productId;
  final String type; // in/out
  final int qty;
  final String reason;
  final String? note;
  final DateTime createdAt;

  const InventoryMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.qty,
    required this.reason,
    this.note,
    required this.createdAt,
  });

  factory InventoryMovement.fromJson(Map<String, dynamic> json) {
    return InventoryMovement(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      type: (json['type'] ?? '').toString(),
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      reason: (json['reason'] ?? '').toString(),
      note: json['note']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
