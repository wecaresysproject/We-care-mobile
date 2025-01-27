import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'Errors/server_exception.dart';
import 'app_interceptors.dart';
import 'status_code.dart';
import 'web_services.dart';

class DioWebServices implements WebServices {
  final Dio dio;

  DioWebServices({required this.dio}) {
    //*solve handCheck certificate exception
    final adapter = IOHttpClientAdapter();
    adapter.createHttpClient = () =>
        HttpClient(context: SecurityContext(withTrustedRoots: false))
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Accept all certificates

    dio.httpClientAdapter = adapter;
    dio.options
      // ..baseUrl = baseUrl
      ..contentType = 'application/json'
      ..followRedirects = true
      ..connectTimeout = const Duration(seconds: 20 * 1000)
      ..receiveTimeout = const Duration(seconds: 20 * 1000)
      ..receiveDataWhenStatusError = true
      // ..responseType = ResponseType.plain
      ..validateStatus = (status) => status! < StatusCode.internalServerError;

    dio.interceptors.add(getIt.get<DioInterceptor>()); 
    if (kDebugMode) {
      dio.interceptors.add(
        getIt.get<LogInterceptor>(),
      );
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future post(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.post(path);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.put(path);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future delete(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
