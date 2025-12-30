import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/manifest_card_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/pending_requests_banner_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/route_summary_card_widget.dart';

/// Driver Home Screen - Operational dashboard for managing daily routes
/// Displays route summary, passenger manifest, earnings, and navigation
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;

  // Mock data for driver's today route
  final Map<String, dynamic> todayRoute = {
    "routeId": "RT001",
    "routeName": "Dutse - Jabi Express",
    "departureTime": "07:30 AM",
    "status": "ready_to_start", // ready_to_start, in_progress, completed
    "totalPassengers": 12,
    "confirmedPassengers": 10,
    "estimatedEarnings": "₦18,000",
    "virtualBusStops": [
      {
        "name": "Dutse Junction",
        "latitude": 9.0765,
        "longitude": 7.3986,
        "pickupOrder": 1,
        "passengersCount": 3,
      },
      {
        "name": "Gwarinpa 1st Gate",
        "latitude": 9.0820,
        "longitude": 7.4050,
        "pickupOrder": 2,
        "passengersCount": 4,
      },
      {
        "name": "Kubwa Express",
        "latitude": 9.0900,
        "longitude": 7.3800,
        "pickupOrder": 3,
        "passengersCount": 3,
      },
    ],
    "currentLocation": {"latitude": 9.0765, "longitude": 7.3986},
  };

  // Mock driver statistics
  final Map<String, dynamic> driverStats = {
    "rating": 4.8,
    "totalRatings": 156,
    "completedTripsThisWeek": 18,
    "weeklyEarnings": "₦324,000",
    "monthlyEarnings": "₦1,296,000",
  };

  // Mock pending booking requests
  final int pendingRequestsCount = 3;

  // Mock weather data
  final Map<String, String> weatherInfo = {
    "condition": "Partly Cloudy",
    "temperature": "28°C",
    "icon": "partly_cloudy_day",
  };

  @override
  void initState() {
    super.initState();
    _loadRouteData();
  }

  Future<void> _loadRouteData() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await _loadRouteData();
  }

  void _handleStartRoute() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start Route?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you ready to begin today\'s route? Make sure you\'ve completed your pre-departure checklist.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/active-ride-screen');
            },
            child: const Text('Start Route'),
          ),
        ],
      ),
    );
  }

  void _handleEmergencySupport() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Call Support'),
              subtitle: const Text('+234 800 123 4567'),
              onTap: () {
                Navigator.pop(context);
                // Implement call functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              title: const Text('Report Incident'),
              onTap: () {
                Navigator.pop(context);
                // Implement incident reporting
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeUntilDeparture() {
    // Mock calculation - in real app, calculate from actual departure time
    return "2h 15m";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Driver Dashboard',
        variant: AppBarVariant.standard,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: theme.colorScheme.error,
              size: 24,
            ),
            onPressed: _handleEmergencySupport,
            tooltip: 'Emergency Support',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/pending-booking-requests-screen');
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pending requests banner
                    if (pendingRequestsCount > 0)
                      PendingRequestsBannerWidget(
                        requestCount: pendingRequestsCount,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(
                            context,
                            '/pending-booking-requests-screen',
                          );
                        },
                      ),

                    // Route summary card
                    RouteSummaryCardWidget(
                      routeData: todayRoute,
                      weatherInfo: weatherInfo,
                      timeUntilDeparture: _getTimeUntilDeparture(),
                    ),

                    SizedBox(height: 2.h),

                    // Quick stats
                    QuickStatsWidget(stats: driverStats),

                    SizedBox(height: 2.h),

                    // Today's manifest card
                    ManifestCardWidget(
                      totalPassengers: todayRoute["totalPassengers"] as int,
                      confirmedPassengers:
                          todayRoute["confirmedPassengers"] as int,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(
                          context,
                          '/driver-manifest-and-qr-scanner-screen',
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Map view with virtual bus stops
                    MapViewWidget(
                      virtualBusStops: (todayRoute["virtualBusStops"] as List)
                          .map((stop) => stop as Map<String, dynamic>)
                          .toList(),
                      currentLocation:
                          todayRoute["currentLocation"] as Map<String, dynamic>,
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
      ),
      floatingActionButton: (todayRoute["status"] as String) == "ready_to_start"
          ? FloatingActionButton.extended(
              onPressed: _handleStartRoute,
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Start Route',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        variant: CustomBottomBarVariant.driver,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }
}
