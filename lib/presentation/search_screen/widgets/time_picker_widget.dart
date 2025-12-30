import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for selecting departure time
class TimePickerWidget extends StatelessWidget {
  final bool isLeaveNow;
  final TimeOfDay? selectedTime;
  final ValueChanged<bool> onLeaveNowToggle;
  final VoidCallback onSelectTime;

  const TimePickerWidget({
    super.key,
    required this.isLeaveNow,
    this.selectedTime,
    required this.onLeaveNowToggle,
    required this.onSelectTime,
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
                iconName: 'schedule',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Departure Time',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onLeaveNowToggle(true),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isLeaveNow
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isLeaveNow
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Leave Now',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isLeaveNow
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onLeaveNowToggle(false);
                    onSelectTime();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: !isLeaveNow
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !isLeaveNow
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        selectedTime != null && !isLeaveNow
                            ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select Time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: !isLeaveNow
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
