import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class MentalIlnessesDataEntryFormFields extends StatelessWidget {
  const MentalIlnessesDataEntryFormFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 70.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ التشخيص",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              DateTimePickerContainer(
                containerBorderColor: state.examinationDate == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText: state.examinationDate ?? "يوم / شهر / سنة",
                onDateSelected: (pickedDate) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updatExaminationDate(pickedDate);
                },
              ),
              verticalSpacing(18),

              UserSelectionContainer(
                containerBorderColor: state.mentalIllnessesType == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "نوع المرض النفسى/السلوكى",
                containerHintText: state.mentalIllnessesType ??
                    "ااختر المرض النفسى أو السلوكى",
                options: [
                  //! from backend
                  "المرض النفسى",
                  "المرض السلوكى",
                ],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateMentalIllnessesType(value);
                },
                bottomSheetTitle: "اختر المرض النفسى أو السلوكى",
                searchHintText: "اختر المرض النفسى أو السلوكى",
              ),
              verticalSpacing(18),

              UserSelectionContainer(
                categoryLabel: "الأعراض المرضية",
                containerHintText:
                    state.selectedMedicalSyptoms ?? "اختر الأعراض الظاهرة عليك",
                options: [
                  //! from backend
                  "المرض النفسى",
                  "المرض السلوكى",
                ],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateMedicalSyptoms(value);
                },
                bottomSheetTitle: "اختر الأعراض الظاهرة عليك",
                searchHintText: "اختر الأعراض الظاهرة عليك",
              ),
              verticalSpacing(16),

// buildAddNewComplainButtonBlocBuilder(),
              verticalSpacing(18),
              Text(
                "شدة الشكوى",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              OptionSelectorWidget(
                options: [
                  "شديد جدا",
                  "شديد",
                  "متوسط",
                  "خفيف",
                  "لا يوجد",
                ],
                initialSelectedOption:
                    state.selectedDiseaseIntensity, //!check it later
                onOptionSelected: (p0) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateSelectedDiseaseIntensity(p0);
                },
              ),
              verticalSpacing(16),
              UserSelectionContainer(
                categoryLabel: "مدة المرض",
                containerHintText: state.diseaseDuration ?? "اختر مدة المرض",
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
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateDiseaseDuration(value);
                },
                bottomSheetTitle: "اختر مدة المرض",
                searchHintText: "اختر مدة المرض",
              ),
              //! handle its ui  حادث له اثر

              verticalSpacing(16),

              //! handle its ui هل يوجد حالات نفسية مشابهة فى العائلة؟

              verticalSpacing(16),

              //! from backend
              UserSelectionContainer(
                categoryLabel: "حالات الطوارئ النفسية",
                containerHintText: state.selectedMentalHealthEmergency ??
                    "اختر حالات الطوارئ النفسية ان وجد",
                options: [
                  'قريبا من الباك اند',
                ],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateMentalHealthEmergency(value);
                },
                bottomSheetTitle: "اختر حالات الطوارئ النفسية ان وجد",
                searchHintText: "اختر حالات الطوارئ النفسية ان وجد",
              ),

              verticalSpacing(18),
              UserSelectionContainer(
                categoryLabel: "الدعم الاجتماعى",
                containerHintText:
                    state.selectedsocialSupport ?? "اختر الدعم الاجتماعى",
                options: [],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateSelectedSocialSupport(value);
                },
                bottomSheetTitle: "اختر الدعم الاجتماعى",
                searchHintText: "اختر الدعم الاجتماعى",
              ),
              verticalSpacing(18),
              //! from backend
              UserSelectionContainer(
                categoryLabel: "التأثيرات الجانبية للأدوية",
                containerHintText: state.selectedMedicationSideEffects ??
                    "اختر التأثيرات الجانبية للأدوية",
                options: [
                  'قريبا من الباك اند',
                ],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateSelectedMedicationSideEffects(value);
                },
                bottomSheetTitle: "اختر التأثيرات الجانبية للأدوية",
                searchHintText: "اختر التأثيرات الجانبية للأدوية",
              ),
              verticalSpacing(18),
              //! from backend
              UserSelectionContainer(
                categoryLabel: "الأنشطة المفضلة لتحسين النفسية",
                containerHintText:
                    state.selectedPreferredMentalWellnessActivities ??
                        "اختر الأنشطة لتحسين الحالة النفسية",
                options: [
                  'قريبا من الباك اند',
                ],
                onOptionSelected: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updatePreferredMentalWellnessActivities(value);
                },
                bottomSheetTitle: "اختر الأنشطة لتحسين الحالة النفسية",
                searchHintText: "اختر الأنشطة لتحسين الحالة النفسية",
              ),

              verticalSpacing(32),
              // submitXrayDataEntryButtonBlocConsumer(
              //   context,
              // ),
            ],
          ),
        );
      },
    );
  }
}
  // Widget buildAddNewComplainButtonBlocBuilder(BuildContext context) {
  //   return BlocBuilder<EmergencyComplaintsDataEntryCubit,
  //       EmergencyComplaintsDataEntryState>(
  //     buildWhen: (previous, current) =>
  //         current.medicalComplaints.length != previous.medicalComplaints.length,
  //     builder: (context, state) {
  //       return Center(
  //         child: Stack(
  //           clipBehavior: Clip.none,
  //           children: [
  //             AddNewItemButton(
  //               text: state.medicalComplaints.isEmpty
  //                   ? "اضف الاعراض المرضية"
  //                   : 'أضف أعراض مرضية أخرى ان وجد',
  //               onPressed: () async {
  //                 final bool? result = await context.pushNamed(
  //                   Routes.addNewComplaintDetails,
  //                 );

  //                 if (result != null && context.mounted) {
  //                   await context
  //                       .read<EmergencyComplaintsDataEntryCubit>()
  //                       .fetchAllAddedComplaints();

  //                   if (!context.mounted) return;

  //                   ///to rebuild submitted button if user added new complain.
  //                   context
  //                       .read<EmergencyComplaintsDataEntryCubit>()
  //                       .validateRequiredFields();
  //                 }
  //               },
  //             ),
  //             Positioned(
  //               top: -2, // move it up (negative means up)
  //               left: -120,
  //               child: Lottie.asset(
  //                 'assets/images/hand_animation.json',
  //                 width: 120, // adjust sizes
  //                 height: 120,
  //                 addRepaintBoundary: true,
  //                 repeat: true,
  //                 alignment: Alignment.center,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
