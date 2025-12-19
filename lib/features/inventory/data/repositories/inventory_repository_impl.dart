import '../../domain/repositories/inventory_repository.dart';
import '../datasource/inventory_api.dart';
import '../models/stock_item.dart';
import '../models/inventory_movement.dart';
import '../models/adjust_stock_request.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryApi api;
  InventoryRepositoryImpl(this.api);

  @override
  Future<List<StockItem>> stockList() => api.stockList();

  @override
  Future<StockItem> stockShow(int id) => api.stockShow(id);

  @override
  Future<List<InventoryMovement>> movements() => api.movements();

  @override
  Future<void> adjustStock(AdjustStockRequest req) => api.adjustStock(req);
}
