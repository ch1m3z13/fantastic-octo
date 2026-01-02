/// API configuration and constants
class ApiConfig {
  // Base URL - Change this for production
  static const String baseUrl = 'http://localhost:8081';
  
  // API version prefix
  static const String apiVersion = '/api/v1';
  
  // Full base API URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/users/register';
  static const String getUserEndpoint = '/users/me';
  
  // Booking endpoints
  static const String bookingsEndpoint = '/bookings';
  
  // Route endpoints
  static const String routesEndpoint = '/routes';
  static const String nearbyRoutesEndpoint = '/routes/nearby';
  static String get headingToRoutesEndpoint => '/routes/heading-to';
  
  // Driver endpoints
  static const String driverStatsEndpoint = '/api/v1/drivers/stats';
  static const String driverManifestEndpoint = '/api/v1/drivers/manifest/active';
  static const String driverStatusEndpoint = '/api/v1/drivers/status';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  
  // For Android emulator to access localhost
  // Use 10.0.2.2:8081 instead of localhost:8081
  static String get androidEmulatorUrl => 'http://10.0.2.2:8081$apiVersion';
  
  // Helper to get correct URL based on platform
  static String getBaseUrl() {
    // In production, always use the actual baseUrl
    // For development, you might want to detect platform
    return apiBaseUrl;
  }
}