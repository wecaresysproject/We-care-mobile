import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/bookings_history_dummy_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_history_card_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_history_filter_dropdown.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "السجل السابق" — كل الكشوفات والاستشارات اللى تمت عبر التطبيق،
/// مع فلترين بإسم الطبيب وبالتخصص، وكل كارت بيفتح شاشة تفاصيله.
class BookingsHistoryView extends StatefulWidget {
  const BookingsHistoryView({super.key});

  @override
  State<BookingsHistoryView> createState() => _BookingsHistoryViewState();
}

class _BookingsHistoryViewState extends State<BookingsHistoryView> {
  final List<BookingHistoryModel> _historyBookings = bookingsHistoryDummyData;

  String? _selectedDoctorName;
  String? _selectedSpecialization;

  /// القيم المتاحة فى الفلترين — من غير تكرار وبترتيب ظهورها فى السجل.
  List<String> get _doctorNames =>
      _historyBookings.map((b) => b.doctor.name).toSet().toList();

  List<String> get _specializations =>
      _historyBookings.map((b) => b.doctor.specialization).toSet().toList();

  List<BookingHistoryModel> get _filteredBookings => _historyBookings
      .where(
        (b) =>
            (_selectedDoctorName == null ||
                b.doctor.name == _selectedDoctorName) &&
            (_selectedSpecialization == null ||
                b.doctor.specialization == _selectedSpecialization),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
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
                      options: _doctorNames,
                      selectedValue: _selectedDoctorName,
                      onSelected: (value) =>
                          setState(() => _selectedDoctorName = value),
                    ),
                  ),
                  horizontalSpacing(10),
                  Expanded(
                    child: BookingHistoryFilterDropdown(
                      placeholder: "التخصص",
                      iconAsset:
                          "assets/images/doctor_examination_tool_icon.png",
                      options: _specializations,
                      selectedValue: _selectedSpecialization,
                      onSelected: (value) =>
                          setState(() => _selectedSpecialization = value),
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
            Expanded(child: _buildHistoryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final filteredBookings = _filteredBookings;
    if (filteredBookings.isEmpty) {
      return _EmptyFilteredHistory(
        onClearFilters: () => setState(() {
          _selectedDoctorName = null;
          _selectedSpecialization = null;
        }),
      );
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
          onViewDetailsPressed: () async {
            await context.pushNamed(
              Routes.bookingDetailsView,
              arguments: booking,
            );
          },
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
