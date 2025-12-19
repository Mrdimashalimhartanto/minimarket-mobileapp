import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/config/endpoints.dart';
import '../models/product.dart';

class ProductsApi {
  ProductsApi(this._dio);
  final Dio _dio;

  Future<List<Product>> list() async {
    final res = await _dio.get(Endpoints.products);

    final raw = res.data;

    // Normalisasi jadi Map<String, dynamic> kalau memungkinkan
    final Map<String, dynamic> map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    dynamic items;

    if (map.isNotEmpty) {
      final data = map['data'];

      if (data is Map) {
        // pagination: data.data
        items = data['data'];
      } else {
        // non pagination: data = [...]
        items = data;
      }
    } else {
      // raw langsung list
      items = raw;
    }

    final list = (items is List) ? items : <dynamic>[];

    return list
        .whereType<Map>()
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Product> detail(int id) async {
    final res = await _dio.get('${Endpoints.products}/$id');

    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    // detail kadang {data:{...}} kadang langsung {...}
    final payload = (map['data'] is Map)
        ? Map<String, dynamic>.from(map['data'])
        : map;

    return Product.fromJson(payload);
  }

  Future<Product> create({
    required int categoryId,
    required String sku,
    required String name,
    String? description,
    required num costPrice,
    required num sellingPrice,
    required int stock,
    required int minStock,
    required String status,
    File? imageFile,
  }) async {
    final form = FormData.fromMap({
      'category_id': categoryId,
      'sku': sku,
      'name': name,
      'description': description ?? '',
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
      'min_stock': minStock,
      'status': status,
      if (imageFile != null)
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });

    final res = await _dio.post(
      Endpoints.products,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    final payload = (map['data'] is Map)
        ? Map<String, dynamic>.from(map['data'])
        : map;

    return Product.fromJson(payload);
  }

  Future<Product> update({
    required int id,
    required int categoryId,
    required String sku,
    required String name,
    String? description,
    required num costPrice,
    required num sellingPrice,
    required int stock,
    required int minStock,
    required String status,
    File? imageFile,
  }) async {
    final form = FormData.fromMap({
      'category_id': categoryId,
      'sku': sku,
      'name': name,
      'description': description ?? '',
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
      'min_stock': minStock,
      'status': status,
      '_method': 'PUT',
      if (imageFile != null)
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });

    final res = await _dio.post(
      '${Endpoints.products}/$id',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    final payload = (map['data'] is Map)
        ? Map<String, dynamic>.from(map['data'])
        : map;

    return Product.fromJson(payload);
  }

  Future<void> delete(int id) async {
    await _dio.delete('${Endpoints.products}/$id');
  }
}
