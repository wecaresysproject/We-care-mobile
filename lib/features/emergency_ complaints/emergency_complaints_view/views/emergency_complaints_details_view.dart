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
                    title: "العرض الرئيسي",
                    value: "تشجنات",
                    icon: 'assets/images/qr_code_icon.png'),
              ],
            ),
            DetailsViewInfoTile(
                title: "الأعراض المرضية - المنطقة",
                value: "صعوبة في التنفس - ارتفاع درجة الحرارة",
                isExpanded: true,
                icon: 'assets/images/symptoms_icon.png'),
            DetailsViewInfoTile(
                title: "الأعراض المرضية - الشكوى",
                value: "صعوبة في التنفس / ارتفاع درجة الحرارة",
                isExpanded: true,
                icon: 'assets/images/symptoms_icon.png'),
            Row(children: [
              DetailsViewInfoTile(
                  title: "مكان الشكوى",
                  value: "الظهر",
                  icon: 'assets/images/body_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "طبيعة الشكوى",
                  value: "مستمرة",
                  icon: 'assets/images/file_icon.png'),
            ]),
            // DetailsViewSlider(
            //   // title: "حدة الشكوى",
            //   levels: ["متوسطة", "شديدة", "شديدة جدًا"],
            //   selectedValue: 1,
            // ),
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
      margin: EdgeInsets.symmetric(horizontal: 65.w),
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

class DetailsViewSlider extends StatelessWidget {
  final List<String> levels;
  final int selectedValue;

  const DetailsViewSlider({
    super.key,
    required this.levels,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Slider(
            value: selectedValue.toDouble(),
            min: 0,
            max: (levels.length - 1).toDouble(),
            divisions: levels.length - 1,
            activeColor: Colors.blue.shade900,
            onChanged: null, // Disabled for display only
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: levels
                .map((level) => Text(level, style: TextStyle(fontSize: 14.sp)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
