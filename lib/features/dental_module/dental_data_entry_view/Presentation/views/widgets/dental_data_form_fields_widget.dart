import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/image_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/report_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/logic/cubit/dental_data_entry_cubit.dart';

class DentalDataFormFieldsWidget extends StatefulWidget {
  const DentalDataFormFieldsWidget({super.key, this.toothNumber});
  final String? toothNumber;
  @override
  State<DentalDataFormFieldsWidget> createState() =>
      _DentalDataFormFieldsWidgetState();
}

class _DentalDataFormFieldsWidgetState
    extends State<DentalDataFormFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DentalDataEntryCubit, DentalDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ بداية العرض",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.startIssueDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.startIssueDateSelection == null
                  ? isArabic()
                      ? "يوم / شهر / سنة"
                      : "Date / Month / Year"
                  : state.startIssueDateSelection!,
              onDateSelected: (pickedDate) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateStartIssueDate(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            /// size between each categogry
            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.syptomTypeSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "نوع العرض",
              containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
              options: state.complainTypes,
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
              },
              bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
              searchHintText: "ابحث عن العرض",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedSyptomsPeriod == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "مدة الأعراض",
              containerHintText:
                  state.selectedSyptomsPeriod ?? "اختر مدة استمرار الأعراض",
              options: [
                'ساعات',
                'يوم',
                'يومين',
                'ثلاث أيام',
                'أربعة أيام',
                'خمسة أيام',
                'ستة أيام',
                'أسبوع',
                '10 أيام',
                'أسبوعين',
                'ثلاث أسابيع',
                'شهر',
                'أكثر من شهر',
              ],
              onOptionSelected: (value) async {
                await context
                    .read<DentalDataEntryCubit>()
                    .updateSyptomsPeriod(value);

                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر المنطقة التى تمت بها العملية',
              searchHintText: "ابحث عن مدة استمرار الأعراض",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.natureOfComplaintSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "طبيعة الشكوي",
              containerHintText:
                  state.natureOfComplaintSelection ?? "اختر الحالة",
              options: [
                "مستمرة",
                "متقطعة",
                " تتزايد مع الوقت",
                " تتناقص مع الوقت"
              ],
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateNatureOfComplaint(value);
              },
              bottomSheetTitle: "اختر طبيعة الشكوي",
              searchHintText: "ابحث عن طبيعة الشكوي",
            ),
            verticalSpacing(16),
            Text(
              "حدة الشكوى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            OptionSelectorWidget(
              containerValidationColor: state.complaintDegree == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              options: [
                "قليلة",
                "متوسطة",
                "شديدة",
                "شديدة جدا",
                "غير محتملة",
              ],
              initialSelectedOption: state.complaintDegree,
              onOptionSelected: (value) async {
                await context
                    .read<DentalDataEntryCubit>()
                    .updateComplaintDegree(value);
              },
            ),
            verticalSpacing(16),
            Text(
              "تاريخ الاجراء الطبى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            DateTimePickerContainer(
              placeholderText: state.medicalProcedureDateSelection == null
                  ? isArabic()
                      ? "يوم / شهر / سنة"
                      : "Date / Month / Year"
                  : state.medicalProcedureDateSelection!,
              onDateSelected: (pickedDate) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateMedicalProcedureDate(pickedDate);
              },
            ),
            verticalSpacing(16),

            verticalSpacing(10),
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "الاجراء الطبى الرئيسى",
              containerHintText: state.primaryMedicalProcedureSelection ??
                  "اختر نوع الاجراء الطبى",
              options: state.mainProcedures,
              onOptionSelected: (value) async {
                await context
                    .read<DentalDataEntryCubit>()
                    .updatePrimaryMedicalProcedure(value);
              },
              bottomSheetTitle: "اختر نوع الاجراء الطبى",
              searchHintText: "ابحث عن نوع الاجراء الطبى",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "الاجراء الطبى الفرعي",
              containerHintText: state.secondaryMedicalProcedureSelection ??
                  "اختر نوع الاجراء الطبى الفرعى",
              options: state.secondaryProcedures,
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSecodaryMedicalProcedure(value);
              },
              bottomSheetTitle: "اختر نوع الاجراء الطبى الفرعى",
              searchHintText: "ابحث عن نوع الاجراء الطبى الفرعى",
            ),

            verticalSpacing(16),

            Text(
              "التقرير الطبي (${state.reportsImageUploadedUrls.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<DentalDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                // ✅ اقرا الـ cubit من الـ context الحالي
                final cubit = context.read<DentalDataEntryCubit>();
                final isFirstTime =
                    cubit.reportTextController.text.isEmpty == true;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReportScreenSharedWidget(
                      reportController: cubit.reportTextController,
                      screenTitle:
                          isFirstTime ? "اكتب التقرير" : "تعديل التقرير",
                      saveButtonText:
                          isFirstTime ? "حفظ التقرير" : "حفظ التعديلات",
                    ),
                  ),
                );
              },
            ),
            verticalSpacing(8),

            ReportUploaderSection<DentalDataEntryCubit, DentalDataEntryState>(
              statusSelector: (state) => state.uploadReportStatus,
              uploadedSelector: (state) => state.reportsImageUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<DentalDataEntryCubit>()
                    .removeUploadedTeethReport(imagePath);
              },
              onUpload: (path) async {
                await context.read<DentalDataEntryCubit>().uploadTeethReport(
                      imagePath: path,
                    );
              },
            ),

            verticalSpacing(16),
            Text(
              "الأشعة السينية (${state.xrayImagesUploadedUrls.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            ImageUploaderSection<DentalDataEntryCubit, DentalDataEntryState>(
              statusSelector: (state) => state.xRayImageRequestStatus,
              uploadedSelector: (state) => state.xrayImagesUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<DentalDataEntryCubit>()
                    .removeUploadedXrayImage(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<DentalDataEntryCubit>()
                    .uploadXrayImagePicked(
                      imagePath: path,
                    );
              },
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              options: state.allOralMedicalTests,
              categoryLabel:
                  "التحاليل الطبية الفموية (${state.lymphAnalysisImagesUploadedUrl.length}/8)",
              bottomSheetTitle: "اختر التحاليل الطبية الفموية",
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateOralPathologySelection(value);
              },
              containerHintText: state.oralPathologySelection ??
                  "اختر التحاليل الطبية الفموية",
              searchHintText: "ابحث عن التحاليل الطبية الفموية",
            ),

            verticalSpacing(16),

            ImageUploaderSection<DentalDataEntryCubit, DentalDataEntryState>(
              statusSelector: (state) => state.lymphAnalysisImageStatus,
              uploadedSelector: (state) => state.lymphAnalysisImagesUploadedUrl,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<DentalDataEntryCubit>()
                    .removeUploadedLymphImage(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<DentalDataEntryCubit>()
                    .uploadLymphAnalysisImage(
                      imagePath: path,
                    );
              },
            ),
            verticalSpacing(16),

            /// حالة اللثه المحيطه
            UserSelectionContainer(
              options: state.allGumsConditions,
              categoryLabel: "حالة اللثه المحيطة",
              bottomSheetTitle: "اختر حالة اللثه المحيطة",
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSurroundingGumsStatus(value);
              },
              containerHintText: state.selectedSurroundingGumStatus ??
                  "اختر حالة اللثه المحيطة",
              searchHintText: "ابحث عن حالة اللثه المحيطة",
            ),

            verticalSpacing(16),

            ///"اسم طبيب المعالج"
            UserSelectionContainer(
              allowManualEntry: true,
              options: state.doctorNames,
              categoryLabel: "اسم طبيب المعالج",
              bottomSheetTitle: "اختر اسم طبيب المعالج",
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedTreatingDoctor(value);
              },
              containerHintText:
                  state.treatingDoctor ?? "اختر اسم طبيب المعالج",
              searchHintText: "ابحث عن اسم طبيب المعالج",
            ),
            verticalSpacing(16),
