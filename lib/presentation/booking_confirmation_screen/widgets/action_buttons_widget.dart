import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Action buttons for calendar and sharing functionality
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onAddToCalendar;
  final VoidCallback onShareTripDetails;

  const ActionButtonsWidget({
    super.key,
    required this.onAddToCalendar,
    required this.onShareTripDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onAddToCalendar();
              },
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Add to Calendar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onShareTripDetails();
              },
              icon: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Share Trip',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
