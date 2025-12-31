import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/auth_models.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Service for handling authentication API calls
class AuthApiService {
  final ApiClient _apiClient = ApiClient();
  final _logger = Logger();

  /// Login user with username and password
  /// Returns LoginResponse on success, throws ApiException on failure
  Future<LoginResponse> login(String username, String password) async {
    try {
      final request = LoginRequest(
        username: username,
        password: password,
      );

      _logger.i('Attempting login for user: $username');

      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Store the token
        await _apiClient.setToken(loginResponse.token);
        
        _logger.i('Login successful for user: $username');
        return loginResponse;
      } else {
        throw ApiException(
          'Login failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Login error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected login error: $e');
      throw ApiException('An unexpected error occurred during login');
    }
  }

  /// Register new user
  /// Returns RegisterResponse on success, throws ApiException on failure
  Future<RegisterResponse> register({
    required String username,
    required String password,
    required String fullName,
    required String email,
    required String phoneNumber,
    bool isDriver = false,
  }) async {
    try {
      final request = RegisterRequest(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        isDriver: isDriver,
      );

      _logger.i('Attempting registration for user: $username');

      final response = await _apiClient.post(
        ApiConfig.registerEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        
        // Store the token
        await _apiClient.setToken(registerResponse.token);
        
        _logger.i('Registration successful for user: $username');
        return registerResponse;
      } else {
        throw ApiException(
          'Registration failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Registration error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected registration error: $e');
      throw ApiException('An unexpected error occurred during registration');
    }
  }

  /// Get current user information
  Future<UserInfo> getCurrentUser() async {
    try {
      _logger.i('Fetching current user information');

      final response = await _apiClient.get(ApiConfig.getUserEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        return UserInfo.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to get user info with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get user error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get user error: $e');
      throw ApiException('An unexpected error occurred while fetching user info');
    }
  }

  /// Logout user (clear local tokens)
  Future<void> logout() async {
    try {
      _logger.i('Logging out user');
      await _apiClient.clearTokens();
    } catch (e) {
      _logger.e('Logout error: $e');
      throw ApiException('An error occurred during logout');
    }
  }

  /// Handle Dio errors and convert to ApiException
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 
                       error.response?.data?['error'] ??
                       'An error occurred';
        
        if (statusCode == 401) {
          return ApiException('Invalid credentials', statusCode: 401);
        } else if (statusCode == 409) {
          return ApiException('Username already exists', statusCode: 409);
        } else if (statusCode == 400) {
          return ApiException(message, statusCode: 400);
        }
        
        return ApiException(
          message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection. Please check your network settings.',
        );

      default:
        return ApiException(
          'An unexpected error occurred: ${error.message}',
        );
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}