// اختيار مركز الأسنان
            UserSelectionContainer(
              allowManualEntry: true,
              initialValue: state.selectedDentalCenter?.isEmptyOrNull == true
                  ? null
                  : state.selectedDentalCenter,

              /// يتعطل لو المستخدم اختار مستشفى
              isDisabled: state.selectedHospitalCenter.isNotEmptyOrNull,

              categoryLabel: "المركز",

              containerHintText: state.selectedHospitalCenter.isNotEmptyOrNull
                  ? "المستشفى محددة، لا يمكن اختيار مركز"
                  : (state.selectedDentalCenter.isEmptyOrNull
                      ? "اختر اسم المركز"
                      : state.selectedDentalCenter!),

              options: state.dentalCenters,

              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedDentalCenter(value);
              },

              /// لو مسح الاختيار
              onDismiss: () {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedDentalCenter("");
              },

              bottomSheetTitle: 'اختر اسم المركز',
              searchHintText: "ابحث عن المركز",
            ),

            verticalSpacing(16),

// اختيار مستشفى الأسنان
            UserSelectionContainer(
              allowManualEntry: true,
              initialValue: state.selectedHospitalCenter?.isEmptyOrNull == true
                  ? null
                  : state.selectedHospitalCenter,

              /// يتعطل لو المستخدم اختار مركز
              isDisabled: state.selectedDentalCenter.isNotEmptyOrNull,
              categoryLabel: "المستشفى",
              containerHintText: state.selectedDentalCenter.isNotEmptyOrNull
                  ? "المركز محدد، لا يمكن اختيار مستشفى"
                  : (state.selectedHospitalCenter.isEmptyOrNull
                      ? "اختر اسم المستشفى"
                      : state.selectedHospitalCenter!),
              options: state.hospitals,
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedHospitalCenter(value);
              },

              /// لو مسح الاختيار
              onDismiss: () {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedHospitalCenter("");
              },

              bottomSheetTitle: 'اختر اسم المستشفى',
              searchHintText: "ابحث عن المستشفى",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) {
                context
                    .read<DentalDataEntryCubit>()
                    .updateSelectedCountry(value);
              },
              containerHintText: state.selectedCountryName ?? "اختر اسم الدولة",
              searchHintText: "ابحث عن اسم الدولة",
              options: state.countriesNames,
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات اضافية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              hintText: "اكتب باختصار أى معلومات مهمة أخرى",
              controller: context
                  .read<DentalDataEntryCubit>()
                  .additionalNotesController,
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),
            buildSubmitDataEntryButtonBlocConsumer(widget.toothNumber!),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget buildSubmitDataEntryButtonBlocConsumer(String toothNumber) {
    return BlocConsumer<DentalDataEntryCubit, DentalDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.dentalDataEntryStatus == RequestStatus.failure ||
          curr.dentalDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.dentalDataEntryStatus != curr.dentalDataEntryStatus,
      listener: (context, state) async {
        if (state.dentalDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(
              result:
                  true //! send true back to test analysis details view inn order to check if its updated , then reload the view
              );
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.dentalDataEntryStatus == RequestStatus.loading,
          title: state.isEditMode ? "حفظ التعديلات" : context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<DentalDataEntryCubit>()
                      .submitEditedOneTeethReportDetails(
                        context.translate,
                        state.updatedTeethId,
                        toothNumber,
                      )
                  : await context
                      .read<DentalDataEntryCubit>()
                      .postOneTeethReportDetails(
                        context.translate,
                        toothNumber,
                      );
              log("xxx:Save Data Entry");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
