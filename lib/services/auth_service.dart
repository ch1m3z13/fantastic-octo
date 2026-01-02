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
          await _authApi.getCurrentUser();
        } catch (e) {
          debugPrint('Token validation failed: $e');
          await logout();
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

      // 🔥 Save token to FlutterSecureStorage via ApiClient
      await ApiClient().setToken(response.token);
      
      // Add debugging
      final savedToken = await ApiClient().getToken();
      debugPrint('🔑 Token saved: ${savedToken?.substring(0, 20)}...');

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

      // Save token
      await ApiClient().setToken(response.token);

      notifyListeners();
      
      return {'success': true, 'message': 'Registration successful'};
    } catch (e) {
      debugPrint('Registration error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Clear token from ApiClient
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
}