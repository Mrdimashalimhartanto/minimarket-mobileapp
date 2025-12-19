import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minimarket/features/auth/presentation/providers/auth_controller.dart';
import 'package:minimarket/features/inventory/presentation/pages/inventory_page.dart';
import 'package:minimarket/features/products/presentation/pages/products_list_page.dart';
import 'package:minimarket/features/products/presentation/pages/product_form_page.dart';
import 'package:minimarket/features/products/presentation/providers/products_controller.dart';
import 'package:minimarket/features/purchase/presentation/pages/purchase_orders_page.dart';
import 'package:minimarket/features/suppliers/presentation/pages/suppliers_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int index = 0;

  final pages = const [
    ProductsListPage(),
    InventoryPage(),
    PurchaseOrdersPage(),
    SuppliersPage(),
  ];

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateProduct() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormPage()),
    );

    if (!mounted) return;
    if (saved == true || saved == null) {
      ref.read(productsControllerProvider.notifier).fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimarket POS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: pages[index],

      // ✅ FAB khusus tab Products
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: _openCreateProduct,
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Purchases',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Suppliers',
          ),
        ],
      ),
    );
  }
}
