import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Journey timeline widget showing pickup, route, and destination details
class JourneyTimelineWidget extends StatelessWidget {
  final Map<String, dynamic> journeyData;

  const JourneyTimelineWidget({super.key, required this.journeyData});

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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'route',
                size: 20.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Journey Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Pickup location
          _buildTimelineItem(
            context,
            icon: 'location_on',
            iconColor: theme.colorScheme.primary,
            title: 'Pickup Location',
            subtitle: journeyData['pickupLocation'] as String,
            time: journeyData['departureTime'] as String,
            description: journeyData['pickupDescription'] as String,
            isFirst: true,
          ),

          // Route path indicator
          _buildRoutePath(context),

          // Destination
          _buildTimelineItem(
            context,
            icon: 'flag',
            iconColor: const Color(0xFFFF6B35),
            title: 'Destination',
            subtitle: journeyData['destination'] as String,
            time: journeyData['arrivalTime'] as String,
            description: journeyData['destinationDescription'] as String,
            isLast: true,
          ),

          SizedBox(height: 2.h),

          // Journey stats
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  icon: 'schedule',
                  label: 'Duration',
                  value: journeyData['duration'] as String,
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  context,
                  icon: 'straighten',
                  label: 'Distance',
                  value: journeyData['distance'] as String,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  size: 18.sp,
                  color: iconColor,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 8.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isLast) SizedBox(height: 1.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutePath(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            width: 2,
            height: 1.h,
            margin: EdgeInsets.symmetric(vertical: 0.5.h),
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          size: 20.sp,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
