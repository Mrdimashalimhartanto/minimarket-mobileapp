import 'package:minimarket/core/utils/json_parser.dart';

class PurchaseOrderItem {
  final int productId;
  final int qty;
  final num unitCost;

  const PurchaseOrderItem({
    required this.productId,
    required this.qty,
    required this.unitCost,
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItem(
      productId: parseInt(json['product_id']),
      qty: parseInt(json['quantity_ordered'] ?? json['qty']),
      unitCost: parseNum(json['unit_cost'] ?? json['cost_price']),
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity_ordered': qty, // ✅
    'unit_cost': unitCost, // ✅
  };
}
