import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/driver_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/pending_requests_banner_widget.dart';
import 'widgets/quick_stats_widget.dart';
import 'widgets/route_summary_card_widget.dart';

class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  bool _isOnline = true; // Local state for the toggle switch

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).user;
    final dashboardState = ref.watch(driverDashboardProvider);
    final stats = dashboardState.stats;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme, user?.fullName ?? 'Driver'),
      body: RefreshIndicator(
        onRefresh: () => ref.read(driverDashboardProvider.notifier).refreshStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Status & Map Placeholder
              _buildMapPlaceholder(theme),
              SizedBox(height: 3.h),

              // 2. Tier 1: Action Items
              if (stats.pendingRequests > 0) ...[
                PendingRequestsBannerWidget(count: stats.pendingRequests),
                SizedBox(height: 2.h),
              ],
              
              // 3. Tier 1: Active Route Info
              RouteSummaryCardWidget(
                nextStopName: stats.nextStopName,
                etaMinutes: stats.nextStopEtaMinutes,
                activePassengers: stats.activePassengers,
              ),
              SizedBox(height: 3.h),

              // 4. Tier 2: Daily Performance
              Text(
                "Today's Performance",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              
              if (dashboardState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                QuickStatsWidget(stats: stats),

              SizedBox(height: 3.h),
              
              // 5. Tier 3: Session Info (Footer)
              _buildSessionFooter(theme, stats.formattedOnlineTime, stats.formattedAcceptanceRate),
              SizedBox(height: 5.h), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, String userName) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            userName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        // Online/Offline Switch
        Container(
          margin: EdgeInsets.only(right: 4.w),
          child: Row(
            children: [
              Text(
                _isOnline ? 'ONLINE' : 'OFFLINE',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isOnline ? Colors.green : Colors.grey,
                ),
              ),
              SizedBox(width: 2.w),
              Switch(
                value: _isOnline,
                activeThumbColor: Colors.green,
                onChanged: (val) {
                  setState(() => _isOnline = val);
                  // TODO: Call API to toggle status
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMapPlaceholder(ThemeData theme) {
    return Container(
      height: 20.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 8.w, color: theme.colorScheme.onSurfaceVariant),
            SizedBox(height: 1.h),
            Text(
              "Map View Loading...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionFooter(ThemeData theme, String timeOnline, String acceptance) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFooterItem(theme, Icons.timer_outlined, "Time Online", timeOnline),
          Container(height: 4.h, width: 1, color: theme.colorScheme.outlineVariant),
          _buildFooterItem(theme, Icons.thumb_up_outlined, "Acceptance", acceptance),
        ],
      ),
    );
  }

  Widget _buildFooterItem(ThemeData theme, IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 4.w, color: theme.colorScheme.onSurfaceVariant),
            SizedBox(width: 1.w),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}