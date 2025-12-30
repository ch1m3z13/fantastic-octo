import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/driver_info_card_widget.dart';
import './widgets/emergency_button_widget.dart';
import './widgets/qr_code_section_widget.dart';
import './widgets/trip_details_sheet_widget.dart';
import './widgets/trip_progress_timeline_widget.dart';

/// Active Ride Screen
/// Provides real-time trip tracking and boarding verification
class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;
  final String _currentStatus = "Driver En Route";
  String? _estimatedTime = "5 mins";

  // Mock data for active ride
  final Map<String, dynamic> _activeRideData = {
    "bookingId": "BK20251226001",
    "pickup": "Dutse Junction",
    "destination": "Jabi Lake Mall",
    "departureTime": "08:30 AM",
    "fare": "₦1,500.00",
    "passengers": ["Amina", "Chidi", "Fatima"],
    "driver": {
      "name": "Ibrahim Musa",
      "photo":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1192981a2-1763292809719.png",
      "photoSemanticLabel":
          "Professional headshot of a Nigerian man with short black hair wearing a blue shirt",
      "rating": 4.8,
      "vehicle": "Toyota Corolla",
      "plateNumber": "ABJ-123-XY",
      "phone": "+2348012345678",
    },
    "route": [
      {"lat": 9.0765, "lng": 7.3986, "name": "Dutse Junction"},
      {"lat": 9.0820, "lng": 7.4050, "name": "Gwarinpa"},
      {"lat": 9.0880, "lng": 7.4120, "name": "Jabi Lake Mall"},
    ],
  };

  final LatLng _initialPosition = const LatLng(9.0765, 7.3986);
  LatLng _driverPosition = const LatLng(9.0720, 7.3950);

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _simulateDriverMovement();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await Future.delayed(const Duration(seconds: 1));
    _addMarkers();
    _addRoute();
    setState(() => _isLoading = false);
  }

  void _addMarkers() {
    final route = _activeRideData["route"] as List;

    // Pickup marker
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(route[0]["lat"] as double, route[0]["lng"] as double),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: route[0]["name"] as String),
      ),
    );

    // Destination marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          route[route.length - 1]["lat"] as double,
          route[route.length - 1]["lng"] as double,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: route[route.length - 1]["name"] as String,
        ),
      ),
    );

    // Driver marker
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
    );
  }

  void _addRoute() {
    final route = _activeRideData["route"] as List;
    final List<LatLng> routePoints = route.map((point) {
      return LatLng(point["lat"] as double, point["lng"] as double);
    }).toList();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Theme.of(context).colorScheme.primary,
        width: 4,
      ),
    );
  }

  void _simulateDriverMovement() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _driverPosition = const LatLng(9.0750, 7.3970);
          _markers.removeWhere((m) => m.markerId.value == 'driver');
          _markers.add(
            Marker(
              markerId: const MarkerId('driver'),
              position: _driverPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
              infoWindow: const InfoWindow(title: 'Driver Location'),
            ),
          );
          _estimatedTime = "3 mins";
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(_driverPosition));
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: const LatLng(9.0700, 7.3900),
          northeast: const LatLng(9.0900, 7.4150),
        ),
        50,
      ),
    );
  }

  void _showTripDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TripDetailsSheetWidget(tripData: _activeRideData),
    );
  }

  void _handleEmergency() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: theme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What would you like to do?',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildEmergencyOption(
                context,
                'Call Emergency Services',
                'emergency_share',
                () {
                  Navigator.pop(context);
                  // Emergency call functionality
                },
              ),
              SizedBox(height: 1.h),
              _buildEmergencyOption(
                context,
                'Share Trip with Contact',
                'share',
                () {
                  Navigator.pop(context);
                  // Share trip functionality
                },
              ),
              SizedBox(height: 1.h),
              _buildEmergencyOption(
                context,
                'Report Safety Issue',
                'report',
                () {
                  Navigator.pop(context);
                  // Report issue functionality
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyOption(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 13,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Material(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(2.w),
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(2.w),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: theme.colorScheme.onSurface,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            EmergencyButtonWidget(onPressed: _handleEmergency),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TripProgressTimelineWidget(
                          currentStatus: _currentStatus,
                          estimatedTime: _estimatedTime,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: QrCodeSectionWidget(
                          qrData: _activeRideData["bookingId"] as String,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta! < -10) {
                            _showTripDetails();
                          }
                        },
                        child: DriverInfoCardWidget(
                          driverData:
                              _activeRideData["driver"] as Map<String, dynamic>,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
