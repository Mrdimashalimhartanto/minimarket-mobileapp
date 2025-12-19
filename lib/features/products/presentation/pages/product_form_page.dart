import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/product.dart';
import '../providers/products_controller.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key, this.editProduct});

  final Product? editProduct;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final categoryIdC = TextEditingController();
  final skuC = TextEditingController();
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final costC = TextEditingController();
  final sellC = TextEditingController();
  final stockC = TextEditingController();
  final minStockC = TextEditingController();

  String status = 'active';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    final p = widget.editProduct;
    if (p != null) {
      categoryIdC.text = p.categoryId.toString();
      skuC.text = p.sku;
      nameC.text = p.name;
      descC.text = p.description ?? '';
      costC.text = p.costPrice.toString();
      sellC.text = p.sellingPrice.toString();
      stockC.text = p.stock.toString();
      minStockC.text = p.minStock.toString();
      status = p.status;
    } else {
      categoryIdC.text = '1';
      stockC.text = '0';
      minStockC.text = '0';
      costC.text = '0';
      sellC.text = '0';
    }
  }

  @override
  void dispose() {
    categoryIdC.dispose();
    skuC.dispose();
    nameC.dispose();
    descC.dispose();
    costC.dispose();
    sellC.dispose();
    stockC.dispose();
    minStockC.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) setState(() => imageFile = File(x.path));
  }

  Future<void> submit() async {
    final categoryId = int.tryParse(categoryIdC.text.trim()) ?? 1;
    final sku = skuC.text.trim();
    final name = nameC.text.trim();
    final description = descC.text.trim();
    final cost = num.tryParse(costC.text.trim()) ?? 0;
    final sell = num.tryParse(sellC.text.trim()) ?? 0;
    final stock = int.tryParse(stockC.text.trim()) ?? 0;
    final minStock = int.tryParse(minStockC.text.trim()) ?? 0;

    if (sku.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('SKU dan Name wajib diisi')));
      return;
    }

    final ctrl = ref.read(productsControllerProvider.notifier);

    if (widget.editProduct == null) {
      await ctrl.create(
        categoryId: categoryId,
        sku: sku,
        name: name,
        description: description,
        costPrice: cost,
        sellingPrice: sell,
        stock: stock,
        minStock: minStock,
        status: status,
        imageFile: imageFile,
      );
    } else {
      await ctrl.update(
        id: widget.editProduct!.id,
        categoryId: categoryId,
        sku: sku,
        name: name,
        description: description,
        costPrice: cost,
        sellingPrice: sell,
        stock: stock,
        minStock: minStock,
        status: status,
        imageFile: imageFile,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editProduct != null;
    final state = ref.watch(productsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Create Product')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.loading) const LinearProgressIndicator(),
          if (state.error != null)
            Text(state.error!, style: const TextStyle(color: Colors.red)),

          TextField(
            controller: categoryIdC,
            decoration: const InputDecoration(labelText: 'Category ID'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: skuC,
            decoration: const InputDecoration(labelText: 'SKU'),
          ),
          TextField(
            controller: nameC,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: descC,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: costC,
            decoration: const InputDecoration(labelText: 'Cost Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: sellC,
            decoration: const InputDecoration(labelText: 'Selling Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: stockC,
            decoration: const InputDecoration(labelText: 'Stock'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: minStockC,
            decoration: const InputDecoration(labelText: 'Min Stock'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('active')),
              DropdownMenuItem(value: 'inactive', child: Text('inactive')),
            ],
            onChanged: (v) => setState(() => status = v ?? 'active'),
            decoration: const InputDecoration(labelText: 'Status'),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(imageFile == null ? 'Pick Image' : 'Change Image'),
              ),
              const SizedBox(width: 12),
              if (imageFile != null) Text(imageFile!.path.split('/').last),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: state.loading ? null : submit,
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ),
        ],
      ),
    );
  }
}
