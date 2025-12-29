class ApiConstants {
  // For local development
  static const String baseUrl = 'http://localhost:8081/api/v1';

  // For Android emulator accessing host machine
  // static const String baseUrl = 'http://10.0.2.2:8081/api/v1';

  // For physical device or iOS simulator
  // static const String baseUrl = 'http://YOUR_IP_ADDRESS:8081/api/v1';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/users/register';
  static const String currentUser = '/users/me';

  // Driver Endpoints
  static const String driverStats = '/drivers/stats';
  static const String driverStatus = '/drivers/status'; // Online/Offline
  static const String activeManifest = '/drivers/manifest/active';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
