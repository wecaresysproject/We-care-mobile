import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_type_badge.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت موعد سابق فى شاشة "السجل السابق" — بيانات الطبيب وتفاصيل الموعد،
/// وفوتر فيه حالة الموعد وتقييم الطبيب وتعليقاته وزرار "عرض التفاصيل".
class BookingHistoryCardItem extends StatelessWidget {
  const BookingHistoryCardItem({
    super.key,
    required this.booking,
    required this.onViewDetailsPressed,
  });

  final BookingHistoryModel booking;
  final VoidCallback onViewDetailsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.mainDarkBlue.withAlpha(10),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.r),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // بلوك الطبيب واخد كل المساحة المتبقية عشان الاسم والتخصص
                  // والمستشفى يبانوا أكبر وأوضح.
                  Expanded(child: _HistoryDoctorBlock(doctor: booking.doctor)),
                  Container(
                    width: 1,
                    margin:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    color: OnlineDoctorTheme.cardBorder,
                  ),
                  // عمود التفاصيل بعرض ثابت مضغوط فى آخر الكارت.
                  SizedBox(
                    width: 118.w,
                    child: _HistoryAppointmentDetails(booking: booking),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: OnlineDoctorTheme.footerDivider),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              children: [
                _CompletedStatusChip(label: booking.statusLabel),
                horizontalSpacing(6),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: _DoctorStatsGroup(booking: booking),
                  ),
                ),
                horizontalSpacing(6),
                _ViewDetailsButton(onPressed: onViewDetailsPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// صورة الطبيب واسمه وتخصصه وجهة عمله ومكانه —
/// زى بلوك كارت المواعيد القادمة بس من غير الدرجة الوظيفية،
/// وعلامة صح خضرا على الصورة بدل نقطة التواجد لأن الموعد خلص.
class _HistoryDoctorBlock extends StatelessWidget {
  const _HistoryDoctorBlock({required this.doctor});

  final BookingDoctorInfo doctor;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 11.5.sp,
      height: 1.4,
      color: OnlineDoctorTheme.mutedText,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HistoryDoctorAvatar(imageUrl: doctor.imageUrl),
        horizontalSpacing(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // FittedBox عشان الاسم يظهر كامل من غير "..." —
              // بيصغر شوية بس لو المساحة ضاقت.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  doctor.name,
                  maxLines: 1,
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
              verticalSpacing(3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  doctor.specialization,
                  maxLines: 1,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.accentBlue,
                  ),
                ),
              ),
              verticalSpacing(6),
              Row(
                children: [
                  Icon(
                    Icons.apartment_rounded,
                    size: 12.sp,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                  horizontalSpacing(3),
                  Flexible(
                    child: Text(
                      doctor.hospital,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mutedStyle,
                    ),
                  ),
                ],
              ),
              verticalSpacing(4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12.sp,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                  horizontalSpacing(3),
                  Flexible(
                    child: Text(
                      doctor.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: mutedStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryDoctorAvatar extends StatelessWidget {
  const _HistoryDoctorAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.w,
      height: 54.w,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: OnlineDoctorTheme.cardSurface,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColorsManager.mainDarkBlue.withAlpha(120),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: OnlineDoctorTheme.cardSurface,
                  padding: EdgeInsets.all(8.w),
                  child: Image.asset(
                    "assets/images/doctor_or_specialist.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: OnlineDoctorTheme.consultationGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(Icons.check, size: 8.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// بادچ النوع وتحته التاريخ والوقت، وبعدها التكلفة وطريقة الدفع (للكشف)
/// أو الكشف المرتبط (للاستشارة).
class _HistoryAppointmentDetails extends StatelessWidget {
  const _HistoryAppointmentDetails({required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    final detailStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 9.5.sp,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: OnlineDoctorTheme.headingColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // FittedBox عشان البادچ والصفوف الطويلة تتصغر شوية بدل ما
        // تلف سطرين جوه العمود المضغوط.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: BookingTypeBadge(type: booking.type),
        ),
        verticalSpacing(10),
        _HistoryDetailRow(
          iconAsset: "assets/images/calender_icon.png",
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(booking.dateLabel, maxLines: 1, style: detailStyle),
          ),
        ),
        verticalSpacing(6),
        _HistoryDetailRow(
          icon: Icons.access_time_rounded,
          child: Text(booking.timeLabel, style: detailStyle),
        ),
        verticalSpacing(6),
        if (booking.type.isExamination) ...[
          _HistoryDetailRow(
            iconAsset: "assets/images/money_icon.png",
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text.rich(
                TextSpan(
                  text: "تكلفة الكشف ",
                  style: detailStyle,
                  children: [
                    TextSpan(
                      text: "${booking.examinationFee} جنيه",
                      style: detailStyle.copyWith(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
            ),
          ),
          verticalSpacing(6),
          _HistoryDetailRow(
            icon: Icons.credit_card_rounded,
            child: Text(
              booking.paymentMethodLabel ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: detailStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ] else
          _HistoryDetailRow(
            icon: Icons.link_rounded,
            iconColor: OnlineDoctorTheme.consultationGreen,
            child: Text(
              booking.linkedExaminationLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: detailStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.consultationGreen,
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryDetailRow extends StatelessWidget {
  const _HistoryDetailRow({
    this.icon,
    this.iconAsset,
    this.iconColor,
    required this.child,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final Color? iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 15.w,
          child: icon != null
              ? Icon(
                  icon,
                  size: 13.sp,
                  color: iconColor ?? AppColorsManager.mainDarkBlue,
                )
              : Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Image.asset(
                    iconAsset!,
                    width: 13.w,
                    height: 13.w,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
        horizontalSpacing(5),
        Expanded(child: child),
      ],
    );
  }
}

/// شيب "مكتملة" الأخضر فى فوتر الكارت.
class _CompletedStatusChip extends StatelessWidget {
  const _CompletedStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.consultationSurface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 12.sp,
            color: OnlineDoctorTheme.consultationGreen,
          ),
          horizontalSpacing(4),
          Text(
            label,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.consultationGreen,
            ),
          ),
        ],
      ),
    );
  }
}

/// تقييم الطبيب وعدد التعليقات عليه — إحصائيات الطبيب مش تقييم المستخدم.
class _DoctorStatsGroup extends StatelessWidget {
  const _DoctorStatsGroup({required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: OnlineDoctorTheme.mutedText,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("تقييم الطبيب", style: labelStyle),
        horizontalSpacing(4),
        Icon(
          Icons.star_rounded,
          size: 14.sp,
          color: OnlineDoctorTheme.ratingAmber,
        ),
        horizontalSpacing(2),
        Text(
          "${booking.doctorRating.toStringAsFixed(1)} / 5",
          style: labelStyle.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: OnlineDoctorTheme.headingColor,
          ),
        ),
        horizontalSpacing(8),
        Container(
          width: 1,
          height: 12.h,
          color: OnlineDoctorTheme.statsDivider,
        ),
        horizontalSpacing(8),
        Icon(
          Icons.mode_comment_outlined,
          size: 12.sp,
          color: OnlineDoctorTheme.likesBlue,
        ),
        horizontalSpacing(3),
        Text("${booking.doctorCommentsCount} تعليق", style: labelStyle),
      ],
    );
  }
}

/// زرار "عرض التفاصيل" — بيفتح شاشة تفاصيل الكشف/الاستشارة.
class _ViewDetailsButton extends StatelessWidget {
  const _ViewDetailsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColorsManager.mainDarkBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "عرض التفاصيل",
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
              horizontalSpacing(4),
              Icon(
                Icons.arrow_forward_ios,
                size: 10.sp,
                color: AppColorsManager.mainDarkBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
