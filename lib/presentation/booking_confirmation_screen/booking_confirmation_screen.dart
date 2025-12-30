import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/booking_header_widget.dart';
import './widgets/cancellation_policy_widget.dart';
import './widgets/directions_card_widget.dart';
import './widgets/fare_breakdown_card_widget.dart';
import './widgets/journey_summary_card_widget.dart';
import './widgets/qr_code_section_widget.dart';

/// Booking Confirmation Screen - Finalizes ride reservation with payment processing
/// and Virtual Bus Stop assignment details
class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  // Mock booking data
  final Map<String, dynamic> _bookingData = {
    "bookingReference": "ABC123456",
    "driverName": "Chukwudi Okafor",
    "driverPhoto":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1192981a2-1763292809719.png",
    "driverPhotoLabel":
        "Professional headshot of a Nigerian man with short black hair wearing a blue shirt",
    "driverRating": "4.8",
    "totalTrips": "342",
    "vehicleMake": "Toyota Corolla 2020",
    "vehiclePlate": "ABJ-456-XY",
    "departureTime": "Tomorrow, 7:30 AM",
    "virtualBusStop": "Police Signboard, Dutse",
    "busStopPhoto":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1f40fc18c-1766709670833.png",
    "busStopPhotoLabel":
        "Street view of a police signboard near a traffic light in Dutse, Abuja with clear road markings",
    "busStopDescription": "Near Traffic Light - Look for the blue police sign",
  };

  final Map<String, dynamic> _fareData = {
    "baseFare": "₦800.00",
    "serviceFee": "₦100.00",
    "totalAmount": "₦900.00",
    "paymentMethod": "Wallet Balance",
  };

  final Map<String, dynamic> _directionsData = {
    "walkingDistance": "250 meters",
    "estimatedTime": "3 minutes",
  };

  final Map<String, dynamic> _policyData = {
    "freeCancellationTime": "2 hours before departure",
    "partialRefundPercentage": "50%",
    "partialRefundTime": "1-2 hours before departure",
    "noRefundTime": "1 hour before departure",
  };

  final String _qrCodeData = "ABC123456-RIDER-20251226";

  @override
  void initState() {
    super.initState();
    // Trigger celebration haptic feedback on screen load
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.mediumImpact();
    });
  }

  void _showFullScreenQrCode() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Show this to your driver',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 3.h),
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 60.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Code: $_qrCodeData',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 3.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddToCalendar() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Trip added to your calendar",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _handleShareTripDetails() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Trip details shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _handleGetDirections() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Opening maps for directions",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _handleBackToHome() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/rider-home-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Booking Confirmed',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookingHeaderWidget(
              bookingReference: _bookingData['bookingReference'] as String,
            ),
            SizedBox(height: 2.h),
            JourneySummaryCardWidget(bookingData: _bookingData),
            FareBreakdownCardWidget(fareData: _fareData),
            QrCodeSectionWidget(
              qrCodeData: _qrCodeData,
              onShowQrCode: _showFullScreenQrCode,
            ),
            DirectionsCardWidget(
              directionsData: _directionsData,
              onGetDirections: _handleGetDirections,
            ),
            ActionButtonsWidget(
              onAddToCalendar: _handleAddToCalendar,
              onShareTripDetails: _handleShareTripDetails,
            ),
            CancellationPolicyWidget(policyData: _policyData),
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleBackToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
