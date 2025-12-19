import 'package:minimarket/core/utils/json_parser.dart';

import 'purchase_order_item.dart';

class PurchaseOrder {
  final int id;
  final int supplierId;
  final String code;
  final String status; // draft/ordered/received/cancelled
  final DateTime? orderedAt;
  final DateTime? receivedAt;
  final num totalAmount;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<PurchaseOrderItem> items;

  const PurchaseOrder({
    required this.id,
    required this.supplierId,
    required this.code,
    required this.status,
    this.orderedAt,
    this.receivedAt,
    required this.totalAmount,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.items,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    final itemsList = (itemsRaw is List) ? itemsRaw : <dynamic>[];

    return PurchaseOrder(
      id: parseInt(json['id']),
      supplierId: parseInt(json['supplier_id']),
      code: (json['code'] ?? '').toString(),
      status: (json['status'] ?? 'draft').toString(),
      orderedAt: DateTime.tryParse(json['ordered_at']?.toString() ?? ''),
      receivedAt: DateTime.tryParse(json['received_at']?.toString() ?? ''),
      totalAmount: parseNum(json['total_amount']),
      createdBy: json['created_by'] == null
          ? null
          : parseInt(json['created_by']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      items: itemsList
          .whereType<Map>()
          .map((e) => PurchaseOrderItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
