import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supplier_detail_controller.dart';
import '../../data/models/supplier_requests.dart';

class SupplierFormPage extends ConsumerStatefulWidget {
  final int? editId;
  const SupplierFormPage({super.key, this.editId});

  @override
  ConsumerState<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends ConsumerState<SupplierFormPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  bool isActive = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) {
      Future.microtask(() async {
        await ref
            .read(supplierDetailControllerProvider.notifier)
            .fetch(widget.editId!);
        final s = ref.read(supplierDetailControllerProvider).data;
        if (s != null && mounted) {
          nameCtrl.text = s.name;
          emailCtrl.text = s.email ?? '';
          phoneCtrl.text = s.phone ?? '';
          addressCtrl.text = s.address ?? '';
          setState(() => isActive = s.isActive);
        }
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (saving) return;
    if (nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name wajib diisi')));
      return;
    }

    setState(() => saving = true);
    try {
      final notifier = ref.read(supplierDetailControllerProvider.notifier);

      if (widget.editId == null) {
        await notifier.create(
          CreateSupplierRequest(
            name: nameCtrl.text.trim(),
            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
            phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
            address: addressCtrl.text.trim().isEmpty
                ? null
                : addressCtrl.text.trim(),
            isActive: isActive,
          ),
        );
      } else {
        await notifier.update(
          widget.editId!,
          UpdateSupplierRequest(
            name: nameCtrl.text.trim(),
            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
            phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
            address: addressCtrl.text.trim().isEmpty
                ? null
                : addressCtrl.text.trim(),
            isActive: isActive,
          ),
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Supplier' : 'Create Supplier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressCtrl,
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: isActive,
            onChanged: (v) => setState(() => isActive = v),
            title: const Text('Active'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: saving ? null : submit,
            child: Text(saving ? 'Saving...' : (isEdit ? 'Update' : 'Create')),
          ),
        ],
      ),
    );
  }
}
