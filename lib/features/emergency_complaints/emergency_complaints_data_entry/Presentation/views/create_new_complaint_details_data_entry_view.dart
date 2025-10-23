import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/searchable_user_selector_container.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaint_details_cubit.dart';

class CreateNewComplaintDetailsView extends StatelessWidget {
  const CreateNewComplaintDetailsView({
    super.key,
    required this.editingComplaintDetails,
    required this.complaintId,
  });

  final MedicalComplaint? editingComplaintDetails;
  final int? complaintId;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider<EmergencyComplaintDataEntryDetailsCubit>(
        create: (context) {
          final cubit = getIt<EmergencyComplaintDataEntryDetailsCubit>();
          if (editingComplaintDetails == null) {
            cubit.getAllRequestsForAddingNewComplaintView();
          } else {
            cubit.loadEmergencyDetailsViewForEditing(editingComplaintDetails!);
          }
          return cubit;
        },
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: AppColorsManager.mainDarkBlue,
              dividerColor: Colors.transparent,
              indicatorColor: AppColorsManager.mainDarkBlue,
              tabs: [
                Tab(
                  text: "بحث بمناطق الجسم",
                ),
                Tab(
                  text: "بحث بالعرض المرضي",
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              _bodyRegionSearchTab(
                editingComplaintDetails,
                complaintId,
              ),
              _symptomSearchTab(
                editingComplaintDetails,
                complaintId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bodyRegionSearchTab(
    MedicalComplaint? editingComplaintDetails, int? complaintId) {
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 36.h,
    ),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<EmergencyComplaintDataEntryDetailsCubit,
              MedicalComplaintDataEntryDetailsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserSelectionContainer(
                    allowManualEntry: true,
                    containerBorderColor: state.symptomsDiseaseRegion == null
                        ? AppColorsManager.warningColor
                        : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "الأعراض المرضية - المنطقة الاساسية",
                    containerHintText: state.symptomsDiseaseRegion ??
                        "اختر منطقة الاعراض المرضية",
                    options: state.complaintPlaces,
                    onOptionSelected: (value) async {
                      await context
                          .read<EmergencyComplaintDataEntryDetailsCubit>()
                          .updateSymptomsDiseaseRegion(value);
                    },
                    bottomSheetTitle: "اختر الأعراض المستدعية",
                    searchHintText: "ابحث عن منطقة الاعراض المرضية",
                    loadingState: state.mainRegionComplainsLoadingState,
                  ),

                  verticalSpacing(16),
                  UserSelectionContainer(
                    allowManualEntry: true,
                    containerBorderColor:
                        state.selectedOrganOrPartSymptom == null
                            ? AppColorsManager.warningColor
                            : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "الأعراض المرضية - العضو/الجزء",
                    containerHintText:
                        state.selectedOrganOrPartSymptom ?? "اختر العضو/الجزء",
                    options: state.complaintPlacesRelativeToMainRegion,
                    onOptionSelected: (value) async {
                      await context
                          .read<EmergencyComplaintDataEntryDetailsCubit>()
                          .updateSelectedOrganOrPartSymptom(value);
                    },
                    bottomSheetTitle: "اختر العضو/الجزء",
                    searchHintText: "ابحث عن العضو",
                    loadingState: state.isEditingComplaint ||
                            state.bodySyptomsResults.isNotEmpty
                        ? OptionsLoadingState.loaded
                        : state.complaintPlacesRelativeToMainRegionLoadingState,
                  ),

                  verticalSpacing(16),

                  UserSelectionContainer(
                    containerBorderColor: state.medicalSymptomsIssue == null
                        ? AppColorsManager.warningColor
                        : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel:
                        "الأعراض المرضية - الشكوى", // Another Dropdown Example§
                    containerHintText: state.medicalSymptomsIssue ??
                        "اختر الأعراض المستدعية", //state.selectedDisease ??
                    options: state.releatedComplaintsToSelectedBodyPartName,
                    onOptionSelected: (value) {
                      context
                          .read<EmergencyComplaintDataEntryDetailsCubit>()
                          .updateMedicalSymptomsIssue(value);
                    },
                    bottomSheetTitle: "اختر الأعراض المستدعية",
                    searchHintText: "ابحث عن شكوى",
                  ),

                  verticalSpacing(16),

                  UserSelectionContainer(
                    allowManualEntry: true,
                    containerBorderColor: state.natureOfComplaint == null
                        ? AppColorsManager.warningColor
                        : AppColorsManager.textfieldOutsideBorderColor,
                    options: [
                      "مستمرة",
                      "متقطعة",
                      "تزايد مع الوقت",
                      "تتناقص مع الوقت",
                    ],
                    categoryLabel: "طبيعة الشكوى",
                    bottomSheetTitle:
                        state.natureOfComplaint ?? "اختر طبيعة الشكوى",
                    onOptionSelected: (value) async {
                      context
                          .read<EmergencyComplaintDataEntryDetailsCubit>()
                          .updateNatureOfComplaint(value);
                    },
                    containerHintText: state.natureOfComplaint ??
                        "اختر طبيعة الشكوى", //state.selectedCityName ?? "اختر المدينة",

                    userEntryLabelText: "اضف الوصف من عندك",
                    searchHintText: "ابحث عن طبيعة الشكوى",
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
                      "شديدة",
                      "شديدة جدا",
                      "غير محتملة",
                    ],
                    initialSelectedOption: state.complaintDegree,
                    onOptionSelected: (p0) {
                      context
                          .read<EmergencyComplaintDataEntryDetailsCubit>()
                          .updateComplaintDegree(p0);
                    },
                  ),
                  verticalSpacing(16),
                  BlocListener<EmergencyComplaintDataEntryDetailsCubit,
                      MedicalComplaintDataEntryDetailsState>(
                    listener: (context, state) async {
                      if (state.isNewComplaintAddedSuccefully) {
                        await showSuccess("تم اضافة العرض بنجاح");
                        if (!context.mounted) return;
                        context.pop(result: true);
                      }
                      if (state.isEditingComplaintSuccess) {
                        await showSuccess("تم تعديل  تفاصيل العرض بنجاح");
                        if (!context.mounted) return;
                        context.pop(result: true);
                      }
                    },
                    child: AppCustomButton(
                      title: state.isEditingComplaint
                          ? "تَعديلُ مَعْلوماتِ العرض"
                          : "اضافة عرض",
                      onPressed: () async {
                        if (state.isAddNewComplaintFormsValidated) {
                          state.isEditingComplaint
                              ? await context
                                  .read<
                                      EmergencyComplaintDataEntryDetailsCubit>()
                                  .updateMedicalComplaint(
                                      complaintId!, editingComplaintDetails!)
                              : await context
                                  .read<
                                      EmergencyComplaintDataEntryDetailsCubit>()
                                  .saveNewMedicalComplaint();
                        }
                      },
                      isEnabled: state.isAddNewComplaintFormsValidated,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    ),
  );
}

Widget _symptomSearchTab(
    MedicalComplaint? editingComplaintDetails, int? complaintId) {
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 36.h,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<EmergencyComplaintDataEntryDetailsCubit,
            MedicalComplaintDataEntryDetailsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchableUserSelectorContainer(
                  containerBorderColor: state.medicalSymptomsIssue == null
                      ? AppColorsManager.warningColor
                      : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel:
                      "الأعراض المرضية - الشكوى", // Another Dropdown Example
                  containerHintText: state.medicalSymptomsIssue ??
                      "اختر الأعراض المستدعية", //state.selectedDisease ??
                  // options: state.releatedComplaintsToSelectedBodyPartName,
                  onOptionSelected: (value) {
                    context
                        .read<EmergencyComplaintDataEntryDetailsCubit>()
                        .updateMedicalSymptomsIssue(value);
                  },
                  bottomSheetTitle: "اختر الأعراض المستدعية",
                  searchHintText: "ابحث عن شكوى",
                ),

                verticalSpacing(16),

                UserSelectionContainer(
                  allowManualEntry: true,
                  containerBorderColor: state.natureOfComplaint == null
                      ? AppColorsManager.warningColor
                      : AppColorsManager.textfieldOutsideBorderColor,
                  options: [
                    "مستمرة",
                    "متقطعة",
                    "تزايد مع الوقت",
                    "تتناقص مع الوقت",
                  ],
                  categoryLabel: "طبيعة الشكوى",
                  bottomSheetTitle:
                      state.natureOfComplaint ?? "اختر طبيعة الشكوى",
                  onOptionSelected: (value) async {
                    context
                        .read<EmergencyComplaintDataEntryDetailsCubit>()
                        .updateNatureOfComplaint(value);
                  },
                  containerHintText: state.natureOfComplaint ??
                      "اختر طبيعة الشكوى", //state.selectedCityName ?? "اختر المدينة",

                  userEntryLabelText: "اضف الوصف من عندك",
                  searchHintText: "ابحث عن طبيعة الشكوى",
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
                    "شديدة",
                    "شديدة جدا",
                    "غير محتملة",
                  ],
                  initialSelectedOption: state.complaintDegree,
                  onOptionSelected: (p0) {
                    context
                        .read<EmergencyComplaintDataEntryDetailsCubit>()
                        .updateComplaintDegree(p0);
                  },
                ),
                verticalSpacing(16),
                BlocListener<EmergencyComplaintDataEntryDetailsCubit,
                    MedicalComplaintDataEntryDetailsState>(
                  listener: (context, state) async {
                    if (state.isNewComplaintAddedSuccefully) {
                      await showSuccess("تم اضافة العرض بنجاح");
                      if (!context.mounted) return;
                      context.pop(result: true);
                    }
                    if (state.isEditingComplaintSuccess) {
                      await showSuccess("تم تعديل  تفاصيل العرض بنجاح");
                      if (!context.mounted) return;
                      context.pop(result: true);
                    }
                  },
                  child: AppCustomButton(
                    title: state.isEditingComplaint
                        ? "تَعديلُ مَعْلوماتِ العرض"
                        : "اضافة عرض",
                    onPressed: () async {
                      if (state.isAddNewComplaintFormsValidated) {
                        state.isEditingComplaint
                            ? await context
                                .read<EmergencyComplaintDataEntryDetailsCubit>()
                                .updateMedicalComplaint(
                                    complaintId!, editingComplaintDetails!)
                            : await context
                                .read<EmergencyComplaintDataEntryDetailsCubit>()
                                .saveNewMedicalComplaint();
                      }
                    },
                    isEnabled: state.isAddNewComplaintFormsValidated,
                  ),
                ),
                // verticalSpacing(90),
              ],
            );
          },
        )
      ],
    ),
  );
}
