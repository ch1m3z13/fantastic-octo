import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Trip header showing route summary and start trip button
class TripHeaderWidget extends StatelessWidget {
  final String routeName;
  final String departureTime;
  final int totalPassengers;
  final int boardedPassengers;
  final bool canStartTrip;
  final VoidCallback onStartTrip;

  const TripHeaderWidget({
    super.key,
    required this.routeName,
    required this.departureTime,
    required this.totalPassengers,
    required this.boardedPassengers,
    required this.canStartTrip,
    required this.onStartTrip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardingProgress = totalPassengers > 0
        ? boardedPassengers / totalPassengers
        : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
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
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: 'directions_bus',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routeName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Departure: $departureTime',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Boarding Progress',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$boardedPassengers/$totalPassengers',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1.w),
                  child: LinearProgressIndicator(
                    value: boardingProgress,
                    minHeight: 1.h,
                    backgroundColor: theme.colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: canStartTrip ? onStartTrip : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canStartTrip
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: canStartTrip ? 'play_arrow' : 'hourglass_empty',
                    color: canStartTrip
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    canStartTrip ? 'Start Trip' : 'Waiting for Passengers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: canStartTrip
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
