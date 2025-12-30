import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Emergency button widget for safety features
/// Provides quick access to emergency contacts and trip sharing
class EmergencyButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.error,
      borderRadius: BorderRadius.circular(2.w),
      elevation: 4,
      child: InkWell(
        onTap: () {
          HapticFeedback.heavyImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: theme.colorScheme.onError,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
