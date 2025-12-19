import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supplier_controller.dart';
import 'supplier_form_page.dart';
import 'supplier_detail_page.dart';

class SuppliersPage extends ConsumerStatefulWidget {
  const SuppliersPage({super.key});

  @override
  ConsumerState<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends ConsumerState<SuppliersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(supplierControllerProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupplierFormPage()),
                ).then(
                  (_) => ref.read(supplierControllerProvider.notifier).fetch(),
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(supplierControllerProvider.notifier).fetch(),
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
            const SizedBox(height: 12),
            ...state.items.map(
              (s) => Card(
                child: ListTile(
                  title: Text(s.name),
                  subtitle: Text('${s.phone ?? '-'} • ${s.email ?? '-'}'),
                  trailing: Icon(
                    s.isActive ? Icons.check_circle : Icons.cancel,
                    color: s.isActive ? Colors.green : Colors.grey,
                  ),
                  onTap: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupplierDetailPage(id: s.id),
                        ),
                      ).then(
                        (_) => ref
                            .read(supplierControllerProvider.notifier)
                            .fetch(),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
