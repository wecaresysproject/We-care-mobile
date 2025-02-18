import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../Database/cach_helper.dart';
import 'auth_api_constants.dart';

class DioServices {
  /// private constructor as I don't want to allow creating an instance of this class
  DioServices._();

  static Dio? dio;

  static Dio getDio() {
    //*solve handCheck certificate exception
    final adapter = IOHttpClientAdapter();
    adapter.createHttpClient = () =>
        HttpClient(context: SecurityContext(withTrustedRoots: false))
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Accept all certificates

    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders(); //TODO: check it later
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
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
}
