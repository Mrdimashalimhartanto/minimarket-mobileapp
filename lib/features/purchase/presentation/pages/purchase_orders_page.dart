import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/purchase_controller.dart';
import 'purchase_order_detail_page.dart';
import 'purchase_order_form_page.dart';

class PurchaseOrdersPage extends ConsumerStatefulWidget {
  const PurchaseOrdersPage({super.key});

  @override
  ConsumerState<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends ConsumerState<PurchaseOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(purchaseControllerProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(purchaseControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Orders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PurchaseOrderFormPage()),
          );
          if (mounted) ref.read(purchaseControllerProvider.notifier).fetch();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(purchaseControllerProvider.notifier).fetch(),
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
              (po) => ListTile(
                key: ValueKey(po.id),
                title: Text('PO #${po.id} • ${po.status}'),
                subtitle: Text(
                  'Supplier: ${po.supplierId} • Items: ${po.items.length}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref
                      .read(purchaseControllerProvider.notifier)
                      .remove(po.id),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PurchaseOrderDetailPage(poId: po.id),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
