import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/auth_api_service.dart';
import '../core/api/api_client.dart';
import '../core/models/auth_models.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final AuthApiService _authApi = AuthApiService();

  bool _isAuthenticated = false;
  String? _userRole;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _roles;
  bool _isRefreshing = false; // Prevent multiple simultaneous refresh attempts

  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;

  bool get isDriver => _roles?.contains('DRIVER') ?? false;
  bool get isRider => _roles?.contains('RIDER') ?? false;

  /// Initialize authentication state from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      _userRole = prefs.getString('userRole');
      _userId = prefs.getString('userId');
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      _userPhone = prefs.getString('userPhone');
      _roles = prefs.getString('roles');
      
      if (_isAuthenticated) {
        try {
          // Validate token by trying to get current user
          await _authApi.getCurrentUser();
        } catch (e) {
          debugPrint('Token validation failed: $e');
          // Try to refresh token before logging out
          try {
            await refreshAccessToken();
            debugPrint('Token successfully refreshed on startup');
          } catch (refreshError) {
            debugPrint('Token refresh failed on startup: $refreshError');
            await logout();
          }
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _authApi.login(username, password);
      
      await _saveUserData(response);
      
      // 🔥 Save both access and refresh tokens
      await ApiClient().setToken(response.token);
      
      // If API returns separate refresh token, save it
      // await ApiClient().setRefreshToken(response.refreshToken);
      
      // Add debugging
      final savedToken = await ApiClient().getToken();
      debugPrint('🔑 Access token saved: ${savedToken?.substring(0, 20)}...');

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String fullName,
    required String phone,
    required String email,
    required bool isDriver,
  }) async {
    try {
      final response = await _authApi.register(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
        phoneNumber: phone,
        isDriver: isDriver,
      );

      await _saveUserData(response);

      // Save tokens
      await ApiClient().setToken(response.token);
      // await ApiClient().setRefreshToken(response.refreshToken);

      notifyListeners();
      
      return {'success': true, 'message': 'Registration successful'};
    } catch (e) {
      debugPrint('Registration error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 🔄 Refresh access token using refresh token
  Future<void> refreshAccessToken() async {
    if (_isRefreshing) {
      debugPrint('Token refresh already in progress, skipping...');
      return;
    }

    _isRefreshing = true;
    
    try {
      debugPrint('🔄 Attempting to refresh access token...');
      
      // Get current refresh token
      final refreshToken = await ApiClient().getRefreshToken();
      
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Call refresh endpoint (you'll need to add this to AuthApiService)
      final response = await _authApi.refreshToken(refreshToken);
      
      // Save new tokens
      await ApiClient().setToken(response.token);
      // await ApiClient().setRefreshToken(response.refreshToken);
      
      debugPrint('✅ Access token refreshed successfully');
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      // If refresh fails, logout user
      await logout();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Handle 401 errors by attempting token refresh
  Future<void> handleUnauthorized() async {
    if (!_isAuthenticated) {
      return;
    }

    try {
      await refreshAccessToken();
    } catch (e) {
      debugPrint('Failed to refresh token on 401: $e');
      // User will be logged out by refreshAccessToken
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Clear all tokens from ApiClient
      await ApiClient().clearTokens();

      _isAuthenticated = false;
      _userRole = null;
      _userId = null;
      _userName = null;
      _userEmail = null;
      _userPhone = null;
      _roles = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  Future<UserInfo?> getUserInfo() async {
    try {
      return await _authApi.getCurrentUser();
    } catch (e) {
      debugPrint('Get user info error: $e');
      return null;
    }
  }

  String getHomeRoute() {
    if (!_isAuthenticated) return '/login-screen';
    return _userRole == 'driver' ? '/driver-home-screen' : '/rider-home-screen';
  }

  /// Helper method to save user data from LoginResponse
  Future<void> _saveUserData(LoginResponse response) async {
    _isAuthenticated = true;
    _userId = response.user.id;
    _userName = response.user.fullName;
    _userEmail = response.user.email;
    _userPhone = response.user.phoneNumber;
    _roles = response.user.roles;
    
    if (response.user.isDriver) {
      _userRole = 'driver';
    } else {
      _userRole = 'rider';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userRole', _userRole!);
    await prefs.setString('userId', _userId!);
    await prefs.setString('userName', _userName!);
    await prefs.setString('userEmail', _userEmail!);
    await prefs.setString('userPhone', _userPhone!);
    await prefs.setString('roles', _roles!);
  }
}