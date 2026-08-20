import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_specializations_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// محتوى قسم "التخصص والاهتمامات الطبية" — التخصص الرئيسى والدقيق
/// والاهتمامات، كل واحد فى صف بأيقونته وتفاصيله.
class DoctorSpecializationDetails extends StatelessWidget {
  const DoctorSpecializationDetails({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Column(
        children: [
          _SpecializationRow(
            iconAsset: doctorSpecializationImage(doctor.specialization),
            icon: Icons.medical_services_rounded,
            title: "التخصص الرئيسي",
            value: doctor.specialization,
          ),
          const _RowDivider(),
          _SpecializationRow(
            icon: Icons.zoom_in_rounded,
            title: "التخصص الدقيق",
            value: doctor.subSpecialization,
          ),
          const _RowDivider(),
          _SpecializationRow(
            icon: Icons.monitor_heart_rounded,
            title: "الاهتمامات الطبية / السريرية",
            items: doctor.medicalInterests,
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: OnlineDoctorTheme.sectionBorder,
    );
  }
}

class _SpecializationRow extends StatelessWidget {
  const _SpecializationRow({
    required this.icon,
    required this.title,
    this.iconAsset,
    this.value,
    this.items = const [],
  });

  final IconData icon;

  /// أيقونة من الـ assets — بتتستخدم لو التخصص ليه صورة، وإلا بنستخدم [icon].
  final String? iconAsset;

  final String title;
  final String? value;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26.w,
            child: Center(
              child: iconAsset != null
                  ? Image.asset(
                      iconAsset!,
                      width: 20.w,
                      height: 20.h,
                      color: OnlineDoctorTheme.accentBlue,
                    )
                  : Icon(
                      icon,
                      size: 20.sp,
                      color: OnlineDoctorTheme.accentBlue,
                    ),
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.accentBlue,
                  ),
                ),
                verticalSpacing(4),
                if (value != null)
                  Text(
                    value!,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: 10.5.sp,
                      height: 1.6,
                      color: OnlineDoctorTheme.sectionBodyText,
                    ),
                  ),
                for (final item in items) _InterestItem(item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestItem extends StatelessWidget {
  const _InterestItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7.h),
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: const BoxDecoration(
                color: OnlineDoctorTheme.sectionBodyText,
                shape: BoxShape.circle,
              ),
            ),
          ),
          horizontalSpacing(7),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 10.5.sp,
                height: 1.6,
                color: OnlineDoctorTheme.sectionBodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
