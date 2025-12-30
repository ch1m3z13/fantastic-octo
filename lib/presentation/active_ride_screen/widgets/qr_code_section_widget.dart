import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sizer/sizer.dart';


/// QR code section widget for boarding verification
/// Displays QR code with auto-brightness adjustment
class QrCodeSectionWidget extends StatefulWidget {
  final String qrData;

  const QrCodeSectionWidget({super.key, required this.qrData});

  @override
  State<QrCodeSectionWidget> createState() => _QrCodeSectionWidgetState();
}

class _QrCodeSectionWidgetState extends State<QrCodeSectionWidget> {
  double? _originalBrightness;

  @override
  void initState() {
    super.initState();
    _adjustBrightness();
  }

  @override
  void dispose() {
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _adjustBrightness() async {
    try {
      _originalBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      // Brightness adjustment not supported on this platform
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      if (_originalBrightness != null) {
        await ScreenBrightness().setScreenBrightness(_originalBrightness!);
      }
    } catch (e) {
      // Brightness adjustment not supported on this platform
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Show to Driver',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: QrImageView(
              data: widget.qrData,
              version: QrVersions.auto,
              size: 50.w,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Booking ID: ${widget.qrData}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
