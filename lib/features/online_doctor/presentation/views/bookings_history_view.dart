import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/logic/cubit/bookings_history_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_history_card_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_history_filter_dropdown.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "السجل السابق" — كل الكشوفات والاستشارات اللى تمت عبر التطبيق،
/// مع فلترين بإسم الطبيب وبالتخصص، وكل كارت بيفتح شاشة تفاصيله.
class BookingsHistoryView extends StatelessWidget {
  const BookingsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingsHistoryCubit>(
      create: (_) => getIt<BookingsHistoryCubit>()..loadHistory(),
      child: const _BookingsHistoryBody(),
    );
  }
}

class _BookingsHistoryBody extends StatelessWidget {
  const _BookingsHistoryBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingsHistoryCubit>();
    final state = context.watch<BookingsHistoryCubit>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: const _BookingsHistoryAppBar(),
            ),
            verticalSpacing(14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: BookingHistoryFilterDropdown(
                      placeholder: "إسم الطبيب",
                      icon: Icons.person_outline_rounded,
                      options: [
                        for (final doctor in state.filters.doctors) doctor.name,
                      ],
                      selectedValue: state.selectedDoctor?.name,
                      // القايمة بتعرض الاسم، والـ API بيتفلتر بالـ id.
                      onSelected: (name) => cubit.selectDoctor(
                        state.filters.doctors
                            .where((doctor) => doctor.name == name)
                            .firstOrNull,
                      ),
                    ),
                  ),
                  horizontalSpacing(10),
                  Expanded(
                    child: BookingHistoryFilterDropdown(
                      placeholder: "التخصص",
                      iconAsset:
                          "assets/images/doctor_examination_tool_icon.png",
                      options: state.filters.specialties,
                      selectedValue: state.selectedSpecialty,
                      onSelected: cubit.selectSpecialty,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const _HistoryScopeNote(),
            ),
            verticalSpacing(14),
            Expanded(child: _buildHistoryList(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, BookingsHistoryState state) {
    final cubit = context.read<BookingsHistoryCubit>();
    if (state.requestStatus == RequestStatus.failure) {
      return ErrorViewWidget(
        errorMessage: state.errorMessage,
        onRetry: cubit.getBookingsHistory,
      );
    }
    if (state.requestStatus != RequestStatus.success) {
      return Center(
        child: CircularProgressIndicator(color: AppColorsManager.mainDarkBlue),
      );
    }
    final filteredBookings = state.bookings;
    if (filteredBookings.isEmpty) {
      return state.hasActiveFilters
          ? _EmptyFilteredHistory(onClearFilters: cubit.clearFilters)
          : const _EmptyHistory();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      itemCount: filteredBookings.length,
      separatorBuilder: (context, index) => verticalSpacing(12),
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return BookingHistoryCardItem(
          booking: booking,
          onViewDetailsPressed: () => context.pushNamed(
            Routes.bookingDetailsView,
            arguments: booking,
          ),
        );
      },
    );
  }
}

/// سهم رجوع، "السجل السابق" فى المنتصف، وأيقونة تقويم فى النهاية.
class _BookingsHistoryAppBar extends StatelessWidget {
  const _BookingsHistoryAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomBackArrow(),
        Expanded(
          child: Text(
            "السجل السابق",
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(
              fontSize: 19.sp,
              color: Colors.black,
            ),
          ),
        ),
        // أيقونة التقويم زى التصميم — شكلية زى ما هى فى شاشة "حجوزاتى".
        Container(
          width: 40.w,
          height: 40.h,
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: OnlineDoctorTheme.iconTint,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            "assets/images/calender_icon.png",
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// تنويه إن السجل بيعرض كل اللى تم عبر المنصة.
class _HistoryScopeNote extends StatelessWidget {
  const _HistoryScopeNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.iconTint,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15.sp,
            color: AppColorsManager.mainDarkBlue,
          ),
          horizontalSpacing(6),
          Flexible(
            child: Text(
              "يعرض لك هذا السجل جميع الكشوفات والاستشارات "
              "التي تمت لك عبر WECARE SYS",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// حالة فاضية لما المريض ملوش أى مواعيد سابقة.
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "لا توجد مواعيد سابقة حتى الآن",
        style: AppTextStyles.font14blackWeight400.copyWith(
          fontWeight: FontWeight.w600,
          color: OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}

/// حالة فاضية لما الفلاتر متطابقش أى موعد.
class _EmptyFilteredHistory extends StatelessWidget {
  const _EmptyFilteredHistory({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48.sp,
            color: AppColorsManager.mainDarkBlue.withAlpha(120),
          ),
          verticalSpacing(12),
          Text(
            "لا توجد مواعيد مطابقة للفلاتر المختارة",
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
          verticalSpacing(14),
          Material(
            color: OnlineDoctorTheme.cardSurface,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: onClearFilters,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: OnlineDoctorTheme.fieldBorder),
                ),
                child: Text(
                  "مسح الفلاتر",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
