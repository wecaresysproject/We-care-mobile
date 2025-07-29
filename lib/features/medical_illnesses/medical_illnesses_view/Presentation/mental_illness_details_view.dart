import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';

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
        answer: false,
        incidentType: "حادث سير",
        incidentDate: "2024-06-10",
        incidentPsychologicalImpact: "أدى إلى توتر وقلق مستمر",
      ),
      hasFamilySimilarMentalIllnessCases: FamilyMentalIllness(
        answer: false,
        relationship: "الأب",
      ),
      selectedPsychologicalEmergencies: "حالة طارئة",
      socialSupport: "العائلة والأصدقاء يقدمون دعمًا جيدًا",
      selectedMedicationSideEffects: "شعور بالدوخة والخمول",
      preferredActivitiesForImprovement: "الرياضة والتأمل",
      isReceivingPsychologicalTreatment: PsychologicalTreatment(
        answer: false,
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

    return BlocProvider(
      create: (context) => getIt<MentalIllnessDataViewCubit>(),
      // ..getMentalIllnessDocumentDetailsById(docId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<MentalIllnessDataViewCubit,
            MentalIllnessDataViewState>(
          listener: (context, state) {
            if (state.requestStatus == RequestStatus.success &&
                state.isDeleteRequest) {
              showSuccess("تم حذف الشكوى بنجاح");
              Navigator.pop(context);
            } else if (state.requestStatus == RequestStatus.failure) {
              showError(state.responseMessage);
            }
          },
          builder: (context, state) {
            final docDetails = state.selectedMentalIllnessDocumentDetails;
            // if (docDetails == null) {
            //   return Center(child: CircularProgressIndicator());
            // }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWithCenteredTitle(
                    title: mockMentalIllnessRequest.mentalIllnessType,
                    shareFunction: () async {
                      await _shareMentalIllnessDetails(context, state);
                    },
                    deleteFunction: () async {
                      await context
                          .read<MentalIllnessDataViewCubit>()
                          .deleteMentalIllnessDetailsDocumentById(docId);
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
                    value: mockMentalIllnessRequest.symptomsList.join(", "),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "شدة المرض",
                    value: mockMentalIllnessRequest.illnessSeverity,
                    icon: 'assets/images/heart_rate_search_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "مدة المرض",
                    value: mockMentalIllnessRequest.illnessDuration,
                    icon: 'assets/images/time_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),

                  // Incident Information Container - Always show
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
                        mockMentalIllnessRequest.hasImpactfulIncident.answer ==
                                true
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Text(
                                  "حادث له تآثير",
                                  style: AppTextStyles.font16DarkGreyWeight400
                                      .copyWith(
                                    color: AppColorsManager.mainDarkBlue,
                                    fontSize: 16.5.sp,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        if (mockMentalIllnessRequest
                                .hasImpactfulIncident.answer ==
                            true) ...[
                          DetailsViewInfoTile(
                            title: "نوع الموقف",
                            value: mockMentalIllnessRequest
                                    .hasImpactfulIncident.incidentType ??
                                "غير محدد",
                            icon: 'assets/images/analysis_type.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تاريخ الموقف",
                            value: mockMentalIllnessRequest
                                    .hasImpactfulIncident.incidentDate ??
                                "غير محدد",
                            icon: 'assets/images/date_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تأثير الحادث على الحالة النفسية",
                            value: mockMentalIllnessRequest.hasImpactfulIncident
                                    .incidentPsychologicalImpact ??
                                "غير محدد",
                            icon: 'assets/images/psychology_icon.png',
                            isExpanded: true,
                          ),
                        ] else ...[
                          DetailsViewInfoTile(
                            title: "وجود حادث أو موقف له تأثير؟",
                            value: "لا",
                            icon: 'assets/images/psychology_icon.png',
                            isExpanded: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  verticalSpacing(16),

                  // Family Mental Illness Container - Always show
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
                          title: "حالات نفسية مشابهة فى العائلة",
                          value: mockMentalIllnessRequest
                                      .hasFamilySimilarMentalIllnessCases
                                      .answer ==
                                  true
                              ? "نعم"
                              : "لا",
                          icon: 'assets/images/psychology_icon.png',
                          isExpanded: true,
                        ),
                        if (mockMentalIllnessRequest
                                .hasFamilySimilarMentalIllnessCases.answer ==
                            true) ...[
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "الصله العائلية",
                            value: mockMentalIllnessRequest
                                    .hasFamilySimilarMentalIllnessCases
                                    .relationship ??
                                "غير محدد",
                            icon: 'assets/images/group_icon.png',
                            isExpanded: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  verticalSpacing(16),

                  DetailsViewInfoTile(
                    title: "حالات الطوارىء النفسية",
                    value: mockMentalIllnessRequest
                            .selectedPsychologicalEmergencies ??
                        "لا توجد",
                    icon: 'assets/images/warning_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الدعم الاجتماعي",
                    value: mockMentalIllnessRequest.socialSupport ?? "غير محدد",
                    icon: 'assets/images/group_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "التأثيرات الجانبية للدواء",
                    value: mockMentalIllnessRequest
                            .selectedMedicationSideEffects ??
                        "لا توجد",
                    icon: 'assets/images/psychology_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الأنشطة المساندة للصحة النفسية",
                    value: mockMentalIllnessRequest
                            .preferredActivitiesForImprovement ??
                        "غير محدد",
                    icon: 'assets/images/activity_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),

                  // Psychological Treatment Container - Always show
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
                          value: mockMentalIllnessRequest
                                      .isReceivingPsychologicalTreatment
                                      .answer ==
                                  true
                              ? "نعم"
                              : "لا",
                          icon:
                              'assets/images/doctor_examination_tool_icon.png',
                          isExpanded: true,
                        ),
                        if (mockMentalIllnessRequest
                                .isReceivingPsychologicalTreatment.answer ==
                            true) ...[
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "أدوية مستخدمة",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .medicationsUsed ??
                                "غير محدد",
                            icon: 'assets/images/medicines_icon_2.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تأثير الدواء على الحياة اليومية",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .medicationEffectOnDailyLife ??
                                "غير محدد",
                            icon: 'assets/images/medicines_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "نوع العلاج النفسي",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .previousTherapyType ??
                                "غير محدد",
                            icon: 'assets/images/hugeicons_medicine.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "عدد الجلسات",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .numberOfSessions
                                    ?.toString() ??
                                "غير محدد",
                            icon: 'assets/images/counterـicon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "رضاك عن نتيجة الجلسات",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .therapySatisfaction ??
                                "غير محدد",
                            icon: 'assets/images/heart_rate_search_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "الطبيب / الأخصائي النفسي",
                            value: mockMentalIllnessRequest
                                    .isReceivingPsychologicalTreatment
                                    .doctorOrSpecialist ??
                                "غير محدد",
                            icon: 'assets/images/doctor_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          Row(
                            children: [
                              Expanded(
                                child: DetailsViewInfoTile(
                                  title: "المستشفى/المركز",
                                  value: mockMentalIllnessRequest
                                          .isReceivingPsychologicalTreatment
                                          .hospitalOrCenter ??
                                      "غير محدد",
                                  icon: 'assets/images/hospital_icon.png',
                                  isExpanded: true,
                                ),
                              ),
                              horizontalSpacing(16),
                              Expanded(
                                child: DetailsViewInfoTile(
                                  title: "الدولة",
                                  value: mockMentalIllnessRequest
                                          .isReceivingPsychologicalTreatment
                                          .country ??
                                      "غير محدد",
                                  icon: 'assets/images/country_icon.png',
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _shareMentalIllnessDetails(
      BuildContext context, MentalIllnessDataViewState state) async {
    try {
      // Using mock data for now - replace with actual data when available
      final details = MentalIllnessRequestBody(
        diagnosisDate: "2025-01-25",
        mentalIllnessType: "اضطراب القلق العام",
        symptomsList: ["الأرق", "سرعة الانفعال", "صعوبة التركيز"],
        illnessSeverity: "متوسط",
        illnessDuration: "7 شهور",
        hasImpactfulIncident: ImpactfulIncident(
          answer: false,
          incidentType: "حادث سير",
          incidentDate: "2024-06-10",
          incidentPsychologicalImpact: "أدى إلى توتر وقلق مستمر",
        ),
        hasFamilySimilarMentalIllnessCases: FamilyMentalIllness(
          answer: false,
          relationship: "الأب",
        ),
        selectedPsychologicalEmergencies: "حالة طارئة",
        socialSupport: "العائلة والأصدقاء يقدمون دعمًا جيدًا",
        selectedMedicationSideEffects: "شعور بالدوخة والخمول",
        preferredActivitiesForImprovement: "الرياضة والتأمل",
        isReceivingPsychologicalTreatment: PsychologicalTreatment(
          answer: false,
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

      // When you have real data, use this instead:
      // final details = state.selectedMentalIllnessDocumentDetails!;

      final text = '''
    🧠 *تفاصيل الحالة النفسية* 🧠

    📅 *تاريخ التشخيص*: ${details.diagnosisDate}
    🏷️ *نوع المرض*: ${details.mentalIllnessType}

    💡 *الأعراض*:
    ${details.symptomsList.map((symptom) => "🔹 $symptom").join('\n')}

    ⚠️ *شدة المرض*: ${details.illnessSeverity}
    ⏳ *مدة المرض*: ${details.illnessDuration}

    🚨 *حالات الطوارئ النفسية*: ${details.selectedPsychologicalEmergencies ?? "لا توجد"}
    👨‍👩‍👧‍👦 *الدعم الاجتماعي*: ${details.socialSupport ?? "غير محدد"}

    💊 *التأثيرات الجانبية للدواء*: 
    ${details.selectedMedicationSideEffects ?? "لا توجد"}

    🏋️ *الأنشطة المساندة*: 
    ${details.preferredActivitiesForImprovement ?? "غير محدد"}

    ${details.hasImpactfulIncident.answer! ? '🚑 *حادث مؤثر*:\n- النوع: ${details.hasImpactfulIncident.incidentType}\n- التاريخ: ${details.hasImpactfulIncident.incidentDate}\n- التأثير: ${details.hasImpactfulIncident.incidentPsychologicalImpact}' : '🚑 *حادث مؤثر*: لا'}

    👪 *حالات عائلية مشابهة*: 
    ${details.hasFamilySimilarMentalIllnessCases.answer! ? 'نعم (${details.hasFamilySimilarMentalIllnessCases.relationship})' : 'لا'}

    🏥 *العلاج النفسي*: 
    ${details.isReceivingPsychologicalTreatment.answer! ? '''
    - الأدوية: ${details.isReceivingPsychologicalTreatment.medicationsUsed}
    - تأثير الأدوية: ${details.isReceivingPsychologicalTreatment.medicationEffectOnDailyLife}
    - نوع العلاج: ${details.isReceivingPsychologicalTreatment.previousTherapyType}
    - عدد الجلسات: ${details.isReceivingPsychologicalTreatment.numberOfSessions}
    - الرضا عن العلاج: ${details.isReceivingPsychologicalTreatment.therapySatisfaction}
    - الطبيب: ${details.isReceivingPsychologicalTreatment.doctorOrSpecialist}
    - المركز: ${details.isReceivingPsychologicalTreatment.hospitalOrCenter}
    - الدولة: ${details.isReceivingPsychologicalTreatment.country}
    ''' : 'لا'}
    ''';

      await Share.share(text);
    } catch (e) {
      await showError("❌ حدث خطأ أثناء المشاركة");
    }
  }
}
