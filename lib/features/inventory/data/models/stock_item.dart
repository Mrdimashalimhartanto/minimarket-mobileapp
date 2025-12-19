class StockItem {
  final int productId;
  final String sku;
  final String name;
  final int stock;
  final int minStock;
  final String status;
  final String? imageUrl;

  const StockItem({
    required this.productId,
    required this.sku,
    required this.name,
    required this.stock,
    required this.minStock,
    required this.status,
    this.imageUrl,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      productId:
          (json['product_id'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      sku: (json['sku'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      minStock: (json['min_stock'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}
