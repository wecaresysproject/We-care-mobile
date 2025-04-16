import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medication_symptoms_form_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medication_symptoms_form_cubit_state.dart';

class MedicineSyptomsDetailsView extends StatelessWidget {
  const MedicineSyptomsDetailsView({
    super.key,
    required this.editingComplaintDetails,
    required this.complaintId,
  });

  final MedicalComplaint? editingComplaintDetails;
  final int? complaintId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicationSymptomsFormCubit>(
      create: (context) {
        final cubit = getIt<MedicationSymptomsFormCubit>();
        if (editingComplaintDetails == null) {
          cubit.getAllRequestsForAddingNewComplaintView();
        } else {
          cubit.loadEmergencyDetailsViewForEditing(editingComplaintDetails!);
        }
        return cubit;
      },
      child: Scaffold(
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
                BlocBuilder<MedicationSymptomsFormCubit,
                    MedicationSymptomsFormState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserSelectionContainer(
                          allowManualEntry: true,
                          categoryLabel: "الأعراض المرضية - المنطقة",
                          containerHintText: state.symptomsDiseaseRegion ??
                              "اختر منطقة الاعراض المرضية",
                          options: state.complaintPlaces,
                          onOptionSelected: (value) {
                            context
                                .read<MedicationSymptomsFormCubit>()
                                .updateSymptomsDiseaseRegion(value);
                          },
                          bottomSheetTitle: "اختر الأعراض المستدعية",
                        ),

                        verticalSpacing(16),

                        UserSelectionContainer(
                          categoryLabel:
                              "الأعراض المرضية - الشكوى", // Another Dropdown Example
                          containerHintText: state.medicalSymptomsIssue ??
                              "اختر الأعراض المستدعية", //state.selectedDisease ??
                          options:
                              state.releatedComplaintsToSelectedBodyPartName,
                          onOptionSelected: (value) {
                            context
                                .read<MedicationSymptomsFormCubit>()
                                .updateMedicalSymptomsIssue(value);
                          },
                          bottomSheetTitle: "اختر الأعراض المستدعية",
                        ),

                        verticalSpacing(16),

                        UserSelectionContainer(
                          allowManualEntry: true,

                          options: [
                            "مستمرة",
                            "منقطعة",
                            "تزايد مع الوقت",
                            "تتناقص مع الوقت",
                          ],
                          categoryLabel: "طبيعة الشكوى",
                          bottomSheetTitle:
                              state.natureOfComplaint ?? "اختر طبيعة الشكوى",
                          onOptionSelected: (value) async {
                            context
                                .read<MedicationSymptomsFormCubit>()
                                .updateNatureOfComplaint(value);
                          },
                          containerHintText: state.natureOfComplaint ??
                              "اختر طبيعة الشكوى", //state.selectedCityName ?? "اختر المدينة",
                          usertEntryLabelText: "اضف الوصف من عندك",
                        ),
                        verticalSpacing(16),
                        // Title
                        Text(
                          "حدة الشكوى",
                          style: AppTextStyles.font18blackWight500,
                        ),
                        verticalSpacing(10),
                        OptionSelectorWidget(
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
                                .read<MedicationSymptomsFormCubit>()
                                .updateComplaintDegree(p0);
                          },
                        ),
                        verticalSpacing(16),
                        BlocListener<MedicationSymptomsFormCubit,
                            MedicationSymptomsFormState>(
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
                                        .read<MedicationSymptomsFormCubit>()
                                        .updateMedicalComplaint(complaintId!,
                                            editingComplaintDetails!)
                                    : await context
                                        .read<MedicationSymptomsFormCubit>()
                                        .saveNewMedicalComplaint();
                              }
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
      ),
    );
  }
}
