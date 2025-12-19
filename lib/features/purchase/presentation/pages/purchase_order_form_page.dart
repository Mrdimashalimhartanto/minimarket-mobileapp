import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/po_requests.dart';
import '../../data/models/purchase_order_item.dart';
import '../../../../bootstrap/providers.dart';

class PurchaseOrderFormPage extends ConsumerStatefulWidget {
  final int? editId;
  const PurchaseOrderFormPage({super.key, this.editId});

  @override
  ConsumerState<PurchaseOrderFormPage> createState() =>
      _PurchaseOrderFormPageState();
}

class _PurchaseOrderFormPageState extends ConsumerState<PurchaseOrderFormPage> {
  final _formKey = GlobalKey<FormState>();

  int supplierId = 1;
  int productId = 1;
  int qty = 1;
  num unitCost = 1000;

  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(purchaseRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editId == null ? 'Create PO' : 'Update PO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Supplier ID'),
                initialValue: '$supplierId',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Supplier ID wajib > 0';
                  return null;
                },
                onChanged: (v) => supplierId = int.tryParse(v) ?? 1,
              ),

              const Divider(height: 32),

              const Text(
                'Item (minimal dulu)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Product ID'),
                initialValue: '$productId',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Product ID wajib > 0';
                  return null;
                },
                onChanged: (v) => productId = int.tryParse(v) ?? 1,
              ),

              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Qty'),
                initialValue: '$qty',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Qty wajib > 0';
                  return null;
                },
                onChanged: (v) => qty = int.tryParse(v) ?? 1,
              ),

              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Unit Cost'),
                initialValue: '$unitCost',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = num.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Unit Cost wajib > 0';
                  return null;
                },
                onChanged: (v) => unitCost = num.tryParse(v) ?? 1000,
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: submitting
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => submitting = true);
                        try {
                          // ✅ backend butuh items.*.quantity_ordered & items.*.unit_cost
                          // itu di-handle di PurchaseOrderItem.toJson()
                          final item = PurchaseOrderItem(
                            productId: productId,
                            qty: qty,
                            unitCost: unitCost,
                          );

                          if (widget.editId == null) {
                            final req = CreatePoRequest(
                              supplierId: supplierId,
                              items: [item],
                            );
                            await repo.create(req);
                          } else {
                            final req = UpdatePoRequest(
                              supplierId: supplierId,
                              items: [item],
                            );
                            await repo.update(widget.editId!, req);
                          }

                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal submit: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => submitting = false);
                        }
                      },
                child: Text(submitting ? 'Processing...' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
