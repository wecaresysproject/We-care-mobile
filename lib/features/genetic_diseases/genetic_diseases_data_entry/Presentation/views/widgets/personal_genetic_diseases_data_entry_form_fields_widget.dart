import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/image_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/report_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class PersonalGeneticDiseasesDataEntryFormFieldsWidget extends StatefulWidget {
  const PersonalGeneticDiseasesDataEntryFormFieldsWidget({super.key});

  @override
  State<PersonalGeneticDiseasesDataEntryFormFieldsWidget> createState() =>
      _PersonalGeneticDiseasesDataEntryFormFieldsWidgetState();
}

class _PersonalGeneticDiseasesDataEntryFormFieldsWidgetState
    extends State<PersonalGeneticDiseasesDataEntryFormFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneticDiseasesDataEntryCubit,
        GeneticDiseasesDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ التشخيص",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.diagnosisDate == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.diagnosisDate ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateDiagnosisDate(pickedDate);
              },
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.geneticDiseaseCategory == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "فئة المرض الوراثى",
              containerHintText:
                  state.geneticDiseaseCategory ?? "اختر فئة المرض الوراثى",
              options: state.diseasesClassfications,
              onOptionSelected: (value) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedGeneticDiseaseCategory(value);
              },
              bottomSheetTitle: "اختر فئة المرض الوراثى",
              searchHintText: "ابحث عن فئة المرض الوراثى",
              allowManualEntry: true,
              onRetryPressed: () async {},
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedDiseaseName == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "المرض الوراثى",
              containerHintText:
                  state.selectedDiseaseName ?? "اختر المرض الوراثى",
              options: state.diseasesNames,
              onOptionSelected: (value) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedGeneticDiseaseName(value);
              },
              bottomSheetTitle: "اختر المرض الوراثى",
              searchHintText: "ابحث المرض الوراثى",
              allowManualEntry: true,
              // loadingState: state.medicinesNamesOptionsLoadingState,
              onRetryPressed: () async {
                // await context
                //     .read<GeneticDiseasesDataEntryCubit>()
                //     .emitAllMedicinesNames();
              },
            ),
            verticalSpacing(16),
            // in case "متنحي"=> show "مصاب وحامل للاختيار من المستخدم"
            (state.diseasesStatuses.length == 1)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "حالة المرض",
                        style: AppTextStyles.font18blackWight500,
                      ),
                      verticalSpacing(10),
                      CustomContainer(
                        value: "مصاب",
                        isExpanded: true,
                      ),
                    ],
                  )
                : UserSelectionContainer(
                    containerBorderColor: state.selectedDiseaseStatus == null
                        ? AppColorsManager.warningColor
                        : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "حالة المرض",
                    containerHintText:
                        state.selectedDiseaseStatus ?? "اختر حالة المرض",
                    options: state.diseasesStatuses,
                    onOptionSelected: (value) async {
                      await context
                          .read<GeneticDiseasesDataEntryCubit>()
                          .updateSelectedDiseaseStatus(value);
                    },
                    bottomSheetTitle: "اختر حالة المرض",
                    searchHintText: "ابحث عن حالة المرض",
                    allowManualEntry: true,
                    // loadingState: state.medicinesNamesOptionsLoadingState,
                    onRetryPressed: () async {},
                  ),

            verticalSpacing(16),
            Text(
              "فحوصات جينية ${state.firstImageUploadedUrls.length}/8",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            ImageUploaderSection<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              statusSelector: (state) => state.firstImageRequestStatus,
              uploadedSelector: (state) => state.firstImageUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .removeSpecificUploadedFirstImage(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .uploadFirstImagePicked(
                      imagePath: path,
                    );
              },
            ),

            verticalSpacing(16),
            Text(
              "فحوصات أخرى ${state.secondImageUploadedUrls.length}/8",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            ImageUploaderSection<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              statusSelector: (state) => state.secondImageRequestStatus,
              uploadedSelector: (state) => state.secondImageUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .removeSpecificUploadedSecondImage(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .uploadSecondImagePicked(
                      imagePath: path,
                    );
              },
            ),

            verticalSpacing(16),
            Text(
              "التقرير الطبى ${state.reportsUploadedUrls.length} / 8",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<GeneticDiseasesDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                final cubit = context.read<GeneticDiseasesDataEntryCubit>();
                final isFirstTime = state.isEditMode;
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
            ReportUploaderSection<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              statusSelector: (state) => state.uploadReportStatus,
              uploadedSelector: (state) => state.reportsUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .removeUploadedReport(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .uploadReportImagePicked(
                      imagePath: path,
                    );
              },
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              options: state.doctorNames,
              categoryLabel: "الطبيب المعالج",
              bottomSheetTitle: "اختر اسم الطبيب",
              onOptionSelected: (value) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedDoctorName(value);
              },
              containerHintText:
                  state.selectedDoctorName ?? "اختر اسم الطبيب المعالج",
              searchHintText: "ابحث عن اسم الطبيب",
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              allowManualEntry: true,
              options: state.hospitalNames,
              categoryLabel: "المستشفى / المركز",
              bottomSheetTitle: "اختر اسم المستشفى/المركز",
              onOptionSelected: (value) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedHospitalName(value);
              },
              containerHintText:
                  state.selectedHospital ?? "اختر اسم المستشفى/المركز",
              searchHintText: "ابحث عن اسم المستشفى/المركز",
            ),
            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedCountry(value);
              },
              containerHintText: state.selectedCountryName ?? "اختر اسم الدولة",
              searchHintText: "ابحث عن الدولة",
            ),

            verticalSpacing(40),

            submitDataEnteredBlocConsumer(),

            verticalSpacing(71),
          ],
        );
      },
    );
  }
}

Widget submitDataEnteredBlocConsumer() {
  return BlocConsumer<GeneticDiseasesDataEntryCubit,
      GeneticDiseasesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.geneticDiseaseDataEntryStatus == RequestStatus.failure ||
        curr.geneticDiseaseDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.geneticDiseaseDataEntryStatus !=
            curr.geneticDiseaseDataEntryStatus,
    listener: (context, state) async {
      if (state.geneticDiseaseDataEntryStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        //* in order to catch it again to rebuild details view
        context.pop(
          result: true,
        );
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.geneticDiseaseDataEntryStatus == RequestStatus.loading,
        title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            state.isEditMode
                ? await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .submitEditsForPersonalGeneticDiseases()
                : await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .submitPersonalGeneticDiseaseDataEntry(
                      context.translate,
                    );
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}
