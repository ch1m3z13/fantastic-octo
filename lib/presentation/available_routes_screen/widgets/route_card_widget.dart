import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual route card displaying driver and vehicle information
/// Supports swipe actions for save, share, and report
class RouteCardWidget extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onReport;

  const RouteCardWidget({
    super.key,
    required this.route,
    required this.onTap,
    this.onSave,
    this.onShare,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(route['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onSave?.call();
              },
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.bookmark_outline,
              label: 'Save',
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onShare?.call();
              },
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onReport?.call();
              },
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              icon: Icons.flag,
              label: 'Report',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverSection(theme),
                  SizedBox(height: 2.h),
                  _buildVehicleSection(theme),
                  SizedBox(height: 2.h),
                  _buildRouteDetailsSection(theme),
                  SizedBox(height: 2.h),
                  _buildBottomSection(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSection(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CustomImageWidget(
            imageUrl: route['driverPhoto'] as String,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            semanticLabel: route['driverPhotoLabel'] as String,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route['driverName'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: const Color(0xFFFFA000),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${route['rating']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '(${route['totalTrips']} trips)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: (route['availableSeats'] as int) > 2
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : const Color(0xFFFF6B35).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${route['availableSeats']} seats',
            style: theme.textTheme.bodySmall?.copyWith(
              color: (route['availableSeats'] as int) > 2
                  ? theme.colorScheme.primary
                  : const Color(0xFFFF6B35),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'directions_car',
            color: theme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${route['vehicleMake']} ${route['vehicleModel']}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${route['vehicleColor']} • ${route['plateNumber']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDetailsSection(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Departure: ${route['departureTime']}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                route['pickupLocation'] as String,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'access_time',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'ETA: ${route['estimatedArrival']}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '₦${route['fare']}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'View Details',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
