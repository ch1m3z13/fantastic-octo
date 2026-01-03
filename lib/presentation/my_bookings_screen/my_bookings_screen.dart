import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../core/api/booking_api_service.dart';
import '../../core/api/auth_api_service.dart';
import '../../core/models/booking_models.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/booking_card_widget.dart';
import './widgets/empty_state_widget.dart';

/// My Bookings Screen - Displays user's ride history and upcoming trips
/// Now integrated with real API
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  final BookingApiService _bookingApi = BookingApiService();
  
  late TabController _tabController;
  int _currentBottomNavIndex = 1;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<BookingResponse> _allBookings = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Load bookings from API
  Future<void> _loadBookings() async {
    final authService = context.read<AuthService>();
    
    if (!authService.isAuthenticated || authService.userId == null) {
      setState(() {
        _errorMessage = 'Please login to view bookings';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookings = await _bookingApi.getRiderBookings(authService.userId!);
      
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookings';
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await _loadBookings();
    setState(() => _isRefreshing = false);
    
    if (mounted && _errorMessage == null) {
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

  /// Separate bookings into upcoming and completed
  List<BookingResponse> get _upcomingBookings {
    return _allBookings.where((booking) {
      final status = booking.status.toUpperCase();
      return status == 'PENDING' || 
             status == 'CONFIRMED' || 
             status == 'IN_PROGRESS';
    }).toList();
  }

  List<BookingResponse> get _completedBookings {
    return _allBookings.where((booking) {
      final status = booking.status.toUpperCase();
      return status == 'COMPLETED' || status == 'CANCELLED';
    }).toList();
  }

  /// Filter bookings by search query
  List<BookingResponse> _getFilteredBookings(List<BookingResponse> bookings) {
    if (_searchQuery.isEmpty) return bookings;
    
    return bookings.where((booking) {
      final searchLower = _searchQuery.toLowerCase();
      return booking.id.toLowerCase().contains(searchLower) ||
             booking.specialInstructions?.toLowerCase().contains(searchLower) == true;
    }).toList();
  }

  void _handleCancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Why are you cancelling this booking?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'e.g., Change of plans',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              maxLength: 200,
              onChanged: (value) => _cancelReason = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () => _confirmCancelBooking(bookingId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  String _cancelReason = '';

  Future<void> _confirmCancelBooking(String bookingId) async {
    Navigator.pop(context); // Close dialog

    try {
      await _bookingApi.cancelBooking(
        bookingId,
        _cancelReason.isEmpty ? 'User cancelled' : _cancelReason,
      );

      // Reload bookings
      await _loadBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleRateRide(BookingResponse booking) {
    int selectedRating = 0;
    String feedback = '';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Rate Your Ride'),
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
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() => selectedRating = index + 1);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Feedback (optional)',
                  hintText: 'Tell us about your experience',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 500,
                onChanged: (value) => feedback = value,
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
                  ? () => _submitRating(booking.id, selectedRating, feedback)
                  : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating(String bookingId, int rating, String feedback) async {
    Navigator.pop(context); // Close dialog

    try {
      await _bookingApi.rateRide(
        bookingId,
        rating,
        feedback.isEmpty ? null : feedback,
      );

      // Reload bookings
      await _loadBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your rating!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleViewDetails(BookingResponse booking) {
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
              _buildDetailRow('Booking ID', booking.id),
              _buildDetailRow('Status', booking.statusDisplay),
              _buildDetailRow('Fare', booking.fareDisplay),
              if (booking.distanceKm != null)
                _buildDetailRow('Distance', booking.distanceDisplay),
              _buildDetailRow('Passengers', '${booking.passengerCount}'),
              _buildDetailRow(
                'Pickup Time',
                DateFormat('MMM dd, yyyy - hh:mm a').format(
                  DateTime.parse(booking.scheduledPickupTime),
                ),
              ),
              if (booking.specialInstructions != null)
                _buildDetailRow('Instructions', booking.specialInstructions!),
              if (booking.riderRating != null)
                _buildDetailRow('Your Rating', '${booking.riderRating} ⭐'),
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
            width: 120,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBookings,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : Column(
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
                          bottom: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Upcoming (${_upcomingBookings.length})'),
                          Tab(text: 'Completed (${_completedBookings.length})'),
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
                                            AppRoutes.search,
                                          )
                                        : null,
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: filteredUpcoming.length,
                                    itemBuilder: (context, index) {
                                      final booking = filteredUpcoming[index];
                                      return BookingCardWidget(
                                        booking: _convertToMap(booking),
                                        isUpcoming: true,
                                        onCancel: () => _handleCancelBooking(booking.id),
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
                                        booking: _convertToMap(booking),
                                        isUpcoming: false,
                                        onRate: booking.riderRating == null
                                            ? () => _handleRateRide(booking)
                                            : null,
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
        },
        variant: CustomBottomBarVariant.rider,
      ),
    );
  }

  /// Convert BookingResponse to Map for existing BookingCardWidget
  Map<String, dynamic> _convertToMap(BookingResponse booking) {
    final scheduledTime = DateTime.parse(booking.scheduledPickupTime);
    final isInProgress = booking.status.toUpperCase() == 'IN_PROGRESS';
    
    return {
      "id": booking.id,
      "date": scheduledTime,
      "driverName": "Driver", // Will be updated when backend includes driver info
      "driverRating": 4.5,
      "driverAvatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "semanticLabel": "Driver avatar",
      "route": "Route ${booking.routeId.substring(0, 8)}",
      "pickupStop": "Pickup: ${booking.pickupLatitude}, ${booking.pickupLongitude}",
      "dropoffStop": "Dropoff: ${booking.dropoffLatitude}, ${booking.dropoffLongitude}",
      "vehicleInfo": "Vehicle info pending",
      "price": booking.fareDisplay,
      "seats": booking.passengerCount,
      "status": booking.statusDisplay,
      "statusColor": _getStatusColor(booking.status),
      "qrCode": "QR_${booking.id}",
      "isActive": isInProgress,
      "userRating": booking.riderRating?.toInt(),
      "completedAt": booking.completedAt != null 
          ? DateTime.parse(booking.completedAt!)
          : null,
    };
  }

  int _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return 0xFF388E3C; // Green
      case 'IN_PROGRESS':
        return 0xFFFF6F00; // Orange
      case 'COMPLETED':
        return 0xFF1B5E20; // Dark green
      case 'CANCELLED':
        return 0xFFD32F2F; // Red
      case 'PENDING':
      default:
        return 0xFF1976D2; // Blue
    }
  }
}