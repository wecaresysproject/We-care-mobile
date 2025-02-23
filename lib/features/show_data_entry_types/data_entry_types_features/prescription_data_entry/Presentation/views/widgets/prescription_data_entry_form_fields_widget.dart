import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/user_selection_container_widget.dart';

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
                    isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
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
                containerHintText: "اختر اسم الطبيب",
                options: [
                  "د / محمد محمد",
                  "د / كريم محمد",
                  "د / رشا محمد",
                  "د / رشا مصطفى",
                ],
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
                containerBorderColor: state.doctorSpecialitySelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "التخصص",
                containerHintText: "اختر تخصص الطبيب",
                options: [
                  "باطنة",
                  "جراحة",
                  "طبيب عام",
                  "طبيب اطفال",
                  "طبيب جراحة",
                ],
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
                hintText: "اكتب الأعراض التى تعانى منها",
                controller: context
                    .read<PrescriptionDataEntryCubit>()
                    .symptomsAccompanyingComplaintController,
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "المرض", // Another Dropdown Example
                containerHintText: "اختر المرض الذى تم تشخيصه",
                options: [
                  "مرض القلب",
                  "مرض البول",
                  "مرض الدم",
                  "مرض القلب",
                ],
                onOptionSelected: (value) {
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
              SelectImageContainer(
                containerBorderColor:
                    (state.isPrescriptionPictureSelected == null) ||
                            (state.isPrescriptionPictureSelected == false)
                        ? AppColorsManager.warningColor
                        : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) {
                      context
                          .read<PrescriptionDataEntryCubit>()
                          .updatePrescriptionPicture(isImagePicked);

                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        log("xxx: image path: ${picker.pickedImage?.path}");
                      }
                    },
                  );
                },
              ),

              verticalSpacing(16),

              ///الدولة
              UserSelectionContainer(
                allowManualEntry: true,
                options: ["مصر", "الامارات", "السعوديه", "الكويت", "العراق"],
                categoryLabel: "الدولة",
                bottomSheetTitle: "اختر اسم الدولة",
                onOptionSelected: (value) {},
                containerHintText: "اختر اسم الدولة",
              ),

              verticalSpacing(16),

              /// الطبيب المعالج

              UserSelectionContainer(
                allowManualEntry: true,
                options: [
                  "مدينة الفيوم",
                  "مدينة القاهرة",
                  "مدينة الجيزة",
                  "مدينة الاسكندرية",
                  "مدينة البحر الاحمر",
                ],
                categoryLabel: "المدينة",
                bottomSheetTitle: "اختر المدينة",
                onOptionSelected: (value) {},
                containerHintText: "اختر المدينة",
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
              ),

              ///TODO: handle this button in main view and remove it from here
              /// final section
              verticalSpacing(32),
              AppCustomButton(
                title: "ارسال",
                onPressed: () {
                  if (state.isFormValidated) {
                    // context.read<XRayDataEntryCubit>().sendForm;
                    log("xxx:Save Data Entry");
                  } else {
                    log("");
                  }
                },
                isEnabled: state.isFormValidated ? true : false,
              ),
              verticalSpacing(71),
            ],
          ),
        );
      },
    );
  }
}
