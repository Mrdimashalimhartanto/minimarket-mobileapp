import 'package:dio/dio.dart';
import '../../../../core/config/endpoints.dart';
import '../models/supplier.dart';
import '../models/supplier_requests.dart';

class SupplierApi {
  SupplierApi(this._dio);
  final Dio _dio;

  Map<String, dynamic> _asMap(dynamic raw) =>
      raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

  Map<String, dynamic> _extractDataMap(Response res) {
    final map = _asMap(res.data);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
  }

  List<dynamic> _extractDataList(Response res) {
    final raw = res.data;
    if (raw is List) return raw;

    final map = _asMap(raw);
    final data = map['data'];

    if (data is Map && data['data'] is List) {
      return data['data'] as List; // pagination
    }
    if (data is List) return data;

    return <dynamic>[];
  }

  Future<List<Supplier>> list({int page = 1}) async {
    final res = await _dio.get(
      Endpoints.suppliers,
      queryParameters: {"page": page},
    );
    final items = _extractDataList(res);

    return items
        .whereType<Map>()
        .map((e) => Supplier.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Supplier> detail(int id) async {
    final res = await _dio.get('${Endpoints.suppliers}/$id');
    return Supplier.fromJson(_extractDataMap(res));
  }

  Future<Supplier> create(CreateSupplierRequest req) async {
    final res = await _dio.post(Endpoints.suppliers, data: req.toJson());
    return Supplier.fromJson(_extractDataMap(res));
  }

  Future<Supplier> update(int id, UpdateSupplierRequest req) async {
    final res = await _dio.put(
      '${Endpoints.suppliers}/$id',
      data: req.toJson(),
    );
    return Supplier.fromJson(_extractDataMap(res));
  }

  Future<void> delete(int id) async {
    await _dio.delete('${Endpoints.suppliers}/$id');
  }
}
