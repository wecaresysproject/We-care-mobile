import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/logic/cubit/bookings_cubit.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_header_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_shimmer.dart';

/// Shell for the single-list screens opened from the home's "حجوزات اليوم"
/// counters (الكشوفات / المتابعات / قائمة الانتظار). Owns its own
/// [BookingsCubit] (same bookings API as the full bookings screen), the
/// loading / error states, pull-to-refresh, a live minute ticker and the
/// [title] header; [sectionBuilder] lays out the one section underneath.
class BookingsSubpageScaffold extends StatelessWidget {
  const BookingsSubpageScaffold({
    super.key,
    required this.title,
    required this.sectionBuilder,
  });

  final String title;

  /// Builds the section for the loaded [bookings]. [now] drives the rows'
  /// minute counters; [processingBookingId] is the waiting patient whose
  /// accept / reject request is running (empty when none).
  final Widget Function(
    BuildContext context,
    BookingsModel bookings,
    DateTime now,
    String processingBookingId,
  ) sectionBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>()..getBookings(),
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        body: SafeArea(
          // Same fixed physical layout as the bookings screen.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: BlocConsumer<BookingsCubit, BookingsState>(
              listenWhen: (previous, current) =>
                  previous.actionStatus != current.actionStatus,
              listener: (context, state) {
                if (state.actionStatus == RequestStatus.failure) {
                  showError(state.actionMessage);
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.bookings != current.bookings ||
                  previous.processingBookingId != current.processingBookingId,
              builder: (context, state) {
                switch (state.status) {
                  case RequestStatus.initial:
                  case RequestStatus.loading:
                    return const _SubpageShimmer();
                  case RequestStatus.failure:
                    return ErrorViewWidget(
                      errorMessage: state.message,
                      onRetry: () =>
                          context.read<BookingsCubit>().getBookings(),
                    );
                  case RequestStatus.success:
                    return _SubpageContent(
                      title: title,
                      bookings: state.bookings!,
                      processingBookingId: state.processingBookingId,
                      sectionBuilder: sectionBuilder,
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SubpageContent extends StatefulWidget {
  const _SubpageContent({
    required this.title,
    required this.bookings,
    required this.processingBookingId,
    required this.sectionBuilder,
  });

  final String title;
  final BookingsModel bookings;
  final String processingBookingId;
  final Widget Function(BuildContext, BookingsModel, DateTime, String)
      sectionBuilder;

  @override
  State<_SubpageContent> createState() => _SubpageContentState();
}

class _SubpageContentState extends State<_SubpageContent> {
  /// Keeps the rows' minute counters ("متبقي / متأخر / منذ N دقيقة") live.
  late final Timer _minuteTicker;

  @override
  void initState() {
    super.initState();
    _minuteTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _minuteTicker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = widget.bookings;
    return RefreshIndicator(
      color: AppColorsManager.mainDarkBlue,
      onRefresh: () => context.read<BookingsCubit>().getBookings(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingsHeaderWidget(
              doctorName: bookings.doctorName,
              specialty: bookings.specialty,
              doctorPhotoUrl: bookings.doctorPhotoUrl,
              title: widget.title,
              showSubtitle: false,
            ),
            SizedBox(height: 20.h),
            widget.sectionBuilder(
              context,
              bookings,
              DateTime.now(),
              widget.processingBookingId,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubpageShimmer extends StatelessWidget {
  const _SubpageShimmer();

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
          ],
        ),
      ),
    );
  }
}
