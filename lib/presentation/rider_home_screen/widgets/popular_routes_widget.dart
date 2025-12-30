import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Horizontal scrolling cards showcasing popular routes
class PopularRoutesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> routes;
  final Function(String) onRouteTap;

  const PopularRoutesWidget({
    super.key,
    required this.routes,
    required this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Routes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/available-routes-screen');
                },
                child: Text(
                  'View All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 22.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return _buildRouteCard(context, route);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCard(BuildContext context, Map<String, dynamic> route) {
    final theme = Theme.of(context);
    final availableSeats = route['availableSeats'] as int;
    final totalSeats = route['totalSeats'] as int;
    final isAlmostFull = availableSeats <= 2;

    return Container(
      width: 75.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onRouteTap(route['id'].toString()),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['origin'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'arrow_forward',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  route['destination'] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        route['fare'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Departure Time
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Departs: ${route['departureTime']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Seats Availability
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'event_seat',
                      color: isAlmostFull
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$availableSeats/$totalSeats seats available',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isAlmostFull
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Driver Info
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: route['driverAvatar'] as String,
                          width: 8.w,
                          height: 8.w,
                          fit: BoxFit.cover,
                          semanticLabel:
                              "Driver ${route['driverName']} profile photo",
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['driverName'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'star',
                                color: const Color(0xFFFFB74D),
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${route['rating']} (${route['totalRides']} rides)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
