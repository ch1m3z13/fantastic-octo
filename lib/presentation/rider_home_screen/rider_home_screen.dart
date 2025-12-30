import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/location_status_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/popular_routes_widget.dart';
import './widgets/quick_actions_widget.dart';

/// Rider Home Screen - Primary dashboard for passengers seeking scheduled rides
/// along the Dutse-Jabi corridor
class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  int _currentBottomNavIndex = 0;
  bool _isLocationEnabled = true;
  bool _isNetworkConnected = true;
  bool _isRefreshing = false;

  // Mock user data
  final String _userName = 'Chioma Adebayo';
  final String _userAvatar =
      'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png';
  final int _notificationCount = 3;

  // Current location (Dutse, Abuja)
  final LatLng _currentLocation = const LatLng(9.0765, 7.4951);
  final String _currentLocationName = 'Dutse, Abuja';

  // Virtual Bus Stops data
  final List<Map<String, dynamic>> _virtualBusStops = [
    {
      'id': 1,
      'name': 'Police Signboard',
      'landmark': 'Dutse',
      'latitude': 9.0765,
      'longitude': 7.4951,
    },
    {
      'id': 2,
      'name': 'Shoprite',
      'landmark': 'Jabi',
      'latitude': 9.0579,
      'longitude': 7.4951,
    },
    {
      'id': 3,
      'name': 'Ceddi Plaza',
      'landmark': 'Wuse',
      'latitude': 9.0643,
      'longitude': 7.4892,
    },
    {
      'id': 4,
      'name': 'Transcorp Hilton',
      'landmark': 'Maitama',
      'latitude': 9.0820,
      'longitude': 7.4918,
    },
    {
      'id': 5,
      'name': 'Eagle Square',
      'landmark': 'Central Area',
      'latitude': 9.0643,
      'longitude': 7.4951,
    },
  ];

  // Popular routes data
  final List<Map<String, dynamic>> _popularRoutes = [
    {
      'id': 1,
      'origin': 'Dutse',
      'destination': 'Jabi',
      'departureTime': '07:30 AM',
      'fare': '₦ 800',
      'availableSeats': 2,
      'totalSeats': 4,
      'driverName': 'Emeka Okafor',
      'driverAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'rating': 4.8,
      'totalRides': 245,
    },
    {
      'id': 2,
      'origin': 'Dutse',
      'destination': 'Wuse',
      'departureTime': '08:00 AM',
      'fare': '₦ 1,000',
      'availableSeats': 3,
      'totalSeats': 4,
      'driverName': 'Fatima Ibrahim',
      'driverAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'rating': 4.9,
      'totalRides': 312,
    },
    {
      'id': 3,
      'origin': 'Jabi',
      'destination': 'Central Area',
      'departureTime': '08:30 AM',
      'fare': '₦ 1,200',
      'availableSeats': 4,
      'totalSeats': 4,
      'driverName': 'Chukwudi Nwosu',
      'driverAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'rating': 4.7,
      'totalRides': 198,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              GreetingHeaderWidget(
                userName: _userName,
                userAvatar: _userAvatar,
                notificationCount: _notificationCount,
                onNotificationTap: _handleNotificationTap,
              ),

              SizedBox(height: 1.h),

              // Location Status
              LocationStatusWidget(
                isLocationEnabled: _isLocationEnabled,
                isNetworkConnected: _isNetworkConnected,
                currentLocation: _currentLocationName,
                onLocationTap: _handleLocationSettings,
              ),

              SizedBox(height: 1.h),

              // Map View
              MapViewWidget(
                currentLocation: _currentLocation,
                virtualBusStops: _virtualBusStops,
                onBusStopTap: _handleBusStopTap,
              ),

              SizedBox(height: 2.h),

              // Quick Actions
              QuickActionsWidget(
                onLocationToggle: _handleLocationToggle,
                onFavoritesView: _handleFavoritesView,
                isLocationEnabled: _isLocationEnabled,
              ),

              SizedBox(height: 2.h),

              // Popular Routes
              PopularRoutesWidget(
                routes: _popularRoutes,
                onRouteTap: _handleRouteTap,
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleFindRide,
        icon: CustomIconWidget(
          iconName: 'search',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Find a Ride',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Routes updated'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleNotificationTap() {
    // Navigate to notifications screen (not implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have $_notificationCount new notifications'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleLocationSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Location Settings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Enable Location Services'),
                subtitle: const Text('Allow app to access your location'),
                trailing: Switch(
                  value: _isLocationEnabled,
                  onChanged: (value) {
                    setState(() => _isLocationEnabled = value);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _handleLocationToggle() {
    setState(() => _isLocationEnabled = !_isLocationEnabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLocationEnabled
              ? 'Location services enabled'
              : 'Location services disabled',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleFavoritesView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorite routes feature coming soon'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBusStopTap(String busStopId) {
    final busStop = _virtualBusStops.firstWhere(
      (stop) => stop['id'].toString() == busStopId,
    );

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(busStop['name'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Landmark: ${busStop['landmark']}',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'This is a Virtual Bus Stop for safe pickup and drop-off.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _handleRouteTap(String routeId) {
    Navigator.pushNamed(
      context,
      '/route-details-screen',
      arguments: {'routeId': routeId},
    );
  }

  void _handleFindRide() {
    Navigator.pushNamed(context, '/search-screen');
  }

  void _handleBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    setState(() => _currentBottomNavIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/search-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/booking-confirmation-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }
}