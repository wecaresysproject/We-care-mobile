import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class CreateNewComplaintDetailsView extends StatelessWidget {
  const CreateNewComplaintDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),
              verticalSpacing(24),
              BlocBuilder<EmergencyComplaintsDataEntryCubit,
                  EmergencyComplaintsDataEntryState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserSelectionContainer(
                        allowManualEntry: true,
                        containerBorderColor:
                            state.symptomsDiseaseRegion == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.textfieldOutsideBorderColor,
                        categoryLabel: "الأعراض المرضية - المنطقة",
                        containerHintText: state.symptomsDiseaseRegion ??
                            "اختر الأعراض المستدعية",
                        options: state.complaintPlaces,
                        onOptionSelected: (value) {
                          context
                              .read<EmergencyComplaintsDataEntryCubit>()
                              .updateSymptomsDiseaseRegion(value);
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
                      BlocListener<EmergencyComplaintsDataEntryCubit,
                          EmergencyComplaintsDataEntryState>(
                        listener: (context, state) async {
                          if (state.isNewComplaintAddedSuccefully) {
                            await showSuccess("تم اضافة العرض بنجاح");
                            if (!context.mounted) return;

                            context.pop(result: true);
                            // context
                            //     .read<EmergencyComplaintsDataEntryCubit>()
                            //     .custoonEmit();
                          }
                        },
                        child: AppCustomButton(
                          title: "اضافة عرض",
                          onPressed: () {
                            if (state.isAddNewComplaintFormsValidated) {
                              context
                                  .read<EmergencyComplaintsDataEntryCubit>()
                                  .saveNewMedicalComplaint();
                            }
                            // context
                            //     .read<EmergencyComplaintsDataEntryCubit>()
                            //     .saveEmergencyComplaintsDataEntry();
                          },
                          isEnabled: state.isAddNewComplaintFormsValidated,
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
