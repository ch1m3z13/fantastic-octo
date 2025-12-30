import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Batch action bar for multi-select mode
class BatchActionBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onAcceptAll;
  final VoidCallback onCancel;

  const BatchActionBarWidget({
    super.key,
    required this.selectedCount,
    required this.onAcceptAll,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onCancel();
              },
              icon: CustomIconWidget(
                iconName: 'close',
                size: 24,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                '$selectedCount selected',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onAcceptAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check',
                    size: 18,
                    color: theme.colorScheme.onSecondary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Accept All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
