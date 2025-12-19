import 'package:dio/dio.dart';
import 'package:minimarket/core/errors/api_exception.dart';

import '../../bootstrap/env.dart' show Env;

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Dio get dio => _dio;

  static Dio buildDio({required Interceptor authInterceptor}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: Env.connectTimeout,
        receiveTimeout: Env.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          final status = e.response?.statusCode;
          final data = e.response?.data;

          String message = 'Terjadi kesalahan';
          if (data is Map && data['message'] is String) {
            message = data['message'];
          } else if (e.message != null) {
            message = e.message!;
          }

          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: ApiException(message, statusCode: status),
            ),
          );
        },
      ),
    );

    return dio;
  }
}