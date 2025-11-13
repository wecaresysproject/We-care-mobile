// essential_data_entry_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/dynamic_question_with_dynamic_answer_list_option.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/logic/cubit/essential_data_entry_cubit.dart';

class EssentialDataEntryFormFields extends StatelessWidget {
  const EssentialDataEntryFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EssentialDataEntryCubit, EssentialDataEntryState>(
      builder: (context, state) {
        final cubit = context.read<EssentialDataEntryCubit>();
        return Form(
          key: GlobalKey<FormState>(),
          child: Padding(
            padding: EdgeInsets.only(bottom: 70.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الاسم رباعى",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(14),
                CustomTextField(
                  controller: cubit.fullNameController,
                  hintText: "اكتب اسمك رباعى",
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'الاسم مطلوب';
                    }
                    return null;
                  },
                  onChanged: (_) => cubit.validateRequiredFields(),
                ),
                verticalSpacing(12),
                Text(
                  'تاريخ الميلاد',
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                DateTimePickerContainer(
                  placeholderText: state.birthDate ?? 'يوم / شهر / سنة',
                  onDateSelected: (pickedDate) {
                    cubit.updateBirthDate(pickedDate);
                    // cubit.onAnyFieldChanged();
                  },
                ),
                verticalSpacing(16),
                Text('الرقم الوطنى', style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.nationalIdController,
                  hintText: "اكتب رقمك القومى",
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'الرقم الوطني مطلوب';
                    }
                    return null;
                  },
                  onChanged: (_) {},
                ),
                verticalSpacing(18),
                Text('الايميل', style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.emailController,
                  hintText: "example@domain.com",
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'الايميل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (_) {},
                ),
                verticalSpacing(18),
                Text(
                  "صورة شخصية( 4x6)",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                SelectImageContainer(
                  containerBorderColor:
                      AppColorsManager.textfieldOutsideBorderColor,
                  imagePath: "assets/images/photo_icon.png",
                  label: "ارفق صورة",
                  onTap: () async {
                    await showImagePicker(
                      context,
                      onImagePicked: (isImagePicked) async {
                        final picker = getIt.get<ImagePickerService>();
                        if (isImagePicked && picker.isImagePickedAccepted) {
                          await context
                              .read<EssentialDataEntryCubit>()
                              .uploadProfileImage(
                                imagePath: picker.pickedImage!.path,
                              );
                        }
                      },
                    );
                  },
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'الدولة',
                  containerHintText: state.selectedNationality ?? 'اختر دولتك',
                  options: state.countriesNames,
                  onOptionSelected: (val) async {
                    cubit.updateNationality(val);
                    await cubit.emitCitiesData();
                  },
                  bottomSheetTitle: 'اختر دولتك',
                  searchHintText: 'ابحث عن دولتك',
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'المدينة',
                  containerHintText: state.selectedCity ?? 'اختر مدينتك',
                  options: state.citiesNames,
                  onOptionSelected: (val) {
                    cubit.updateCity(val);
                  },
                  bottomSheetTitle: 'اختر مدينتك',
                  searchHintText: 'ابحث عن مدينتك',
                ),
                verticalSpacing(18),
                Text('المنطقة', style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.exactLocation,
                  hintText: "اكتب المنطقة",
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(18),
                Text(
                  'الحى /العزبة /الشياخة',
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.userAddress,
                  hintText: "اكتب الحى /العزبة /الشياخة",
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'فصيلة الدم',
                  containerHintText:
                      state.selectedBloodType ?? 'اختر فصيلة الدم',
                  options: cubit.bloodTypes,
                  onOptionSelected: (val) {
                    cubit.updateBloodType(val);
                  },
                  bottomSheetTitle: 'اختر فصيلة الدم',
                  searchHintText: 'ابحث عن فصيلة الدم',
                ),
                verticalSpacing(18),
                MedicalInsuranceYesOrNoWidget(),
                verticalSpacing(16),
                QuestionWithDynamicAnswerListOption(
                  options: [
                    'كلي',
                    'جزئي',
                  ],
                  questionTitle: "العجز الجسدى أو الوظيفى ان وجد",
                  initialValue: state.disabilityLevel,
                  onAnswerChanged: (val) {
                    context
                        .read<EssentialDataEntryCubit>()
                        .updateDisabilityLevel(val);
                  },
                ),
                verticalSpacing(16),
                Text(
                  'نوع العجز (إن وجد)',
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.disabilityTypeDetailsController,
                  hintText: "اكتب نوع العجز (إن وجد)",
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                QuestionWithDynamicAnswerListOption(
                  options: [
                    'متزوج',
                    'أعزب',
                  ],
                  questionTitle: "الحالة الاجتماعية",
                  initialValue: state.socialStatus,
                  onAnswerChanged: (val) {
                    context
                        .read<EssentialDataEntryCubit>()
                        .updateIsMarriedOrNot(val);
                  },
                ),
                verticalSpacing(16),
                Text(
                  "عدد الأبناء",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.numberOfChildrenController,
                  hintText: "اختر عدد أبنائك",
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                Text(
                  "طبيب الأسرة",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.familyDoctorNameController,
                  hintText: "اكتب اسم طبيب الأسرة ان وجد",
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                Text(
                  "تليفون طبيب الأسرة",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.familyDoctorPhoneNumberController,
                  hintText: "اكتب تليفون طبيب الأسرة",
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                Text(
                  'ساعات العمل الأسبوعى',
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.noOfWoringHours,
                  hintText: "اكتب ساعات العمل الأسبوعى",
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                Text(
                  "تليفون للطوارئ",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.mainEmergencyPhoneController,
                  hintText: "تليفون اخر (الأم/الأب/الأخ/الأخت/الزوج/الزوجة)",
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                Text(
                  "تليفون للطوارئ اخر",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.anotherEmergencyPhoneController,
                  hintText: "تليفون اخر (الأم/الأب/الأخ/الأخت/الزوج/الزوجة)",
                  keyboardType: TextInputType.number,
                  validator: (val) {},
                  onChanged: (_) {},
                ),
                verticalSpacing(16),
                submitDataButtonBlocConsumer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MedicalInsuranceYesOrNoWidget extends StatelessWidget {
  const MedicalInsuranceYesOrNoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EssentialDataEntryCubit, EssentialDataEntryState>(
      buildWhen: (previous, current) =>
          previous.hasMedicalInsurance != current.hasMedicalInsurance,
      builder: (context, state) {
        final cubit = context.read<EssentialDataEntryCubit>();

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
                "تأمين طبى",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
              verticalSpacing(16),
              // سؤال نعم/لا
              GenericQuestionWidget(
                questionTitle: "هل لديك تأمين طبى ؟",
                initialValue: state.hasMedicalInsurance,
                onAnswerChanged: (value) {
                  context
                      .read<EssentialDataEntryCubit>()
                      .updateHasMedicalInsurance(value, context.translate);
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
                child: state.hasMedicalInsurance == true
                    ? Column(
                        key: const Key('familySimilarCasesForm'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "شركة التأمين",
                            style: AppTextStyles.font18blackWight500,
                          ),
                          verticalSpacing(10),
                          CustomTextField(
                            controller: cubit.insuranceCompanyController,
                            hintText: state.insuranceCompany ??
                                "اختر اسم شركة التأمين",
                            validator: (val) {},
                            onChanged: (_) {},
                          ),
                          verticalSpacing(16),
                          Text(
                            'تاريخ انتهاء التغطية التأمينية',
                            style: AppTextStyles.font18blackWight500,
                          ),
                          verticalSpacing(10),
                          DateTimePickerContainer(
                            placeholderText:
                                state.insuranceEndDate ?? 'يوم / شهر / سنة',
                            onDateSelected: (pickedDate) {
                              context
                                  .read<EssentialDataEntryCubit>()
                                  .updateInsuranceEndDate(pickedDate);
                            },
                          ),
                          verticalSpacing(16),
                          Text(
                            'شروط اضافية للتأمين',
                            style: AppTextStyles.font18blackWight500,
                          ),
                          verticalSpacing(10),
                          CustomTextField(
                            controller:
                                cubit.additionalInsuranceConditionsController,
                            hintText: "اكتب أى شروط اضافية للتأمين",
                            validator: (val) {},
                            onChanged: (_) {},
                          ),
                          verticalSpacing(16),
                          Text(
                            "صورة كارت التأمين",
                            style: AppTextStyles.font18blackWight500,
                          ),
                          verticalSpacing(10),
                          SelectImageContainer(
                            containerBorderColor:
                                AppColorsManager.textfieldOutsideBorderColor,
                            imagePath: "assets/images/photo_icon.png",
                            label: "ارفق صورة",
                            onTap: () async {
                              await showImagePicker(
                                context,
                                onImagePicked: (isImagePicked) async {
                                  final picker =
                                      getIt.get<ImagePickerService>();
                                  if (isImagePicked &&
                                      picker.isImagePickedAccepted) {
                                    await context
                                        .read<EssentialDataEntryCubit>()
                                        .uploadInsuranceCardImage(
                                          imagePath: picker.pickedImage!.path,
                                        );
                                  }
                                },
                              );
                            },
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

Widget submitDataButtonBlocConsumer() {
  return BlocConsumer<EssentialDataEntryCubit, EssentialDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.submissionStatus == RequestStatus.failure ||
        curr.submissionStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.submissionStatus != curr.submissionStatus,
    listener: (context, state) async {
      if (state.submissionStatus == RequestStatus.success) {
        await showSuccess(state.message!);
        if (!context.mounted) return;
        context.pop(
          result:
              true, //! send true back to test analysis details view inn order to check if its updated , then reload the view
        );
      } else {
        await showError(state.message!);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.submissionStatus == RequestStatus.loading,
        title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            state.isEditMode
                ? await context
                    .read<EssentialDataEntryCubit>()
                    .submitEditsOnUserEssentialInfo(
                      context.translate,
                    )
                : await context
                    .read<EssentialDataEntryCubit>()
                    .postUserBasicData(
                      context.translate,
                    );
          }
        },
        isEnabled: state.isFormValidated || state.isEditMode ? true : false,
      );
    },
  );
}
