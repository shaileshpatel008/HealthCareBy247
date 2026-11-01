import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';

/// Thin Dio wrapper — base URL and timeouts matching the RN axios client
/// (`timeout: 50000`). The API needs no auth header.
class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 50),
        // Booking/prescription uploads carry up to 5 photos.
        sendTimeout: const Duration(minutes: 3),
        headers: {'Accept': 'application/json'},
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    }
  }

  static final DioClient instance = DioClient._internal();
  late final Dio _dio;

  Dio get dio => _dio;
}
