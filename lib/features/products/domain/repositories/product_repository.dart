import 'dart:io';
import '../../data/models/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> list();
  Future<Product> detail(int id);

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
  });

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
  });

  Future<void> delete(int id);
}
