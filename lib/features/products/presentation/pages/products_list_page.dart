import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_controller.dart';
import 'product_form_page.dart';

class ProductsListPage extends ConsumerStatefulWidget {
  const ProductsListPage({super.key});

  @override
  ConsumerState<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends ConsumerState<ProductsListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(productsControllerProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsControllerProvider);

    // ✅ Body-only widget (biar gak nested Scaffold)
    return RefreshIndicator(
      onRefresh: () => ref.read(productsControllerProvider.notifier).fetch(),
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
              child: Center(child: Text('Produk masih kosong')),
            ),

          ...state.items.map(
            (p) => ListTile(
              key: ValueKey(p.id),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: () {
                    final imgUrl = p.imageUrl;
                    if (imgUrl == null || imgUrl.isEmpty) {
                      return Container(
                        color: Colors.black12,
                        child: const Icon(Icons.inventory_2_outlined),
                      );
                    }

                    return Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black12,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    );
                  }(),
                ),
              ),
              title: Text(p.name),
              subtitle: Text('SKU: ${p.sku} • Stock: ${p.stock}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Hapus Product'),
                      content: Text('Yakin hapus "${p.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );

                  if (ok == true) {
                    await ref
                        .read(productsControllerProvider.notifier)
                        .remove(p.id);
                  }
                },
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductFormPage(editProduct: p),
                  ),
                );
                if (mounted)
                  ref.read(productsControllerProvider.notifier).fetch();
              },
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
