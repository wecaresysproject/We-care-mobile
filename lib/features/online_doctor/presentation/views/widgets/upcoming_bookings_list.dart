import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/my_bookings_dummy_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_card_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// قايمة كروت المواعيد القادمة — مشتركة بين شاشتى "حجوزاتى" و"الكشف":
/// "يتبقى على الموعد" بعد تنازلى لايف، و"حان وقت الموعد" بزرار دخول مفعّل،
/// مع إلغاء/تعديل الكشوفات ودايالوج تأكيد الإلغاء والحالة الفاضية.
/// "دخول عند الطبيب" بيفتح شاشة غرفة الكشف بحجز الكارت فى أى وقت —
/// الدخول الفعلى للمكالمة بيتفعل جواها عند حلول الموعد.
class UpcomingBookingsList extends StatefulWidget {
  const UpcomingBookingsList({super.key});

  @override
  State<UpcomingBookingsList> createState() => _UpcomingBookingsListState();
}

class _UpcomingBookingsListState extends State<UpcomingBookingsList> {
  late final List<BookingModel> _bookings = buildMyBookingsDummyData();

  /// تكة بتحدث العد التنازلى وبتنقل الكروت بين القسمين لما موعدها يحين.
  Timer? _countdownTicker;

  @override
  void initState() {
    super.initState();
    _countdownTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    super.dispose();
  }

  Future<void> _onEnterPressed(BookingModel booking) async {
    await context.pushNamed(
      Routes.examinationRoomView,
      arguments: booking,
    );
  }

  Future<void> _onCancelPressed(BookingModel booking) async {
    final isConfirmed = await _showCancelBookingDialog(booking);
    if (isConfirmed != true || !mounted) return;

    setState(() => _bookings.remove(booking));
    _showMessage("تم إلغاء الموعد بنجاح");
  }

  //! تعديل الموعد محتاج endpoints المواعيد المتاحة — هيتفعل مع ربط الحجوزات.
  void _onEditPressed() => _showMessage("تعديل الموعد سيكون متاحاً قريباً");

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColorsManager.mainDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              fontSize: 12.5.sp,
            ),
          ),
        ),
      );
  }

  Future<bool?> _showCancelBookingDialog(BookingModel booking) {
    return showDialog<bool>(
      context: context,
      // نفس ستايل دايالوجات فلو الحجز — طبقة بيضاء خفيفة مش سودا.
      barrierColor: Colors.white.withValues(alpha: 0.4),
      builder: (dialogContext) => _CancelBookingDialog(
        doctorName: booking.doctor.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final waitingBookings = _bookings.where((b) => b.isUpcoming(now)).toList()
      ..sort((a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime));
    final timeNowBookings = _bookings.where((b) => b.isTimeNow(now)).toList()
      ..sort((a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime));

    if (waitingBookings.isEmpty && timeNowBookings.isEmpty) {
      return const _EmptyUpcomingBookings();
    }

    // var sectionNumber = 0;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      children: [
        // if (waitingBookings.isNotEmpty) ...[
        //   _SectionHeader(
        //     title: "${++sectionNumber}. يتبقى على الموعد "
        //         "(${arabicCountdownLabel(waitingBookings.first.remaining(now))})",
        //   ),
        //   verticalSpacing(10),
        // ],
        ..._buildBookingCards(waitingBookings, now),
        // if (timeNowBookings.isNotEmpty) ...[
        //   if (waitingBookings.isNotEmpty) verticalSpacing(6),
        //   _SectionHeader(title: "${++sectionNumber}. حان وقت الموعد"),
        //   verticalSpacing(10),
        // ],
        ..._buildBookingCards(timeNowBookings, now),
      ],
    );
  }

  List<Widget> _buildBookingCards(List<BookingModel> bookings, DateTime now) {
    return [
      for (final booking in bookings) ...[
        BookingCardItem(
          booking: booking,
          now: now,
          onEnterPressed: () => _onEnterPressed(booking),
          onCancelPressed: booking.type.isExamination
              ? () => _onCancelPressed(booking)
              : null,
          onEditPressed: booking.type.isExamination ? _onEditPressed : null,
        ),
        verticalSpacing(12),
      ],
    ];
  }
}

// عناوين الأقسام المرقمة متعلقة مؤقتًا فى القايمة فوق — الويدجت محفوظة
// لحد ما يتقرر رجوعها أو شيلها نهائى.
// ignore: unused_element
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.font14blackWeight400.copyWith(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColorsManager.mainDarkBlue,
      ),
    );
  }
}

/// حالة فاضية للمواعيد القادمة — بتظهر لو المستخدم ألغى كل مواعيده.
class _EmptyUpcomingBookings extends StatelessWidget {
  const _EmptyUpcomingBookings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96.w,
            height: 96.h,
            padding: EdgeInsets.all(20.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCDE1F8), Color(0xFFE7E9EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/date_icon.png",
              fit: BoxFit.contain,
            ),
          ),
          verticalSpacing(16),
          Text(
            "لا توجد مواعيد قادمة حالياً",
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          verticalSpacing(8),
          Text(
            "احجز كشفك مع أفضل الأطباء أون لاين",
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// دايالوج تأكيد إلغاء الموعد — بيرجع `true` لو المستخدم أكد الإلغاء.
class _CancelBookingDialog extends StatelessWidget {
  const _CancelBookingDialog({required this.doctorName});

  final String doctorName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: OnlineDoctorTheme.offlineRed.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 28.sp,
                color: OnlineDoctorTheme.offlineRed,
              ),
            ),
            verticalSpacing(12),
            Text(
              "إلغاء الموعد",
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
            verticalSpacing(6),
            Text(
              "هل أنت متأكد من إلغاء موعد الكشف مع $doctorName؟",
              textAlign: TextAlign.center,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 12.sp,
                height: 1.6,
                color: OnlineDoctorTheme.mutedText,
              ),
            ),
            verticalSpacing(18),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: "رجوع",
                    backgroundColor: OnlineDoctorTheme.cardSurface,
                    contentColor: OnlineDoctorTheme.headingColor,
                    borderColor: OnlineDoctorTheme.fieldBorder,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: _DialogButton(
                    label: "تأكيد الإلغاء",
                    backgroundColor: OnlineDoctorTheme.offlineRed,
                    contentColor: Colors.white,
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.contentColor,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color contentColor;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ),
      ),
    );
  }
}
