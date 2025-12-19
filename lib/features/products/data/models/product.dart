class Product {
  final int id;
  final int categoryId;
  final String sku;
  final String name;
  final String? imagePath; // ✅ sesuai DB
  final String? imageUrl;
  final String? description;
  final num costPrice; // decimal(15,2)
  final num sellingPrice; // decimal(15,2)
  final int stock;
  final int minStock;
  final String status; // active / inactive

  const Product({
    required this.id,
    required this.categoryId,
    required this.sku,
    required this.name,
    this.imagePath,
    this.imageUrl,
    this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    required this.minStock,
    required this.status,
  });

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id']),
      sku: (json['sku'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      imagePath: json['image_path']?.toString(), // ✅ sesuai DB
      imageUrl: json['image_url']?.toString(),
      description: json['description']?.toString(),
      costPrice: _toNum(json['cost_price']),
      sellingPrice: _toNum(json['selling_price']),
      stock: _toInt(json['stock']),
      minStock: _toInt(json['min_stock']),
      status: (json['status'] ?? 'active').toString(),
    );
  }
}
