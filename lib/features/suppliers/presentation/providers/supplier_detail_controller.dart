import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/supplier.dart';
import '../../data/models/supplier_requests.dart';
import '../../../../bootstrap/providers.dart';

class SupplierDetailState {
  final bool loading;
  final String? error;
  final Supplier? data;

  const SupplierDetailState({this.loading = false, this.error, this.data});

  SupplierDetailState copyWith({
    bool? loading,
    String? error,
    Supplier? data,
  }) => SupplierDetailState(
    loading: loading ?? this.loading,
    error: error,
    data: data ?? this.data,
  );
}

final supplierDetailControllerProvider =
    StateNotifierProvider<SupplierDetailController, SupplierDetailState>((ref) {
      final repo = ref.read(supplierRepositoryProvider);
      return SupplierDetailController(repo);
    });

class SupplierDetailController extends StateNotifier<SupplierDetailState> {
  SupplierDetailController(this._repo) : super(const SupplierDetailState());
  final dynamic _repo;

  Future<void> fetch(int id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _repo.detail(id);
      state = state.copyWith(loading: false, data: data);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<Supplier> create(CreateSupplierRequest req) async {
    final created = await _repo.create(req);
    state = state.copyWith(data: created);
    return created;
  }

  Future<Supplier> update(int id, UpdateSupplierRequest req) async {
    final updated = await _repo.update(id, req);
    state = state.copyWith(data: updated);
    return updated;
  }
}
