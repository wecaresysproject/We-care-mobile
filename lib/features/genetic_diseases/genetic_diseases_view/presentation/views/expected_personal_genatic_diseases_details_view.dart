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

class PersonalGenaticDiseasesDetailsView extends StatelessWidget {
  const PersonalGenaticDiseasesDetailsView({super.key, required this.disease});
 final String disease;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticsDiseasesViewCubit>(
      create: (context) => getIt.get<GeneticsDiseasesViewCubit>()
        ..getFamilyMemberGeneticDiseaseDetails(
          disease: disease,
        ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsViewAppBar(
                    title: 'المرض الوراثى',
                    showActionButtons: true,
                    showShareButtonOnly: true,
                  ),
                  SizedBox(height: 16),
                  ExpectedPersonalGenaticDiseaseInfo(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExpectedPersonalGenaticDiseaseInfo extends StatelessWidget {
  const ExpectedPersonalGenaticDiseaseInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading ||
            state.familyMemberGeneticDiseaseDetails == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final GenaticDiseaseDetails diseaseDetails = state
            .familyMemberGeneticDiseaseDetails!.genaticDiseaseDetails.first;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  DetailsViewInfoTile(
                    title: "المرض الوراثى",
                    value: diseaseDetails.geneticDisease!,
                    icon: 'assets/images/tumor_icon.png',
                  ),
                  Spacer(),
                  DetailsViewInfoTile(
                    title: 'المرحلة العمرية للظهور',
                    value: diseaseDetails.typicalOnsetAge!,
                    icon: 'assets/images/time_icon.png',
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  DetailsViewInfoTile(
                    title: "التصنيف الطبي للمرض",
                    value: diseaseDetails.medicalClassification!,
                    icon: 'assets/images/file_icon.png',
                  ),
                  Spacer(),
                  DetailsViewInfoTile(
                    title: "نوع الوراثة",
                    value: diseaseDetails.inheritanceType!,
                    icon: 'assets/images/symptoms_icon.png',
                  ),
                ],
              ),

              DetailsViewInfoTile(
                title: "الوصف التفصيلي",
                value: diseaseDetails.detailedDescription!,
                icon: 'assets/images/doctor_name.png',
                isExpanded: true,
              ),
              verticalSpacing(16),
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

              Row(
                children: [
                  DetailsViewInfoTile(
                    title: "الجين المسؤول",
                    value: diseaseDetails.responsibleGene!,
                    icon: 'assets/images/time_icon.png',
                  ),
                  Spacer(),
                  DetailsViewInfoTile(
                    title: 'معدل الانتشار الجغرافي',
                    value: diseaseDetails.prevalenceRate!,
                    icon: 'assets/images/symptoms_icon.png',
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  DetailsViewInfoTile(
                    title: "مستوى المخاطرة",
                    value: diseaseDetails.riskLevel!.join(','),
                    icon: 'assets/images/symptoms_icon.png',
                  ),
                  Spacer(),
                  DetailsViewInfoTile(
                    title: "تفسير النطاق",
                    value: diseaseDetails.domainInterpretation!.join(','),
                    icon: 'assets/images/time_icon.png',
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
              ...diseaseDetails.mainSymptoms!.skip(1).map((symptom) => Column(
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
              ...diseaseDetails.diagnosticTests!.skip(1).map((test) => Column(
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
    );
  }
}
