import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Loading skeleton widget for route cards
/// Maintains layout during data fetching
class LoadingSkeletonWidget extends StatelessWidget {
  const LoadingSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildShimmer(50, 50, isCircle: true),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmer(30.w, 2.h),
                            SizedBox(height: 0.5.h),
                            _buildShimmer(20.w, 1.5.h),
                          ],
                        ),
                      ),
                      _buildShimmer(15.w, 3.h),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildShimmer(double.infinity, 6.h),
                  SizedBox(height: 2.h),
                  _buildShimmer(40.w, 2.h),
                  SizedBox(height: 1.h),
                  _buildShimmer(60.w, 2.h),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmer(20.w, 3.h),
                      _buildShimmer(25.w, 4.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(double width, double height, {bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: isCircle
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(8),
      ),
    );
  }
}
