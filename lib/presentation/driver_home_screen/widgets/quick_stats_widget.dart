import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/models/driver_stats_model.dart';

class QuickStatsWidget extends StatelessWidget {
  final DriverStats stats;

  const QuickStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main Card: Earnings (Takes up 50% of width)
        Expanded(
          flex: 5,
          child: _buildStatCard(
            context,
            title: "Earnings",
            value: stats.formattedEarnings,
            icon: Icons.account_balance_wallet,
            color: const Color(0xFF2196F3), // Professional Blue
            isPrimary: true,
          ),
        ),
        SizedBox(width: 3.w),
        // Secondary Cards: Trips & Passengers
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildStatCard(
                context,
                title: "Trips",
                value: stats.tripsCompleted.toString(),
                icon: Icons.route,
                color: Colors.orange,
              ),
              SizedBox(height: 2.h),
              _buildStatCard(
                context,
                title: "Passengers",
                value: stats.passengersTransported.toString(),
                icon: Icons.people,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      height: isPrimary ? 18.h : 8.h, // Dynamic height based on importance
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isPrimary ? color : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary ? null : Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: isPrimary ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 5.w,
                  color: isPrimary ? Colors.white : color,
                ),
              ),
              if (isPrimary)
                Text(
                  "Today",
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
              fontSize: isPrimary ? 22.sp : 16.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isPrimary ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}