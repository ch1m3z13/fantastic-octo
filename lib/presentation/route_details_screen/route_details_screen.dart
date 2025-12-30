import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/driver_profile_header_widget.dart';
import './widgets/driver_reviews_widget.dart';
import './widgets/fare_breakdown_widget.dart';
import './widgets/journey_timeline_widget.dart';
import './widgets/safety_features_widget.dart';
import './widgets/vehicle_information_widget.dart';

/// Route Details Screen providing comprehensive journey information
/// Enables confident booking decisions with fare breakdown and Virtual Bus Stop assignment
class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool _isLoading = false;
  int _selectedSeat = -1;

  // Mock data for route details
  final Map<String, dynamic> _routeData = {
    "driver": {
      "id": 1,
      "name": "Chukwuemeka Okonkwo",
      "photo":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1192981a2-1763292809719.png",
      "photoSemanticLabel":
          "Professional headshot of a Nigerian man with short black hair wearing a dark blue shirt",
      "rating": 4.8,
      "totalRides": 342,
      "experience": 5,
      "isVerified": true,
    },
    "vehicle": {
      "make": "Toyota",
      "model": "Camry",
      "year": 2020,
      "color": "Silver",
      "licensePlate": "ABC-123-XY",
      "seatsAvailable": 3,
      "totalSeats": 4,
      "lastInspection": "15/11/2024",
    },
    "journey": {
      "pickupLocation": "Police Signboard, Dutse",
      "pickupDescription": "Near Dutse Junction Police Station",
      "departureTime": "07:30 AM",
      "destination": "Jabi Lake Mall",
      "destinationDescription": "Main entrance, Jabi Lake Mall",
      "arrivalTime": "08:15 AM",
      "duration": "45 mins",
      "distance": "12.5 km",
    },
    "fare": {
      "baseFare": "₦ 800",
      "serviceFee": "₦ 100",
      "totalFare": "₦ 900",
      "paymentMethod": "Wallet Balance: ₦ 5,200",
    },
    "safety": {
      "driverVerification": "ID & License verified",
      "lastInspection": "15/11/2024",
      "emergencyContact": "+234 800 123 4567",
    },
    "reviews": [
      {
        "reviewerName": "Amina Hassan",
        "rating": 5,
        "date": "2 days ago",
        "comment":
            "Very professional driver. Smooth ride and arrived on time. Highly recommended!",
      },
      {
        "reviewerName": "Oluwaseun Adebayo",
        "rating": 5,
        "date": "1 week ago",
        "comment":
            "Great experience! Clean car and friendly driver. Will definitely book again.",
      },
      {
        "reviewerName": "Fatima Ibrahim",
        "rating": 4,
        "date": "2 weeks ago",
        "comment":
            "Good ride overall. Driver was punctual and the car was comfortable.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Route Details'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 20.sp,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              size: 20.sp,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showShareOptions(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 2.h,
              bottom: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver profile header
                DriverProfileHeaderWidget(
                  driverData: _routeData['driver'] as Map<String, dynamic>,
                ),
                SizedBox(height: 2.h),

                // Vehicle information
                VehicleInformationWidget(
                  vehicleData: _routeData['vehicle'] as Map<String, dynamic>,
                ),
                SizedBox(height: 2.h),

                // Journey timeline
                JourneyTimelineWidget(
                  journeyData: _routeData['journey'] as Map<String, dynamic>,
                ),
                SizedBox(height: 2.h),

                // Fare breakdown
                FareBreakdownWidget(
                  fareData: _routeData['fare'] as Map<String, dynamic>,
                ),
                SizedBox(height: 2.h),

                // Safety features
                SafetyFeaturesWidget(
                  safetyData: _routeData['safety'] as Map<String, dynamic>,
                ),
                SizedBox(height: 2.h),

                // Driver reviews
                DriverReviewsWidget(
                  reviews: (_routeData['reviews'] as List)
                      .map((review) => review as Map<String, dynamic>)
                      .toList(),
                ),
              ],
            ),
          ),

          // Floating book button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _showSeatSelectionModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Book This Ride',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSeatSelectionModal(BuildContext context) {
    final theme = Theme.of(context);
    final vehicleData = _routeData['vehicle'] as Map<String, dynamic>;
    final totalSeats = vehicleData['totalSeats'] as int;
    final seatsAvailable = vehicleData['seatsAvailable'] as int;

    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              SizedBox(height: 2.h),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Your Seat',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 20.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // Seat layout
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      // Driver seat indicator
                      Row(
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'person',
                                size: 24.sp,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Driver',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      // Passenger seats
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: totalSeats,
                        itemBuilder: (context, index) {
                          final isOccupied = index >= seatsAvailable;
                          final isSelected = _selectedSeat == index;

                          return GestureDetector(
                            onTap: isOccupied
                                ? null
                                : () {
                                    HapticFeedback.lightImpact();
                                    setModalState(() {
                                      _selectedSeat = isSelected ? -1 : index;
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isOccupied
                                    ? theme.colorScheme.outline.withValues(
                                        alpha: 0.2,
                                      )
                                    : isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                  color: isOccupied
                                      ? theme.colorScheme.outline.withValues(
                                          alpha: 0.3,
                                        )
                                      : isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withValues(
                                          alpha: 0.5,
                                        ),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: isOccupied
                                        ? 'event_seat'
                                        : 'event_seat',
                                    size: 28.sp,
                                    color: isOccupied
                                        ? theme.colorScheme.onSurfaceVariant
                                        : isSelected
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.primary,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Seat ${index + 1}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isOccupied
                                          ? theme.colorScheme.onSurfaceVariant
                                          : isSelected
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (isOccupied)
                                    Text(
                                      'Occupied',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Confirm button
              Padding(
                padding: EdgeInsets.all(4.w),
                child: SafeArea(
                  top: false,
                  child: ElevatedButton(
                    onPressed: _selectedSeat == -1
                        ? null
                        : () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                            _confirmBooking();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      minimumSize: Size(double.infinity, 6.h),
                    ),
                    child: Text(
                      _selectedSeat == -1
                          ? 'Select a Seat'
                          : 'Confirm Seat ${_selectedSeat + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBooking() {
    setState(() {
      _isLoading = true;
    });

    // Simulate booking confirmation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to booking confirmation screen
        Navigator.pushNamed(context, '/booking-confirmation-screen');
      }
    });
  }

  void _showShareOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              Text(
                'Share Route Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'message',
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Share via SMS'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'email',
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Share via Email'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Copy Link'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
