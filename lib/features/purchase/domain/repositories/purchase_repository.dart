import '../../data/models/purchase_order.dart';
import '../../data/models/po_requests.dart';

abstract class PurchaseRepository {
  Future<List<PurchaseOrder>> list({int page = 1});
  Future<PurchaseOrder> detail(int id);
  Future<PurchaseOrder> create(CreatePoRequest req);
  Future<PurchaseOrder> update(int id, UpdatePoRequest req);
  Future<void> delete(int id);
  Future<PurchaseOrder> markOrdered(int id);
  Future<PurchaseOrder> receive(int id);
  Future<PurchaseOrder> cancel(int id, {String? reason, String? note});
}
