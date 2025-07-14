import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
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
              verticalSpacing(18),

              HasIncidentEffectQuestionWidget(),
              verticalSpacing(18),

              //! handle its ui هل يوجد حالات نفسية مشابهة فى العائلة؟
              HasFamilySimilarMentalCasesQuestionWidget(),
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
              verticalSpacing(18),
              PsychologicalTreatmentQuestionWidget(),
              verticalSpacing(32),
              submitMentalIlnessDataEntryButtonBlocConsumer(context),
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
Widget submitMentalIlnessDataEntryButtonBlocConsumer(
  BuildContext context,
) {
  return BlocConsumer<MedicalIllnessesDataEntryCubit,
      MedicalIllnessesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.mentalIllnessesDataEntryStatus == RequestStatus.failure ||
        curr.mentalIllnessesDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.mentalIllnessesDataEntryStatus !=
            curr.mentalIllnessesDataEntryStatus,
    listener: (context, state) async {
      if (state.mentalIllnessesDataEntryStatus == RequestStatus.success) {
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
        isLoading:
            state.mentalIllnessesDataEntryStatus == RequestStatus.loading,
        title: state.isEditMode ? 'ارسل التعديلات' : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            if (state.isEditMode) {
//               await context
//                   .read<MedicalIllnessesDataEntryCubit
// >()
//                   .submitEyeDataEnteredEdits();
//               return;
            }
//             await context.read<MedicalIllnessesDataEntryCubit
// >().postEyeDataEntry(
//                   context.translate,

//                 );
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}

class HasIncidentEffectQuestionWidget extends StatelessWidget {
  const HasIncidentEffectQuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.hasIncidentEffect != current.hasIncidentEffect,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 8.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColorsManager.mainDarkBlue,
              width: 1.1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text(
                "حادث له تأثير",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpacing(16),

              // Yes/No Question using GenericQuestionWidget
              GenericQuestionWidget(
                questionTitle: "وجود حادث أو موقف له تأثير؟",
                initialValue: state.hasIncidentEffect,
                onAnswerChanged: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateHasIncidentEffect(value);
                },
              ),

              // This is where we'll add the animation
              _buildAnimatedContent(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContent(MedicalIllnessesDataEntryState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: state.hasIncidentEffect == true
          ? _buildFormFields()
          : SizedBox.shrink(key: Key('empty')),
    );
  }

  Widget _buildFormFields() {
    return Column(
      key: Key('formFields'), // Important for animation
      children: [
        verticalSpacing(18),
        UserSelectionContainer(
          categoryLabel: "نوع الموقف",
          containerHintText: "اختر نوع الموقف",
          options: const [
            "حادث مرور",
            "وفاة قريب",
            "مشكلة عائلية",
            "مشكلة مالية",
          ],
          onOptionSelected: (value) {
            // Handle selection
          },
          bottomSheetTitle: "اختر نوع الموقف",
          searchHintText: "اختر نوع الموقف",
        ),
        verticalSpacing(18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ الموقف",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            DateTimePickerContainer(
              placeholderText: "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                // Handle date selection
              },
            ),
          ],
        ),
        verticalSpacing(18),
        UserSelectionContainer(
          categoryLabel: "تأثير الموقف على الحالة النفسية",
          containerHintText: "اختر نوع التأثير على الحالة النفسية",
          options: const [
            "قلق",
            "اكتئاب",
            "أرق",
            "نوبات هلع",
          ],
          onOptionSelected: (value) {
            // Handle selection
          },
          bottomSheetTitle: "اختر تأثير الموقف",
          searchHintText: "اختر تأثير الموقف",
        ),
      ],
    );
  }
}

