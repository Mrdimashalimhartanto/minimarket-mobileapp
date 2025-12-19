import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supplier_detail_controller.dart';
import '../providers/supplier_controller.dart';
import 'supplier_form_page.dart';

class SupplierDetailPage extends ConsumerStatefulWidget {
  final int id;
  const SupplierDetailPage({super.key, required this.id});

  @override
  ConsumerState<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends ConsumerState<SupplierDetailPage> {
  bool acting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          ref.read(supplierDetailControllerProvider.notifier).fetch(widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierDetailControllerProvider);
    final s = state.data;

    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier #${widget.id}'),
        actions: [
          IconButton(
            onPressed: s == null
                ? null
                : () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupplierFormPage(editId: s.id),
                        ),
                      ).then(
                        (_) => ref
                            .read(supplierDetailControllerProvider.notifier)
                            .fetch(widget.id),
                      ),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: acting
                ? null
                : () async {
                    setState(() => acting = true);
                    try {
                      await ref
                          .read(supplierControllerProvider.notifier)
                          .remove(widget.id);
                      if (mounted) Navigator.pop(context);
                    } finally {
                      if (mounted) setState(() => acting = false);
                    }
                  },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
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
          if (s != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${s.email ?? '-'}'),
                    Text('Phone: ${s.phone ?? '-'}'),
                    Text('Address: ${s.address ?? '-'}'),
                    Text('Active: ${s.isActive ? "Yes" : "No"}'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
