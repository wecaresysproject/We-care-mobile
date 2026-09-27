import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/features/doctor/shared/widgets/app_shimmer.dart';

/// Bone layout mirroring [DoctorHomeContentWidget]'s shape for the loading state.
class DoctorHomeShimmerWidget extends StatelessWidget {
  const DoctorHomeShimmerWidget({super.key});

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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        AppShimmerBone(width: 90, height: 12),
                        SizedBox(height: 6),
                        AppShimmerBone(width: 100, height: 12),
                      ],
                    ),
                    SizedBox(width: 5.w),
                    const AppShimmerBone(width: 56, height: 44, radius: 16),
                  ],
                ),
                const AppShimmerBone(width: 72, height: 44, radius: 10),
              ],
            ),
            SizedBox(height: 24.h),
            AppShimmerBone(width: double.infinity, height: 120.h, radius: 32),
            SizedBox(height: 16.h),
            AppShimmerBone(width: double.infinity, height: 170.h, radius: 32),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                    child: AppShimmerBone(
                        width: double.infinity, height: 130.h, radius: 26)),
                SizedBox(width: 14.w),
                Expanded(
                    child: AppShimmerBone(
                        width: double.infinity, height: 130.h, radius: 26)),
                SizedBox(width: 14.w),
                Expanded(
                    child: AppShimmerBone(
                        width: double.infinity, height: 130.h, radius: 26)),
              ],
            ),
            SizedBox(height: 32.h),
            AppShimmerBone(width: double.infinity, height: 173.h, radius: 8),
          ],
        ),
      ),
    );
  }
}
