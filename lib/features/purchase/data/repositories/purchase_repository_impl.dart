import '../../domain/repositories/purchase_repository.dart';
import '../datasource/purchase_api.dart';
import '../models/purchase_order.dart';
import '../models/po_requests.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseApi api;
  PurchaseRepositoryImpl(this.api);

  @override
  Future<List<PurchaseOrder>> list({int page = 1}) => api.list(page: page);

  @override
  Future<PurchaseOrder> detail(int id) => api.detail(id);

  @override
  Future<PurchaseOrder> create(CreatePoRequest req) => api.create(req);

  @override
  Future<PurchaseOrder> update(int id, UpdatePoRequest req) =>
      api.update(id, req);

  @override
  Future<void> delete(int id) => api.delete(id);

  @override
  Future<PurchaseOrder> markOrdered(int id) => api.markOrdered(id);

  @override
  Future<PurchaseOrder> receive(int id) => api.receive(id);

  @override
  Future<PurchaseOrder> cancel(int id, {String? reason, String? note}) =>
      api.cancel(id, reason: reason, note: note);
}
