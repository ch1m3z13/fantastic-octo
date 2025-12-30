import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

/// Balance Card Widget - Displays current wallet balance with visual indicators
class BalanceCardWidget extends StatelessWidget {
  final double balance;
  final bool isLowBalance;
  final VoidCallback? onTapCard;

  const BalanceCardWidget({
    super.key,
    required this.balance,
    this.isLowBalance = false,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat('#,##0.00');

    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLowBalance
                ? [Color(0xFFFF6F00), Color(0xFFFF8F00)]
                : [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14.sp,
                  ),
                ),
                if (isLowBalance)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Low Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              '₦${currencyFormat.format(balance)}',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Tap for details',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
