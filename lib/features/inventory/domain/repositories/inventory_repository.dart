import '../../data/models/stock_item.dart';
import '../../data/models/inventory_movement.dart';
import '../../data/models/adjust_stock_request.dart';

abstract class InventoryRepository {
  Future<List<StockItem>> stockList();
  Future<StockItem> stockShow(int id);
  Future<List<InventoryMovement>> movements();
  Future<void> adjustStock(AdjustStockRequest req);
}
