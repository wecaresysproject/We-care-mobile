import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:we_care/features/doctor/shared/widgets/app_shimmer.dart';

/// Loading bones for the header's name/specialty/photo block.
class DoctorProfileIdentityShimmer extends StatelessWidget {
  const DoctorProfileIdentityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppShimmerBone(width: 90, height: 12),
              SizedBox(height: 6),
              AppShimmerBone(width: 100, height: 12),
            ],
          ),
          SizedBox(width: 5.w),
          AppShimmerBone(width: 56.w, height: 44.h, radius: 16),
        ],
      ),
    );
  }
}

/// Loading bones for the "حجوزات اليوم" counters card.
class DoctorBookingsStatsShimmer extends StatelessWidget {
  const DoctorBookingsStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: AppShimmerBone(width: double.infinity, height: 150.h, radius: 32),
    );
  }
}

/// Loading bones for the target/achieved cards inside "الكشوفات الشهرية".
class DoctorMonthlyExaminationsShimmer extends StatelessWidget {
  const DoctorMonthlyExaminationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Row(
        children: [
          Expanded(
            child: AppShimmerBone(
              width: double.infinity,
              height: 100.h,
              radius: 22,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AppShimmerBone(
              width: double.infinity,
              height: 100.h,
              radius: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading bones for the three performance cards inside "الكشوفات الشهرية".
class DoctorPerformanceStatsShimmer extends StatelessWidget {
  const DoctorPerformanceStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget card() => Expanded(
          child: AppShimmerBone(
            width: double.infinity,
            height: 115.h,
            radius: 20,
          ),
        );
    return AppShimmer(
      child: Row(
        children: [
          card(),
          SizedBox(width: 8.w),
          card(),
          SizedBox(width: 8.w),
          card(),
        ],
      ),
    );
  }
}

/// Loading state for the ads carousel — identical to the patient home's
/// `BannerCrausalWidget` skeleton.
class DoctorAdBannerShimmer extends StatelessWidget {
  const DoctorAdBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(seconds: 1),
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// Loading bones for the "التعليقات" title and its comment bubbles.
class DoctorCommentsShimmer extends StatelessWidget {
  const DoctorCommentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const AppShimmerBone(width: 120, height: 18),
          SizedBox(height: 8.h),
          for (var i = 0; i < 3; i++) ...[
            AppShimmerBone(width: double.infinity, height: 80.h, radius: 12),
            SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}

/// Loading bones for the "المقيمين" ratings bar.
class DoctorRatingsBarShimmer extends StatelessWidget {
  const DoctorRatingsBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AppShimmer(
        child: AppShimmerBone(width: 260.w, height: 36.h, radius: 8),
      ),
    );
  }
}
