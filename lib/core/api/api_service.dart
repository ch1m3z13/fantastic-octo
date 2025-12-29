import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/driver_stats_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  // ... (Existing register and login methods remain unchanged)

  Future<AuthResponse> register(RegisterUserDTO dto) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');
      
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['message'] ?? 'Registration failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<AuthResponse> login(LoginDTO dto) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
      
      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['message'] ?? 'Login failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
  
  Future<UserData> getCurrentUser(String token) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.currentUser}');
      
      final response = await http.get(
        url,
        headers: {
          ...ApiConstants.headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserData.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['message'] ?? 'Failed to get user',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // --- New Driver Methods ---

  Future<DriverStats> getDriverStats(String token) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driverStats}');
      
      final response = await http.get(
        url,
        headers: {
          ...ApiConstants.headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DriverStats.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['message'] ?? 'Failed to load driver stats',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}