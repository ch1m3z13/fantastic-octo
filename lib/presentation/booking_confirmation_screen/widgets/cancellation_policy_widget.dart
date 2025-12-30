import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Cancellation policy section with time limits and refund terms
class CancellationPolicyWidget extends StatelessWidget {
  final Map<String, dynamic> policyData;

  const CancellationPolicyWidget({super.key, required this.policyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'policy',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Cancellation Policy',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildPolicyItem(
            context,
            theme,
            'Free cancellation up to ${policyData['freeCancellationTime']}',
            true,
          ),
          SizedBox(height: 1.h),
          _buildPolicyItem(
            context,
            theme,
            '${policyData['partialRefundPercentage']} refund if cancelled ${policyData['partialRefundTime']}',
            false,
          ),
          SizedBox(height: 1.h),
          _buildPolicyItem(
            context,
            theme,
            'No refund if cancelled less than ${policyData['noRefundTime']}',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(
    BuildContext context,
    ThemeData theme,
    String text,
    bool isHighlighted,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 0.5.h),
          child: CustomIconWidget(
            iconName: isHighlighted ? 'check_circle' : 'info',
            color: isHighlighted
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isHighlighted
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
