import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/route_card_widget.dart';
import './widgets/route_filter_bottom_sheet.dart';
import './widgets/sort_options_widget.dart';

/// Available Routes Screen
/// Displays matching rides with comprehensive driver and vehicle information
/// Supports filtering, sorting, and real-time seat availability updates
class AvailableRoutesScreen extends StatefulWidget {
  const AvailableRoutesScreen({super.key});

  @override
  State<AvailableRoutesScreen> createState() => _AvailableRoutesScreenState();
}

class _AvailableRoutesScreenState extends State<AvailableRoutesScreen> {
  bool _isLoading = false;
  String _currentSort = 'earliest';
  Map<String, dynamic>? _currentFilters;
  int _currentBottomNavIndex = 0;

  // Mock data for available routes
  final List<Map<String, dynamic>> _allRoutes = [
    {
      "id": 1,
      "driverName": "Chukwuemeka Okonkwo",
      "driverPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1192981a2-1763292809719.png",
      "driverPhotoLabel":
          "Professional headshot of a Nigerian man with short black hair wearing a blue shirt",
      "rating": 4.8,
      "totalTrips": 342,
      "vehicleMake": "Toyota",
      "vehicleModel": "Camry",
      "vehicleColor": "Silver",
      "plateNumber": "ABJ 234 KL",
      "vehicleType": "Sedan",
      "departureTime": "07:30 AM",
      "pickupLocation": "Police Signboard, Dutse",
      "estimatedArrival": "08:15 AM",
      "availableSeats": 3,
      "fare": 800,
    },
    {
      "id": 2,
      "driverName": "Aisha Mohammed",
      "driverPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1e24da9d6-1763297055199.png",
      "driverPhotoLabel":
          "Professional headshot of a Nigerian woman with braided hair wearing a green traditional outfit",
      "rating": 4.9,
      "totalTrips": 456,
      "vehicleMake": "Honda",
      "vehicleModel": "Accord",
      "vehicleColor": "Black",
      "plateNumber": "ABJ 567 MN",
      "vehicleType": "Sedan",
      "departureTime": "08:00 AM",
      "pickupLocation": "Dutse Junction, Near First Bank",
      "estimatedArrival": "08:45 AM",
      "availableSeats": 2,
      "fare": 900,
    },
    {
      "id": 3,
      "driverName": "Ibrahim Yusuf",
      "driverPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1016ee15f-1763292251484.png",
      "driverPhotoLabel":
          "Professional headshot of a Nigerian man with a beard wearing a white kaftan",
      "rating": 4.7,
      "totalTrips": 289,
      "vehicleMake": "Nissan",
      "vehicleModel": "Altima",
      "vehicleColor": "White",
      "plateNumber": "ABJ 890 PQ",
      "vehicleType": "Sedan",
      "departureTime": "07:45 AM",
      "pickupLocation": "Dutse Market, Main Gate",
      "estimatedArrival": "08:30 AM",
      "availableSeats": 4,
      "fare": 750,
    },
    {
      "id": 4,
      "driverName": "Ngozi Eze",
      "driverPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1bd18c57d-1763297550621.png",
      "driverPhotoLabel":
          "Professional headshot of a Nigerian woman with short natural hair wearing a yellow blouse",
      "rating": 4.9,
      "totalTrips": 512,
      "vehicleMake": "Toyota",
      "vehicleModel": "Sienna",
      "vehicleColor": "Blue",
      "plateNumber": "ABJ 123 RS",
      "vehicleType": "Minivan",
      "departureTime": "08:15 AM",
      "pickupLocation": "Dutse Alheri Junction",
      "estimatedArrival": "09:00 AM",
      "availableSeats": 5,
      "fare": 1000,
    },
    {
      "id": 5,
      "driverName": "Oluwaseun Adebayo",
      "driverPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1674f7337-1763292472622.png",
      "driverPhotoLabel":
          "Professional headshot of a Nigerian man with glasses wearing a black polo shirt",
      "rating": 4.6,
      "totalTrips": 198,
      "vehicleMake": "Hyundai",
      "vehicleModel": "Elantra",
      "vehicleColor": "Red",
      "plateNumber": "ABJ 456 TU",
      "vehicleType": "Sedan",
      "departureTime": "09:00 AM",
      "pickupLocation": "Dutse Makaranta Junction",
      "estimatedArrival": "09:45 AM",
      "availableSeats": 1,
      "fare": 850,
    },
  ];

  List<Map<String, dynamic>> _filteredRoutes = [];

  @override
  void initState() {
    super.initState();
    _filteredRoutes = List.from(_allRoutes);
    _simulateLoading();
  }

  void _simulateLoading() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _filteredRoutes = _allRoutes.where((route) {
        final priceMatch =
            (route['fare'] as int) >= (filters['minPrice'] as double) &&
            (route['fare'] as int) <= (filters['maxPrice'] as double);
        final ratingMatch =
            (route['rating'] as double) >= (filters['minRating'] as double);
        final vehicleTypeMatch = (filters['vehicleTypes'] as List).contains(
          route['vehicleType'],
        );
        return priceMatch && ratingMatch && vehicleTypeMatch;
      }).toList();
      _applySorting(_currentSort);
    });
  }

  void _applySorting(String sortType) {
    setState(() {
      _currentSort = sortType;
      switch (sortType) {
        case 'earliest':
          _filteredRoutes.sort(
            (a, b) => (a['departureTime'] as String).compareTo(
              b['departureTime'] as String,
            ),
          );
          break;
        case 'price':
          _filteredRoutes.sort(
            (a, b) => (a['fare'] as int).compareTo(b['fare'] as int),
          );
          break;
        case 'rating':
          _filteredRoutes.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
          );
          break;
        case 'seats':
          _filteredRoutes.sort(
            (a, b) => (b['availableSeats'] as int).compareTo(
              a['availableSeats'] as int,
            ),
          );
          break;
      }
    });
  }

  void _handleRefresh() {
    HapticFeedback.mediumImpact();
    _simulateLoading();
  }

  void _showFilterBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteFilterBottomSheet(
        onApplyFilters: _applyFilters,
        currentFilters: _currentFilters,
      ),
    );
  }

  void _handleRouteAction(String action, Map<String, dynamic> route) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: ${route['driverName']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Available Routes',
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: _isLoading ? const LoadingSkeletonWidget() : _buildBody(theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/search-screen'),
        child: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 24,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      children: [
        SortOptionsWidget(
          currentSort: _currentSort,
          onSortChanged: _applySorting,
        ),
        _filteredRoutes.isEmpty
            ? Expanded(
                child: EmptyStateWidget(onAdjustSearch: _showFilterBottomSheet),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _handleRefresh(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    itemCount: _filteredRoutes.length,
                    itemBuilder: (context, index) {
                      final route = _filteredRoutes[index];
                      return RouteCardWidget(
                        route: route,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/route-details-screen',
                          arguments: route,
                        ),
                        onSave: () => _handleRouteAction('Saved', route),
                        onShare: () => _handleRouteAction('Shared', route),
                        onReport: () => _handleRouteAction('Reported', route),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}