class HasFamilySimilarMentalCasesQuestionWidget extends StatelessWidget {
  const HasFamilySimilarMentalCasesQuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.hasFamilySimilarMentalCases !=
          current.hasFamilySimilarMentalCases,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 8.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColorsManager.mainDarkBlue,
              width: 1.1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              // سؤال نعم/لا
              GenericQuestionWidget(
                questionTitle: "هل يوجد حالات نفسية مشابهة فى العائلة؟",
                initialValue: state.hasFamilySimilarMentalCases,
                onAnswerChanged: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateHasFamilySimilarMentalCases(value);
                },
              ),
              verticalSpacing(10),

              // Animated content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: state.hasFamilySimilarMentalCases == true
                    ? Column(
                        key: const Key('familySimilarCasesForm'),
                        children: [
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel: "الصلة العائلية",
                            containerHintText:
                                state.selectedFamilyRelationType ??
                                    "اختر الصلة",
                            options: const [
                              "الأب",
                              "الأم",
                              "الأخ",
                              "الأخت",
                              "الجد",
                              "الابن",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updateFamilyRelationType(value);
                            },
                            bottomSheetTitle: "اختر الصلة",
                            searchHintText: "اختر الصلة",
                          ),
                        ],
                      )
                    : const SizedBox.shrink(
                        key: Key('emptyFamilySimilarCases')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PsychologicalTreatmentQuestionWidget extends StatelessWidget {
  const PsychologicalTreatmentQuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.isReceivingPsychologicalTreatment !=
          current.isReceivingPsychologicalTreatment,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 8.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColorsManager.mainDarkBlue,
              width: 1.1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // السؤال
              GenericQuestionWidget(
                questionTitle: "هل تتلقى العلاج النفسي/الاستشارات؟",
                initialValue: state.isReceivingPsychologicalTreatment,
                onAnswerChanged: (value) {
                  context
                      .read<MedicalIllnessesDataEntryCubit>()
                      .updateIsReceivingPsychologicalTreatment(value);
                },
              ),
              verticalSpacing(10),

              // Animated content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: state.isReceivingPsychologicalTreatment == true
                    ? Column(
                        key: const Key('psychologicalTreatmentForm'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel: "الأدوية المستخدمة",
                            containerHintText: state.medicationsUsed ??
                                "اختر الأدوية المستخدمة",
                            options: const [
                              "مضادات الاكتئاب",
                              "مضادات القلق",
                              "مثبتات المزاج",
                              "أدوية نفسية أخرى",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updateMedicationsUsed(value);
                            },
                            bottomSheetTitle: "اختر الأدوية المستخدمة",
                            searchHintText: "اختر الأدوية المستخدمة",
                          ),
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel: "تأثير الأدوية على الحياة اليومية",
                            containerHintText: state.medicationEffectOnLife ??
                                "اختر التأثير على حياتك اليومية",
                            options: const [
                              "تحسن كبير",
                              "تحسن بسيط",
                              "لا تأثير",
                              "تأثير سلبي",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updateMedicationEffectOnLife(value);
                            },
                            bottomSheetTitle: "اختر تأثير الأدوية",
                            searchHintText: "اختر تأثير الأدوية",
                          ),
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel:
                                "نوع العلاج النفسى/السلوكى (الذى قمت بتلقيه فى الماضى )",
                            containerHintText:
                                state.psychologicalTreatmentType ??
                                    "اختر نوع العلاج",
                            options: const [
                              "علاج معرفي سلوكي",
                              "علاج تحليلي",
                              "علاج جماعي",
                              "علاج أسري",
                              "علاج دوائي فقط",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updatePsychologicalTreatmentType(value);
                            },
                            bottomSheetTitle: "اختر نوع العلاج",
                            searchHintText: "اختر نوع العلاج",
                          ),
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel: "عدد الجلسات النفسية",
                            containerHintText:
                                state.numberOfSessions ?? "اختر عدد الجلسات",
                            options: const [
                              "1-5 جلسات",
                              "6-10 جلسات",
                              "11-20 جلسة",
                              "أكثر من 20 جلسة",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updateNumberOfSessions(value);
                            },
                            bottomSheetTitle: "اختر عدد الجلسات",
                            searchHintText: "اختر عدد الجلسات",
                          ),
                          verticalSpacing(18),
                          Text(
                            "رضائك عن نتيجة الجلسات",
                            style: AppTextStyles.font18blackWight500,
                          ),
                          verticalSpacing(10),
                          OptionSelectorWidget(
                            options: const [
                              "راض تماماً",
                              "مقبول",
                              "أقل من المتوقع",
                              "غير راض تماماً",
                            ],
                            initialSelectedOption: state.treatmentSatisfaction,
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updateTreatmentSatisfaction(value);
                            },
                          ),
                          verticalSpacing(18),
                          UserSelectionContainer(
                            categoryLabel: "الطبيب/الاخصائي النفسي",
                            containerHintText: state.psychologistName ??
                                "اختر اسم الطبيب النفسي/الاخصائي",
                            options: const [
                              "د. أحمد محمد",
                              "د. سارة علي",
                              "د. خالد حسن",
                              "د. نورة عبدالله",
                            ],
                            onOptionSelected: (value) {
                              context
                                  .read<MedicalIllnessesDataEntryCubit>()
                                  .updatePsychologistName(value);
                            },
                            bottomSheetTitle: "اختر الطبيب/الاخصائي",
                            searchHintText: "اختر الطبيب/الاخصائي",
                          ),
                          verticalSpacing(18),
                          Row(
                            children: [
                              Expanded(
                                child: UserSelectionContainer(
                                  categoryLabel: "المستشفى/المركز",
                                  containerHintText:
                                      state.selectedHospitalName ??
                                          "اختر اسم المستشفى",
                                  options: hosptitalsNames,
                                  onOptionSelected: (value) {
                                    context
                                        .read<MedicalIllnessesDataEntryCubit>()
                                        .updateSelectedHospitalName(value);
                                  },
                                  bottomSheetTitle: "اختر اسم المستشفى",
                                  searchHintText: "ابحث عن اسم المستشفى",
                                ),
                              ),
                              horizontalSpacing(16),
                              Expanded(
                                child: UserSelectionContainer(
                                  categoryLabel: "الدولة",
                                  containerHintText: state.selectedCountry ??
                                      "اختر اسم الدولة",
                                  options: [],
                                  onOptionSelected: (value) {
                                    context
                                        .read<MedicalIllnessesDataEntryCubit>()
                                        .updateTreatmentCountry(value);
                                  },
                                  bottomSheetTitle: "اختر اسم الدولة",
                                  searchHintText: "ابحث عن اسم الدولة",
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(
                        key: Key('emptyPsychologicalTreatment')),
              ),
            ],
          ),
        );
      },
    );
  }
}
