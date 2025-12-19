import 'package:flutter_riverpod/legacy.dart';
import '../../../../bootstrap/providers.dart';
import '../../data/models/supplier.dart';

class SupplierState {
  final bool loading;
  final String? error;
  final List<Supplier> items;

  const SupplierState({
    this.loading = false,
    this.error,
    this.items = const [],
  });

  SupplierState copyWith({
    bool? loading,
    String? error,
    List<Supplier>? items,
  }) => SupplierState(
    loading: loading ?? this.loading,
    error: error,
    items: items ?? this.items,
  );
}

final supplierControllerProvider =
    StateNotifierProvider<SupplierController, SupplierState>((ref) {
      final repo = ref.read(supplierRepositoryProvider);
      return SupplierController(repo);
    });

class SupplierController extends StateNotifier<SupplierState> {
  SupplierController(this._repo) : super(const SupplierState());

  final dynamic _repo; // SupplierRepository

  Future<void> fetch({int page = 1}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.list(page: page);
      state = state.copyWith(loading: false, items: items);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    state = state.copyWith(
      items: state.items.where((e) => e.id != id).toList(),
    );
  }
}
