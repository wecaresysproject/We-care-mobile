import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class XRayDetailsView extends StatelessWidget {
  const XRayDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          spacing: 16.h,
          children: [
            Row(
              children: [
                Align(
                  alignment:
                      isArabic() ? Alignment.topRight : Alignment.topLeft,
                  child: CustomBackArrow(),
                ),
                Expanded(
                  child: Text(
                    "الأشعة",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font20blackWeight600,
                  ),
                ),
                horizontalSpacing(24.h)
              ],
            ),
            Row(children: [
              InfoTile(
                  title: "التاريخ",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
              Spacer(),
              InfoTile(
                title: "المنطقة",
                value: "الرأس والدماغ",
                icon: 'assets/images/body_icon.png',
              ),
            ]),
            Row(children: [
              InfoTile(
                  title: "النوع",
                  value: "الرنين المغناطيسي",
                  icon: 'assets/images/type_icon.png'),
              Spacer(),
              InfoTile(
                  title: "نوعية الاحتياج",
                  value: "دورية",
                  icon: 'assets/images/need_icon.png'),
            ]),
            InfoTile(
                title: "الأعراض",
                value: "ارتفاع درجة الحرارة / صداع مزمن",
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true),
            Row(children: [
              InfoTile(
                  title: "الطبيب المعالج",
                  value: "د/ أحمد هاني",
                  icon: 'assets/images/doctor_icon.png'),
              Spacer(),
              InfoTile(
                  title: "طبيب الأشعة",
                  value: "د/ أسامة محمد",
                  icon: 'assets/images/doctor_icon.png'),
            ]),
            Row(children: [
              InfoTile(
                  title: "المستشفى",
                  value: "دار الفؤاد",
                  icon: 'assets/images/hospital_icon.png'),
              Spacer(),
              InfoTile(
                  title: "الدولة",
                  value: "مصر",
                  icon: 'assets/images/country_icon.png'),
            ]),
            InfoTile(
                title: "ملاحظات",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true),
            ImageTile(
                image: 'assets/images/x_ray_sample.png', title: "صورة الأشعة"),
            ImageTile(image: 'assets/images/report.png', title: "صورة التقرير"),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final bool isExpanded;

  const InfoTile(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icon, height: 14.h, width: 14.w),
            horizontalSpacing(2),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),
        verticalSpacing(8),
        SizedBox(
          width: isExpanded
              ? MediaQuery.of(context).size.width - 32.w
              : (MediaQuery.of(context).size.width * 0.5) - 24.w,
          child: Container(
            padding: const EdgeInsets.fromLTRB(4, 8, 14, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border:
                  Border.all(color: AppColorsManager.mainDarkBlue, width: 0.3),
              gradient: const LinearGradient(
                colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              value,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: AppColorsManager.textColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final String image;
  final String title;
  const ImageTile({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
        verticalSpacing(8),
        Image.asset(image, height: 278.h, width: 343.w),
      ],
    );
  }
}
