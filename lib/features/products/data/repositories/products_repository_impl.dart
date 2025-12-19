import 'dart:io';
import '../../domain/repositories/product_repository.dart';
import '../datasource/products_api.dart';
import '../models/product.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._api);
  final ProductsApi _api;

  @override
  Future<List<Product>> list() => _api.list();

  @override
  Future<Product> detail(int id) => _api.detail(id);

  @override
  Future<Product> create({
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
  }) {
    return _api.create(
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
  }

  @override
  Future<Product> update({
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
  }) {
    return _api.update(
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
  }

  @override
  Future<void> delete(int id) => _api.delete(id);
}
