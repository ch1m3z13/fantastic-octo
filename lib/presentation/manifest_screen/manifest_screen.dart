import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/emergency_section_widget.dart';
import './widgets/passenger_card_widget.dart';
import './widgets/trip_header_widget.dart';

/// Manifest screen displaying confirmed passenger list with boarding management
class ManifestScreen extends StatefulWidget {
  const ManifestScreen({super.key});

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  int _currentBottomNavIndex = 1;
  bool _isOnline = true;

  final List<Map<String, dynamic>> _passengers = [
    {
      "id": 1,
      "name": "Chioma Okafor",
      "photo":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1afc73db3-1763293906263.png",
      "photoLabel":
          "Professional photo of a woman with braided hair wearing a white blouse",
      "pickupStop": "Dutse Police Station",
      "status": "pending",
      "phone": "+234 803 456 7890",
      "notes": "Prefers front seat",
      "sequence": 1,
    },
    {
      "id": 2,
      "name": "Ibrahim Musa",
      "photo":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1af53b3dd-1763295309635.png",
      "photoLabel":
          "Professional photo of a man with short hair wearing a blue shirt",
      "pickupStop": "Kubwa Total Fuel Station",
      "status": "boarded",
      "phone": "+234 805 123 4567",
      "notes": "",
      "sequence": 2,
    },
    {
      "id": 3,
      "name": "Blessing Adeyemi",
      "photo":
          "https://img.rocket.new/generatedImages/rocket_gen_img_10f2ac275-1763297173925.png",
      "photoLabel":
          "Professional photo of a woman with natural hair wearing a green dress",
      "pickupStop": "Gwarinpa 1st Gate",
      "status": "pending",
      "phone": "+234 807 890 1234",
      "notes": "Has luggage",
      "sequence": 3,
    },
    {
      "id": 4,
      "name": "Emeka Nwosu",
      "photo":
          "https://images.unsplash.com/photo-1708617451137-f94b1c4c4dc5",
      "photoLabel":
          "Professional photo of a man with glasses wearing a black polo shirt",
      "pickupStop": "Lifecamp Junction",
      "status": "pending",
      "phone": "+234 809 234 5678",
      "notes": "",
      "sequence": 4,
    },
    {
      "id": 5,
      "name": "Fatima Abubakar",
      "photo":
          "https://images.unsplash.com/photo-1716841461108-3dfce51fc6c6",
      "photoLabel":
          "Professional photo of a woman with hijab wearing a purple outfit",
      "pickupStop": "Jikwoyi Police Signboard",
      "status": "no-show",
      "phone": "+234 802 345 6789",
      "notes": "Regular passenger",
      "sequence": 5,
    },
  ];

  int get _boardedCount =>
      _passengers.where((p) => p['status'] == 'boarded').length;
  int get _totalPassengers => _passengers.length;
  bool get _canStartTrip =>
      _boardedCount == _totalPassengers ||
      _boardedCount >= (_totalPassengers * 0.8).ceil();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Today's Manifest",
        subtitle: _isOnline ? 'Live Updates' : 'Offline Mode',
        variant: AppBarVariant.primary,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'map',
              color: theme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showRouteNavigation();
            },
            tooltip: 'View Route',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: _isOnline ? 'cloud_done' : 'cloud_off',
              color: theme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showConnectivityInfo();
            },
            tooltip: _isOnline ? 'Online' : 'Offline',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshManifest,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TripHeaderWidget(
                  routeName: 'Dutse - Jabi Express',
                  departureTime: '07:30 AM',
                  totalPassengers: _totalPassengers,
                  boardedPassengers: _boardedCount,
                  canStartTrip: _canStartTrip,
                  onStartTrip: _startTrip,
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passenger List',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        'Ordered by Pickup',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _passengers.length,
                  itemBuilder: (context, index) {
                    final passenger = _passengers[index];
                    return PassengerCardWidget(
                      passenger: passenger,
                      onScanQR: () => _scanPassengerQR(passenger),
                      onMarkBoarded: () => _markPassengerBoarded(passenger),
                      onContact: () => _contactPassenger(passenger),
                      onViewNotes: () => _viewPassengerNotes(passenger),
                    );
                  },
                ),
                SizedBox(height: 3.h),
                EmergencySectionWidget(
                  onContactSupport: _contactSupport,
                  onShareManifest: _shareManifest,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentBottomNavIndex = index);
          _handleBottomNavigation(index);
        },
        userRole: UserRole.driver,
      ),
    );
  }

  Future<void> _refreshManifest() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Manifest updated successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _scanPassengerQR(Map<String, dynamic> passenger) {
    Navigator.pushNamed(context, '/qr-code-scanner-screen');
  }

  void _markPassengerBoarded(Map<String, dynamic> passenger) {
    setState(() {
      final index = _passengers.indexWhere((p) => p['id'] == passenger['id']);
      if (index != -1) {
        _passengers[index]['status'] = 'boarded';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${passenger['name']} marked as boarded'),
        backgroundColor: const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactPassenger(Map<String, dynamic> passenger) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${passenger['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${passenger['phone']}'),
            SizedBox(height: 2.h),
            Text(
              'Would you like to call this passenger?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling passenger...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _viewPassengerNotes(Map<String, dynamic> passenger) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notes for ${passenger['name']}'),
        content: Text(
          passenger['notes'] as String,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startTrip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Trip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you ready to start the trip?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              'Boarded: $_boardedCount/$_totalPassengers passengers',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Trip started! Safe travels.'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Start Trip'),
          ),
        ],
      ),
    );
  }

  void _showRouteNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening route navigation...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showConnectivityInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isOnline ? 'Online Mode' : 'Offline Mode'),
        content: Text(
          _isOnline
              ? 'You are connected to the internet. All updates are synced in real-time.'
              : 'You are offline. Changes will be synced when connection is restored.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Support Line',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            Text(
              '+234 800 123 4567',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Available 24/7 for emergencies',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling support...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _shareManifest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing manifest with support team...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/splash-screen');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/qr-code-scanner-screen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/splash-screen');
        break;
    }
  }
}
