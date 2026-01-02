import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../core/api/route_api_service.dart';
import '../../core/api/auth_api_service.dart';
import '../../core/models/route_models.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';

/// Search Screen with Real API Integration
/// Allows riders to search for available routes based on location
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RouteApiService _routeApi = RouteApiService();
  
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  
  // Mock current location - In production, use location services
  final double _currentLat = 9.0765; // Dutse area
  final double _currentLon = 7.3986;
  
  bool _isSearching = false;
  List<RouteResponse> _searchResults = [];
  String? _errorMessage;

  int _currentBottomNavIndex = 1; // Search tab

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  /// Search for nearby routes based on current location
  Future<void> _searchNearbyRoutes() async {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _searchResults.clear();
    });

    try {
      final routes = await _routeApi.findNearbyRoutes(
        latitude: _currentLat,
        longitude: _currentLon,
        radiusInMeters: 2000, // 2km radius
      );

      setState(() {
        _searchResults = routes;
        _isSearching = false;
      });

      if (routes.isEmpty) {
        _showMessage('No routes found in your area');
      }
    } on ApiException catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage = e.message;
      });
      _showMessage(e.message);
    } catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage = 'An unexpected error occurred';
      });
      _showMessage('Failed to search routes');
    }
  }

  /// Search for routes with specific destination
  /// Note: This requires implementing destination search/geocoding
  Future<void> _searchWithDestination() async {
    if (_destinationController.text.isEmpty) {
      _showMessage('Please enter a destination');
      return;
    }

    // In a real app, you would:
    // 1. Geocode the destination address to lat/lon
    // 2. Call findRoutesHeadingTo with origin and destination coordinates
    
    // For now, just search nearby
    await _searchNearbyRoutes();
  }

  /// Navigate to route details
  void _viewRouteDetails(RouteResponse route) {
    HapticFeedback.lightImpact();
    
    // Navigate to route details screen with route data
    Navigator.pushNamed(
      context,
      AppRoutes.routeDetails,
      arguments: route, // Pass route data
    );
  }

  /// Show snackbar message
  void _showMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Search Routes',
        variant: AppBarVariant.standard,
      ),
      body: Column(
        children: [
          _buildSearchForm(theme),
          _buildSearchResults(theme),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        variant: CustomBottomBarVariant.rider,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }

  Widget _buildSearchForm(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Location / Pickup
          TextField(
            controller: _pickupController,
            decoration: InputDecoration(
              labelText: 'Pickup Location',
              hintText: 'Current location',
              prefixIcon: Icon(Icons.my_location, color: theme.colorScheme.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.gps_fixed),
                onPressed: () {
                  _pickupController.text = 'Dutse, Abuja'; // Mock
                  HapticFeedback.lightImpact();
                },
              ),
            ),
            readOnly: true,
          ),
          SizedBox(height: 2.h),

          // Destination
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Destination',
              hintText: 'Where are you going?',
              prefixIcon: Icon(Icons.location_on, color: theme.colorScheme.error),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _searchWithDestination(),
          ),
          SizedBox(height: 2.h),

          // Search Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: _isSearching ? null : _searchNearbyRoutes,
              icon: _isSearching
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(_isSearching ? 'Searching...' : 'Find Routes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (_isSearching) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              SizedBox(height: 2.h),
              Text(
                'Searching for routes...',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              SizedBox(height: 2.h),
              Text(
                _errorMessage!,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: _searchNearbyRoutes,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 2.h),
              Text(
                'Search for available routes',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'Enter your destination or search nearby',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final route = _searchResults[index];
          return _buildRouteCard(theme, route);
        },
      ),
    );
  }

  Widget _buildRouteCard(ThemeData theme, RouteResponse route) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => _viewRouteDetails(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route name and distance
              Row(
                children: [
                  Expanded(
                    child: Text(
                      route.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      route.distanceDisplay,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Route description if available
              if (route.description != null) ...[
                SizedBox(height: 1.h),
                Text(
                  route.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              
              // Start and end points
              if (route.startPoint != null && route.endPoint != null) ...[
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.trip_origin,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        '${route.startPoint} → ${route.endPoint}',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: 1.h),

              // Driver info (if available)
              if (route.driver != null) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(route.driver!.name[0]),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route.driver!.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (route.driver!.rating != null) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${route.driver!.rating} (${route.driver!.totalTrips ?? 0} trips)',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                // Vehicle info (if available)
                if (route.driver?.vehicle != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${route.driver!.vehicle!.displayName} • ${route.driver!.vehicle!.plateNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
              ],

              // Route stats
              Row(
                children: [
                  if (route.stopCount != null) ...[
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${route.stopCount} stops',
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  if (route.availableSeats != null) ...[
                    Icon(
                      Icons.event_seat,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${route.availableSeats} seats',
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  if (route.estimatedFare != null) ...[
                    Icon(
                      Icons.payments,
                      size: 16,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '₦${route.estimatedFare!.toStringAsFixed(0)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}