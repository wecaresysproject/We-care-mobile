import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/networking/api_error_handler.dart';

import '../Database/cach_helper.dart';
import 'auth_api_constants.dart';

class DioServices {
  /// private constructor as I don't want to allow creating an instance of this class
  DioServices._();

  static Dio? dio;

  /// Cancel token to cancel requests
  static CancelToken cancelToken = CancelToken();

  static Dio getDio() {
    //*solve handCheck certificate exception
    final adapter = IOHttpClientAdapter();
    adapter.createHttpClient = () =>
        HttpClient(context: SecurityContext(withTrustedRoots: false))
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Accept all certificates

    Duration timeOut = const Duration(seconds: 100);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders(); //TODO: check it later
      addDioInterceptor();
      addCancelableInterceptor();
      addRetryInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addRetryInterceptor() {
    dio!.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 500) {
            // Retry logic
            final RequestOptions options = error.requestOptions;
            AppLogger.debug('Retrying...');
            final response = await dio!.fetch(options);
            return handler.resolve(response); // Return the new response
          }
          return handler.next(error); // Propagate error if no retry
        },
      ),
    );
  }

  static void addCancelableInterceptor() async {
    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.cancelToken = cancelToken;
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          ApiErrorHandler.handle(e);

          return handler.next(e);
        },
      ),
    );
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${await CacheHelper.getSecuredString(AuthApiConstants.userTokenKey)}',
    };
  }

  //TODO: use it later after getting token from login response in cubit in case of success
  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }

  static String getUserToken() {
    return dio?.options.headers['Authorization'];
  }

  static void addDioInterceptor() {
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }

  // This method allows cancellation of requests
  static void cancelRequests([String? reason]) {
    cancelToken.cancel(reason); // Cancel all requests with this token
    cancelToken = CancelToken(); // reset after cancellation
  }
}
