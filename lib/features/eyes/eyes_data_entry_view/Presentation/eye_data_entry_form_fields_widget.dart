import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/medical_examinations_upload_section_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/upload_eye_report_section_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

class EyeDataEntryFormFields extends StatelessWidget {
  const EyeDataEntryFormFields({
    super.key,
    required this.selectedSyptoms,
    required this.selectedProcedures,
    required this.affectedEyePart,
  });
  final List<SymptomAndProcedureItem> selectedSyptoms;
  final List<SymptomAndProcedureItem> selectedProcedures;
  final String affectedEyePart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EyesDataEntryCubit, EyesDataEntryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 70.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ بداية الأعراض",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              DateTimePickerContainer(
                containerBorderColor: state.syptomStartDate == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText: state.syptomStartDate ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSyptomStartDate(pickedDate);
                  log("xxx: pickedDate: $pickedDate");
                },
              ),
              verticalSpacing(16),
              Text(
                "الاعراض",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              ...selectedSyptoms.isNotEmpty
                  ? selectedSyptoms.map(
                      (symptom) => buildCustomContainer(
                        model: symptom,
                      ),
                    )
                  : [
                      buildCustomContainer(
                        model: SymptomAndProcedureItem(
                          id: 'default',
                          title: 'لا يوجد عرض طبي مرفق',
                          isSelected: false,
                        ),
                      ),
                    ],
              verticalSpacing(10),
              UserSelectionContainer(
                categoryLabel: "مدة الأعراض",
                containerHintText: state.symptomDuration ?? "اختر مدة الأعراض",
                options: [
                  "يوم",
                  "يومين",
                  "ثلاث ايام",
                  "اربع ايام",
                  "خمسة ايام",
                  "ستة ايام",
                  "اسبوع",
                  "عشر ايام",
                  "اسبوعين",
                  "ثلاث اسابيع",
                  "شهر",
                  "اكثر من شهر",
                ],
                onOptionSelected: (value) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSymptomDuration(value);
                },
                bottomSheetTitle: "اختر مدة الأعراض",
                searchHintText: "اختر مدة الأعراض",
              ),
              verticalSpacing(16),
              Text(
                "الإجراء الطبى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              ...selectedProcedures.isNotEmpty
                  ? selectedProcedures.map(
                      (procedure) => buildCustomContainer(
                        model: procedure,
                      ),
                    )
                  : [
                      buildCustomContainer(
                        model: SymptomAndProcedureItem(
                          id: 'default',
                          title: 'لا يوجد احراء طبي',
                          isSelected: false,
                        ),
                      ),
                    ],
              verticalSpacing(10),
              Text(
                "تاريخ الإجراء الطبي",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              DateTimePickerContainer(
                placeholderText:
                    state.procedureDateSelection ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateProcedureDate(pickedDate);
                },
              ),
              verticalSpacing(16),
              Text(
                "التقرير الطبي",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              SelectImageContainer(
                imagePath: "assets/images/t_shape_icon.png",
                label: context
                        .read<EyesDataEntryCubit>()
                        .reportTextController
                        .text
                        .isEmpty
                    ? "اكتب التقرير"
                    : "تعديل التقرير",
                onTap: () async {
                  // ✅ اقرا الـ cubit من الـ context الحالي
                  final cubit = context.read<EyesDataEntryCubit>();
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
              verticalSpacing(16),
              EyeReportUploadSection(),
              verticalSpacing(16),
              MedicalExaminationUploadSection(),
              verticalSpacing(16),
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "اسم الطبيب",
                containerHintText: state.doctorName ?? "اختر اسم الطبيب",
                options: state.doctorNames,
                onOptionSelected: (value) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedDoctorName(value);
                },
                bottomSheetTitle: 'اختر اسم الطبيب',
                searchHintText: "ابحث عن اسم الطبيب",
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                initialValue:
                    state.selectedEyeMedicalCenter?.isEmptyOrNull == true
                        ? null
                        : state.selectedEyeMedicalCenter,
                allowManualEntry: true,
                isDisabled: state.selectedHospitalCenter.isNotEmptyOrNull,
                categoryLabel: "مركز العيون",
                containerHintText: state.selectedHospitalCenter.isNotEmptyOrNull
                    ? "المستشفى محددة، لا يمكن اختيار مركز"
                    : (state.selectedEyeMedicalCenter.isEmptyOrNull
                        ? "اختر اسم مركز العيون"
                        : state.selectedEyeMedicalCenter!),
                options: state.eyeMedicalCenters,
                onDismiss: () {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedEyeMedicalCenter("");
                },
                onOptionSelected: (value) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedEyeMedicalCenter(value);
                },
                bottomSheetTitle: 'اختر اسم مركز العيون',
                searchHintText: "ابحث عن مركز العيون",
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                initialValue:
                    state.selectedHospitalCenter?.isEmptyOrNull == true
                        ? null
                        : state.selectedHospitalCenter,
                allowManualEntry: true,
                isDisabled: state.selectedEyeMedicalCenter.isNotEmptyOrNull,
                categoryLabel: "المستشفى",
                containerHintText:
                    state.selectedEyeMedicalCenter.isNotEmptyOrNull
                        ? "المركز محدد، لا يمكن اختيار مستشفى"
                        : (state.selectedHospitalCenter.isEmptyOrNull
                            ? "اختر اسم المستشفى"
                            : state.selectedHospitalCenter!),
                options: state.hospitalNames,
                onDismiss: () {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedHospitalName("");
                },
                onOptionSelected: (value) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedHospitalName(value);
                },
                bottomSheetTitle: 'اختر اسم المستشفى',
                searchHintText: "ابحث عن المستشفى",
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                options: state.countriesNames,
                categoryLabel: "الدولة",
                bottomSheetTitle: "اختر اسم الدولة",
                onOptionSelected: (selectedCountry) {
                  context
                      .read<EyesDataEntryCubit>()
                      .updateSelectedCountry(selectedCountry);
                },
                containerHintText:
                    state.selectedCountryName ?? "اختر اسم الدولة",
                searchHintText: "ابحث عن اسم الدولة",
              ),
              verticalSpacing(16),
              Text(
                "ملاحظات اضافية",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              WordLimitTextField(
                controller:
                    context.read<EyesDataEntryCubit>().personalNotesController,
              ),
              verticalSpacing(32),
              submitXrayDataEntryButtonBlocConsumer(
                context,
                selectedSymptoms: selectedSyptoms,
                selectedProcedures: selectedProcedures,
                affectedEyePart: affectedEyePart,
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget submitXrayDataEntryButtonBlocConsumer(
  BuildContext context, {
  required List<SymptomAndProcedureItem> selectedSymptoms,
  required List<SymptomAndProcedureItem> selectedProcedures,
  required String affectedEyePart,
}) {
  return BlocConsumer<EyesDataEntryCubit, EyesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.eyeDataEntryStatus == RequestStatus.failure ||
        curr.eyeDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.eyeDataEntryStatus != curr.eyeDataEntryStatus,
    listener: (context, state) async {
      if (state.eyeDataEntryStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        //* in order to catch it again to rebuild details view
        context.pop(result: true);
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.eyeDataEntryStatus == RequestStatus.loading,
        title: state.isEditMode ? 'ارسل التعديلات' : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            if (state.isEditMode) {
              await context
                  .read<EyesDataEntryCubit>()
                  .submitEyeDataEnteredEdits();
              return;
            }
            await context.read<EyesDataEntryCubit>().postEyeDataEntry(
                  context.translate,
                  symptoms: selectedSymptoms,
                  procedures: selectedProcedures,
                  affectedEyePart: affectedEyePart,
                );
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}

Widget buildCustomContainer({required SymptomAndProcedureItem model}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(right: 16.w, top: 4.h, bottom: 4.h),
    margin: EdgeInsets.only(bottom: 10.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        8.r,
      ),
      border: Border.all(
        color: Color(0xff555555),
        width: .5,
      ),
    ),
    child: Text(
      model.title,
      style: AppTextStyles.font14blackWeight400,
      textAlign: TextAlign.right,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      textDirection: TextDirection.ltr,
    ),
  );
}
