import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/passenger_confirmation_widget.dart';
import './widgets/scanner_overlay_widget.dart';

/// QR Code Scanner Screen for driver passenger verification
/// Implements camera-based boarding confirmation with manual entry fallback
class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isFlashlightOn = false;
  bool _isScanning = true;
  bool _showManualEntry = false;
  bool _showConfirmation = false;
  Map<String, dynamic>? _scannedPassenger;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  /// Initialize camera scanner with permission handling
  Future<void> _initializeScanner() async {
    final cameraPermission = await Permission.camera.request();

    if (cameraPermission.isGranted) {
      setState(() {
        _scannerController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        );
      });
    } else if (cameraPermission.isPermanentlyDenied) {
      setState(() {
        _errorMessage =
            'Camera permission is required for QR scanning. Please enable it in settings.';
      });
    } else {
      setState(() {
        _errorMessage =
            'Camera permission denied. Please grant permission to scan QR codes.';
      });
    }
  }

  /// Handle QR code detection
  void _handleQRCodeDetection(BarcodeCapture capture) {
    if (!_isScanning || _showConfirmation) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrCode = barcodes.first.rawValue;
    if (qrCode == null || qrCode.isEmpty) return;

    // Validate QR code format and extract booking reference
    if (_validateQRCode(qrCode)) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isScanning = false;
        _scannedPassenger = _getPassengerFromQRCode(qrCode);
        _showConfirmation = true;
      });
    } else {
      HapticFeedback.heavyImpact();
      _showErrorDialog(
        'Invalid QR Code',
        'This QR code is not valid or has expired. Please ask the passenger to show their current booking QR code.',
      );
    }
  }

  /// Validate QR code format and expiration
  bool _validateQRCode(String qrCode) {
    // QR code format: BOOKING_REF|TIMESTAMP|PASSENGER_ID
    final parts = qrCode.split('|');
    if (parts.length != 3) return false;

    // Check if QR code is expired (valid for 24 hours)
    try {
      final timestamp = int.parse(parts[1]);
      final qrTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(qrTime);

      return difference.inHours < 24;
    } catch (e) {
      return false;
    }
  }

  /// Extract passenger information from QR code
  Map<String, dynamic> _getPassengerFromQRCode(String qrCode) {
    final parts = qrCode.split('|');
    final bookingRef = parts[0];

    // Mock passenger data - in production, this would fetch from database
    final mockPassengers = [
      {
        "bookingRef": "BK001",
        "name": "Chioma Okafor",
        "phone": "+234 803 456 7890",
        "pickupStop": "Dutse Police Station",
        "seatNumber": "A1",
        "fare": "₦ 800",
        "avatar":
            "https://img.rocket.new/generatedImages/rocket_gen_img_1e20f0ace-1763299053725.png",
        "semanticLabel":
            "Profile photo of a woman with long black hair wearing a blue blouse",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        "bookingRef": "BK002",
        "name": "Ibrahim Musa",
        "phone": "+234 805 123 4567",
        "pickupStop": "Dutse Junction",
        "seatNumber": "B2",
        "fare": "₦ 800",
        "avatar":
            "https://img.rocket.new/generatedImages/rocket_gen_img_15473c7b5-1763295351945.png",
        "semanticLabel":
            "Profile photo of a man with short black hair wearing a white shirt",
        "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];

    return mockPassengers.firstWhere(
      (p) => p["bookingRef"] == bookingRef,
      orElse: () => mockPassengers[0],
    );
  }

  /// Toggle flashlight
  void _toggleFlashlight() {
    if (_scannerController == null) return;

    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
    });

    _scannerController!.toggleTorch();
    HapticFeedback.lightImpact();
  }

  /// Show manual entry dialog
  void _showManualEntryDialog() {
    HapticFeedback.lightImpact();
    setState(() {
      _showManualEntry = true;
    });
  }

  /// Handle manual booking reference entry
  void _handleManualEntry(String bookingRef) {
    if (bookingRef.isEmpty) {
      _showErrorDialog(
        'Invalid Reference',
        'Please enter a valid booking reference number.',
      );
      return;
    }

    // Validate booking reference
    final passenger = _getPassengerFromQRCode(
      '$bookingRef|${DateTime.now().millisecondsSinceEpoch}|123',
    );

    if (passenger["bookingRef"] == bookingRef) {
      HapticFeedback.mediumImpact();
      setState(() {
        _showManualEntry = false;
        _scannedPassenger = passenger;
        _showConfirmation = true;
        _isScanning = false;
      });
    } else {
      HapticFeedback.heavyImpact();
      _showErrorDialog(
        'Booking Not Found',
        'No booking found with reference: $bookingRef',
      );
    }
  }

  /// Confirm passenger boarding
  void _confirmBoarding() {
    HapticFeedback.mediumImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_scannedPassenger!["name"]} boarded successfully'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back to manifest with boarding confirmation
    Navigator.pop(context, {
      'boarded': true,
      'passenger': _scannedPassenger,
      'timestamp': DateTime.now(),
    });
  }

  /// Cancel boarding confirmation
  void _cancelBoarding() {
    HapticFeedback.lightImpact();
    setState(() {
      _showConfirmation = false;
      _scannedPassenger = null;
      _isScanning = true;
    });
  }

  /// Show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isScanning = true;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Open app settings for permission
  void _openSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview or error state
            if (_errorMessage != null)
              _buildErrorState(theme)
            else if (_scannerController != null)
              _buildScannerView()
            else
              _buildLoadingState(theme),

            // Scanner overlay with frame
            if (_errorMessage == null && !_showConfirmation)
              ScannerOverlayWidget(isScanning: _isScanning),

            // Top bar with close button and title
            _buildTopBar(theme),

            // Bottom controls
            if (_errorMessage == null && !_showConfirmation)
              _buildBottomControls(theme),

            // Manual entry dialog
            if (_showManualEntry)
              ManualEntryWidget(
                onSubmit: _handleManualEntry,
                onCancel: () {
                  setState(() {
                    _showManualEntry = false;
                  });
                },
              ),

            // Passenger confirmation dialog
            if (_showConfirmation && _scannedPassenger != null)
              PassengerConfirmationWidget(
                passenger: _scannedPassenger!,
                onConfirm: _confirmBoarding,
                onCancel: _cancelBoarding,
              ),
          ],
        ),
      ),
    );
  }

  /// Build scanner view with camera preview
  Widget _buildScannerView() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: _handleQRCodeDetection,
    );
  }

  /// Build loading state
  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Build error state with permission request
  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Access Required',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _openSettings,
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build top bar with close button and title
  Widget _buildTopBar(ThemeData theme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Scan Passenger QR',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom controls with flashlight and manual entry
  Widget _buildBottomControls(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Instruction text
            Text(
              'Align QR code within frame',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Flashlight toggle
                _buildControlButton(
                  theme: theme,
                  icon: _isFlashlightOn ? 'flash_on' : 'flash_off',
                  label: 'Flash',
                  onPressed: _toggleFlashlight,
                ),
                // Manual entry
                _buildControlButton(
                  theme: theme,
                  icon: 'keyboard',
                  label: 'Manual Entry',
                  onPressed: _showManualEntryDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build control button
  Widget _buildControlButton({
    required ThemeData theme,
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 28,
            ),
            iconSize: 28,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}