import 'dart:io';

import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(errors: ["Connection to server failed"]);

        case DioExceptionType.cancel:
          return ApiErrorModel(errors: ["Request was cancelled"]);

        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(errors: ["Connection timeout with the server"]);

        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(errors: ["Receive timeout with the server"]);

        case DioExceptionType.sendTimeout:
          return ApiErrorModel(errors: ["Send timeout with the server"]);

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return ApiErrorModel(errors: ["No internet connection"]);
          }
          return ApiErrorModel(errors: ["Unexpected error, please try again"]);

        case DioExceptionType.badResponse:
          return _handleBadResponse(error);

        default:
          return ApiErrorModel(errors: ["Something went wrong"]);
      }
    }

    return ApiErrorModel(errors: ["Unknown error, please try again later"]);
  }

  // ✅ كل منطق الـ badResponse في مكان واحد
  static ApiErrorModel _handleBadResponse(DioException error) {
    final data = error.response?.data;
    final statusCode = error.response?.statusCode ?? 0;

    // أول حاجة: جرب تعمل parse للـ body اللي جه من الـ API
    if (data is Map<String, dynamic>) {
      return _parseErrorBody(data);
    }

    // لو مفيش body صالح: fallback حسب الـ status code
    return _fallbackError(statusCode);
  }

  // ✅ parse الـ body الجاي من الـ API
  static ApiErrorModel _parseErrorBody(Map<String, dynamic> data) {
    try {
      return ApiErrorModel.fromJson(data);
    } catch (_) {
      return ApiErrorModel(errors: ["Unexpected server response format"]);
    }
  }

  // ✅ fallback لو الـ API مبعتش body صالح
  static ApiErrorModel _fallbackError(int statusCode) {
    switch (statusCode) {
      case 400:
        return ApiErrorModel(errors: ["Bad request"]);
      case 401:
        return ApiErrorModel(errors: ["Unauthorized, please login again"]);
      case 403:
        return ApiErrorModel(errors: ["You don't have permission"]);
      case 404:
        return ApiErrorModel(errors: ["Resource not found"]);
      case 422:
        return ApiErrorModel(errors: ["Validation error"]);
      case 500:
        return ApiErrorModel(errors: ["Server error, please try again later"]);
      case >= 502 && <= 504:
        return ApiErrorModel(errors: [
          "Server is temporarily unavailable, please try again later"
        ]);
      default:
        return ApiErrorModel(errors: [
          "Status code: $statusCode Unexpected error, please try again",
        ]);
    }
  }
}
