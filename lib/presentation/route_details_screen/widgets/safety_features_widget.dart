import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Safety features widget highlighting security measures
class SafetyFeaturesWidget extends StatelessWidget {
  final Map<String, dynamic> safetyData;

  const SafetyFeaturesWidget({super.key, required this.safetyData});

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
                iconName: 'security',
                size: 20.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Safety Features',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Safety features list
          _buildSafetyItem(
            context,
            icon: 'verified_user',
            title: 'Driver Verification',
            subtitle: safetyData['driverVerification'] as String,
            isVerified: true,
          ),
          SizedBox(height: 1.5.h),

          _buildSafetyItem(
            context,
            icon: 'build',
            title: 'Vehicle Inspection',
            subtitle: 'Last inspection: ${safetyData['lastInspection']}',
            isVerified: true,
          ),
          SizedBox(height: 1.5.h),

          _buildSafetyItem(
            context,
            icon: 'phone_in_talk',
            title: 'Emergency Contact',
            subtitle: safetyData['emergencyContact'] as String,
            isVerified: false,
          ),
          SizedBox(height: 2.h),

          // Emergency button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'emergency',
                  size: 20.sp,
                  color: const Color(0xFFD32F2F),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Support',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD32F2F),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '24/7 support available',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool isVerified,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isVerified
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isVerified
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              size: 18.sp,
              color: isVerified
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isVerified) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      size: 14.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
