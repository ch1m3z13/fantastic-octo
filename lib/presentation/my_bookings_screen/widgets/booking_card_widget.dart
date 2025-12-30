import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';

/// Booking card widget displaying ride information with swipe actions
class BookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isUpcoming;
  final VoidCallback? onCancel;
  final VoidCallback? onContact;
  final VoidCallback? onTrack;
  final VoidCallback? onViewQR;
  final VoidCallback? onRate;
  final VoidCallback? onBookAgain;
  final VoidCallback? onViewDetails;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.isUpcoming,
    this.onCancel,
    this.onContact,
    this.onTrack,
    this.onViewQR,
    this.onRate,
    this.onBookAgain,
    this.onViewDetails,
  });

  String _getTimeUntilDeparture(DateTime departureTime) {
    final now = DateTime.now();
    final difference = departureTime.difference(now);

    if (difference.isNegative) return 'Departed';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = booking["isActive"] == true;
    final departureTime = booking["date"] as DateTime;
    final timeUntil = _getTimeUntilDeparture(departureTime);

    Widget cardContent = Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(
                        booking["statusColor"] as int,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      booking["status"] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Color(booking["statusColor"] as int),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Time info
                  if (isUpcoming)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            size: 14,
                            color: isActive
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeUntil,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isActive
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Driver info
              Row(
                children: [
                  CustomImageWidget(
                    imageUrl: booking["driverAvatar"] as String,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    semanticLabel: booking["semanticLabel"] as String,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking["driverName"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              size: 14,
                              color: theme.colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              booking["driverRating"].toString(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking["vehicleInfo"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
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
                ],
              ),
              const SizedBox(height: 16),

              // Route info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                booking["pickupStop"] as String,
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            width: 2,
                            height: 24,
                            color: theme.colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          size: 20,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Drop-off',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                booking["dropoffStop"] as String,
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
              ),
              const SizedBox(height: 16),

              // Date and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(departureTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    booking["price"] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              // Action buttons
              if (isUpcoming && isActive) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onViewQR,
                        icon: CustomIconWidget(
                          iconName: 'qr_code_2',
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        label: const Text('Show QR'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onTrack,
                        icon: CustomIconWidget(
                          iconName: 'my_location',
                          size: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                        label: const Text('Track'),
                      ),
                    ),
                  ],
                ),
              ],

              // Rating prompt for completed rides
              if (!isUpcoming && booking["userRating"] == null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'How was your ride?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onRate,
                        child: const Text('Rate Now'),
                      ),
                    ],
                  ),
                ),
              ],

              // User rating display
              if (!isUpcoming && booking["userRating"] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Your rating: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < (booking["userRating"] as int)
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ],

              // Book again button for completed rides
              if (!isUpcoming) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onBookAgain,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    label: const Text('Book Again'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // Wrap with Slidable for upcoming bookings
    if (isUpcoming) {
      return Slidable(
        key: ValueKey(booking["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onContact?.call(),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: Icons.phone,
              label: 'Contact',
            ),
            SlidableAction(
              onPressed: (context) => onCancel?.call(),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: Icons.cancel,
              label: 'Cancel',
            ),
          ],
        ),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