// Widget submitXrayDataEntryButtonBlocConsumer(
//   BuildContext context, {

// }) {
//   return BlocConsumer<MedicalIllnessesDataEntryCubit
//, EyesDataEntryState>(
//     listenWhen: (prev, curr) =>
//         curr.eyeDataEntryStatus == RequestStatus.failure ||
//         curr.eyeDataEntryStatus == RequestStatus.success,
//     buildWhen: (prev, curr) =>
//         prev.isFormValidated != curr.isFormValidated ||
//         prev.eyeDataEntryStatus != curr.eyeDataEntryStatus,
//     listener: (context, state) async {
//       if (state.eyeDataEntryStatus == RequestStatus.success) {
//         await showSuccess(state.message);
//         if (!context.mounted) return;
//         //* in order to catch it again to rebuild details view
//         context.pop(result: true);
//       } else {
//         await showError(state.message);
//       }
//     },
//     builder: (context, state) {
//       return AppCustomButton(
//         isLoading: state.eyeDataEntryStatus == RequestStatus.loading,
//         title: state.isEditMode ? 'ارسل التعديلات' : context.translate.send,
//         onPressed: () async {
//           if (state.isFormValidated) {
//             if (state.isEditMode) {
//               await context
//                   .read<MedicalIllnessesDataEntryCubit
// >()
//                   .submitEyeDataEnteredEdits();
//               return;
//             }
//             await context.read<MedicalIllnessesDataEntryCubit
// >().postEyeDataEntry(
//                   context.translate,

//                 );
//           }
//         },
//         isEnabled: state.isFormValidated ? true : false,
//       );
//     },
//   );
// }

// Widget buildCustomContainer({required SymptomAndProcedureItem model}) {
//   return Container(
//     width: double.infinity,
//     padding: EdgeInsets.only(right: 16.w, top: 4.h, bottom: 4.h),
//     margin: EdgeInsets.only(bottom: 10.h),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(
//         8.r,
//       ),
//       border: Border.all(
//         color: Color(0xff555555),
//         width: .5,
//       ),
//     ),
//     child: Expanded(
//       child: Text(
//         model.title,
//         style: AppTextStyles.font14blackWeight400,
//         textAlign: TextAlign.right,
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//         textDirection: TextDirection.ltr,
//       ),
//     ),
//   );
// }
