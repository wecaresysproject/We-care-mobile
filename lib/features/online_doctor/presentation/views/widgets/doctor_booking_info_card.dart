import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت "معلومات الحجز" — أقرب موعد، أيام العمل، وتكلفة الكشف.
class DoctorBookingInfoCard extends StatelessWidget {
  const DoctorBookingInfoCard({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.bookingSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 18.sp,
                color: OnlineDoctorTheme.accentBlue,
              ),
              horizontalSpacing(8),
              Text(
                "معلومات الحجز",
                style: AppTextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ],
          ),
          verticalSpacing(12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _BookingInfoColumn(
                    icon: Icons.access_time_rounded,
                    label: "أقرب موعد متاح",
                    value: doctor.nearestAppointmentDate,
                    hint:
                        "${doctor.nearestAppointmentTime} ${doctor.nearestAppointmentPeriod}",
                  ),
                ),
                const _ColumnDivider(),
                Expanded(
                  child: _BookingInfoColumn(
                    icon: Icons.calendar_month_rounded,
                    label: "أيام العمل الأسبوعية",
                    value: doctor.workingDays,
                    hint: doctor.workingHours,
                  ),
                ),
                const _ColumnDivider(),
                Expanded(
                  child: _BookingInfoColumn(
                    icon: Icons.payments_rounded,
                    label: "تكلفة الكشف اون لاين",
                    value: "${doctor.consultationFee} جنيه",
                    isValueHighlighted: true,
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

/// خط فاصل رأسى بين أعمدة الكارت.
class _ColumnDivider extends StatelessWidget {
  const _ColumnDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      color: OnlineDoctorTheme.columnDivider,
    );
  }
}

class _BookingInfoColumn extends StatelessWidget {
  const _BookingInfoColumn({
    required this.icon,
    required this.label,
    required this.value,
    this.hint,
    this.isValueHighlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? hint;

  /// بيكبّر النص شوية — بيتستخدم مع تكلفة الكشف.
  final bool isValueHighlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: const BoxDecoration(
              color: OnlineDoctorTheme.iconBadgeSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15.sp,
              color: OnlineDoctorTheme.accentBlue,
            ),
          ),
          verticalSpacing(6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 9.sp,
              height: 1.4,
              color: OnlineDoctorTheme.mutedText,
            ),
          ),
          verticalSpacing(4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: isValueHighlighted ? 13.sp : 9.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.4,
              color: OnlineDoctorTheme.accentBlue,
            ),
          ),
          if (hint != null) ...[
            verticalSpacing(2),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 8.5.sp,
                height: 1.4,
                color: OnlineDoctorTheme.mutedText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
