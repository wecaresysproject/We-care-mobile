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
          return ApiErrorModel(
            errors: [
              "Connection to the server failed due to internet connection"
            ],
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            errors: ["Receive timeout in connection with the server"],
          );
        case DioExceptionType.badResponse:
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
