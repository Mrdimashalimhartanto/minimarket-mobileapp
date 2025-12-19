class Supplier {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final bool isActive;

  const Supplier({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    required this.isActive,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '').toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      isActive: _toBool(json['is_active']),
    );
  }

  static bool _toBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }
}
