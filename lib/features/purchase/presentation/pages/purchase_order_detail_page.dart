import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/purchase_detail_controller.dart';

class PurchaseOrderDetailPage extends ConsumerStatefulWidget {
  final int poId;
  const PurchaseOrderDetailPage({super.key, required this.poId});

  @override
  ConsumerState<PurchaseOrderDetailPage> createState() =>
      _PurchaseOrderDetailPageState();
}

class _PurchaseOrderDetailPageState
    extends ConsumerState<PurchaseOrderDetailPage> {
  bool acting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(purchaseDetailControllerProvider.notifier).fetch(widget.poId);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (acting) return;
    setState(() => acting = true);
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(purchaseDetailControllerProvider);
    final po = state.data;

    final status = (po?.status ?? '').toLowerCase();
    final canMarkOrdered = po != null && status == 'draft';
    final canReceive = po != null && status == 'ordered';
    final canCancel = po != null && (status == 'draft' || status == 'ordered');

    return Scaffold(
      appBar: AppBar(title: Text('Detail PO #${widget.poId}')),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(purchaseDetailControllerProvider.notifier)
            .fetch(widget.poId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            if (po == null && !state.loading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: Text('Data PO tidak ditemukan')),
              ),

            if (po != null) ...[
              // Header info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        po.code.isEmpty ? 'PO #${po.id}' : po.code,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Status: ${po.status}'),
                      Text('Supplier ID: ${po.supplierId}'),
                      Text('Total: ${po.totalAmount}'),
                      if (po.orderedAt != null)
                        Text('Ordered at: ${po.orderedAt}'),
                      if (po.receivedAt != null)
                        Text('Received at: ${po.receivedAt}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (po.items.isEmpty)
                const Text('Belum ada item.')
              else
                ...po.items.map(
                  (it) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Product #${it.productId}'),
                    subtitle: Text('Qty: ${it.qty}'),
                    trailing: Text('Unit Cost: ${it.unitCost}'),
                  ),
                ),

              const SizedBox(height: 16),

              // Actions
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: (!canMarkOrdered || acting)
                        ? null
                        : () => _run(
                            () => ref
                                .read(purchaseDetailControllerProvider.notifier)
                                .markOrdered(widget.poId),
                          ),
                    child: Text(acting ? '...' : 'Mark Ordered'),
                  ),
                  ElevatedButton(
                    onPressed: (!canReceive || acting)
                        ? null
                        : () => _run(
                            () => ref
                                .read(purchaseDetailControllerProvider.notifier)
                                .receive(widget.poId),
                          ),
                    child: Text(acting ? '...' : 'Receive'),
                  ),
                  OutlinedButton(
                    onPressed: (!canCancel || acting)
                        ? null
                        : () => _run(
                            () => ref
                                .read(purchaseDetailControllerProvider.notifier)
                                .cancel(widget.poId),
                          ),
                    child: Text(acting ? '...' : 'Cancel'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
