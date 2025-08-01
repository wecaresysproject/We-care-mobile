import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
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
              "فحوصات جينية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.firstImageRequestStatus != curr.firstImageRequestStatus,
              listener: (context, state) async {
                if (state.firstImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.firstImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .uploadFirstImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),

            verticalSpacing(16),
            Text(
              "فحوصات أخرى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.secondImageRequestStatus !=
                  curr.secondImageRequestStatus,
              listener: (context, state) async {
                if (state.secondImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.secondImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .uploadSecondImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),

            verticalSpacing(16),
            Text(
              "التقرير الطبى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: "اكتب التقرير",
              onTap: () {},
            ),

            verticalSpacing(8),
            BlocListener<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              listenWhen: (previous, current) =>
                  previous.reportRequestStatus != current.reportRequestStatus,
              listener: (context, state) async {
                if (state.reportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.reportRequestStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: " ارفق صورة للتقرير",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .uploadReportImage(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
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
              options: hosptitalsNames,
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
