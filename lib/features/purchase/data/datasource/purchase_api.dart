import 'package:dio/dio.dart';
import '../../../../core/config/endpoints.dart';
import '../models/purchase_order.dart';
import '../models/po_requests.dart';

class PurchaseApi {
  PurchaseApi(this._dio);
  final Dio _dio;

  // ---------- Helpers ----------
  Map<String, dynamic> _asMap(dynamic raw) {
    return raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  }

  /// ambil payload object (detail/create/update/action) dari response standar:
  /// { success, message, data: {...} }
  Map<String, dynamic> _extractDataMap(Response res) {
    final map = _asMap(res.data);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    // fallback: kalau API return object langsung
    return map;
  }

  /// ambil payload list dari response:
  /// - pagination: data.data
  /// - non pagination: data (list)
  /// - raw list: []
  List<dynamic> _extractDataList(Response res) {
    final raw = res.data;

    // raw list langsung
    if (raw is List) return raw;

    final map = _asMap(raw);
    final data = map['data'];

    // pagination: { data: { data: [...] } }
    if (data is Map && data['data'] is List) {
      return data['data'] as List;
    }

    // non pagination: { data: [...] }
    if (data is List) return data;

    return <dynamic>[];
  }

  // ---------- API Calls ----------
  Future<List<PurchaseOrder>> list({int page = 1}) async {
    final res = await _dio.get(
      Endpoints.purchaseOrders,
      queryParameters: {'page': page},
    );

    final items = _extractDataList(res);

    return items
        .whereType<Map>()
        .map((e) => PurchaseOrder.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<PurchaseOrder> detail(int id) async {
    final res = await _dio.get('${Endpoints.purchaseOrders}/$id');
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }

  Future<PurchaseOrder> create(CreatePoRequest req) async {
    final res = await _dio.post(Endpoints.purchaseOrders, data: req.toJson());
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }

  Future<PurchaseOrder> update(int id, UpdatePoRequest req) async {
    final res = await _dio.put(
      '${Endpoints.purchaseOrders}/$id',
      data: req.toJson(),
    );
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }

  Future<void> delete(int id) async {
    await _dio.delete('${Endpoints.purchaseOrders}/$id');
  }

  // ✅ Return PO terbaru biar UI langsung update tanpa refetch
  Future<PurchaseOrder> markOrdered(int id) async {
    final res = await _dio.post('${Endpoints.purchaseOrders}/$id/mark-ordered');
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }

  Future<PurchaseOrder> receive(int id) async {
    final res = await _dio.post('${Endpoints.purchaseOrders}/$id/receive');
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }

  Future<PurchaseOrder> cancel(int id, {String? reason, String? note}) async {
    final res = await _dio.post(
      '${Endpoints.purchaseOrders}/$id/cancel',
      data: {
        if (reason != null) 'reason': reason,
        if (note != null) 'note': note,
      },
    );
    final payload = _extractDataMap(res);
    return PurchaseOrder.fromJson(payload);
  }
}
