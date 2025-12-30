import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Trip progress timeline widget
/// Shows current trip status with visual indicators
class TripProgressTimelineWidget extends StatelessWidget {
  final String currentStatus;
  final String? estimatedTime;

  const TripProgressTimelineWidget({
    super.key,
    required this.currentStatus,
    this.estimatedTime,
  });

  List<Map<String, dynamic>> _getTimelineSteps() {
    return [
      {
        "status": "Driver En Route",
        "icon": "directions_car",
        "description": "Driver is on the way to pick you up",
      },
      {
        "status": "Arrived at Pickup",
        "icon": "location_on",
        "description": "Driver has arrived at your pickup point",
      },
      {
        "status": "Trip Started",
        "icon": "play_circle",
        "description": "Your journey has begun",
      },
      {
        "status": "Approaching Destination",
        "icon": "flag",
        "description": "Almost at your destination",
      },
    ];
  }

  int _getCurrentStepIndex() {
    final steps = _getTimelineSteps();
    return steps.indexWhere((step) => step["status"] == currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = _getTimelineSteps();
    final currentIndex = _getCurrentStepIndex();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              estimatedTime != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        'ETA: $estimatedTime',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final step = steps[index];
              final isActive = index == currentIndex;
              final isCompleted = index < currentIndex;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive || isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: isActive || isCompleted
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: theme.colorScheme.onPrimary,
                                  size: 5.w,
                                )
                              : CustomIconWidget(
                                  iconName: step["icon"] as String,
                                  color: isActive
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  size: 5.w,
                                ),
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          width: 2,
                          height: 6.h,
                          color: isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                    ],
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step["status"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isActive || isCompleted
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          step["description"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
