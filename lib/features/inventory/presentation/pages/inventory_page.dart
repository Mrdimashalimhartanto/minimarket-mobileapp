import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_controller.dart';
import 'inventory_adjust_page.dart';
import 'inventory_movements_page.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(inventoryControllerProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryMovementsPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InventoryAdjustPage()),
          );
          if (mounted) ref.read(inventoryControllerProvider.notifier).fetch();
        },
        child: const Icon(Icons.tune),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(inventoryControllerProvider.notifier).fetch(),
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
            if (!state.loading && state.error == null && state.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Stock masih kosong')),
              ),
            ...state.items.map(
              (s) => ListTile(
                key: ValueKey(s.productId),
                title: Text(s.name),
                subtitle: Text('SKU: ${s.sku} • Min: ${s.minStock}'),
                trailing: Text('Stock: ${s.stock}'),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
