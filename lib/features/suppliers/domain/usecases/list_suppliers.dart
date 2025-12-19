import '../repositories/supplier_repository.dart';
import '../../data/models/supplier.dart';

class ListSuppliers {
  final SupplierRepository repo;
  ListSuppliers(this.repo);

  Future<List<Supplier>> call({int page = 1}) => repo.list(page: page);
}
