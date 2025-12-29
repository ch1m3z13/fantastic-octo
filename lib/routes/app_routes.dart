import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String driverHome = '/driver-home';
  static const String activeRide = '/active-ride';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegistrationScreen(),
    driverHome: (context) => const DriverHomeScreen(),
    activeRide: (context) => const ActiveRideScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHomeScreen());
      case activeRide:
        return MaterialPageRoute(builder: (_) => const ActiveRideScreen());
      default:
        return null;
    }
  }
}
