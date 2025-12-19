import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimarket/bootstrap/providers.dart';
import '../../data/datasource/products_api.dart';
import '../../data/models/product.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

class ProductsState {
  final bool loading;
  final String? error;
  final List<Product> items;

  const ProductsState({
    this.loading = false,
    this.error,
    this.items = const [],
  });

  ProductsState copyWith({bool? loading, String? error, List<Product>? items}) {
    return ProductsState(
      loading: loading ?? this.loading,
      error: error,
      items: items ?? this.items,
    );
  }
}

final productsApiProvider = Provider<ProductsApi>((ref) {
  final dio = ref.watch(dioProvider); // ✅ Bearer interceptor already attached
  return ProductsApi(dio);
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(ref.watch(productsApiProvider));
});

class ProductsController extends Notifier<ProductsState> {
  @override
  ProductsState build() => const ProductsState();

  ProductsRepository get _repo => ref.read(productsRepositoryProvider);

  Future<void> fetch() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _repo.list();
      state = state.copyWith(loading: false, items: items);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> create({
    required int categoryId,
    required String sku,
    required String name,
    String? description,
    required num costPrice,
    required num sellingPrice,
    required int stock,
    required int minStock,
    required String status,
    File? imageFile,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.create(
        categoryId: categoryId,
        sku: sku,
        name: name,
        description: description,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        stock: stock,
        minStock: minStock,
        status: status,
        imageFile: imageFile,
      );
      await fetch();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> update({
    required int id,
    required int categoryId,
    required String sku,
    required String name,
    String? description,
    required num costPrice,
    required num sellingPrice,
    required int stock,
    required int minStock,
    required String status,
    File? imageFile,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.update(
        id: id,
        categoryId: categoryId,
        sku: sku,
        name: name,
        description: description,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        stock: stock,
        minStock: minStock,
        status: status,
        imageFile: imageFile,
      );
      await fetch();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> remove(int id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _repo.delete(id);
      await fetch();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final productsControllerProvider =
    NotifierProvider<ProductsController, ProductsState>(
      () => ProductsController(),
    );
