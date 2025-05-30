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
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class GeneticDiseasesDataEntryFormFieldsWidget extends StatefulWidget {
  const GeneticDiseasesDataEntryFormFieldsWidget({super.key});

  @override
  State<GeneticDiseasesDataEntryFormFieldsWidget> createState() =>
      _GeneticDiseasesDataEntryFormFieldsWidgetState();
}

class _GeneticDiseasesDataEntryFormFieldsWidgetState
    extends State<GeneticDiseasesDataEntryFormFieldsWidget> {
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
              containerBorderColor: state.medicineStartDate == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.medicineStartDate ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateStartMedicineDate(pickedDate);
              },
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedMedicineName == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "نوع المرض الوراثى",
              containerHintText:
                  state.selectedMedicineName ?? "اختر نوع المرض الوراثى",
              options: state.medicinesNames,
              onOptionSelected: (value) async {
                await context
                    .read<GeneticDiseasesDataEntryCubit>()
                    .updateSelectedMedicineName(value);
              },
              bottomSheetTitle: "اختر نوع المرض الوراثى",
              searchHintText: "ابحث عن نوع المرض الوراثى",
              allowManualEntry: true,
              // loadingState: state.medicinesNamesOptionsLoadingState,
              onRetryPressed: () async {
                // await context
                //     .read<GeneticDiseasesDataEntryCubit>()
                //     .emitAllMedicinesNames();
              },
            ),
            verticalSpacing(16),
            Text(
              "فحوصات جينية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
              // listenWhen: (prev, curr) =>
              //     prev.xRayImageRequestStatus != curr.xRayImageRequestStatus,
              listener: (context, state) async {
                // if (state.xRayImageRequestStatus ==
                //     UploadImageRequestStatus.success) {
                //   await showSuccess(state.message);
                // }
                // if (state.xRayImageRequestStatus ==
                //     UploadImageRequestStatus.failure) {
                //   await showError(state.message);
                // }
              },
              child: SelectImageContainer(
                // containerBorderColor: ((state.isXRayPictureSelected == null) ||
                //             (state.isXRayPictureSelected == false)) &&
                //         state.xRayPictureUploadedUrl.isEmpty
                //     ? AppColorsManager.warningColor
                //     : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        // context
                        //     .read<GeneticDiseasesDataEntryCubit>()
                        //     .updateXRayPicture(isImagePicked);

                        // await context
                        //     .read<GeneticDiseasesDataEntryCubit>()
                        //     .uploadXrayImagePicked(
                        //       imagePath: picker.pickedImage!.path,
                        //     );
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
              // listenWhen: (prev, curr) =>
              //     prev.xRayImageRequestStatus != curr.xRayImageRequestStatus,
              listener: (context, state) async {
                // if (state.xRayImageRequestStatus ==
                //     UploadImageRequestStatus.success) {
                //   await showSuccess(state.message);
                // }
                // if (state.xRayImageRequestStatus ==
                //     UploadImageRequestStatus.failure) {
                //   await showError(state.message);
                // }
              },
              child: SelectImageContainer(
                // containerBorderColor: ((state.isXRayPictureSelected == null) ||
                //             (state.isXRayPictureSelected == false)) &&
                //         state.xRayPictureUploadedUrl.isEmpty
                //     ? AppColorsManager.warningColor
                //     : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        // context
                        //     .read<GeneticDiseasesDataEntryCubit>()
                        //     .updateXRayPicture(isImagePicked);

                        // await context
                        //     .read<GeneticDiseasesDataEntryCubit>()
                        //     .uploadXrayImagePicked(
                        //       imagePath: picker.pickedImage!.path,
                        //     );
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
              // listenWhen: (previous, current) =>
              //     previous.xRayReportRequestStatus !=
              //     current.xRayReportRequestStatus,
              listener: (context, state) async {
                // if (state.xRayReportRequestStatus ==
                //     UploadReportRequestStatus.success) {
                //   await showSuccess(state.message);
                // }
                // if (state.xRayReportRequestStatus ==
                //     UploadReportRequestStatus.failure) {
                //   await showError(state.message);
                // }
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
                        // await context
                        //     .read<GeneticDiseasesDataEntryCubit>()
                        //     .uploadXrayReportPicked(
                        //       imagePath: picker.pickedImage!.path,
                        //     );
                      }
                    },
                  );
                },
              ),
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              options: doctorsList,
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
              options: doctorsList,
              categoryLabel: "المستشفى / المركز",
              bottomSheetTitle: "اختر اسم المستشفى/المركز",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم المستشفى/المركز",
              searchHintText: "ابحث عن اسم المستشفى/المركز",
            ),
            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: [],
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) async {},
              containerHintText: "اختر اسم الدولة",
              searchHintText: "ابحث عن الدولة",
            ),

            verticalSpacing(16),

            /// final section
            verticalSpacing(32),

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
        curr.medicinesDataEntryStatus == RequestStatus.failure ||
        curr.medicinesDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.medicinesDataEntryStatus != curr.medicinesDataEntryStatus,
    listener: (context, state) async {
      if (state.medicinesDataEntryStatus == RequestStatus.success) {
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
        isLoading: state.medicinesDataEntryStatus == RequestStatus.loading,
        title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            // state.isEditMode
            //     ? await context
            //         .read<GeneticDiseasesDataEntryCubit>()
            //         .submitEditsForMedicine()
            //     : await context
            //         .read<GeneticDiseasesDataEntryCubit>()
            //         .postMedicinesDataEntry(
            //           context.translate,
            //         );
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}
