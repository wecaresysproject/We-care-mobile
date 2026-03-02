import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';

class DentalOperationDetailsView extends StatelessWidget {
  const DentalOperationDetailsView({
    super.key,
    required this.documentId,
    this.toothNumber,
  });
  final String documentId;
  final String? toothNumber;

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
                return Center(
                  child: CircularProgressIndicator(),
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
                  AppBarWithCenteredTitle(
                    deleteFunction: () => context
                        .read<DentalViewCubit>()
                        .deleteToothOperationDetailsById(documentId),
                    editFunction: () async {
                      await context.pushNamed(
                        Routes.dentalDataEntryView,
                        arguments: {
                          'teethDocumentId': documentId,
                          "existingToothModel":
                              state.selectedToothOperationDetails,
                          "toothNumber": toothNumber,
                        },
                      ).then((value) async {
                        if (value == true) {
                          if (!context.mounted) return;
                          await context
                              .read<DentalViewCubit>()
                              .getToothOperationDetailsById(documentId);
                        }
                      });
                    },
                    shareFunction: () => shareDentalDetails(context, state),
                    title: state.selectedToothOperationDetails!.procedure
                                    .primaryProcedure !=
                                null &&
                            state.selectedToothOperationDetails!.procedure
                                .primaryProcedure!.isNotFilled
                        ? "تفاصيل الإجراء السني"
                        : state.selectedToothOperationDetails!.procedure
                            .primaryProcedure!,
                    showActionButtons: true,
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
                                  title: "الأشعة",
                                  description: state
                                      .moduleGuidanceData!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  verticalSpacing(16),
                  SymptomContainer(
                    complaintDate: state.selectedToothOperationDetails!
                        .medicalComplaints.symptomStartDate!,
                    complaintReason: state.selectedToothOperationDetails!
                            .medicalComplaints.reasonExcpected ??
                        "",
                    symptomComplaint: state.selectedToothOperationDetails!
                            .medicalComplaints.symptomType ??
                        "",
                    natureOfComplaint: state.selectedToothOperationDetails!
                            .medicalComplaints.complaintNature ??
                        "",
                    severityOfComplaint: state.selectedToothOperationDetails!
                            .medicalComplaints.painNature ??
                        "",
                  ),
                  verticalSpacing(16),
                  MedicalOperationsComponent(
                    operationStartDate: state.selectedToothOperationDetails!
                            .procedure.procedureDate ??
                        "",
                    mainMedicalOperation: state.selectedToothOperationDetails!
                            .procedure.primaryProcedure ??
                        "",
                    secendoryMedicalOperation: state
                            .selectedToothOperationDetails!
                            .procedure
                            .subProcedure ??
                        "",
                    operationDetailedDescription: state
                            .selectedToothOperationDetails!
                            .procedure
                            .patientDescription ??
                        "",
                    operationType: state.selectedToothOperationDetails!
                            .procedure.procedureType ??
                        "",
                    operationLevelOfPain: state.selectedToothOperationDetails!
                            .procedure.painLevel ??
                        "",
                    operationRecoveryDuration: state
                            .selectedToothOperationDetails!
                            .procedure
                            .painLevel ??
                        "",
                    useOfAnesthesia: state.selectedToothOperationDetails!
                            .procedure.painLevel ??
                        "",
                  ),
                  verticalSpacing(16),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedToothOperationDetails!
                        .medicalReportImage, // Replace with actual image URL or asset
                    title: "التقرير الطبي",
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedToothOperationDetails!
                        .xRayImage, // Replace with actual image URL or asset
                    title: "اللقطة السنية",
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedToothOperationDetails!
                        .lymphAnalysisImage, // Replace with actual image URL or asset
                    title: "التحاليل الطبية الفموية ",
                  ),
                  DetailsViewInfoTile(
                    title: "الطبيب المعالج",
                    value: state.selectedToothOperationDetails!.treatingDoctor,
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الدولة",
                    value: state.selectedToothOperationDetails!.country,
                    icon: 'assets/images/country_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المستشفي",
                    value: state.selectedToothOperationDetails!.hospital ?? "",
                    icon: 'assets/images/hospital_icon.png',
                    isExpanded: true,
                  ),
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
    if (complaintDate.isNotFilled &&
        symptomComplaint.isNotFilled &&
        natureOfComplaint.isNotFilled &&
        severityOfComplaint.isEmpty &&
        complaintReason.isNotFilled) {
      return SizedBox.shrink();
    }
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
          DetailsViewInfoTile(
            title: " الشكوى",
            value: symptomComplaint,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          DetailsViewInfoTile(
            title: "الاسباب المحتملة ",
            value: complaintReason,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
          DetailsViewInfoTile(
            title: "طبيعة الشكوى",
            value: natureOfComplaint,
            icon: 'assets/images/file_icon.png',
            isExpanded: true,
          ),
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
    if (operationStartDate.isNotFilled &&
        mainMedicalOperation.isNotFilled &&
        secendoryMedicalOperation.isNotFilled &&
        operationDetailedDescription.isNotFilled &&
        operationType.isNotFilled &&
        operationLevelOfPain.isNotFilled &&
        operationRecoveryDuration.isNotFilled &&
        useOfAnesthesia.isNotFilled) {
      return SizedBox.shrink();
    }
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
          DetailsViewInfoTile(
            title: "الإجراء الطبي الرئيسي",
            value: mainMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          DetailsViewInfoTile(
            title: "الإجراء الطبي الفرعي",
            value: secendoryMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          DetailsViewInfoTile(
            title: "الوصف التفصيلي للإجراء",
            value: operationDetailedDescription,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
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
    List<String> imagePaths = [];

    // if (dentalData.medicalReportImage.startsWith("http")) {
    //   final path = await downloadImage(
    //       dentalData.medicalReportImage, tempDir, 'report.png');
    //   if (path != null) imagePaths.add(path);
    // }

    // if (dentalData.xRayImage.startsWith("http")) {
    //   final path =
    //       await downloadImage(dentalData.xRayImage, tempDir, 'xray.png');
    //   if (path != null) imagePaths.add(path);
    // }

    // if (dentalData.lymphAnalysisImage.startsWith("http")) {
    //   final path = await downloadImage(
    //       dentalData.lymphAnalysisImage, tempDir, 'lymph.png');
    //   if (path != null) imagePaths.add(path);
    // }

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
