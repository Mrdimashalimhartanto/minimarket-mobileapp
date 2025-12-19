import 'package:flutter_riverpod/legacy.dart';
import '../../../../bootstrap/providers.dart';
import '../../data/models/purchase_order.dart';
import '../../domain/repositories/purchase_repository.dart';

class PurchaseState {
  final bool loading;
  final String? error;
  final List<PurchaseOrder> items;

  const PurchaseState({required this.loading, this.error, required this.items});
  factory PurchaseState.initial() =>
      const PurchaseState(loading: false, items: []);

  PurchaseState copyWith({
    bool? loading,
    String? error,
    List<PurchaseOrder>? items,
  }) {
    return PurchaseState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
    );
  }
}

class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController(this._repo) : super(PurchaseState.initial());
  final PurchaseRepository _repo;

  Future<void> fetch() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.list();
      state = state.copyWith(loading: false, items: items, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> remove(int id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.delete(id);
      await fetch();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>((ref) {
      final repo = ref.read(purchaseRepositoryProvider);
      return PurchaseController(repo);
    });
