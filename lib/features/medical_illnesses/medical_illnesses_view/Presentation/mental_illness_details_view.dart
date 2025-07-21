import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MentalIllnessDetailsView extends StatelessWidget {
  const MentalIllnessDetailsView({super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context) {
    // Mock data
    final mockDetails = {
      "diagnosisDate": "2023-06-10",
      "illnessType": "اضطراب الهلع",
      "symptoms": "تسارع ضربات القلب، ضيق في التنفس، شعور بالخوف المفاجئ",
      "severity": "شديدة",
      "acuteness": "مزمن",
      "incidentType": "حادث له تأثير",
      "incidentDate": "2022-12-01",
      "incidentEffect":
          "الحادث أدى إلى تدهور الحالة النفسية وزيادة نوبات الهلع.",
      "similarFamilyCases": "يوجد حالات مشابهة في العائلة",
      "emergencyCases": "تم استدعاء الطوارئ النفسية مرة واحدة",
      "socialSupport": "يحصل على دعم من الأسرة والأصدقاء",
      "drugSideEffects": "دوخة، تعب عام، أرق",
      "psychActivities": "ممارسة الرياضة، التأمل، حضور جلسات دعم",
      "followsTherapy": true,
    };

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWithCenteredTitle(
              title: "اضطراب الهلع",
              shareFunction: () {},
              deleteFunction: () {
                // Add deletion logic if needed
              },
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "تاريخ التشخيص",
              value: mockDetails["diagnosisDate"].toString(),
              icon: 'assets/images/date_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "نوع المرض",
              value: mockDetails["illnessType"].toString(),
              icon: 'assets/images/analysis_type.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "الأعراض المرضية",
              value: mockDetails["symptoms"].toString(),
              icon: 'assets/images/symptoms_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "شدة المرض",
              value: mockDetails["severity"].toString(),
              icon: 'assets/images/heart_rate_search_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "مدة المرض",
              value: mockDetails["acuteness"]!.toString(),
              icon: 'assets/images/time_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColorsManager.mainDarkBlue, width: 0.3),
                gradient: const LinearGradient(
                  colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      "حادث له تآثير",
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                        fontSize: 16.5.sp,
                      ),
                    ),
                  ),
                  DetailsViewInfoTile(
                    title: "نوع الموقف",
                    value: mockDetails["incidentType"]!.toString(),
                    icon: 'assets/images/analysis_type.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "تاريخ الموقف",
                    value: mockDetails["incidentDate"]!.toString(),
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "تأثير الحادث على الحالة النفسية",
                    value: mockDetails["incidentEffect"]!.toString(),
                    icon: 'assets/images/psychology_icon.png',
                    isExpanded: true,
                  ),
                ],
              ),
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "حالات نفسية مشابهة في العائلة",
              value: mockDetails["similarFamilyCases"]!.toString(),
              icon: 'assets/images/psychology_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "حالات الطوارىء النفسية",
              value: mockDetails["emergencyCases"]!.toString(),
              icon: 'assets/images/warning_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "الدعم الاجتماعي",
              value: mockDetails["socialSupport"]!.toString(),
              icon: 'assets/images/group_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "التأثيرات الجانبية للدواء",
              value: mockDetails["drugSideEffects"]!.toString(),
              icon: 'assets/images/psychology_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "الأنشطة المساندة للصحة النفسية",
              value: mockDetails["psychActivities"]!.toString(),
              icon: 'assets/images/activity_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            DetailsViewInfoTile(
              title: "هل يُتابع العلاج النفسي / السلوكي؟",
              value: mockDetails["followsTherapy"]!.toString() == "true"
                  ? "نعم"
                  : "لا",
              icon: 'assets/images/doctor_icon.png',
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
