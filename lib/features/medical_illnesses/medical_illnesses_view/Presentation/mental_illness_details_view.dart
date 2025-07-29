import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';

class MentalIllnessDetailsView extends StatelessWidget {
  const MentalIllnessDetailsView({super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context) {
    final mockMentalIllnessRequest = MentalIllnessRequestBody(
      diagnosisDate: "2025-01-25",
      mentalIllnessType: "اضطراب القلق العام",
      symptomsList: ["الأرق", "سرعة الانفعال", "صعوبة التركيز"],
      illnessSeverity: "متوسط",
      illnessDuration: "7 شهور",
      hasImpactfulIncident: ImpactfulIncident(
        answer: true,
        incidentType: "حادث سير",
        incidentDate: "2024-06-10",
        incidentPsychologicalImpact: "أدى إلى توتر وقلق مستمر",
      ),
      hasFamilySimilarMentalIllnessCases: FamilyMentalIllness(
        answer: true,
        relationship: "الأب",
      ),
      selectedPsychologicalEmergencies: "حالة طارئة",
      socialSupport: "العائلة والأصدقاء يقدمون دعمًا جيدًا",
      selectedMedicationSideEffects: "شعور بالدوخة والخمول",
      preferredActivitiesForImprovement: "الرياضة والتأمل",
      isReceivingPsychologicalTreatment: PsychologicalTreatment(
        answer: true,
        medicationsUsed: "دواء مضاد للاكتئاب",
        medicationEffectOnDailyLife: "يسبب بعض النعاس أثناء النهار",
        previousTherapyType: "العلاج السلوكي المعرفي",
        numberOfSessions: 12,
        therapySatisfaction: "مقبول",
        doctorOrSpecialist: "د. محمد علي",
        hospitalOrCenter: "دار الفؤاد",
        country: "مصر",
      ),
    );

    return BlocProvider.value(
      value: getIt<MentalIllnessDataViewCubit>(),
      // ..getMentalIllnessDocumentDetailsById(docId),
      child: Scaffold(
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
                value: mockMentalIllnessRequest.diagnosisDate,
                icon: 'assets/images/date_icon.png',
                isExpanded: true,
              ),
              verticalSpacing(16),
              DetailsViewInfoTile(
                title: "نوع المرض",
                value: mockMentalIllnessRequest.mentalIllnessType,
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
              // DetailsViewInfoTile(
              //   title: "حالات نفسية مشابهة في العائلة",
              //   value: mockDetails["similarFamilyCases"]!.toString(),
              //   icon: 'assets/images/psychology_icon.png',
              //   isExpanded: true,
              // ),
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
                    DetailsViewInfoTile(
                      title: "حالات نفسية مشابهة فى العائلة ",
                      value: "نعم",
                      icon: 'assets/images/psychology_icon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "الصله العائلية",
                      value: "الاب",
                      icon: 'assets/images/group_icon.png',
                      isExpanded: true,
                    ),
                  ],
                ),
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
              // DetailsViewInfoTile(
              //   title: "هل يُتابع العلاج النفسي / السلوكي؟",
              //   value: mockDetails["followsTherapy"]!.toString() == "true"
              //       ? "نعم"
              //       : "لا",
              //   icon: 'assets/images/doctor_icon.png',
              //   isExpanded: true,
              // ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColorsManager.mainDarkBlue,
                    width: 0.3,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    DetailsViewInfoTile(
                      title: "تلقي العلاج النفسي / الاستشارات",
                      value: "نعم",
                      icon: 'assets/images/doctor_examination_tool_icon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "أدوية مستخدمة",
                      value: "هذا النص هو مثال لنص يمكن أن يستبدل",
                      icon: 'assets/images/medicines_icon_2.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "تأثير الدواء على الحياة اليومية",
                      value: "هذا النص هو مثال لنص يمكن أن يستبدل في",
                      icon: 'assets/images/medicines_icon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "نوع العلاج النفسي",
                      value: "النص مثال",
                      icon: 'assets/images/hugeicons_medicine.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "عدد الجلسات",
                      value: "النص مثال",
                      icon: 'assets/images/counterـicon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "الجرعة",
                      value: "النص مثال",
                      icon: 'assets/images/hugeicons_medicine.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "عدد مرات الدواء",
                      value: "النص مثال",
                      icon: 'assets/images/counterـicon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    verticalSpacing(8),
                    DetailsViewInfoTile(
                      title: "رضاك عن نتيجة الجلسات",
                      value: "النص مثال",
                      icon: 'assets/images/heart_rate_search_icon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    DetailsViewInfoTile(
                      title: "الطبيب / الأخصائي النفسي",
                      value: "النص مثال",
                      icon: 'assets/images/doctor_icon.png',
                      isExpanded: true,
                    ),
                    verticalSpacing(16),
                    Row(
                      children: [
                        Expanded(
                          child: DetailsViewInfoTile(
                            title: "المستشفى/المركز",
                            value: "دار الفؤاد",
                            icon: 'assets/images/hospital_icon.png',
                            isExpanded: true,
                          ),
                        ),
                        horizontalSpacing(16),
                        Expanded(
                          child: DetailsViewInfoTile(
                            title: "الدولة",
                            value: "دار الفؤاد",
                            icon: 'assets/images/country_icon.png',
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
