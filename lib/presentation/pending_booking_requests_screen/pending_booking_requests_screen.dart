import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/batch_action_bar_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/request_card_widget.dart';

/// Pending Booking Requests Screen for driver role
/// Displays incoming ride requests with accept/decline functionality
class PendingBookingRequestsScreen extends StatefulWidget {
  const PendingBookingRequestsScreen({super.key});

  @override
  State<PendingBookingRequestsScreen> createState() =>
      _PendingBookingRequestsScreenState();
}

class _PendingBookingRequestsScreenState
    extends State<PendingBookingRequestsScreen> {
  int _currentBottomNavIndex = 1;
  bool _isRefreshing = false;
  bool _isBatchMode = false;
  final Set<int> _selectedRequests = {};
  List<Map<String, dynamic>> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _pendingRequests = [
      {
        'id': 1,
        'passengerName': 'Chioma Okafor',
        'passengerPhoto':
            'https://img.rocket.new/generatedImages/rocket_gen_img_1f6a0e5ca-1763295077315.png',
        'passengerPhotoLabel':
            'Professional photo of a young African woman with natural hair wearing a white blouse',
        'rating': 4.8,
        'tripCount': 47,
        'pickupLocation': 'Dutse Junction, Virtual Bus Stop A',
        'destination': 'Jabi Lake Mall',
        'fare': 1500.0,
        'timestamp': DateTime.now().subtract(Duration(minutes: 3)),
        'isRouteCompatible': true,
        'currentPassengers': 2,
        'currentEarnings': 3000.0,
        'phone': '+234 803 456 7890',
      },
      {
        'id': 2,
        'passengerName': 'Ibrahim Musa',
        'passengerPhoto':
            'https://img.rocket.new/generatedImages/rocket_gen_img_1af4cdc9f-1763301735986.png',
        'passengerPhotoLabel':
            'Professional headshot of a young African man with short hair wearing a dark suit',
        'rating': 4.9,
        'tripCount': 62,
        'pickupLocation': 'Dutse Alheri, Virtual Bus Stop B',
        'destination': 'Wuse Market',
        'fare': 1200.0,
        'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
        'isRouteCompatible': true,
        'currentPassengers': 2,
        'currentEarnings': 3000.0,
        'phone': '+234 805 123 4567',
      },
      {
        'id': 3,
        'passengerName': 'Blessing Adeyemi',
        'passengerPhoto':
            'https://images.unsplash.com/photo-1711468964388-bf87076f6846',
        'passengerPhotoLabel':
            'Smiling African woman with braided hair wearing a colorful traditional outfit',
        'rating': 4.7,
        'tripCount': 34,
        'pickupLocation': 'Dutse Makaranta, Virtual Bus Stop C',
        'destination': 'Central Area',
        'fare': 1800.0,
        'timestamp': DateTime.now().subtract(Duration(minutes: 9)),
        'isRouteCompatible': false,
        'currentPassengers': 2,
        'currentEarnings': 3000.0,
        'phone': '+234 807 890 1234',
      },
      {
        'id': 4,
        'passengerName': 'Emeka Nwosu',
        'passengerPhoto':
            'https://img.rocket.new/generatedImages/rocket_gen_img_12ab9ea78-1763296173898.png',
        'passengerPhotoLabel':
            'Young African man with glasses wearing a casual blue shirt outdoors',
        'rating': 5.0,
        'tripCount': 89,
        'pickupLocation': 'Dutse Main Road, Virtual Bus Stop D',
        'destination': 'Maitama District',
        'fare': 2000.0,
        'timestamp': DateTime.now().subtract(Duration(minutes: 2)),
        'isRouteCompatible': true,
        'currentPassengers': 2,
        'currentEarnings': 3000.0,
        'phone': '+234 809 567 8901',
      },
    ];
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _loadMockData();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Requests updated'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleAcceptRequest(int requestId) {
    setState(() {
      _pendingRequests.removeWhere((request) => request['id'] == requestId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 2.w),
            Text('Booking request accepted'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Manifest',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.manifest, // ✅ Fixed
            );
          },
        ),
      ),
    );
  }

  void _handleDeclineRequest(int requestId) {
    setState(() {
      _pendingRequests.removeWhere((request) => request['id'] == requestId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(iconName: 'info', size: 20, color: Colors.white),
            SizedBox(width: 2.w),
            Text('Booking request declined'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleBatchMode(int requestId) {
    setState(() {
      if (_isBatchMode) {
        _selectedRequests.contains(requestId)
            ? _selectedRequests.remove(requestId)
            : _selectedRequests.add(requestId);
      } else {
        _isBatchMode = true;
        _selectedRequests.add(requestId);
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _cancelBatchMode() {
    setState(() {
      _isBatchMode = false;
      _selectedRequests.clear();
    });
  }

  void _acceptAllSelected() {
    final selectedIds = List<int>.from(_selectedRequests);
    setState(() {
      _pendingRequests.removeWhere(
        (request) => selectedIds.contains(request['id']),
      );
      _isBatchMode = false;
      _selectedRequests.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedIds.length} requests accepted'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pending Requests',
        variant: AppBarVariant.notifications,
        actions: [
          if (_pendingRequests.isNotEmpty && !_isBatchMode)
            IconButton(
              onPressed: _handleRefresh,
              icon: _isRefreshing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'refresh',
                      size: 24,
                      color: theme.colorScheme.onSurface,
                    ),
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _buildBody(theme),
      bottomNavigationBar: _isBatchMode
          ? BatchActionBarWidget(
              selectedCount: _selectedRequests.length,
              onAcceptAll: _acceptAllSelected,
              onCancel: _cancelBatchMode,
            )
          : CustomBottomBar(
              currentIndex: _currentBottomNavIndex,
              onTap: (index) {
                setState(() => _currentBottomNavIndex = index);
              },
              variant: CustomBottomBarVariant.driver,
            ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_pendingRequests.isEmpty) {
      return EmptyStateWidget(estimatedNextRequest: 'Around 7:30 AM');
    }

    return Column(
      children: [
        _buildHeader(theme),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 2.h),
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final request = _pendingRequests[index];
                final isSelected = _selectedRequests.contains(request['id']);

                return GestureDetector(
                  onLongPress: () => _toggleBatchMode(request['id']),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: _isBatchMode && !isSelected ? 0.5 : 1.0,
                        child: RequestCardWidget(
                          request: request,
                          onAccept: () => _handleAcceptRequest(request['id']),
                          onDecline: () => _handleDeclineRequest(request['id']),
                        ),
                      ),
                      if (_isBatchMode)
                        Positioned(
                          top: 2.h,
                          right: 6.w,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      size: 16,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'notifications_active',
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_pendingRequests.length} Pending ${_pendingRequests.length == 1 ? 'Request' : 'Requests'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Review and respond to booking requests',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (_isRefreshing)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}