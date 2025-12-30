import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual booking request card widget
/// Displays passenger information and action buttons for accept/decline
class RequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RequestCardWidget({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUrgent = _isUrgent();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUrgent
            ? BorderSide(color: theme.colorScheme.error, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showRequestDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              SizedBox(height: 2.h),
              _buildPassengerInfo(theme),
              SizedBox(height: 2.h),
              _buildRouteInfo(theme),
              SizedBox(height: 2.h),
              _buildActionButtons(theme, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 2.w),
              Text(
                _formatTimestamp(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (_isUrgent())
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  size: 14,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: 1.w),
                Text(
                  _getTimeRemaining(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPassengerInfo(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: request['passengerPhoto'] != null
                ? CustomImageWidget(
                    imageUrl: request['passengerPhoto'],
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        request['passengerPhotoLabel'] ??
                        'Passenger profile photo',
                  )
                : Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        _getInitials(request['passengerName']),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request['passengerName'],
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
                    iconName: 'star',
                    size: 16,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${request['rating']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${request['tripCount']} trips',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (request['isRouteCompatible'] == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  size: 14,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Compatible',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRouteInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trip_origin',
                size: 20,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      request['pickupLocation'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.5.w),
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  width: 4,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.3,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                size: 20,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      request['destination'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showDeclineDialog(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'close',
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Decline',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showAcceptDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check',
                  size: 18,
                  color: theme.colorScheme.onSecondary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Accept',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRequestDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RequestDetailsSheet(request: request),
    );
  }

  void _showAcceptDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accept Booking Request?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm booking for ${request['passengerName']}',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Updated Passenger Count:',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '${(request['currentPassengers'] ?? 0) + 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Earnings:',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '₦${((request['currentEarnings'] ?? 0) + (request['fare'] ?? 0)).toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onAccept();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeclineDialog(BuildContext context) {
    final theme = Theme.of(context);
    String? selectedReason;
    final reasons = [
      'Route not compatible',
      'Vehicle at capacity',
      'Time conflict',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Decline Booking Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please select a reason (optional):',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              ...reasons.map(
                (reason) => RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) => setState(() => selectedReason = value),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDecline();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isUrgent() {
    final timestamp = request['timestamp'] as DateTime;
    final difference = DateTime.now().difference(timestamp);
    return difference.inMinutes > 8;
  }

  String _getTimeRemaining() {
    final timestamp = request['timestamp'] as DateTime;
    final expiryTime = timestamp.add(Duration(minutes: 10));
    final remaining = expiryTime.difference(DateTime.now());
    return '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String _formatTimestamp() {
    final timestamp = request['timestamp'] as DateTime;
    final difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, 1).toUpperCase();
  }
}

class _RequestDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> request;

  const _RequestDetailsSheet({required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailRow(theme, 'Passenger', request['passengerName']),
                  _buildDetailRow(
                    theme,
                    'Phone',
                    request['phone'] ?? '+234 XXX XXX XXXX',
                  ),
                  _buildDetailRow(theme, 'Pickup', request['pickupLocation']),
                  _buildDetailRow(theme, 'Destination', request['destination']),
                  _buildDetailRow(
                    theme,
                    'Fare',
                    '₦${request['fare']?.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(theme, 'Rating', '${request['rating']} ⭐'),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
