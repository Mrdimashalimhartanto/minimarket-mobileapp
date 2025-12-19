import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_movements_controller.dart';

class InventoryMovementsPage extends ConsumerStatefulWidget {
  const InventoryMovementsPage({super.key});

  @override
  ConsumerState<InventoryMovementsPage> createState() =>
      _InventoryMovementsPageState();
}

class _InventoryMovementsPageState
    extends ConsumerState<InventoryMovementsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(inventoryMovementsControllerProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryMovementsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Movements')),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(inventoryMovementsControllerProvider.notifier).fetch(),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ...state.items.map(
              (m) => ListTile(
                title: Text('${m.type.toUpperCase()} • Qty: ${m.qty}'),
                subtitle: Text('Product: ${m.productId} • ${m.reason}'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
