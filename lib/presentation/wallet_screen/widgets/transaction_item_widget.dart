import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

/// Transaction Item Widget - Displays individual transaction in history list
class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction['type'] == 'credit';
    final amount = transaction['amount'] as double;
    final timestamp = transaction['timestamp'] as DateTime;
    final description = transaction['description'] as String;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Transaction Icon
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color:
                    (isCredit
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error)
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Transaction Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}₦${NumberFormat('#,##0.00').format(amount)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCredit
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.3.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    transaction['status'].toString().toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
