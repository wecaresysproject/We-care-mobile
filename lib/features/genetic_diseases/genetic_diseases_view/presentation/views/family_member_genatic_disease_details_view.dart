import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatic_disease_response_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class FamilyMemberGeneticDiseaseDetailsView extends StatelessWidget {
  const FamilyMemberGeneticDiseaseDetailsView(
      {super.key, required this.disease});
  final String disease;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticsDiseasesViewCubit>(
      create: (context) => getIt<GeneticsDiseasesViewCubit>()
        ..getFamilyMemberGeneticDiseaseDetails(
          disease: 'نقص إنزيم G6PD (الفوال)',
        ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.requestStatus == RequestStatus.failure) {
              return Center(
                child: Text(state.message ?? "حدث خطأ ما"),
              );
            } else if (state.familyMemberGeneticDiseaseDetails == null) {
              return Center(
                child: Text("لا توجد تفاصيل لهذا المرض"),
              );
            }
            final GenaticDiseaseDetails diseaseDetails =
                state.familyMemberGeneticDiseaseDetails!.genaticDiseaseDetails.first;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsViewAppBar(
                    title: disease,
                  ),

                  SizedBox(height: 16.h),
                  DetailsViewInfoTile(
                    title: "المرض الوراثى",
                    value: diseaseDetails.geneticDisease!,
                    icon: 'assets/images/tumor_icon.png',
                    isExpanded: true,
                  ),
                  SizedBox(height: 16.h),
                  DetailsViewInfoTile(
                    title: "حالة المرض",
                    value: diseaseDetails.diseaseStatuses!,
                    icon: 'assets/images/tumor_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(16),
                  // Disease Classification and Inheritance Type
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "التصنيف الطبي المرضي",
                        value: diseaseDetails.medicalClassification!,
                        icon: 'assets/images/tumor_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "نوع الوراثة",
                        value: diseaseDetails.inheritanceType!,
                        icon: 'assets/images/symptoms_icon.png',
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Detailed description
                  DetailsViewInfoTile(
                    title: "الوصف التفصيلي",
                    value: diseaseDetails.detailedDescription ?? "لا يوجد وصف",
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  SizedBox(height: 16.h),

                  // Responsible Gene and Inheritance Pattern
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "الجين المسؤول",
                          value: diseaseDetails.responsibleGene!,
                          icon: 'assets/images/tumor_icon.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "معدل الانتشار",
                          value: diseaseDetails.prevalenceRate!,
                          icon: 'assets/images/doctor_icon.png',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Age of Onset and Risk level
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "العمر النموذجي للظهور",
                        value: diseaseDetails.typicalOnsetAge!,
                        icon: 'assets/images/tumor_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "الجنس المعني",
                        value: diseaseDetails.affectedGender!,
                        icon: 'assets/images/symptoms_icon.png',
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Age of Onset and Risk level
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "المرحلة العمرية ",
                        value: diseaseDetails.typicalOnsetAge!,
                        icon: 'assets/images/time_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "مستوى المخاطرة",
                        value: diseaseDetails.riskLevel!.join(', '),
                        icon: 'assets/images/symptoms_icon.png',
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Main Symptoms
                  DetailsViewInfoTile(
                    title: "الأعراض الرئيسية",
                    value: diseaseDetails.mainSymptoms![0],
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),

                  // بناء عدد من الحاويات بناءً على عدد الأعراض
                  ...diseaseDetails.mainSymptoms!
                      .skip(1)
                      .map((symptom) => Column(
                            children: [
                              CustomContainer(
                                value: symptom,
                                isExpanded: true,
                              ),
                              verticalSpacing(8),
                            ],
                          )),

                  SizedBox(height: 16.h),

                  // Diagnostic Tests
                  DetailsViewInfoTile(
                    title: "الفحوصات التشخيصية",
                    value: diseaseDetails.diagnosticTests![0],
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(8),
                  // بناء عدد من الحاويات بناءً على عدد الفحوصات
                  ...diseaseDetails.diagnosticTests!
                      .skip(1)
                      .map((test) => Column(
                            children: [
                              CustomContainer(
                                value: test,
                                isExpanded: true,
                              ),
                              verticalSpacing(8),
                            ],
                          )),
                  SizedBox(height: 16.h),

                  // Available Treatments
                  DetailsViewInfoTile(
                    title: "العلاجات المتاحة",
                    value: diseaseDetails.availableTreatments![0],
                    icon: 'assets/images/medicine_icon.png',
                    isExpanded: true,
                  ),
                  verticalSpacing(8),
                  // بناء عدد من الحاويات بناءً على عدد العلاجات
                  ...diseaseDetails.availableTreatments!
                      .skip(1)
                      .map((treatment) => Column(
                            children: [
                              CustomContainer(
                                value: treatment,
                                isExpanded: true,
                              ),
                              verticalSpacing(8),
                            ],
                          )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
