import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthRepository(this._apiService);

  // Register user
  Future<AuthResponse> register(RegisterUserDTO dto) async {
    final response = await _apiService.register(dto);
    
    // Save token and user data
    await _secureStorage.write(key: _tokenKey, value: response.token);
    await _secureStorage.write(
      key: _userKey, 
      value: jsonEncode(response.user.toJson()),
    );
    
    return response;
  }

  // Login user
  Future<AuthResponse> login(LoginDTO dto) async {
    final response = await _apiService.login(dto);
    
    // Save token and user data
    await _secureStorage.write(key: _tokenKey, value: response.token);
    await _secureStorage.write(
      key: _userKey,
      value: jsonEncode(response.user.toJson()),
    );
    
    return response;
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Get stored user data
  Future<UserData?> getStoredUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserData.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Get current user from API
  Future<UserData?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      return await _apiService.getCurrentUser(token);
    } catch (e) {
      // If API call fails, return stored user data
      return await getStoredUser();
    }
  }

  // Logout
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}