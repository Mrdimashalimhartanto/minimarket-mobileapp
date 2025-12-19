import '../../domain/repositories/supplier_repository.dart';
import '../datasource/supplier_api.dart';
import '../models/supplier.dart';
import '../models/supplier_requests.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierApi api;
  SupplierRepositoryImpl(this.api);

  @override
  Future<List<Supplier>> list({int page = 1}) => api.list(page: page);

  @override
  Future<Supplier> detail(int id) => api.detail(id);

  @override
  Future<Supplier> create(CreateSupplierRequest req) => api.create(req);

  @override
  Future<Supplier> update(int id, UpdateSupplierRequest req) =>
      api.update(id, req);

  @override
  Future<void> delete(int id) => api.delete(id);
}
