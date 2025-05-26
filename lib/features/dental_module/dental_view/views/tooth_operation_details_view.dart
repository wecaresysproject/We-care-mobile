import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';

class DentalOperationDetailsView extends StatelessWidget {
  const DentalOperationDetailsView({
    super.key,
    required this.documentId,
  });
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DentalViewCubit>()..getToothOperationDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          child: BlocConsumer<DentalViewCubit, DentalViewState>(
              listener: (context, state) {
                  if (state.requestStatus == RequestStatus.failure &&
                      state.message != null &&
                      state.isDeleteRequest) {
                    showError(state.message!);
                  }
                  if (state.requestStatus == RequestStatus.success &&
                      state.isDeleteRequest &&
                      state.message != null) {
                    showSuccess(state.message ?? "تم الحذف بنجاح");
                    Navigator.pop(context, true);
                  }
                },
            buildWhen: (previous, current) =>
                previous.selectedToothOperationDetails !=
                current.selectedToothOperationDetails,
            builder: (context, state) {
              if (state.requestStatus == RequestStatus.loading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state.requestStatus == RequestStatus.failure) {
                return Center(
                  child: Text(
                    state.message ?? "حدث خطأ",
                    style: AppTextStyles.font16DarkGreyWeight400,
                  ),
                );
              } else if (state.selectedToothOperationDetails == null) {
                return Center(
                  child: Text(
                    "لا توجد بيانات",
                    style: AppTextStyles.font22MainBlueWeight700,
                  ),
                );
              }
              return Column(
                children: [
                  DetailsViewAppBar(
                      deleteFunction: () => context
                          .read<DentalViewCubit>()
                          .deleteToothOperationDetailsById(documentId),
                      shareFunction: () => shareDentalDetails(context, state),
                      title: state.selectedToothOperationDetails!.procedure
                          .primaryProcedure),
                  verticalSpacing(16),
                  SymptomContainer(
                    complaintDate: state.selectedToothOperationDetails!
                        .medicalComplaints.symptomStartDate,
                    complaintReason: state.selectedToothOperationDetails!
                        .medicalComplaints.reasonExcpected,
                    symptomComplaint: state.selectedToothOperationDetails!
                        .medicalComplaints.symptomType,
                    natureOfComplaint: state.selectedToothOperationDetails!
                        .medicalComplaints.complaintNature,
                    severityOfComplaint: state.selectedToothOperationDetails!
                        .medicalComplaints.painNature,
                  ),
                  verticalSpacing(16),
                  MedicalOperationsComponent(
                    operationStartDate: state
                        .selectedToothOperationDetails!.procedure.procedureDate,
                    mainMedicalOperation: state.selectedToothOperationDetails!
                        .procedure.primaryProcedure,
                    secendoryMedicalOperation: state
                        .selectedToothOperationDetails!.procedure.subProcedure,
                    operationDetailedDescription: state
                        .selectedToothOperationDetails!
                        .procedure
                        .patientDescription,
                    operationType: state
                        .selectedToothOperationDetails!.procedure.procedureType,
                    operationLevelOfPain: state
                        .selectedToothOperationDetails!.procedure.painLevel,
                    operationRecoveryDuration: state
                        .selectedToothOperationDetails!.procedure.painLevel,
                    useOfAnesthesia: state
                        .selectedToothOperationDetails!.procedure.painLevel,
                  ),
                  verticalSpacing(16),
                  DetailsViewImageWithTitleTile(
                    image: state.selectedToothOperationDetails!
                        .medicalReportImage, // Replace with actual image URL or asset
                    title: "التقرير الطبي",
                  ),
                  verticalSpacing(16),
                  DetailsViewImageWithTitleTile(
                    image: state.selectedToothOperationDetails!
                        .xRayImage, // Replace with actual image URL or asset
                    title: "اللقطة السنية",
                  ),
                  verticalSpacing(16),
                  DetailsViewImageWithTitleTile(
                    image: state.selectedToothOperationDetails!
                        .lymphAnalysisImage, // Replace with actual image URL or asset
                    title: "التحاليل الطبية الفموية ",
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "الطبيب المعالج",
                    value: state.selectedToothOperationDetails!.treatingDoctor,
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "الدولة",
                      value: state.selectedToothOperationDetails!.country,
                      icon: 'assets/images/country_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "المستشفي",
                      value: state.selectedToothOperationDetails!.hospital,
                      icon: 'assets/images/hospital_icon.png',
                    ),
                  ]),
                  DetailsViewInfoTile(
                    title: " ملاحظات شخصية",
                    value: state.selectedToothOperationDetails!.additionalNotes,
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SymptomContainer extends StatelessWidget {
  const SymptomContainer({
    super.key,
    required this.complaintDate,
    required this.symptomComplaint,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
    required this.complaintReason,
  });

  final String complaintDate;
  final String symptomComplaint;
  final String natureOfComplaint;
  final String severityOfComplaint;
  final String complaintReason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "الشكوي المرضية",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              Spacer(),
              CustomActionButton(
                onTap: () {
                  final shareContent = '''
📆 تاريخ الشكوى: $complaintDate
📋 الشكوى: $complaintReason
🧠 طبيعة الشكوى: $natureOfComplaint
🔥 حدة الشكوى: $severityOfComplaint
🧪 نوع الأعراض: $symptomComplaint
''';
                  Share.share(shareContent);
                },
                title: 'ارسال',
                icon: 'assets/images/share.png',
              ),
            ],
          ),
          verticalSpacing(8),
          DetailsViewInfoTile(
            title: "تاريخ الشكوى",
            value: complaintDate,
            icon: 'assets/images/date_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: " الشكوى",
            value: symptomComplaint,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الاسباب المحتملة ",
            value: complaintReason,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "طبيعة الشكوى",
            value: natureOfComplaint,
            icon: 'assets/images/file_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "حدة الشكوى",
            value: severityOfComplaint,
            icon: 'assets/images/heart_rate_search_icon.png',
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class MedicalOperationsComponent extends StatelessWidget {
  const MedicalOperationsComponent({
    super.key,
    required this.operationStartDate,
    required this.mainMedicalOperation,
    required this.secendoryMedicalOperation,
    required this.operationDetailedDescription,
    required this.operationType,
    required this.operationLevelOfPain,
    required this.operationRecoveryDuration,
    required this.useOfAnesthesia,
  });

  final String operationStartDate;
  final String mainMedicalOperation;
  final String secendoryMedicalOperation;
  final String operationDetailedDescription;
  final String operationType;
  final String operationLevelOfPain;
  final String operationRecoveryDuration;
  final String useOfAnesthesia;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "الإجراء الطبي",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              Spacer(),
              CustomActionButton(
                onTap: () {
                  final shareContent = '''
🛠️ الإجراء الطبي  
📅 التاريخ: $operationStartDate
🔧 الرئيسي: $mainMedicalOperation
📎 الفرعي: $secendoryMedicalOperation
📝 وصف: $operationDetailedDescription 
🏷️ النوع: $operationType
💥 الألم: $operationLevelOfPain
⏳ مدة الشفاء: $operationRecoveryDuration
💉 نوع التخدير: $useOfAnesthesia
''';
                  Share.share(shareContent);
                },
                title: 'ارسال',
                icon: 'assets/images/share.png',
              ),
            ],
          ),
          verticalSpacing(8),
          DetailsViewInfoTile(
            title: "تاريخ الإجراء",
            value: operationStartDate,
            icon: 'assets/images/date_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الإجراء الطبي الرئيسي",
            value: mainMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الإجراء الطبي الفرعي",
            value: secendoryMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الوصف التفصيلي للإجراء",
            value: operationDetailedDescription,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "نوع الإجراء",
                value: operationType,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "مستوى الألم",
                value: operationLevelOfPain,
                icon: 'assets/images/heart_rate_search_icon.png',
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "استخدام التخدير",
                value: useOfAnesthesia,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "مدة الشفاء",
                value: operationRecoveryDuration,
                icon: 'assets/images/notes_icon.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> shareDentalDetails(
    BuildContext context, DentalViewState state) async {
  final dentalData = state.selectedToothOperationDetails;
  if (dentalData != null) {
    final shareContent = '''
🦷 تفاصيل الإجراء السني

📆 تاريخ الشكوى: ${dentalData.medicalComplaints.symptomStartDate}
📋 الشكوى: ${dentalData.medicalComplaints.symptomDuration}
🧠 طبيعة الشكوى: ${dentalData.medicalComplaints.complaintNature}
🔥 حدة الشكوى: ${dentalData.medicalComplaints.painNature}
🧪 نوع الأعراض: ${dentalData.medicalComplaints.symptomType}

🛠️ الإجراء الطبي:
📅 التاريخ: ${dentalData.procedure.procedureDate}
🔧 الرئيسي: ${dentalData.procedure.primaryProcedure}
📎 الفرعي: ${dentalData.procedure.subProcedure}
📝 وصف: ${dentalData.procedure.patientDescription}
🏷️ النوع: ${dentalData.procedure.procedureType}
💥 الألم: ${dentalData.procedure.painLevel}
⏳ مدة الشفاء: ${dentalData.procedure.recoveryTime}
💉 نوع التخدير: ${dentalData.procedure.anesthesia}

👨‍⚕️ الطبيب المعالج: ${dentalData.treatingDoctor}
🏥 المستشفى: ${dentalData.hospital}
🌍 الدولة: ${dentalData.country}
📌 ملاحظات إضافية: ${dentalData.additionalNotes}
''';

    // تحميل الصور
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (dentalData.medicalReportImage.startsWith("http")) {
      final path = await downloadImage(
          dentalData.medicalReportImage, tempDir, 'report.png');
      if (path != null) imagePaths.add(path);
    }

    if (dentalData.xRayImage.startsWith("http")) {
      final path =
          await downloadImage(dentalData.xRayImage, tempDir, 'xray.png');
      if (path != null) imagePaths.add(path);
    }

    if (dentalData.lymphAnalysisImage.startsWith("http")) {
      final path = await downloadImage(
          dentalData.lymphAnalysisImage, tempDir, 'lymph.png');
      if (path != null) imagePaths.add(path);
    }

    // المشاركة
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(imagePaths.map((e) => XFile(e)).toList(),
          text: shareContent);
    } else {
      await Share.share(shareContent);
    }
  } else {
    showError("لا توجد بيانات للمشاركة.");
  }
}
