import 'dart:io';

import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            errors: ["Connection to server failed"],
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            errors: ["Request to the server was cancelled"],
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            errors: ["Connection timeout with the server"],
          );
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return ApiErrorModel(errors: ["No internet connection"]);
          }
          return ApiErrorModel(errors: [
            "Something went wrong while connecting to the server. Please try again."
          ]);

        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            errors: ["Receive timeout in connection with the server"],
          );
        case DioExceptionType.badResponse
            when error.response?.statusCode == 401 ||
                error.response?.statusCode == 403:
          return _handleError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            errors: ["Send timeout in connection with the server"],
          );

        default:
          return ApiErrorModel(
            errors: ["Something went wrong"],
          );
      }
    } else {
      return ApiErrorModel(
        errors: ["Unknown error occurred , please try again later"],
      );
    }
  }

  static ApiErrorModel _handleError(dynamic data) {
    // Assuming the API response structure matches the ApiErrorModel
    if (data is Map<String, dynamic>) {
      return ApiErrorModel.fromJson(data);
    } else {
      return ApiErrorModel(
        errors: [
          "Unexpected server response format. Please try again later.",
        ],
      );
    }
  }
}
