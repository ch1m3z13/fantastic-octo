import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/api/booking_api_service.dart';
import '../../core/api/auth_api_service.dart';
import '../../core/models/booking_models.dart';
import '../../core/models/route_models.dart';
import '../../services/auth_service.dart';

/// Route Details Screen with Booking Integration
class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final BookingApiService _bookingApi = BookingApiService();
  
  RouteResponse? _route;
  bool _isBooking = false;

  // Booking form data (in production, get from user input/map)
  int _passengerCount = 1;
  String _specialInstructions = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get route from navigation arguments
    if (_route == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RouteResponse) {
        setState(() => _route = args);
      }
    }
  }

  /// Show booking confirmation dialog
  Future<void> _showBookingDialog() async {
    final authService = context.read<AuthService>();
    
    if (!authService.isAuthenticated) {
      _showLoginRequired();
      return;
    }

    // Show dialog to get booking details
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildBookingDialog(context),
    );

    if (confirmed == true) {
      _createBooking();
    }
  }

  Widget _buildBookingDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route: ${_route!.name}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_route!.startPoint != null && _route!.endPoint != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    '${_route!.startPoint} → ${_route!.endPoint}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                SizedBox(height: 2.h),
                
                // Passenger count
                Text(
                  'Number of Passengers',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: _passengerCount > 1
                          ? () => setDialogState(() => _passengerCount--)
                          : null,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$_passengerCount',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: _passengerCount < 4
                          ? () => setDialogState(() => _passengerCount++)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                
                // Special instructions
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Special Instructions (Optional)',
                    hintText: 'e.g., Please call when you arrive',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  maxLength: 200,
                  onChanged: (value) => _specialInstructions = value,
                ),
                SizedBox(height: 1.h),
                
                // Fare estimate (if available)
                if (_route!.estimatedFare != null) ...[
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Fare:',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '₦${(_route!.estimatedFare! * _passengerCount).toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm Booking'),
            ),
          ],
        );
      },
    );
  }

  /// Create booking with backend
  Future<void> _createBooking() async {
    final authService = context.read<AuthService>();
    
    setState(() => _isBooking = true);

    try {
      // In production, get these from map/location picker
      // For now, use route's first and last coordinates
      final coords = _route!.coordinates;
      final pickupCoord = coords.first;
      final dropoffCoord = coords.last;
      
      final request = CreateBookingRequest(
        riderId: authService.userId!,
        routeId: _route!.id,
        pickupLatitude: pickupCoord.latitude,
        pickupLongitude: pickupCoord.longitude,
        dropoffLatitude: dropoffCoord.latitude,
        dropoffLongitude: dropoffCoord.longitude,
        scheduledPickupTime: DateTime.now()
            .add(Duration(minutes: 30))
            .toIso8601String(),
        passengerCount: _passengerCount,
        specialInstructions: _specialInstructions.isNotEmpty 
            ? _specialInstructions 
            : null,
      );

      final booking = await _bookingApi.createBooking(request);

      if (!mounted) return;
      
      setState(() => _isBooking = false);

      // Show success and navigate
      _showSuccessDialog(booking);

    } on ApiException catch (e) {
      if (!mounted) return;
      
      setState(() => _isBooking = false);
      _showErrorSnackbar('Failed to create booking: ${e.message}');
      
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isBooking = false);
      _showErrorSnackbar('An unexpected error occurred');
    }
  }

  void _showSuccessDialog(BookingResponse booking) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.secondary,
              size: 32,
            ),
            SizedBox(width: 12),
            Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your ride has been booked successfully. The driver will be notified.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Details',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Status: ${booking.status}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Passengers: ${booking.passengerCount}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (booking.specialInstructions != null)
                    Text(
                      'Notes: ${booking.specialInstructions}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to search
            },
            child: Text('Back to Search'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to my bookings screen
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.myBookings,
              );
            },
            child: Text('View My Bookings'),
          ),
        ],
      ),
    );
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Required'),
        content: Text('Please login to book a ride.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_route == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Route Details')),
        body: Center(child: Text('No route data')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route name
                Text(
                  _route!.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),

                // Route summary
                if (_route!.startPoint != null && _route!.endPoint != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.trip_origin,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          '${_route!.startPoint} → ${_route!.endPoint}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],

                // Description
                if (_route!.description != null) ...[
                  Text(
                    _route!.description!,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),
                ],

                // Route stats
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        _buildStatRow(
                          theme,
                          Icons.straighten,
                          'Distance',
                          _route!.distanceDisplay,
                        ),
                        if (_route!.stopCount != null) ...[
                          Divider(height: 3.h),
                          _buildStatRow(
                            theme,
                            Icons.location_on,
                            'Stops',
                            '${_route!.stopCount} stops',
                          ),
                        ],
                        if (_route!.estimatedFare != null) ...[
                          Divider(height: 3.h),
                          _buildStatRow(
                            theme,
                            Icons.payments,
                            'Estimated Fare',
                            '₦${_route!.estimatedFare!.toStringAsFixed(0)}',
                            valueColor: theme.colorScheme.primary,
                          ),
                        ],
                        if (_route!.availableSeats != null) ...[
                          Divider(height: 3.h),
                          _buildStatRow(
                            theme,
                            Icons.event_seat,
                            'Available Seats',
                            '${_route!.availableSeats} seats',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Driver info (if available)
                if (_route!.driver != null) ...[
                  Text(
                    'Driver Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                child: Text(
                                  _route!.driver!.name[0],
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _route!.driver!.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (_route!.driver!.rating != null)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            '${_route!.driver!.rating} (${_route!.driver!.totalTrips ?? 0} trips)',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_route!.driver?.vehicle != null) ...[
                            Divider(height: 3.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  color: theme.colorScheme.primary,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  _route!.driver!.vehicle!.displayName,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Spacer(),
                                Text(
                                  _route!.driver!.vehicle!.plateNumber,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 10.h), // Space for button
              ],
            ),
          ),

          // Loading overlay
          if (_isBooking)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 2.h),
                        Text(
                          'Creating booking...',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: ElevatedButton(
            onPressed: _isBooking ? null : _showBookingDialog,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: Text(
              'Book This Route',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}