import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Quick access shortcuts for common actions
class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onLocationToggle;
  final VoidCallback onFavoritesView;
  final bool isLocationEnabled;

  const QuickActionsWidget({
    super.key,
    required this.onLocationToggle,
    required this.onFavoritesView,
    required this.isLocationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              context,
              icon: isLocationEnabled ? 'location_on' : 'location_off',
              label: isLocationEnabled ? 'Location On' : 'Enable Location',
              color: isLocationEnabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              onTap: onLocationToggle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildActionCard(
              context,
              icon: 'favorite',
              label: 'Favorite Routes',
              color: const Color(0xFFFF6B35),
              onTap: onFavoritesView,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
