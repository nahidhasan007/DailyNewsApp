import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio = Dio();
  ApiClient() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 10);
    _dio.options.receiveTimeout = Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': ApiConstants.apiKey,
    };

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      error: true
    ));
  }
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    }
    catch(e) {
      rethrow;
    }
  }
}