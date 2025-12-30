import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Location and network status indicator widget
class LocationStatusWidget extends StatelessWidget {
  final bool isLocationEnabled;
  final bool isNetworkConnected;
  final String currentLocation;
  final VoidCallback onLocationTap;

  const LocationStatusWidget({
    super.key,
    required this.isLocationEnabled,
    required this.isNetworkConnected,
    required this.currentLocation,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Location Icon
          CustomIconWidget(
            iconName: isLocationEnabled ? 'location_on' : 'location_off',
            color: isLocationEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
            size: 20,
          ),

          SizedBox(width: 2.w),

          // Location Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLocationEnabled ? 'Current Location' : 'Location Disabled',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (isLocationEnabled) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    currentLocation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Network Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isNetworkConnected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isNetworkConnected ? 'wifi' : 'wifi_off',
                  color: isNetworkConnected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  isNetworkConnected ? 'Online' : 'Offline',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isNetworkConnected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 2.w),

          // Settings Button
          InkWell(
            onTap: onLocationTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: CustomIconWidget(
                iconName: 'settings',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
