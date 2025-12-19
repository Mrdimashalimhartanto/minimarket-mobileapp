import '../../data/models/supplier.dart';
import '../../data/models/supplier_requests.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> list({int page = 1});
  Future<Supplier> detail(int id);
  Future<Supplier> create(CreateSupplierRequest req);
  Future<Supplier> update(int id, UpdateSupplierRequest req);
  Future<void> delete(int id);
}
