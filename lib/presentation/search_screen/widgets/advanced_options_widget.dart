import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for advanced search options
class AdvancedOptionsWidget extends StatelessWidget {
  final bool isExpanded;
  final int passengerCount;
  final bool hasAccessibilityRequirements;
  final VoidCallback onToggleExpanded;
  final ValueChanged<int> onPassengerCountChanged;
  final ValueChanged<bool> onAccessibilityToggle;

  const AdvancedOptionsWidget({
    super.key,
    required this.isExpanded,
    required this.passengerCount,
    required this.hasAccessibilityRequirements,
    required this.onToggleExpanded,
    required this.onPassengerCountChanged,
    required this.onAccessibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Advanced Options',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: theme.colorScheme.outline),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Passengers',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: passengerCount > 1
                            ? () => onPassengerCountChanged(passengerCount - 1)
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'remove_circle_outline',
                          color: passengerCount > 1
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              passengerCount.toString(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: passengerCount < 4
                            ? () => onPassengerCountChanged(passengerCount + 1)
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'add_circle_outline',
                          color: passengerCount < 4
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Accessibility Requirements',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Switch(
                        value: hasAccessibilityRequirements,
                        onChanged: onAccessibilityToggle,
                      ),
                    ],
                  ),
                  if (hasAccessibilityRequirements) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'accessible',
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Wheelchair accessible vehicles will be prioritized',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
