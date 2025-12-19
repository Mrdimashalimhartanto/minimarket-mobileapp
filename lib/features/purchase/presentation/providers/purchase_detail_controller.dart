import 'package:flutter_riverpod/legacy.dart';
import '../../../../bootstrap/providers.dart';
import '../../data/models/purchase_order.dart';
import '../../domain/repositories/purchase_repository.dart';

class PurchaseDetailState {
  final bool loading;
  final String? error;
  final PurchaseOrder? data;

  const PurchaseDetailState({required this.loading, this.error, this.data});
  factory PurchaseDetailState.initial() =>
      const PurchaseDetailState(loading: false);

  PurchaseDetailState copyWith({
    bool? loading,
    String? error,
    PurchaseOrder? data,
  }) {
    return PurchaseDetailState(
      loading: loading ?? this.loading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class PurchaseDetailController extends StateNotifier<PurchaseDetailState> {
  PurchaseDetailController(this._repo) : super(PurchaseDetailState.initial());
  final PurchaseRepository _repo;

  Future<void> fetch(int id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final po = await _repo.detail(id);
      state = state.copyWith(loading: false, data: po, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> markOrdered(int id) async {
    await _repo.markOrdered(id);
    await fetch(id);
  }

  Future<void> receive(int id) async {
    await _repo.receive(id);
    await fetch(id);
  }

  Future<void> cancel(int id) async {
    await _repo.cancel(id);
    await fetch(id);
  }
}

final purchaseDetailControllerProvider =
    StateNotifierProvider<PurchaseDetailController, PurchaseDetailState>((ref) {
      final repo = ref.read(purchaseRepositoryProvider);
      return PurchaseDetailController(repo);
    });
