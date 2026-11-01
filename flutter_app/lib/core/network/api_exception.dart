import 'package:dio/dio.dart';

/// One error type for the UI to show — a plain sentence, never a stack
/// trace or status code, so it can go straight into an error dialog.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  /// Maps Dio failures to messages a patient can act on.
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('The lab’s server is taking too long to answer. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException('We couldn’t reach the lab’s server. Check your internet connection and try again.');
      case DioExceptionType.badResponse:
        return ApiException('The lab’s server had a problem (${e.response?.statusCode}). Please try again in a moment.');
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
