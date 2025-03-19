import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class EmergencyComplaintsDetailsView extends StatelessWidget {
  const EmergencyComplaintsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.h,
          children: [
            DetailsViewAppBar(
              title: 'الشكاوى المرضية الطارئة',
              editFunction: () {},
              shareFunction: () {},
              deleteFunction: () {},
            ),
            Row(
              children: [
                DetailsViewInfoTile(
                    title: "تاريخ ظهور الشكوى",
                    value: "1 / 3 / 2025",
                    icon: 'assets/images/date_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: "طبيعة الشكوى",
                    value: "مستمرة",
                    icon: 'assets/images/file_icon.png'),
              ],
            ),
            SymptomContainer(isMainSymptom: true),
            SymptomContainer(isMainSymptom: false),
            SectionTitleContainer(
                title: 'شكاوي مشابهه سابقا',
                iconPath: 'assets/images/symptoms_icon.png'),
            Row(children: [
              DetailsViewInfoTile(
                  title: "التشخيص ",
                  value: "التهاب الجيوب الأنفية",
                  icon: 'assets/images/doctor_stethoscope_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "تاريخ الشكوى",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
            ]),
            SectionTitleContainer(
                title: "ادوية حالية", iconPath: 'assets/images/medicines.png'),
            Row(
              children: [
                DetailsViewInfoTile(
                    title: "اسم الدواء",
                    value: "بانادول",
                    icon: 'assets/images/doctor_name.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: "الجرعة",
                    value: "مرتين في اليوم",
                    icon: 'assets/images/hugeicons_medicine-01.png'),
              ],
            ),
            SectionTitleContainer(
                title: "تدخل طبي طارئ للشكوى",
                iconPath: 'assets/images/medical_kit_icon.png'),
            Row(
              children: [
                DetailsViewInfoTile(
                    title: "نوع التدخل   ",
                    value: "هذا نص مثال",
                    icon: 'assets/images/qr_code_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: " التاريخ",
                    value: "1 / 3 / 2025",
                    icon: 'assets/images/date_icon.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitleContainer extends StatelessWidget {
  const SectionTitleContainer(
      {super.key, required this.title, required this.iconPath});
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 55.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: AppColorsManager.secondaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 15.w, height: 15.h),
          horizontalSpacing(5),
          Text(title,
              style: AppTextStyles.font14whiteWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              )),
        ],
      ),
    );
  }
}

class SymptomContainer extends StatelessWidget {
  const SymptomContainer({super.key, required this.isMainSymptom});
  final bool isMainSymptom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isMainSymptom
          ? EdgeInsets.all(8)
          : EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          isMainSymptom
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      "العرض المرضي الرئيسي",
                      style: AppTextStyles.font18blackWight500.copyWith(
                          color: AppColorsManager.mainDarkBlue,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          DetailsViewInfoTile(
              title: "الأعراض المرضية - المنطقة",
              value: "صعوبة في التنفس - ارتفاع درجة الحرارة",
              isExpanded: true,
              icon: 'assets/images/symptoms_icon.png'),
          verticalSpacing(16),
          DetailsViewInfoTile(
              title: "الأعراض المرضية - الشكوى",
              value: "صعوبة في التنفس / ارتفاع درجة الحرارة",
              isExpanded: true,
              icon: 'assets/images/symptoms_icon.png'),
          verticalSpacing(16),
          Row(children: [
            DetailsViewInfoTile(
                title: "طبيعة الشكوى",
                value: "مستمرة",
                icon: 'assets/images/file_icon.png'),
            Spacer(),
            DetailsViewInfoTile(
                title: "حدة الشكوى",
                value: "هذا النص مثال",
                icon: 'assets/images/heart_rate_search_icon.png'),
          ]),
        ],
      ),
    );
  }
}
