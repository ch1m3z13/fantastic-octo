import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Sort options widget for route listing
/// Provides quick access to common sorting criteria
class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSortChip(theme, 'Earliest', 'earliest', Icons.schedule),
            SizedBox(width: 2.w),
            _buildSortChip(theme, 'Lowest Price', 'price', Icons.attach_money),
            SizedBox(width: 2.w),
            _buildSortChip(theme, 'Highest Rated', 'rating', Icons.star),
            SizedBox(width: 2.w),
            _buildSortChip(theme, 'Most Seats', 'seats', Icons.event_seat),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = currentSort == value;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSortChanged(value);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon
                  .toString()
                  .split('.')
                  .last
                  .replaceAll('IconData(U+', '')
                  .replaceAll(')', ''),
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
