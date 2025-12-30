import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/booking_card_widget.dart';
import './widgets/empty_state_widget.dart';

/// My Bookings Screen - Displays user's ride history and upcoming trips
/// Implements segmented control for Upcoming/Completed rides with pull-to-refresh
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 1; // Bookings tab active
  bool _isRefreshing = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for upcoming bookings
  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      "id": "BK001",
      "date": DateTime.now().add(const Duration(hours: 2)),
      "driverName": "Chukwuemeka Okafor",
      "driverRating": 4.8,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a man with short brown hair and a beard, wearing a dark t-shirt, sitting outdoors.",
      "route": "Dutse → Jabi",
      "pickupStop": "Dutse Police Station",
      "dropoffStop": "Jabi Lake Mall",
      "vehicleInfo": "Toyota Corolla - ABC 123 XY",
      "price": "₦1,500",
      "seats": 1,
      "status": "Confirmed",
      "statusColor": 0xFF388E3C,
      "qrCode": "QR_BK001_ACTIVE",
      "isActive": false,
    },
    {
      "id": "BK002",
      "date": DateTime.now().add(const Duration(minutes: 30)),
      "driverName": "Aisha Mohammed",
      "driverRating": 4.9,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a woman with long black hair wearing a white hijab and blue top, smiling at camera.",
      "route": "Dutse → Wuse",
      "pickupStop": "Dutse Junction",
      "dropoffStop": "Wuse Market",
      "vehicleInfo": "Honda Accord - XYZ 456 AB",
      "price": "₦1,200",
      "seats": 2,
      "status": "In Progress",
      "statusColor": 0xFFFF6F00,
      "qrCode": "QR_BK002_ACTIVE",
      "isActive": true,
    },
    {
      "id": "BK003",
      "date": DateTime.now().add(const Duration(days: 1, hours: 8)),
      "driverName": "Ibrahim Yusuf",
      "driverRating": 4.7,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a man with short black hair and glasses, wearing a grey polo shirt, standing in front of a brick wall.",
      "route": "Dutse → Maitama",
      "pickupStop": "Dutse Fuel Station",
      "dropoffStop": "Maitama District Center",
      "vehicleInfo": "Nissan Altima - DEF 789 CD",
      "price": "₦1,800",
      "seats": 1,
      "status": "Confirmed",
      "statusColor": 0xFF388E3C,
      "qrCode": "QR_BK003_PENDING",
      "isActive": false,
    },
  ];

  // Mock data for completed bookings
  final List<Map<String, dynamic>> _completedBookings = [
    {
      "id": "BK004",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "driverName": "Ngozi Eze",
      "driverRating": 4.6,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a woman with short curly black hair, wearing a yellow blouse, smiling warmly at camera.",
      "route": "Dutse → Jabi",
      "pickupStop": "Dutse Police Station",
      "dropoffStop": "Jabi Lake Mall",
      "vehicleInfo": "Toyota Camry - GHI 012 EF",
      "price": "₦1,500",
      "seats": 1,
      "status": "Completed",
      "statusColor": 0xFF1B5E20,
      "userRating": null,
      "completedAt": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": "BK005",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "driverName": "Oluwaseun Adebayo",
      "driverRating": 4.9,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a man with short black hair and a friendly smile, wearing a white shirt, standing outdoors.",
      "route": "Dutse → Central Area",
      "pickupStop": "Dutse Junction",
      "dropoffStop": "Central Business District",
      "vehicleInfo": "Honda Civic - JKL 345 GH",
      "price": "₦2,000",
      "seats": 1,
      "status": "Completed",
      "statusColor": 0xFF1B5E20,
      "userRating": 5,
      "completedAt": DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      "id": "BK006",
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "driverName": "Fatima Bello",
      "driverRating": 4.8,
      "driverAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel":
          "Profile photo of a woman with long black hair wearing a green hijab, smiling gently at camera.",
      "route": "Dutse → Wuse",
      "pickupStop": "Dutse Fuel Station",
      "dropoffStop": "Wuse Market",
      "vehicleInfo": "Toyota Corolla - MNO 678 IJ",
      "price": "₦1,200",
      "seats": 2,
      "status": "Completed",
      "statusColor": 0xFF1B5E20,
      "userRating": 4,
      "completedAt": DateTime.now().subtract(const Duration(days: 7)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookings updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<Map<String, dynamic>> _getFilteredBookings(
    List<Map<String, dynamic>> bookings,
  ) {
    if (_searchQuery.isEmpty) return bookings;
    return bookings.where((booking) {
      final route = (booking["route"] as String).toLowerCase();
      final driverName = (booking["driverName"] as String).toLowerCase();
      final pickupStop = (booking["pickupStop"] as String).toLowerCase();
      final dropoffStop = (booking["dropoffStop"] as String).toLowerCase();
      return route.contains(_searchQuery) ||
          driverName.contains(_searchQuery) ||
          pickupStop.contains(_searchQuery) ||
          dropoffStop.contains(_searchQuery);
    }).toList();
  }

  void _handleCancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _upcomingBookings.removeWhere(
                  (booking) => booking["id"] == bookingId,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleContactDriver(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact ${booking["driverName"]}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Call Driver'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling driver...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening messages...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleTrackRide(Map<String, dynamic> booking) {
    Navigator.pushNamed(context, '/splash-screen');
  }

  void _handleViewQRCode(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Boarding QR Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code_2',
                        size: 120,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking["qrCode"] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Show this QR code to your driver',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRateRide(Map<String, dynamic> booking) {
    int selectedRating = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Rate ${booking["driverName"]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was your ride?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() => selectedRating = index + 1);
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedRating > 0
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        final bookingIndex = _completedBookings.indexWhere(
                          (b) => b["id"] == booking["id"],
                        );
                        if (bookingIndex != -1) {
                          _completedBookings[bookingIndex]["userRating"] =
                              selectedRating;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your rating!'),
                        ),
                      );
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBookAgain(Map<String, dynamic> booking) {
    Navigator.pushNamed(context, '/splash-screen');
  }

  void _handleViewDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Booking Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Booking ID', booking["id"] as String),
              _buildDetailRow('Driver', booking["driverName"] as String),
              _buildDetailRow('Route', booking["route"] as String),
              _buildDetailRow('Pickup', booking["pickupStop"] as String),
              _buildDetailRow('Drop-off', booking["dropoffStop"] as String),
              _buildDetailRow('Vehicle', booking["vehicleInfo"] as String),
              _buildDetailRow('Fare', booking["price"] as String),
              _buildDetailRow(
                'Seats',
                '${booking["seats"]} passenger(s)',
              ),
              _buildDetailRow('Status', booking["status"] as String),
              _buildDetailRow(
                'Date',
                DateFormat(
                  'MMM dd, yyyy - hh:mm a',
                ).format(booking["date"] as DateTime),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredUpcoming = _getFilteredBookings(_upcomingBookings);
    final filteredCompleted = _getFilteredBookings(_completedBookings);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Bookings',
        centerTitle: false,
        notificationBadgeCount: 2,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Search bookings...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming bookings
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: filteredUpcoming.isEmpty
                      ? EmptyStateWidget(
                          title: _searchQuery.isEmpty
                              ? 'No Upcoming Rides'
                              : 'No Results Found',
                          message: _searchQuery.isEmpty
                              ? 'You don\'t have any upcoming bookings. Start by finding a ride!'
                              : 'Try adjusting your search terms',
                          iconName: _searchQuery.isEmpty
                              ? 'event_busy'
                              : 'search_off',
                          actionLabel: _searchQuery.isEmpty
                              ? 'Find a Ride'
                              : null,
                          onActionPressed: _searchQuery.isEmpty
                              ? () => Navigator.pushNamed(
                                  context,
                                  '/splash-screen',
                                )
                              : null,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredUpcoming.length,
                          itemBuilder: (context, index) {
                            final booking = filteredUpcoming[index];
                            return BookingCardWidget(
                              booking: booking,
                              isUpcoming: true,
                              onCancel: () =>
                                  _handleCancelBooking(booking["id"] as String),
                              onContact: () => _handleContactDriver(booking),
                              onTrack: () => _handleTrackRide(booking),
                              onViewQR: () => _handleViewQRCode(booking),
                              onViewDetails: () => _handleViewDetails(booking),
                            );
                          },
                        ),
                ),

                // Completed bookings
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: filteredCompleted.isEmpty
                      ? EmptyStateWidget(
                          title: _searchQuery.isEmpty
                              ? 'No Ride History'
                              : 'No Results Found',
                          message: _searchQuery.isEmpty
                              ? 'Your completed rides will appear here'
                              : 'Try adjusting your search terms',
                          iconName: _searchQuery.isEmpty
                              ? 'history'
                              : 'search_off',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredCompleted.length,
                          itemBuilder: (context, index) {
                            final booking = filteredCompleted[index];
                            return BookingCardWidget(
                              booking: booking,
                              isUpcoming: false,
                              onRate: () => _handleRateRide(booking),
                              onBookAgain: () => _handleBookAgain(booking),
                              onViewDetails: () => _handleViewDetails(booking),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentBottomNavIndex = index);
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/splash-screen');
              break;
            case 1:
              // Already on bookings screen
              break;
            case 2:
              Navigator.pushNamed(context, '/splash-screen');
              break;
            case 3:
              Navigator.pushNamed(context, '/splash-screen');
              break;
          }
        },
        userRole: UserRole.rider,
      ),
    );
  }
}
