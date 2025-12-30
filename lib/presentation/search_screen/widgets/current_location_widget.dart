import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for displaying and selecting current location
class CurrentLocationWidget extends StatelessWidget {
  final String currentLocation;
  final VoidCallback onUseCurrentLocation;
  final ValueChanged<String> onManualInput;

  const CurrentLocationWidget({
    super.key,
    required this.currentLocation,
    required this.onUseCurrentLocation,
    required this.onManualInput,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'my_location',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Current Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          InkWell(
            onTap: onUseCurrentLocation,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'gps_fixed',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      currentLocation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            onChanged: onManualInput,
            decoration: InputDecoration(
              hintText: 'Or enter address manually',
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.5.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
