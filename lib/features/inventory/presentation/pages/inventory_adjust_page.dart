import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/adjust_stock_request.dart';
import '../providers/inventory_controller.dart';

class InventoryAdjustPage extends ConsumerStatefulWidget {
  const InventoryAdjustPage({super.key});

  @override
  ConsumerState<InventoryAdjustPage> createState() =>
      _InventoryAdjustPageState();
}

class _InventoryAdjustPageState extends ConsumerState<InventoryAdjustPage> {
  final _formKey = GlobalKey<FormState>();

  int? productId;
  int qty = 1;
  String type = 'in';
  String reason = 'correction';
  String note = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product ID'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib' : null,
                onChanged: (v) => productId = int.tryParse(v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Qty'),
                initialValue: '1',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Qty > 0' : null,
                onChanged: (v) => qty = int.tryParse(v) ?? 1,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'in', child: Text('IN')),
                  DropdownMenuItem(value: 'out', child: Text('OUT')),
                ],
                onChanged: (v) => setState(() => type = v ?? 'in'),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                initialValue: 'correction',
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib' : null,
                onChanged: (v) => reason = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Note (optional)'),
                onChanged: (v) => note = v,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state.loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (productId == null) return;

                        await ref
                            .read(inventoryControllerProvider.notifier)
                            .adjust(
                              AdjustStockRequest(
                                productId: productId!,
                                qty: qty,
                                type: type,
                                reason: reason,
                                note: note.isEmpty ? null : note,
                              ),
                            );

                        if (mounted) Navigator.pop(context);
                      },
                child: Text(state.loading ? 'Processing...' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
