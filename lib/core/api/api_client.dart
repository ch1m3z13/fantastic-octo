import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'api_config.dart';

/// API client for making HTTP requests to the backend
/// Handles authentication, token management, and error handling
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _initializeDio();
  }

  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  Dio get dio => _dio;

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.getBaseUrl(),
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => _logger.d(obj),
        ),
      );
    }
  }

  /// Request interceptor - adds auth token to headers
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get token from secure storage
      final token = await _storage.read(key: ApiConfig.tokenKey);

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
      handler.next(options);
    } catch (e) {
      _logger.e('Error in request interceptor: $e');
      handler.next(options);
    }
  }

  /// Response interceptor - handles successful responses
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  /// Error interceptor - handles errors and token refresh
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    _logger.e('ERROR MESSAGE: ${err.message}');

    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      _logger.w('Token expired or invalid - attempting refresh');
      
      // Try to refresh token
      // final refreshed = await _refreshToken();
      
      // if (refreshed) {
      //   // Retry the original request
      //   return handler.resolve(await _retry(err.requestOptions));
      // } else {
      //   // Refresh failed - logout user
      //   await _clearTokens();
      //   // Navigate to login screen (implement via callback or event bus)
      // }
    }

    handler.next(err);
  }

  /// Retry a failed request with new token
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Store authentication token
  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: ApiConfig.tokenKey, value: token);
      _logger.i('Token stored successfully');
    } catch (e) {
      _logger.e('Error storing token: $e');
    }
  }

  /// Get current authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: ApiConfig.tokenKey);
    } catch (e) {
      _logger.e('Error reading token: $e');
      return null;
    }
  }

  /// Clear all stored tokens
  Future<void> _clearTokens() async {
    try {
      await _storage.delete(key: ApiConfig.tokenKey);
      await _storage.delete(key: ApiConfig.refreshTokenKey);
      _logger.i('Tokens cleared');
    } catch (e) {
      _logger.e('Error clearing tokens: $e');
    }
  }

  /// Clear all tokens (public method for logout)
  Future<void> clearTokens() async {
    await _clearTokens();
  }

  // Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}