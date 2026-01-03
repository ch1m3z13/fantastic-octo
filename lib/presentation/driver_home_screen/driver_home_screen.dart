import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/api/driver_api_service.dart';
import '../../core/api/auth_api_service.dart';
import '../../core/models/driver_models.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/quick_stats_widget.dart';

/// Driver Home Screen - Now with real API integration
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final DriverApiService _driverApi = DriverApiService();
  
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  DriverStats? _driverStats;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  /// Load driver stats from API
  Future<void> _loadDriverData() async {
    final authService = context.read<AuthService>();
    
    if (!authService.isAuthenticated || authService.userId == null) {
      setState(() {
        _errorMessage = 'Please login as a driver';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _driverApi.getDriverStats(authService.userId!);
      
      setState(() {
        _driverStats = stats;
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
        _errorMessage = 'Failed to load driver data';
      });
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await _loadDriverData();
  }

  void _handleToggleStatus() async {
    if (_driverStats == null) return;

    final authService = context.read<AuthService>();
    final currentStatus = DriverStatus.fromString(_driverStats!.status);
    final newStatus = currentStatus == DriverStatus.online
        ? DriverStatus.offline
        : DriverStatus.online;

    try {
      await _driverApi.updateDriverStatus(authService.userId!, newStatus);
      await _loadDriverData(); // Reload to get updated status

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${newStatus.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleEmergencySupport() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Call Support'),
              subtitle: const Text('+234 800 123 4567'),
              onTap: () {
                Navigator.pop(context);
                // Implement call functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              title: const Text('Report Incident'),
              onTap: () {
                Navigator.pop(context);
                // Implement incident reporting
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: theme.colorScheme.error,
              size: 24,
            ),
            onPressed: _handleEmergencySupport,
            tooltip: 'Emergency Support',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, AppRoutes.pendingBookingRequests);
            },
            tooltip: 'Pending Requests',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: 2.h),
                        Text(_errorMessage!),
                        SizedBox(height: 2.h),
                        ElevatedButton(
                          onPressed: _loadDriverData,
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status toggle card
                          _buildStatusCard(theme),
                          SizedBox(height: 2.h),

                          // Quick stats
                          QuickStatsWidget(stats: _convertStatsToMap()),
                          SizedBox(height: 2.h),

                          // Today's earnings
                          _buildEarningsCard(theme),
                          SizedBox(height: 2.h),

                          // Quick actions
                          _buildQuickActions(theme),
                          SizedBox(height: 2.h),

                          // Performance metrics
                          _buildPerformanceCard(theme),
                          
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        variant: CustomBottomBarVariant.driver,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    if (_driverStats == null) return SizedBox.shrink();

    final isOnline = _driverStats!.status.toUpperCase() == 'ONLINE';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isOnline ? Colors.green : Colors.grey)
                    .withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOnline ? Icons.check_circle : Icons.cancel,
                color: isOnline ? Colors.green : Colors.grey,
                size: 28,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOnline ? 'You\'re Online' : 'You\'re Offline',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isOnline
                        ? 'Ready to accept rides'
                        : 'Go online to accept rides',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isOnline,
              onChanged: (_) => _handleToggleStatus(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(ThemeData theme) {
    if (_driverStats == null) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Earnings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _driverStats!.earningsTodayDisplay,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '${_driverStats!.completedTripsToday} trips completed today',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Divider(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _driverStats!.earningsWeekDisplay,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _driverStats!.earningsMonthDisplay,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                theme,
                'Pending Requests',
                Icons.notifications_active,
                () => Navigator.pushNamed(context, AppRoutes.pendingBookingRequests),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildActionButton(
                theme,
                'View Manifest',
                Icons.list_alt,
                () => Navigator.pushNamed(context, AppRoutes.manifest),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              SizedBox(height: 1.h),
              Text(
                label,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(ThemeData theme) {
    if (_driverStats == null) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildStatRow(
              theme,
              'Rating',
              '${_driverStats!.ratingDisplay} ⭐',
            ),
            _buildStatRow(
              theme,
              'Total Trips',
              '${_driverStats!.completedTrips}',
            ),
            _buildStatRow(
              theme,
              'Total Ratings',
              '${_driverStats!.totalRatings}',
            ),
            _buildStatRow(
              theme,
              'Total Earnings',
              _driverStats!.totalEarningsDisplay,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Convert DriverStats to map format for QuickStatsWidget
  Map<String, dynamic> _convertStatsToMap() {
    if (_driverStats == null) {
      return {
        "rating": 0.0,
        "totalRatings": 0,
        "completedTripsThisWeek": 0,
        "weeklyEarnings": "₦0",
        "monthlyEarnings": "₦0",
      };
    }

    return {
      "rating": _driverStats!.rating,
      "totalRatings": _driverStats!.totalRatings,
      "completedTripsThisWeek": _driverStats!.completedTripsThisWeek,
      "weeklyEarnings": _driverStats!.earningsWeekDisplay,
      "monthlyEarnings": _driverStats!.earningsMonthDisplay,
    };
  }
}