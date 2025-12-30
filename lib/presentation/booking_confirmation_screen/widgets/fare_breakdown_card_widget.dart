import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Fare breakdown card showing itemized costs and payment method
class FareBreakdownCardWidget extends StatelessWidget {
  final Map<String, dynamic> fareData;

  const FareBreakdownCardWidget({super.key, required this.fareData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fare Breakdown',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          _buildFareItem(
            context,
            theme,
            'Base Fare',
            fareData['baseFare'] as String,
            false,
          ),
          SizedBox(height: 1.h),
          _buildFareItem(
            context,
            theme,
            'Service Fee',
            fareData['serviceFee'] as String,
            false,
          ),
          SizedBox(height: 1.h),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
          SizedBox(height: 1.h),
          _buildFareItem(
            context,
            theme,
            'Total Amount',
            fareData['totalAmount'] as String,
            true,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        fareData['paymentMethod'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareItem(
    BuildContext context,
    ThemeData theme,
    String label,
    String amount,
    bool isTotal,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}
