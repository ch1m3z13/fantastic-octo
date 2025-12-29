import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PendingRequestsBannerWidget extends StatelessWidget {
  final int count;

  const PendingRequestsBannerWidget({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Action color (Orange/Red) to denote urgency
    const color = Color(0xFFFF5722); 

    return InkWell(
      onTap: () {
        // TODO: Navigate to PendingRequestsScreen
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Navigating to Pending Requests...')),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$count New Pickup Request${count > 1 ? 's' : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    "Tap to review and accept",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}