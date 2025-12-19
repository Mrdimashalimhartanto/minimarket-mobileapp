class CreateSupplierRequest {
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final bool isActive;

  CreateSupplierRequest({
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "is_active": isActive,
  };
}

class UpdateSupplierRequest {
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final bool isActive;

  UpdateSupplierRequest({
    required this.name,
    this.email,
    this.phone,
    this.address,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "is_active": isActive,
  };
}
