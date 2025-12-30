import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual passenger card with boarding status and actions
class PassengerCardWidget extends StatelessWidget {
  final Map<String, dynamic> passenger;
  final VoidCallback onScanQR;
  final VoidCallback onMarkBoarded;
  final VoidCallback onContact;
  final VoidCallback onViewNotes;

  const PassengerCardWidget({
    super.key,
    required this.passenger,
    required this.onScanQR,
    required this.onMarkBoarded,
    required this.onContact,
    required this.onViewNotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = passenger['status'] as String;
    final hasNotes =
        passenger['notes'] != null && (passenger['notes'] as String).isNotEmpty;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.lightImpact();
              onContact();
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.phone,
            label: 'Call',
          ),
          if (hasNotes)
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onViewNotes();
              },
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onTertiary,
              icon: Icons.note,
              label: 'Notes',
            ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: _getStatusColor(status, theme).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getStatusColor(status, theme),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: passenger['photo'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                          semanticLabel: passenger['photoLabel'] as String,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status, theme),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: _getStatusIcon(status),
                          color: theme.colorScheme.onPrimary,
                          size: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger['name'] as String,
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
                            iconName: 'location_on',
                            color: theme.colorScheme.primary,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              passenger['pickupStop'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            status,
                            theme,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(status, theme),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status == 'pending') ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onScanQR();
                        },
                        icon: CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: theme.colorScheme.primary,
                          size: 5.w,
                        ),
                        label: Text(
                          'Scan QR',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onMarkBoarded();
                        },
                        icon: CustomIconWidget(
                          iconName: 'check_circle',
                          color: theme.colorScheme.onPrimary,
                          size: 5.w,
                        ),
                        label: Text(
                          'Mark Boarded',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'boarded':
        return const Color(0xFF388E3C);
      case 'no-show':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.tertiary;
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'boarded':
        return 'check_circle';
      case 'no-show':
        return 'cancel';
      default:
        return 'schedule';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'boarded':
        return 'Boarded';
      case 'no-show':
        return 'No-Show';
      default:
        return 'Pending';
    }
  }
}
