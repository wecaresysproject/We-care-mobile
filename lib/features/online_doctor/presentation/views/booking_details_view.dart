import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctors_dummy_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_type_badge.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "تفاصيل الكشف/الاستشارة" — بتتفتح من "عرض التفاصيل" فى السجل السابق:
/// بيانات الطبيب، تفاصيل الموعد، الروشتة، تقييم وتعليق المستخدم،
/// وزرار حجز موعد جديد مع الطبيب.
class BookingDetailsView extends StatelessWidget {
  const BookingDetailsView({super.key, required this.booking});

  final BookingHistoryModel booking;

  void _showComingSoonMessage(BuildContext context, String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  const CustomBackArrow(),
                  Expanded(
                    child: Text(
                      booking.detailsTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font20blackWeight600.copyWith(
                        fontSize: 19.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  //! مشاركة تفاصيل الموعد لسه محتاجة صيغة متفق عليها —
                  //! الزرار موجود زى التصميم وهيتفعل معاها.
                  Material(
                    color: OnlineDoctorTheme.iconTint,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      onTap: () => _showComingSoonMessage(
                        context,
                        "مشاركة تفاصيل الموعد ستتوفر قريباً",
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Icon(
                          Icons.share_outlined,
                          size: 19.sp,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(14),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                children: [
                  _DoctorHeaderCard(booking: booking),
                  verticalSpacing(12),
                  _AppointmentInfoCard(booking: booking),
                  verticalSpacing(12),
                  _PrescriptionCard(
                    booking: booking,
                    onDownloadPressed: () => _showComingSoonMessage(
                      context,
                      "عرض وتحميل الروشتة سيتوفر مع ربط الروشتات",
                    ),
                  ),
                  verticalSpacing(12),
                  _UserRatingCard(
                    booking: booking,
                    onEditPressed: () => _showComingSoonMessage(
                      context,
                      "تعديل التقييم سيتوفر قريباً",
                    ),
                  ),
                  verticalSpacing(12),
                  _UserCommentCard(
                    booking: booking,
                    onEditPressed: () => _showComingSoonMessage(
                      context,
                      "تعديل التعليق سيتوفر قريباً",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
              child: _BookNewAppointmentButton(
                // بيفتح شاشة "حجز موعد" لنفس الطبيب مباشرة — المواعيد المتاحة
                // وطريقة الدفع والموديولز المسموح بها — من غير المرور بالبحث.
                onPressed: () async {
                  await context.pushNamed(
                    Routes.bookAppointmentView,
                    arguments: doctorFromBookingInfo(
                      booking.doctor,
                      consultationFee: booking.examinationFee,
                      rating: booking.doctorRating,
                      commentsCount: booking.doctorCommentsCount,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// كارت بيانات الطبيب أعلى الشاشة — الصورة والاسم والتخصص وجهة العمل،
/// وبادچ نوع الموعد.
class _DoctorHeaderCard extends StatelessWidget {
  const _DoctorHeaderCard({required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    final doctor = booking.doctor;
    final mutedStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 11.5.sp,
      height: 1.4,
      color: OnlineDoctorTheme.mutedText,
    );

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.bookingSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailsDoctorAvatar(imageUrl: doctor.imageUrl),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 14.5.sp,
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
                verticalSpacing(4),
                Text(doctor.academicTitle, maxLines: 1, style: mutedStyle),
                Text(
                  doctor.hospital,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mutedStyle,
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
          horizontalSpacing(6),
          // البادچ متحدد بعرض أقصى ومتلفوف فى FittedBox عشان الطويل منه
          // ("استشارة متابعة مجانية") يتصغر بدل ما ياكل من مساحة الاسم.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 105.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.topEnd,
              child: BookingTypeBadge(type: booking.type),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsDoctorAvatar extends StatelessWidget {
  const _DetailsDoctorAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58.w,
      height: 58.w,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white,
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
                  color: Colors.white,
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
            bottom: 2,
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

/// كارت تفاصيل الموعد — عمودين مفصولين بخط: التاريخ والوقت والتكلفة،
/// وطريقة الدفع وحالة الموعد.
class _AppointmentInfoCard extends StatelessWidget {
  const _AppointmentInfoCard({required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoRow(
                    iconAsset: "assets/images/calender_icon.png",
                    child: _InfoValueText(booking.dateLabel),
                  ),
                  verticalSpacing(10),
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    child: _InfoValueText(booking.timeLabel),
                  ),
                  verticalSpacing(10),
                  if (booking.type.isExamination)
                    _InfoRow(
                      iconAsset: "assets/images/money_icon.png",
                      child: _LabeledInfoValue(
                        label: "تكلفة الكشف",
                        value: "${booking.examinationFee} جنيه",
                        valueColor: AppColorsManager.mainDarkBlue,
                      ),
                    )
                  else
                    _InfoRow(
                      icon: Icons.link_rounded,
                      iconColor: OnlineDoctorTheme.consultationGreen,
                      child: Text(
                        booking.linkedExaminationLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          color: OnlineDoctorTheme.consultationGreen,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              color: OnlineDoctorTheme.columnDivider,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (booking.type.isExamination) ...[
                    _InfoRow(
                      icon: Icons.credit_card_rounded,
                      child: _LabeledInfoValue(
                        label: "طريقة الدفع",
                        value: booking.paymentMethodLabel ?? "",
                        valueColor: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                    verticalSpacing(10),
                  ] else ...[
                    _InfoRow(
                      icon: Icons.question_answer_outlined,
                      iconColor: OnlineDoctorTheme.consultationGreen,
                      child: _LabeledInfoValue(
                        label: "نوع الموعد",
                        value: "استشارة مجانية",
                        valueColor: OnlineDoctorTheme.consultationGreen,
                      ),
                    ),
                    verticalSpacing(10),
                  ],
                  _InfoRow(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: OnlineDoctorTheme.consultationGreen,
                    child: _LabeledInfoValue(
                      label: "حالة الموعد",
                      value: booking.statusLabel,
                      valueColor: OnlineDoctorTheme.consultationGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
          width: 16.w,
          child: icon != null
              ? Icon(
                  icon,
                  size: 14.sp,
                  color: iconColor ?? AppColorsManager.mainDarkBlue,
                )
              : Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Image.asset(
                    iconAsset!,
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
        horizontalSpacing(6),
        Expanded(child: child),
      ],
    );
  }
}

class _InfoValueText extends StatelessWidget {
  const _InfoValueText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.font12blackWeight400.copyWith(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: OnlineDoctorTheme.headingColor,
      ),
    );
  }
}

/// عنوان صغير وقيمة غامقة تحته — زى "طريقة الدفع / بطاقة ائتمان".
class _LabeledInfoValue extends StatelessWidget {
  const _LabeledInfoValue({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: OnlineDoctorTheme.headingColor,
          ),
        ),
        verticalSpacing(2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// كارت الروشتة — عنوانه وزرار "عرض / تحميل الروشتة"،
/// وتحتهم حالة الروشتة فى صندوق فاتح.
class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({
    required this.booking,
    required this.onDownloadPressed,
  });

  final BookingHistoryModel booking;
  final VoidCallback onDownloadPressed;

  @override
  Widget build(BuildContext context) {
    final issuedDate = booking.prescriptionIssuedDate;

    return _DetailsSectionCard(
      children: [
        Row(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 18.sp,
              color: AppColorsManager.mainDarkBlue,
            ),
            horizontalSpacing(6),
            Text(
              "الروشتة",
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
            const Spacer(),
            if (issuedDate != null)
              InkWell(
                onTap: onDownloadPressed,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "عرض / تحميل الروشتة",
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                      ),
                      horizontalSpacing(4),
                      Icon(
                        Icons.download_rounded,
                        size: 15.sp,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        verticalSpacing(10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: OnlineDoctorTheme.cardSurface,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            issuedDate != null
                ? "يوجد روشتة تم إصدارها في تاريخ "
                    "${arabicShortDateLabel(issuedDate)}"
                : "لا توجد روشتة لهذا الموعد",
            textAlign: TextAlign.center,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// كارت تقييم المستخدم للطبيب — النجوم والدرجة ووصفها وزرار التعديل،
/// أو دعوة لإضافة تقييم لو لسه مقيّمش.
class _UserRatingCard extends StatelessWidget {
  const _UserRatingCard({required this.booking, required this.onEditPressed});

  final BookingHistoryModel booking;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final userRating = booking.userRating;
    final ratingDate = booking.userRatingDate;

    return _DetailsSectionCard(
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 19.sp,
              color: OnlineDoctorTheme.ratingAmber,
            ),
            horizontalSpacing(6),
            Text(
              "تقييمك للطبيب",
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
            const Spacer(),
            if (userRating != null && ratingDate != null)
              Text(
                "تم التقييم في ${arabicShortDateLabel(ratingDate)}",
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: OnlineDoctorTheme.mutedText,
                ),
              ),
          ],
        ),
        verticalSpacing(12),
        if (userRating != null) ...[
          Row(
            children: [
              _RatingStarsRow(rating: userRating),
              horizontalSpacing(10),
              Text(
                "${userRating.toStringAsFixed(1)} / 5",
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ],
          ),
          verticalSpacing(4),
          Text(
            ratingDescription(userRating),
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.mutedText,
            ),
          ),
          verticalSpacing(10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _OutlinedActionButton(
              label: "تعديل تقييمك",
              onPressed: onEditPressed,
            ),
          ),
        ] else ...[
          Text(
            "لم تقم بتقييم هذا الموعد بعد",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.mutedText,
            ),
          ),
          verticalSpacing(10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _OutlinedActionButton(
              label: "أضف تقييمك",
              onPressed: onEditPressed,
            ),
          ),
        ],
      ],
    );
  }
}

/// صف نجوم التقييم — ممتلئة ونصف ممتلئة وفاضية حسب الدرجة.
class _RatingStarsRow extends StatelessWidget {
  const _RatingStarsRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final IconData starIcon;
        if (rating >= index + 1) {
          starIcon = Icons.star_rounded;
        } else if (rating > index) {
          starIcon = Icons.star_half_rounded;
        } else {
          starIcon = Icons.star_border_rounded;
        }
        return Icon(
          starIcon,
          size: 26.sp,
          color: OnlineDoctorTheme.ratingAmber,
        );
      }),
    );
  }
}

/// كارت تعليق المستخدم على الطبيب — نص التعليق وتاريخ نشره وزرار التعديل،
/// أو دعوة لإضافة تعليق لو لسه معلّقش.
class _UserCommentCard extends StatelessWidget {
  const _UserCommentCard({required this.booking, required this.onEditPressed});

  final BookingHistoryModel booking;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final userComment = booking.userComment;
    final commentDate = booking.userCommentDate;

    return _DetailsSectionCard(
      children: [
        Row(
          children: [
            Icon(
              Icons.mode_comment_outlined,
              size: 17.sp,
              color: AppColorsManager.mainDarkBlue,
            ),
            horizontalSpacing(6),
            Text(
              "تعليقك على الطبيب",
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
            const Spacer(),
            if (userComment != null && commentDate != null)
              Text(
                "تم النشر في ${arabicShortDateLabel(commentDate)}",
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: OnlineDoctorTheme.mutedText,
                ),
              ),
          ],
        ),
        verticalSpacing(10),
        Text(
          userComment ?? "لم تقم بكتابة تعليق على هذا الموعد بعد",
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            height: 1.7,
            color: userComment != null
                ? OnlineDoctorTheme.sectionBodyText
                : OnlineDoctorTheme.mutedText,
          ),
        ),
        verticalSpacing(10),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: _OutlinedActionButton(
            label: userComment != null ? "تعديل تعليقك" : "أضف تعليقك",
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }
}

/// كارت أبيض بحواف دائرية بيلم أقسام الشاشة — الروشتة والتقييم والتعليق.
class _DetailsSectionCard extends StatelessWidget {
  const _DetailsSectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({required this.label, required this.onPressed});

  final String label;
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
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColorsManager.mainDarkBlue),
          ),
          child: Text(
            label,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}

/// الزرار الأساسى أسفل الشاشة — "حجز موعد جديد مع الطبيب".
class _BookNewAppointmentButton extends StatelessWidget {
  const _BookNewAppointmentButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorsManager.mainDarkBlue,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
              horizontalSpacing(8),
              Text(
                "حجز موعد جديد مع الطبيب",
                style: AppTextStyles.font14whiteWeight600.copyWith(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
