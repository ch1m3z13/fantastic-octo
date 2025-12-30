import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication service to manage user login state
/// Uses SharedPreferences for persistent storage
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isAuthenticated = false;
  String? _userRole; // 'rider' or 'driver'
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhone;

  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;

  bool get isDriver => _userRole == 'driver';
  bool get isRider => _userRole == 'rider';

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
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  /// Login with username and password (mock authentication)
  Future<bool> login(String username, String password) async {
    try {
      // Mock authentication - replace with real API call later
      final mockUsers = {
        'rider1': {
          'password': 'rider123',
          'role': 'rider',
          'name': 'Chinedu Okafor',
          'email': 'chinedu@example.com',
          'phone': '+234 803 456 7890',
        },
        'driver1': {
          'password': 'driver123',
          'role': 'driver',
          'name': 'Amina Bello',
          'email': 'amina@example.com',
          'phone': '+234 805 123 4567',
        },
      };

      if (mockUsers.containsKey(username)) {
        final user = mockUsers[username]!;
        if (user['password'] == password) {
          _isAuthenticated = true;
          _userRole = user['role'] as String;
          _userId = username;
          _userName = user['name'] as String;
          _userEmail = user['email'] as String;
          _userPhone = user['phone'] as String;

          // Save to storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAuthenticated', true);
          await prefs.setString('userRole', _userRole!);
          await prefs.setString('userId', _userId!);
          await prefs.setString('userName', _userName!);
          await prefs.setString('userEmail', _userEmail!);
          await prefs.setString('userPhone', _userPhone!);

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register new user (mock registration)
  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
    required String phone,
    required String email,
    required bool isDriver,
  }) async {
    try {
      // Mock registration - replace with real API call later
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      _userRole = isDriver ? 'driver' : 'rider';
      _userId = username;
      _userName = fullName;
      _userEmail = email;
      _userPhone = phone;

      // Save to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userRole', _userRole!);
      await prefs.setString('userId', _userId!);
      await prefs.setString('userName', _userName!);
      await prefs.setString('userEmail', _userEmail!);
      await prefs.setString('userPhone', _userPhone!);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _isAuthenticated = false;
      _userRole = null;
      _userId = null;
      _userName = null;
      _userEmail = null;
      _userPhone = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Get home route based on user role
  String getHomeRoute() {
    if (!_isAuthenticated) return '/login-screen';
    return _userRole == 'driver' ? '/driver-home-screen' : '/rider-home-screen';
  }
}