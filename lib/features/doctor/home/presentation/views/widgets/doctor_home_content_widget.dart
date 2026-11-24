import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/home/logic/cubit/doctor_home_cubit.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/ad_banner_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/comments_section_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_home_section_shimmers.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_profile_header_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_timeline_stats_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/home_section_error_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examinations_section_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/performance_stats_row_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/quick_actions_grid_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/ratings_bar_widget.dart';

/// The home layout. Each API-backed section listens to its own slice of
/// [DoctorHomeState] and shows its own shimmer / error, so the page never
/// waits on a single request.
class DoctorHomeContentWidget extends StatelessWidget {
  const DoctorHomeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<DoctorHomeCubit>().refreshHome(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DoctorProfileHeaderWidget(),
            SizedBox(height: 20.h),
            const _BookingsStatsSection(),
            SizedBox(height: 16.h),
            const _AdsSection(),
            const QuickActionsGridWidget(),
            SizedBox(height: 24.h),
            const MonthlyExaminationsSectionWidget(
              examinationsContent: _MonthlyExaminationsSection(),
              performanceContent: _PerformanceStatsSection(),
            ),
            SizedBox(height: 30.h),
            const _CommentsSection(),
            SizedBox(height: 16.h),
            const _RatingsSection(),
          ],
        ),
      ),
    );
  }
}

class _BookingsStatsSection extends StatelessWidget {
  const _BookingsStatsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.bookingsStats != current.bookingsStats ||
          previous.bookingsStatsStatus != current.bookingsStatsStatus,
      builder: (context, state) => HomeSectionStateWidget(
        data: state.bookingsStats,
        isFailure: state.bookingsStatsStatus == RequestStatus.failure,
        shimmer: const DoctorBookingsStatsShimmer(),
        error: HomeSectionErrorWidget(
          height: 125.h,
          sectionName: 'حجوزات اليوم',
          onRetry: () => context.read<DoctorHomeCubit>().getBookingsStats(),
        ),
        builder: (stats) => DoctorTimelineStatsWidget(
          waitingCount: stats.waitingCount,
          followUpsCount: stats.followUpsCount,
          currentBookingsCount: stats.currentBookingsCount,
          allowedBookingsCount: stats.allowedBookingsCount,
          onBookingsTap: () => Navigator.pushNamed(
            context,
            Routes.doctorTodayExaminationsView,
          ),
          onFollowUpsTap: () => Navigator.pushNamed(
            context,
            Routes.doctorTodayFollowUpsView,
          ),
          onWaitingTap: () => Navigator.pushNamed(
            context,
            Routes.doctorWaitingListView,
          ),
        ),
      ),
    );
  }
}

class _MonthlyExaminationsSection extends StatelessWidget {
  const _MonthlyExaminationsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.monthlyExaminations != current.monthlyExaminations ||
          previous.monthlyExaminationsStatus !=
              current.monthlyExaminationsStatus,
      builder: (context, state) => HomeSectionStateWidget(
        data: state.monthlyExaminations,
        isFailure: state.monthlyExaminationsStatus == RequestStatus.failure,
        shimmer: const DoctorMonthlyExaminationsShimmer(),
        error: HomeSectionErrorWidget(
          height: 110.h,
          sectionName: 'الكشوفات الشهرية',
          onRetry: () =>
              context.read<DoctorHomeCubit>().getMonthlyExaminations(),
        ),
        builder: (examinations) => MonthlyExaminationsCardsRowWidget(
          achievedExaminationsCount: examinations.achievedCount,
          monthlyTargetExaminationsCount: examinations.targetCount,
        ),
      ),
    );
  }
}

class _PerformanceStatsSection extends StatelessWidget {
  const _PerformanceStatsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.performanceStats != current.performanceStats ||
          previous.performanceStatsStatus != current.performanceStatsStatus,
      builder: (context, state) => HomeSectionStateWidget(
        data: state.performanceStats,
        isFailure: state.performanceStatsStatus == RequestStatus.failure,
        shimmer: const DoctorPerformanceStatsShimmer(),
        error: HomeSectionErrorWidget(
          height: 115.h,
          sectionName: 'إحصائيات الأداء',
          onRetry: () => context.read<DoctorHomeCubit>().getPerformanceStats(),
        ),
        builder: (stats) => PerformanceStatsRowWidget(stats: stats),
      ),
    );
  }
}

/// Hidden entirely when there are no active ads; owns its bottom spacing so
/// the gap disappears with it.
class _AdsSection extends StatelessWidget {
  const _AdsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.ads != current.ads ||
          previous.adsStatus != current.adsStatus,
      builder: (context, state) {
        final ads = state.ads;
        if (ads != null && ads.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: HomeSectionStateWidget(
            data: ads,
            isFailure: state.adsStatus == RequestStatus.failure,
            shimmer: const DoctorAdBannerShimmer(),
            error: AdBannerErrorWidget(
              onRetry: () => context.read<DoctorHomeCubit>().getAds(),
            ),
            builder: (ads) => AdBannerWidget(imageUrls: ads),
          ),
        );
      },
    );
  }
}

class _CommentsSection extends StatelessWidget {
  const _CommentsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.latestComments != current.latestComments ||
          previous.latestCommentsStatus != current.latestCommentsStatus,
      builder: (context, state) => HomeSectionStateWidget(
        data: state.latestComments,
        isFailure: state.latestCommentsStatus == RequestStatus.failure,
        shimmer: const DoctorCommentsShimmer(),
        error: Column(
          children: [
            const CommentsHeaderWidget(),
            SizedBox(height: 8.h),
            HomeSectionErrorWidget(
              height: 130.h,
              sectionName: 'التعليقات',
              onRetry: () =>
                  context.read<DoctorHomeCubit>().getLatestComments(),
            ),
          ],
        ),
        builder: (latest) => CommentsSectionWidget(
          commentsCount: latest.totalCount,
          comments: latest.comments,
        ),
      ),
    );
  }
}

class _RatingsSection extends StatelessWidget {
  const _RatingsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
      buildWhen: (previous, current) =>
          previous.ratingsSummary != current.ratingsSummary ||
          previous.ratingsSummaryStatus != current.ratingsSummaryStatus,
      builder: (context, state) => HomeSectionStateWidget(
        data: state.ratingsSummary,
        isFailure: state.ratingsSummaryStatus == RequestStatus.failure,
        shimmer: const DoctorRatingsBarShimmer(),
        error: RatingsBarErrorWidget(
          onRetry: () => context.read<DoctorHomeCubit>().getRatingsSummary(),
        ),
        builder: (summary) => RatingsBarWidget(
          ratingsCount: summary.ratingsCount,
          averageRating: summary.averageRating,
        ),
      ),
    );
  }
}
