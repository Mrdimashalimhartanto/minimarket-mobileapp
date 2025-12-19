import 'purchase_order_item.dart';

class CreatePoRequest {
  final int supplierId;
  final List<PurchaseOrderItem> items;

  const CreatePoRequest({required this.supplierId, required this.items});

  Map<String, dynamic> toJson() => {
    'supplier_id': supplierId,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class UpdatePoRequest {
  final int supplierId;
  final List<PurchaseOrderItem> items;

  const UpdatePoRequest({required this.supplierId, required this.items});

  Map<String, dynamic> toJson() => {
    'supplier_id': supplierId,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
