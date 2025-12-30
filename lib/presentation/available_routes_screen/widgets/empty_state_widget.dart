import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget shown when no routes are available
/// Provides helpful suggestions to adjust search criteria
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAdjustSearch;

  const EmptyStateWidget({super.key, required this.onAdjustSearch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Routes Found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'We couldn\'t find any routes matching your search criteria. Try adjusting your filters or search at a different time.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: onAdjustSearch,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Adjust Search'),
            ),
            SizedBox(height: 2.h),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/search-screen'),
              icon: CustomIconWidget(
                iconName: 'search',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              label: const Text('New Search'),
            ),
          ],
        ),
      ),
    );
  }
}
