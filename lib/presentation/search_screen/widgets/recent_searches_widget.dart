import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for displaying recent searches
class RecentSearchesWidget extends StatelessWidget {
  final List<Map<String, String>> recentSearches;
  final ValueChanged<Map<String, String>> onSearchSelected;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onSearchSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'history',
              color: theme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              'Recent Searches',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: recentSearches.map((search) {
            return InkWell(
              onTap: () => onSearchSelected(search),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      search["destination"] ?? "",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
