import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/active_ride_screen/active_ride_screen.dart';
import '../presentation/driver_home_screen/driver_home_screen.dart';
import '../presentation/pending_booking_requests_screen/pending_booking_requests_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/rider_home_screen/rider_home_screen.dart';
import '../presentation/route_details_screen/route_details_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/booking_confirmation_screen/booking_confirmation_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/available_routes_screen/available_routes_screen.dart';
import '../presentation/my_bookings_screen/my_bookings_screen.dart';
import '../presentation/manifest_screen/manifest_screen.dart';
import '../presentation/qr_code_scanner_screen/qr_code_scanner_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String login = '/login-screen';
  static const String activeRide = '/active-ride-screen';
  static const String driverHome = '/driver-home-screen';
  static const String pendingBookingRequests =
      '/pending-booking-requests-screen';
  static const String registration = '/registration-screen';
  static const String riderHome = '/rider-home-screen';
  static const String routeDetails = '/route-details-screen';
  static const String search = '/search-screen';
  static const String bookingConfirmation = '/booking-confirmation-screen';
  static const String profile = '/profile-screen';
  static const String availableRoutes = '/available-routes-screen';
  static const String myBookings = '/my-bookings-screen';
  static const String manifest = '/manifest-screen';
  static const String qrCodeScanner = '/qr-code-scanner-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
   // splashScreen: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    activeRide: (context) => const ActiveRideScreen(),
    driverHome: (context) => const DriverHomeScreen(),
    pendingBookingRequests: (context) => const PendingBookingRequestsScreen(),
    registration: (context) => const RegistrationScreen(),
    riderHome: (context) => const RiderHomeScreen(),
    routeDetails: (context) => const RouteDetailsScreen(),
    search: (context) => const SearchScreen(),
    bookingConfirmation: (context) => const BookingConfirmationScreen(),
    profile: (context) => const ProfileScreen(),
    availableRoutes: (context) => const AvailableRoutesScreen(),
    myBookings: (context) => const MyBookingsScreen(),
    manifest: (context) => const ManifestScreen(),
    qrCodeScanner: (context) => const QrCodeScannerScreen(),
    // TODO: Add your other routes here
  };
}
