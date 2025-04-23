import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/prescription/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class PrescriptionDataEntryFormFields extends StatefulWidget {
  const PrescriptionDataEntryFormFields({super.key});

  @override
  State<PrescriptionDataEntryFormFields> createState() =>
      _PrescriptionDataEntryFormFieldsState();
}

class _PrescriptionDataEntryFormFieldsState
    extends State<PrescriptionDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionDataEntryCubit, PrescriptionDataEntryState>(
      builder: (context, state) {
        return Form(
          key: context.read<PrescriptionDataEntryCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ الروشتة",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.preceriptionDateSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText:
                    state.preceriptionDateSelection ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updatePrescriptionDate(pickedDate);
                  log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
                },
              ),

              /// size between each categogry
              verticalSpacing(16),

              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.doctorNameSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "اسم الطبيب",
                containerHintText:
                    state.doctorNameSelection ?? "اختر اسم الطبيب",
                options: doctorsList,
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateDoctorName(value);
                },
                bottomSheetTitle: "اختر اسم الطبيب",
              ),

              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.doctorSpecialitySelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "التخصص",
                containerHintText:
                    state.doctorSpecialitySelection ?? "اختر تخصص",
                options: medicalSpecialties,
                onOptionSelected: (value) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateDoctorSpeciality(value);

                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر تخصص الطبيب",
              ),

              verticalSpacing(16),
              Text(
                "الأعراض المصاحبة للشكوى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                hintText: state.prescribtionEditedModel?.cause ??
                    "اكتب الأعراض التى تعانى منها",
                controller: context
                    .read<PrescriptionDataEntryCubit>()
                    .symptomsAccompanyingComplaintController,
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "المرض", // Another Dropdown Example
                containerHintText:
                    state.selectedDisease ?? "اختر المرض الذى تم تشخيصه",
                options: [
                  "مرض القلب",
                  "مرض البول",
                  "مرض الدم",
                  "مرض القلب",
                ],
                onOptionSelected: (value) {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedDisease(value);
                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر المرض الذى تم تشخيصه",
              ),

              verticalSpacing(16),
              Text(
                "الروشتة",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              BlocListener<PrescriptionDataEntryCubit,
                  PrescriptionDataEntryState>(
                listenWhen: (prev, curr) =>
                    prev.prescriptionImageRequestStatus !=
                    curr.prescriptionImageRequestStatus,
                listener: (context, state) async {
                  if (state.prescriptionImageRequestStatus ==
                      UploadImageRequestStatus.success) {
                    await showSuccess(state.message);
                  }
                  if (state.prescriptionImageRequestStatus ==
                      UploadImageRequestStatus.failure) {
                    await showError(state.message);
                  }
                },
                child: SelectImageContainer(
                  containerBorderColor: ((state.isPrescriptionPictureSelected ==
                                  null) ||
                              (state.isPrescriptionPictureSelected == false)) &&
                          state.prescriptionPictureUploadedUrl.isEmpty
                      ? AppColorsManager.warningColor
                      : AppColorsManager.textfieldOutsideBorderColor,
                  imagePath: "assets/images/photo_icon.png",
                  label: "ارفق صورة",
                  onTap: () async {
                    await showImagePicker(
                      context,
                      onImagePicked: (isImagePicked) async {
                        final picker = getIt.get<ImagePickerService>();
                        if (isImagePicked && picker.isImagePickedAccepted) {
                          context
                              .read<PrescriptionDataEntryCubit>()
                              .updatePrescriptionPicture(isImagePicked);

                          await context
                              .read<PrescriptionDataEntryCubit>()
                              .uploadPrescriptionImagePicked(
                                imagePath: picker.pickedImage!.path,
                              );
                        }
                      },
                    );
                  },
                ),
              ),

              verticalSpacing(16),
              // verticalSpacing(8),
              // if (state.prescriptionPictureUploadedUrl.isNotEmpty)
              //   imageWithMenuItem(
              //     state.prescriptionPictureUploadedUrl,
              //     context,
              //   ),

              ///الدولة
              UserSelectionContainer(
                options: state.countriesNames,
                categoryLabel: "الدولة",
                bottomSheetTitle: "اختر اسم الدولة",
                onOptionSelected: (value) async {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedCountry(value);
                  await context
                      .read<PrescriptionDataEntryCubit>()
                      .emitCountriesData();
                },
                containerHintText:
                    state.selectedCountryName ?? "اختر اسم الدولة",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                options: state.citiesNames,
                categoryLabel: "المدينة",
                bottomSheetTitle: "اختر المدينة",
                onOptionSelected: (value) async {
                  context
                      .read<PrescriptionDataEntryCubit>()
                      .updateSelectedCityName(value);
                  await context
                      .read<PrescriptionDataEntryCubit>()
                      .emitCitiesData();
                },
                containerHintText: state.selectedCityName ?? "اختر المدينة",
              ),

              verticalSpacing(16),

              Text(
                "ملاحظات شخصية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              WordLimitTextField(
                controller: context
                    .read<PrescriptionDataEntryCubit>()
                    .personalNotesController,
                hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
                    "اكتب باختصار اى معلومات مهمة اخرى",
              ),

              ///TODO: handle this button in main view and remove it from here
              /// final section
              verticalSpacing(32),
              submitPrescriptionDataEnteredBlocConsumer(),
              verticalSpacing(71),
            ],
          ),
        );
      },
    );
  }

  Widget submitPrescriptionDataEnteredBlocConsumer() {
    return BlocConsumer<PrescriptionDataEntryCubit, PrescriptionDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.preceriptionDataEntryStatus == RequestStatus.failure ||
          curr.preceriptionDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.preceriptionDataEntryStatus != curr.preceriptionDataEntryStatus,
      listener: (context, state) async {
        if (state.preceriptionDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.preceriptionDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<PrescriptionDataEntryCubit>()
                      .submitEditsOnPrescription()
                  : await context
                      .read<PrescriptionDataEntryCubit>()
                      .postPrescriptionDataEntry(
                        context.translate,
                      );
              log("xxx:Save Data Entry");
            } else {
              log("form not validated");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}

Widget imageWithMenuItem(String imageUrl, BuildContext context) {
  return Container(
    height: 100.h,
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        // IconButton(
        //   onPressed: () {},
        //   padding: EdgeInsets.zero,
        //   alignment: Alignment.topCenter,
        //   icon: Icon(
        //     Icons.delete,
        //     size: 28.sp,
        //     color: AppColorsManager.warningColor,
        //   ),
        // ),
        Spacer(),
        // Image on the left with tap action
        GestureDetector(
          onTap: () {
            showImagePreview(context, imageUrl);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

// Preview Dialog Function
void showImagePreview(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      Future.delayed(Duration(seconds: 1), () {
        if (!context.mounted) return;

        Navigator.of(context).pop();
      });

      return Dialog(
        backgroundColor: Colors.transparent,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
        ),
      );
    },
  );
}
