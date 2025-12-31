import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/auth_api_service.dart';
import '../core/models/auth_models.dart';

/// Authentication service to manage user login state
/// Now uses real API calls instead of mock data
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final AuthApiService _authApi = AuthApiService();

  bool _isAuthenticated = false;
  String? _userRole; // 'driver' or 'rider'
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _roles; // Store the actual roles string from backend

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
      
      // If authenticated, verify token is still valid
      if (_isAuthenticated) {
        try {
          await _authApi.getCurrentUser();
        } catch (e) {
          // Token invalid, clear authentication
          debugPrint('Token validation failed: $e');
          await logout();
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  /// Login with username and password using real API
  Future<bool> login(String username, String password) async {
    try {
      final response = await _authApi.login(username, password);
      
      _isAuthenticated = true;
      _userId = response.user.id;
      _userName = response.user.fullName;
      _userEmail = response.user.email;
      _userPhone = response.user.phoneNumber;
      _roles = response.user.roles;
      
      // Set primary role based on what user has
      if (response.user.isDriver) {
        _userRole = 'driver';
      } else {
        _userRole = 'rider';
      }

      // Save to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userRole', _userRole!);
      await prefs.setString('userId', _userId!);
      await prefs.setString('userName', _userName!);
      await prefs.setString('userEmail', _userEmail!);
      await prefs.setString('userPhone', _userPhone!);
      await prefs.setString('roles', _roles!);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register new user using real API
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
      
      // Set primary role
      if (response.user.isDriver) {
        _userRole = 'driver';
      } else {
        _userRole = 'rider';
      }

      // Save to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userRole', _userRole!);
      await prefs.setString('userId', _userId!);
      await prefs.setString('userName', _userName!);
      await prefs.setString('userEmail', _userEmail!);
      await prefs.setString('userPhone', _userPhone!);
      await prefs.setString('roles', _roles!);

      notifyListeners();
      
      return {'success': true, 'message': 'Registration successful'};
    } catch (e) {
      debugPrint('Registration error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      // Clear API tokens
      await _authApi.logout();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

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

  /// Get current user info from API
  Future<UserInfo?> getUserInfo() async {
    try {
      return await _authApi.getCurrentUser();
    } catch (e) {
      debugPrint('Get user info error: $e');
      return null;
    }
  }

  /// Get home route based on user role
  String getHomeRoute() {
    if (!_isAuthenticated) return '/login-screen';
    return _userRole == 'driver' ? '/driver-home-screen' : '/rider-home-screen';
  }
}