import '../api/api_service.dart';
import '../models/driver_stats_model.dart';
import 'auth_repository.dart';

class DriverRepository {
  final ApiService _apiService;
  final AuthRepository _authRepository;

  DriverRepository(this._apiService, this._authRepository);

  Future<DriverStats> getDriverStats() async {
    try {
      final token = await _authRepository.getToken();
      if (token == null) throw ApiException('User not authenticated');

      // Try fetching from API
      return await _apiService.getDriverStats(token);
    } catch (e) {
      // DEVELOPMENT FALLBACK: 
      // If API fails (e.g. endpoint doesn't exist yet), return Mock Data.
      // In production, you might want to log this error or throw it.
      print('⚠️ API Request failed: $e. Using Mock Data for Driver Stats.');
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency
      return _getMockDriverStats();
    }
  }

  // Mock data representing a busy afternoon shift in Abuja
  DriverStats _getMockDriverStats() {
    return const DriverStats(
      // Tier 1
      activePassengers: 12,
      pendingRequests: 3,
      nextStopName: "Wuse Market",
      nextStopEtaMinutes: 8,
      
      // Tier 2
      todaysEarnings: 15400.00,
      tripsCompleted: 4,
      passengersTransported: 45,
      
      // Tier 3
      onlineMinutes: 265, // 4 hours 25 mins
      acceptanceRate: 0.92, // 92%
    );
  }
}