import 'package:flutter_riverpod/legacy.dart';
import '../../../../bootstrap/providers.dart';
import '../../data/models/inventory_movement.dart';
import '../../domain/repositories/inventory_repository.dart';

class MovementsState {
  final bool loading;
  final String? error;
  final List<InventoryMovement> items;

  const MovementsState({
    required this.loading,
    this.error,
    required this.items,
  });
  factory MovementsState.initial() =>
      const MovementsState(loading: false, items: []);

  MovementsState copyWith({
    bool? loading,
    String? error,
    List<InventoryMovement>? items,
  }) {
    return MovementsState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
    );
  }
}

class InventoryMovementsController extends StateNotifier<MovementsState> {
  InventoryMovementsController(this._repo) : super(MovementsState.initial());

  final InventoryRepository _repo;

  Future<void> fetch() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.movements();
      state = state.copyWith(loading: false, items: items, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final inventoryMovementsControllerProvider =
    StateNotifierProvider<InventoryMovementsController, MovementsState>((ref) {
      final repo = ref.read(inventoryRepositoryProvider);
      return InventoryMovementsController(repo);
    });
