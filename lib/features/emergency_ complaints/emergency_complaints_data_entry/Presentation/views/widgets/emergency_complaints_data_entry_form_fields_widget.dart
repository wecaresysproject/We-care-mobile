import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_regex.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/true_or_false_question_component.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import '../../../logic/cubit/emergency_complaints_data_entry_cubit.dart';

class EmergencyComplaintDataEntryFormFields extends StatefulWidget {
  const EmergencyComplaintDataEntryFormFields({super.key});

  @override
  State<EmergencyComplaintDataEntryFormFields> createState() =>
      _EmergencyComplaintDataEntryFormFieldsState();
}

class _EmergencyComplaintDataEntryFormFieldsState
    extends State<EmergencyComplaintDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      builder: (context, state) {
        return Form(
          key: context.read<EmergencyComplaintsDataEntryCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ ظهور الشكوى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.complaintAppearanceDate == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText:
                    state.complaintAppearanceDate ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateDateOfComplaint(pickedDate);
                  log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
                },
              ),

              /// size between each categogry
              verticalSpacing(16),

              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.complaintLocation == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "مكان الألم أو الشكوى",
                containerHintText:
                    state.complaintLocation ?? "اختر الأعراض المصاحبة",
                options: [
                  "غثيان",
                  "تعب المعده",
                  "تعب الصدر",
                  "تعب الجهاز النفسي",
                ],
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateComplaintLocation(value);
                },
                bottomSheetTitle: "اختر الأعراض المصاحبة",
              ),

              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                containerBorderColor: state.symptomsDiseaseRegion == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "الأعراض المرضية - المنطقة",
                containerHintText:
                    state.symptomsDiseaseRegion ?? "اختر الأعراض المستدعية",
                options: [
                  "الجهاز النفسي",
                  "التعب النفسي",
                  "التعب الجهاز النفسي",
                ],
                onOptionSelected: (value) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateSymptomsDiseaseRegion(value);

                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر الأعراض المستدعية",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                containerBorderColor: state.medicalSymptomsIssue == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel:
                    "الأعراض المرضية - الشكوى", // Another Dropdown Example
                containerHintText:
                    "اختر الأعراض المستدعية", //state.selectedDisease ??
                options: [
                  "مرض القلب",
                  "مرض البول",
                  "مرض الدم",
                  "مرض القلب",
                ],
                onOptionSelected: (value) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateMedicalSymptomsIssue(value);
                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر الأعراض المستدعية",
              ),

              verticalSpacing(16),

              UserSelectionContainer(
                containerBorderColor: state.natureOfComplaint == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                options: [
                  "منطقية",
                  "مرضية",
                  "نفسية",
                  "جهازية",
                  "متغيرة",
                ],
                categoryLabel: "طبيعة الشكوى",
                bottomSheetTitle: "اختر طبيعة الشكوى",
                onOptionSelected: (value) async {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateNatureOfComplaint(value);
                },
                containerHintText:
                    "اختر طبيعة الشكوى", //state.selectedCityName ?? "اختر المدينة",
              ),
              verticalSpacing(16),
              // Title
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
                  "كثيرة",
                ],
                onOptionSelected: (p0) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateComplaintDegree(p0);
                },
              ),
              verticalSpacing(16),
              TrueOrFalseQuestionWidget(
                question: "هل عانيت من شكوى مشابهة سابقًا ؟",
                containerValidationColor:
                    state.hasSimilarComplaintBefore == null
                        ? AppColorsManager.redBackgroundValidationColor
                        : AppColorsManager.babyBlueColor,
                imagePath: "assets/images/sick_outline_imoji.png",
                onOptionSelected: (p0) {
                  log("xxx:hasSimilarComplaintBefore: $p0");
                  final result = context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateHasPreviousComplaintBefore(p0);

                  if (result) {
                    // open botttem sheet that has two text fields to enter the name of the previous complaint and the date of the previous complaint
                    if (result) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18.r),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 24.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "التشخيص",
                                    style: AppTextStyles.font18blackWight500,
                                  ),
                                  verticalSpacing(8),
                                  CustomTextField(
                                    validator: (value) {
                                      if (AppRegex.isOnlyWhiteSpaces(value!)) {
                                        return S
                                            .of(context)
                                            .white_spaces_validation;
                                      }
                                      if (value.isEmpty) {
                                        return S
                                            .of(context)
                                            .pleaseEnterYourName;
                                      }
                                    },
                                    // controller:
                                    //     context.read<SignUpCubit>().firstNameController,
                                    isPassword: false,
                                    showSuffixIcon: false,
                                    keyboardType: TextInputType.name,
                                    hintText: "اكتب التشخيص الذى تم",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
              verticalSpacing(16),

              TrueOrFalseQuestionWidget(
                question: "هل تتناول أدوية حالية ؟",
                containerValidationColor:
                    state.isCurrentlyTakingMedication == null
                        ? AppColorsManager.redBackgroundValidationColor
                        : AppColorsManager.babyBlueColor,
                imagePath: "assets/images/medicines.png",
                onOptionSelected: (p0) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateIsTakingMedicines(p0);
                },
              ),
              verticalSpacing(16),

              TrueOrFalseQuestionWidget(
                question: "هل أجريت  تدخل طبى طارئ للشكوى ؟",
                containerValidationColor:
                    state.hasReceivedEmergencyCareBefore == null
                        ? AppColorsManager.redBackgroundValidationColor
                        : AppColorsManager.babyBlueColor,
                imagePath: "assets/images/medical_tool_kit.png",
                onOptionSelected: (p0) {
                  context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateHasReceivedEmergencyCareBefore(p0);
                },
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
    return BlocConsumer<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.failure ||
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.emergencyComplaintsDataEntryStatus !=
              curr.emergencyComplaintsDataEntryStatus,
      listener: (context, state) async {
        if (state.emergencyComplaintsDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading:
              state.emergencyComplaintsDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              // state.isEditMode
              //     ? await context
              //         .read<EmergencyComplaintsDataEntryCubit>()
              //         .submitEditsOnPrescription()
              //     : await context
              //         .read<EmergencyComplaintsDataEntryCubit>()
              //         .postPrescriptionDataEntry(
              //           context.translate,
              //         );
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
