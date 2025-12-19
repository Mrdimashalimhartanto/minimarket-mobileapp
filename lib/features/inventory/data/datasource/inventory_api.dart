import 'package:dio/dio.dart';
import '../../../../core/config/endpoints.dart';
import '../models/stock_item.dart';
import '../models/inventory_movement.dart';
import '../models/adjust_stock_request.dart';

class InventoryApi {
  InventoryApi(this._dio);
  final Dio _dio;

  Future<List<StockItem>> stockList() async {
    final res = await _dio.get(Endpoints.inventoryStock);
    final raw = res.data;
    // items berada di data.data (pagination) / data(list)
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    dynamic items;
    if (map.isNotEmpty) {
      final data = map['data'];
      items = (data is Map) ? data['data'] : data;
    } else {
      items = raw;
    }

    final list = (items is List) ? items : <dynamic>[];
    return list
        .whereType<Map>()
        .map((e) => StockItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<StockItem> stockShow(int id) async {
    final res = await _dio.get('${Endpoints.inventoryStock}/$id');
    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    final payload = (map['data'] is Map)
        ? Map<String, dynamic>.from(map['data'])
        : map;
    return StockItem.fromJson(payload);
  }

  Future<List<InventoryMovement>> movements() async {
    final res = await _dio.get(Endpoints.inventoryMovements);
    final raw = res.data;
    final map = (raw is Map)
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};

    dynamic items;
    if (map.isNotEmpty) {
      final data = map['data'];
      items = (data is Map) ? data['data'] : data;
    } else {
      items = raw;
    }

    final list = (items is List) ? items : <dynamic>[];
    return list
        .whereType<Map>()
        .map((e) => InventoryMovement.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> adjustStock(AdjustStockRequest req) async {
    await _dio.post(Endpoints.inventoryAdjustments, data: req.toJson());
  }
}
