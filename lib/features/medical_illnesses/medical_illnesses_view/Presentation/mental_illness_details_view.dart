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
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
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
    return BlocProvider(
      create: (context) => getIt<MentalIllnessDataViewCubit>()
        ..getMentalIllnessDocumentDetailsById(docId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<MentalIllnessDataViewCubit,
            MentalIllnessDataViewState>(
          listener: (context, state) async {
            if (state.requestStatus == RequestStatus.success &&
                state.isDeleteRequest) {
              Navigator.pop(context);
              await showSuccess(state.responseMessage);
            } else if (state.requestStatus == RequestStatus.failure) {
              await showError(state.responseMessage);
            }
          },
          builder: (context, state) {
            final docDetails = state.selectedMentalIllnessDocumentDetails;
            if (docDetails == null) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWithCenteredTitle(
                    title: docDetails.mentalIllnessType,
                    shareFunction: () async {
                      await _shareMentalIllnessDetails(context, docDetails);
                    },
                    deleteFunction: () async {
                      await context
                          .read<MentalIllnessDataViewCubit>()
                          .deleteMentalIllnessDetailsDocumentById(docId);
                      // Add deletion logic if needed
                    },
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color:
                            state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                    true
                                ? AppColorsManager.mainDarkBlue
                                : Colors.grey,
                        onTap:
                            state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                    true
                                ? () => launchYouTubeVideo(
                                    state.moduleGuidanceData!.videoLink)
                                : null,
                      ),
                      SizedBox(width: 12.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color: state.moduleGuidanceData?.moduleGuidanceText
                                    ?.isNotEmpty ==
                                true
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: state.moduleGuidanceData?.moduleGuidanceText
                                    ?.isNotEmpty ==
                                true
                            ? () {
                                ModuleGuidanceAlertDialog.show(
                                  context,
                                  title: "الأمراض النفسية",
                                  description: state
                                      .moduleGuidanceData!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "تاريخ التشخيص",
                    value: docDetails.diagnosisDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "نوع المرض",
                    value: docDetails.mentalIllnessType,
                    icon: 'assets/images/analysis_type.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الأعراض المرضية",
                    value: docDetails.symptomsList.join(", "),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "شدة المرض",
                    value: docDetails.illnessSeverity,
                    icon: 'assets/images/heart_rate_search_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "مدة المرض",
                    value: docDetails.illnessDuration,
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
                        docDetails.hasImpactfulIncident.answer == true
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
                        if (docDetails.hasImpactfulIncident.answer == true) ...[
                          DetailsViewInfoTile(
                            title: "نوع الموقف",
                            value:
                                docDetails.hasImpactfulIncident.incidentType ??
                                    "غير محدد",
                            icon: 'assets/images/analysis_type.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تاريخ الموقف",
                            value:
                                docDetails.hasImpactfulIncident.incidentDate ??
                                    "غير محدد",
                            icon: 'assets/images/date_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تأثير الحادث على الحالة النفسية",
                            value: docDetails.hasImpactfulIncident
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
                          value: docDetails.hasFamilySimilarMentalIllnessCases
                                      .answer ==
                                  true
                              ? "نعم"
                              : "لا",
                          icon: 'assets/images/psychology_icon.png',
                          isExpanded: true,
                        ),
                        if (docDetails
                                .hasFamilySimilarMentalIllnessCases.answer ==
                            true) ...[
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "الصله العائلية",
                            value: docDetails.hasFamilySimilarMentalIllnessCases
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
                    value: docDetails.selectedPsychologicalEmergencies ??
                        "لا توجد",
                    icon: 'assets/images/warning_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الدعم الاجتماعي",
                    value: docDetails.socialSupport ?? "غير محدد",
                    icon: 'assets/images/group_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "التأثيرات الجانبية للدواء",
                    value:
                        docDetails.selectedMedicationSideEffects ?? "لا توجد",
                    icon: 'assets/images/psychology_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الأنشطة المساندة للصحة النفسية",
                    value: docDetails.preferredActivitiesForImprovement ??
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
                          value: docDetails.isReceivingPsychologicalTreatment
                                      .answer ==
                                  true
                              ? "نعم"
                              : "لا",
                          icon:
                              'assets/images/doctor_examination_tool_icon.png',
                          isExpanded: true,
                        ),
                        if (docDetails
                                .isReceivingPsychologicalTreatment.answer ==
                            true) ...[
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "أدوية مستخدمة",
                            value: docDetails.isReceivingPsychologicalTreatment
                                    .medicationsUsed ??
                                "غير محدد",
                            icon: 'assets/images/medicines_icon_2.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "تأثير الدواء على الحياة اليومية",
                            value: docDetails.isReceivingPsychologicalTreatment
                                    .medicationEffectOnDailyLife ??
                                "غير محدد",
                            icon: 'assets/images/medicines_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "نوع العلاج النفسي",
                            value: docDetails.isReceivingPsychologicalTreatment
                                    .previousTherapyType ??
                                "غير محدد",
                            icon: 'assets/images/hugeicons_medicine.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "عدد الجلسات",
                            value: docDetails.isReceivingPsychologicalTreatment
                                    .numberOfSessions
                                    ?.toString() ??
                                "غير محدد",
                            icon: 'assets/images/counterـicon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "رضاك عن نتيجة الجلسات",
                            value: docDetails.isReceivingPsychologicalTreatment
                                    .therapySatisfaction ??
                                "غير محدد",
                            icon: 'assets/images/heart_rate_search_icon.png',
                            isExpanded: true,
                          ),
                          verticalSpacing(16),
                          DetailsViewInfoTile(
                            title: "الطبيب / الأخصائي النفسي",
                            value: docDetails.isReceivingPsychologicalTreatment
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
                                  value: docDetails
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
                                  value: docDetails
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
      BuildContext context, MentalIllnessRequestBody state) async {
    try {
      final text = '''
🧠 تفاصيل الحالة النفسية

📅 تاريخ التشخيص: ${state.diagnosisDate}
🏷️ نوع المرض: ${state.mentalIllnessType}

🤒 الأعراض:
${state.symptomsList.asMap().entries.map((e) => "${e.key + 1}. ${e.value}").join('\n')}

⚠️ شدة المرض: ${state.illnessSeverity}
⏳ مدة المرض: ${state.illnessDuration}

🚨 حالات الطوارئ النفسية: ${state.selectedPsychologicalEmergencies ?? "لا توجد"}
👨‍👩‍👧‍👦 الدعم الاجتماعي: ${state.socialSupport ?? "غير محدد"}

💊 التأثيرات الجانبية للدواء:
${state.selectedMedicationSideEffects ?? "لا توجد"}

🏃 الأنشطة المساندة للصحة النفسية:
${state.preferredActivitiesForImprovement ?? "غير محدد"}

🚑 وجود حادث مؤثر:
${state.hasImpactfulIncident.answer == true ? "نعم" : "لا"}
${state.hasImpactfulIncident.answer == true ? '''
نوع الموقف: ${state.hasImpactfulIncident.incidentType ?? "غير محدد"}
تاريخ الموقف: ${state.hasImpactfulIncident.incidentDate ?? "غير محدد"}
تأثير الحادث: ${state.hasImpactfulIncident.incidentPsychologicalImpact ?? "غير محدد"}
''' : ""}

👪 حالات نفسية مشابهة في العائلة:
${state.hasFamilySimilarMentalIllnessCases.answer == true ? "نعم" : "لا"}
${state.hasFamilySimilarMentalIllnessCases.answer == true ? '''
صلة القرابة: ${state.hasFamilySimilarMentalIllnessCases.relationship ?? "غير محدد"}
''' : ""}

🩺 تلقي علاج نفسي:
${state.isReceivingPsychologicalTreatment.answer == true ? "نعم" : "لا"}
${state.isReceivingPsychologicalTreatment.answer == true ? '''
الأدوية المستخدمة: ${state.isReceivingPsychologicalTreatment.medicationsUsed ?? "غير محدد"}
تأثير الدواء على الحياة اليومية: ${state.isReceivingPsychologicalTreatment.medicationEffectOnDailyLife ?? "غير محدد"}
نوع العلاج النفسي: ${state.isReceivingPsychologicalTreatment.previousTherapyType ?? "غير محدد"}
عدد الجلسات: ${state.isReceivingPsychologicalTreatment.numberOfSessions ?? "غير محدد"}
الرضا عن نتيجة الجلسات: ${state.isReceivingPsychologicalTreatment.therapySatisfaction ?? "غير محدد"}
الطبيب / الأخصائي: ${state.isReceivingPsychologicalTreatment.doctorOrSpecialist ?? "غير محدد"}
المستشفى / المركز: ${state.isReceivingPsychologicalTreatment.hospitalOrCenter ?? "غير محدد"}
الدولة: ${state.isReceivingPsychologicalTreatment.country ?? "غير محدد"}
''' : ""}
''';

      await Share.share(text);
    } catch (e) {
      await showError("❌ حدث خطأ أثناء المشاركة");
    }
  }
}
