import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minimarket/bootstrap/env.dart';
import 'package:minimarket/features/auth/data/datasource/auth_api.dart';
import 'package:minimarket/features/auth/data/datasource/google_sign_in_service.dart';
import 'package:minimarket/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minimarket/features/auth/domain/repositories/auth_repository.dart';
import 'package:minimarket/features/inventory/data/datasource/inventory_api.dart';
import 'package:minimarket/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:minimarket/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:minimarket/features/purchase/data/datasource/purchase_api.dart';
import 'package:minimarket/features/purchase/data/repositories/purchase_repository_impl.dart';
import 'package:minimarket/features/purchase/domain/repositories/purchase_repository.dart';
import 'package:minimarket/features/suppliers/data/datasource/supplier_api.dart';
import 'package:minimarket/features/suppliers/data/repositories/supplier_repository_impl.dart';
import 'package:minimarket/features/suppliers/domain/repositories/supplier_repository.dart';

import '../core/network/dio_client.dart';
import '../core/network/dio_interceptors.dart';
import '../core/storage/secure_storage.dart';

// storage
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(ref.watch(flutterSecureStorageProvider));
});

// dio
final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final authInterceptor = AuthInterceptor(storage);

  return DioClient.buildDio(authInterceptor: authInterceptor);
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(dioProvider));
});

final inventoryApiProvider = Provider<InventoryApi>((ref) {
  final dio = ref.read(dioProvider);
  return InventoryApi(dio);
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final api = ref.read(inventoryApiProvider);
  return InventoryRepositoryImpl(api);
});

final purchaseApiProvider = Provider<PurchaseApi>((ref) {
  final dio = ref.read(dioProvider);
  return PurchaseApi(dio);
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  final api = ref.read(purchaseApiProvider);
  return PurchaseRepositoryImpl(api);
});

final supplierApiProvider = Provider<SupplierApi>((ref) {
  final dio = ref.read(dioProvider);
  return SupplierApi(dio);
});

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  final api = ref.read(supplierApiProvider);
  return SupplierRepositoryImpl(api);
});

// 1) Google SignIn service
final googleSignInServiceProvider = Provider<GoogleSignInService>((ref) {
  return GoogleSignInService(webClientId: Env.googleWebClientId);
});

// 2) Auth API
final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.read(dioProvider); 
  return AuthApi(dio);
});

// 3) Auth repo
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthRepositoryImpl(api, storage);
});
