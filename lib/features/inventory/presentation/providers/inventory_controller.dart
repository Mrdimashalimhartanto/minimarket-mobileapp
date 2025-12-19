import 'package:flutter_riverpod/legacy.dart';
import '../../../../bootstrap/providers.dart';
import '../../data/models/stock_item.dart';
import '../../data/models/adjust_stock_request.dart';
import '../../domain/repositories/inventory_repository.dart';

// ini provider repo lu bikin di bootstrap/providers.dart
// final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) => ...);

class InventoryState {
  final bool loading;
  final String? error;
  final List<StockItem> items;

  const InventoryState({
    required this.loading,
    this.error,
    required this.items,
  });

  factory InventoryState.initial() =>
      const InventoryState(loading: false, error: null, items: []);

  InventoryState copyWith({
    bool? loading,
    String? error,
    List<StockItem>? items,
  }) {
    return InventoryState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
    );
  }
}

class InventoryController extends StateNotifier<InventoryState> {
  InventoryController(this._repo) : super(InventoryState.initial());

  final InventoryRepository _repo;

  Future<void> fetch() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.stockList();
      state = state.copyWith(loading: false, items: items, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> adjust(AdjustStockRequest req) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.adjustStock(req);
      await fetch();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, InventoryState>((ref) {
      final repo = ref.read(inventoryRepositoryProvider);
      return InventoryController(repo);
    });
