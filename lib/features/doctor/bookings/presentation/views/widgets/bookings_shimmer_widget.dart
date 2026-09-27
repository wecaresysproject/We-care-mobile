import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/features/doctor/shared/widgets/app_shimmer.dart';

/// Bone layout mirroring the bookings screen's shape for the loading state.
class BookingsShimmerWidget extends StatelessWidget {
  const BookingsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppShimmerBone.circle(diameter: 44),
                AppShimmerBone(width: 140.w, height: 44.h, radius: 12),
              ],
            ),
            SizedBox(height: 24.h),
            AppShimmerBone(width: double.infinity, height: 320.h, radius: 16),
            SizedBox(height: 16.h),
            AppShimmerBone(width: double.infinity, height: 220.h, radius: 16),
          ],
        ),
      ),
    );
  }
}
