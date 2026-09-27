import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_home_model.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/ad_banner_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/comments_section_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_profile_header_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_timeline_stats_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examinations_section_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/performance_stats_row_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/quick_actions_grid_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/ratings_bar_widget.dart';

class DoctorHomeContentWidget extends StatelessWidget {
  const DoctorHomeContentWidget({super.key, required this.doctorHome});

  final DoctorHomeModel doctorHome;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorProfileHeaderWidget(
            doctorName: doctorHome.doctorName,
            specialty: doctorHome.specialty,
            doctorPhotoUrl: doctorHome.doctorPhotoUrl,
            clinicLogoUrl: doctorHome.clinicLogoUrl,
          ),
          SizedBox(height: 20.h),
          DoctorTimelineStatsWidget(
            waitingCount: doctorHome.waitingCount,
            followUpsCount: doctorHome.followUpsCount,
            currentBookingsCount: doctorHome.currentBookingsCount,
            allowedBookingsCount: doctorHome.allowedBookingsCount,
          ),
          SizedBox(height: 16.h),
          MonthlyExaminationsSectionWidget(
            achievedExaminationsCount: doctorHome.achievedExaminationsCount,
            monthlyTargetExaminationsCount:
                doctorHome.monthlyTargetExaminationsCount,
            yearlyTargetExaminationsCount:
                doctorHome.yearlyTargetExaminationsCount,
          ),
          SizedBox(height: 16.h),
          PerformanceStatsRowWidget(
            appearances: doctorHome.appearances,
            shares: doctorHome.shares,
            watches: doctorHome.watches,
          ),
          SizedBox(height: 30.h),
          const QuickActionsGridWidget(),
          SizedBox(height: 30.h),
          AdBannerWidget(imageUrls: doctorHome.adBannerImageUrls),
          SizedBox(height: 24.h),
          CommentsSectionWidget(
            commentsCount: doctorHome.commentsCount,
            comments: doctorHome.comments,
          ),
          SizedBox(height: 16.h),
          RatingsBarWidget(ratingsCount: doctorHome.ratingsCount),
        ],
      ),
    );
  }
}
