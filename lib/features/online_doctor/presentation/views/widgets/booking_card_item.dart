import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_type_badge.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت الحجز فى شاشة "حجوزاتى" — بيانات الطبيب فى البداية وتفاصيل الموعد
/// فى النهاية، وشكله بيتغير حسب النوع (كشف/استشارة) وحالة الموعد:
/// - مستنى: شيب عد تنازلى جنب زرار "دخول عند الطبيب".
/// - حان وقته: البادچ بيتبدل بـ"حان وقت الكشف/الاستشارة" والزرار بياخد العرض كله.
class BookingCardItem extends StatelessWidget {
  const BookingCardItem({
    super.key,
    required this.booking,
    required this.now,
    required this.onEnterPressed,
    this.onCancelPressed,
    this.onEditPressed,
  });

  final BookingModel booking;

  /// اللحظة اللى الكارت بيتحسب عليها — بتيجى من الشاشة عشان كل الكروت
  /// تتحدث مع بعض بنفس التكة.
  final DateTime now;

  final VoidCallback onEnterPressed;

  /// بيظهروا فى فوتر كروت الكشف بس — الاستشارة المجانية ملهاش إلغاء أو تعديل.
  final VoidCallback? onCancelPressed;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final isTimeNow = booking.isTimeNow(now);
    final accentColor = booking.type.isExamination
        ? AppColorsManager.mainDarkBlue
        : OnlineDoctorTheme.consultationGreen;

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
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // بلوك الطبيب واخد كل المساحة المتبقية عشان الاسم
                      // والتخصص والمستشفى يبانوا أكبر وأوضح.
                      Expanded(
                        child: _DoctorInfoBlock(doctor: booking.doctor),
                      ),
                      Container(
                        width: 1,
                        margin: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        color: OnlineDoctorTheme.cardBorder,
                      ),
                      // عمود التفاصيل بعرض ثابت مضغوط فى آخر الكارت.
                      SizedBox(
                        width: 118.w,
                        child: _AppointmentDetailsBlock(
                          booking: booking,
                          isTimeNow: isTimeNow,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpacing(12),
                if (isTimeNow)
                  _EnterDoctorButton(
                    label: "دخول عند الطبيب الآن",
                    color: accentColor,
                    onPressed: onEnterPressed,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _CountdownChip(booking: booking, now: now),
                      ),
                      horizontalSpacing(8),
                      Expanded(
                        flex: 6,
                        child: _EnterDoctorButton(
                          label: "دخول عند الطبيب",
                          color: accentColor,
                          onPressed: onEnterPressed,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (booking.type.isExamination)
            _CardFooterActions(
              onCancelPressed: onCancelPressed,
              onEditPressed: onEditPressed,
            ),
        ],
      ),
    );
  }
}

/// صورة الطبيب واسمه وتخصصه وجهة عمله ومكانه.
class _DoctorInfoBlock extends StatelessWidget {
  const _DoctorInfoBlock({required this.doctor});

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
        _DoctorAvatar(imageUrl: doctor.imageUrl, isOnline: doctor.isOnline),
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
              verticalSpacing(5),
              Text(doctor.academicTitle, maxLines: 1, style: mutedStyle),
              verticalSpacing(3),
              Text(
                doctor.hospital,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: mutedStyle,
              ),
              verticalSpacing(5),
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

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({required this.imageUrl, required this.isOnline});

  final String imageUrl;
  final bool isOnline;

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
          if (isOnline)
            PositionedDirectional(
              bottom: 0,
              end: 2.w,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: OnlineDoctorTheme.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// بادچ النوع وتحته صفوف التاريخ والوقت، وبعدها التكلفة (للكشف)
/// أو الكشف المرتبط (للاستشارة).
class _AppointmentDetailsBlock extends StatelessWidget {
  const _AppointmentDetailsBlock({
    required this.booking,
    required this.isTimeNow,
  });

  final BookingModel booking;
  final bool isTimeNow;

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
          child: BookingTypeBadge(type: booking.type, isTimeNow: isTimeNow),
        ),
        verticalSpacing(10),
        _DetailRow(
          iconAsset: "assets/images/calender_icon.png",
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(booking.dateLabel, maxLines: 1, style: detailStyle),
          ),
        ),
        verticalSpacing(6),
        _DetailRow(
          icon: Icons.access_time_rounded,
          child: Text(booking.timeLabel, style: detailStyle),
        ),
        verticalSpacing(6),
        if (booking.type.isExamination)
          _DetailRow(
            iconAsset: "assets/images/money_icon.png",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "تكلفة الكشف أون لاين",
                    maxLines: 1,
                    style: detailStyle,
                  ),
                ),
                Text(
                  "${booking.examinationFee} جنيه",
                  style: detailStyle.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ],
            ),
          )
        else
          _DetailRow(
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

/// صف تفصيلة واحدة — أيقونة فى البداية وجنبها المحتوى.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
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

/// شيب العد التنازلى — ساعة رملية وسطرين: "متبقى على الكشف" والمدة.
class _CountdownChip extends StatelessWidget {
  const _CountdownChip({required this.booking, required this.now});

  final BookingModel booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.countdownSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: OnlineDoctorTheme.countdownBorder),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_bottom_rounded,
            size: 17.sp,
            color: OnlineDoctorTheme.countdownAmber,
          ),
          horizontalSpacing(5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    booking.type.countdownLabel,
                    maxLines: 1,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: OnlineDoctorTheme.countdownText,
                    ),
                  ),
                ),
                verticalSpacing(2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    arabicCountdownLabel(booking.remaining(now)),
                    maxLines: 1,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: OnlineDoctorTheme.countdownText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// زرار "دخول عند الطبيب" — أزرق للكشف وأخضر للاستشارة.
class _EnterDoctorButton extends StatelessWidget {
  const _EnterDoctorButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          height: 46.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_rounded, size: 17.sp, color: Colors.white),
              horizontalSpacing(7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14whiteWeight600.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// فوتر كروت الكشف — "إلغاء الموعد" و"تعديل الموعد" مفصولين بخط.
class _CardFooterActions extends StatelessWidget {
  const _CardFooterActions({
    required this.onCancelPressed,
    required this.onEditPressed,
  });

  final VoidCallback? onCancelPressed;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: OnlineDoctorTheme.footerDivider),
        SizedBox(
          height: 42.h,
          child: Row(
            children: [
              Expanded(
                child: _FooterAction(
                  icon: Icons.delete_outline_rounded,
                  label: "إلغاء الموعد",
                  color: OnlineDoctorTheme.offlineRed,
                  onTap: onCancelPressed,
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                color: OnlineDoctorTheme.footerDivider,
              ),
              Expanded(
                child: _FooterAction(
                  icon: Icons.edit_calendar_rounded,
                  label: "تعديل الموعد",
                  color: OnlineDoctorTheme.accentBlue,
                  onTap: onEditPressed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15.sp, color: color),
          horizontalSpacing(5),
          Text(
            label,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
