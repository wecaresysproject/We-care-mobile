// essential_data_entry_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/logic/cubit/essential_data_entry_cubit.dart';

class EssentialDataEntryView extends StatelessWidget {
  const EssentialDataEntryView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EssentialDataEntryCubit>(
      create: (context) => EssentialDataEntryCubit(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(24),
                EssentialDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EssentialDataEntryFormFields extends StatelessWidget {
  const EssentialDataEntryFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EssentialDataEntryCubit, EssentialDataEntryState>(
      listenWhen: (prev, curr) =>
          prev.submissionStatus != curr.submissionStatus ||
          prev.message != curr.message,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          if (state.message != null) {
            await showSuccess(state.message!);
          }
        } else if (state.submissionStatus == RequestStatus.failure) {
          if (state.message != null) {
            await showError(state.message!);
          }
        }
      },
      buildWhen: (prev, curr) => true,
      builder: (context, state) {
        final cubit = context.read<EssentialDataEntryCubit>();

        return Form(
          key: GlobalKey<FormState>(),
          child: Padding(
            padding: EdgeInsets.only(bottom: 70.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الاسم رباعى", style: AppTextStyles.font18blackWight500),
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
                  onChanged: (_) => cubit.onAnyFieldChanged(),
                ),
                verticalSpacing(12),
                Text('تاريخ الميلاد', style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                DateTimePickerContainer(
                  placeholderText: state.birthDate ?? 'يوم / شهر / سنة',
                  onDateSelected: (pickedDate) {
                    cubit.updateBirthDate(pickedDate);
                    cubit.onAnyFieldChanged();
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
                  onChanged: (_) => cubit.onAnyFieldChanged(),
                ),
                verticalSpacing(18),
                Text('الايميل', style: AppTextStyles.font18blackWight500),
                verticalSpacing(10),
                CustomTextField(
                  controller: cubit.nationalIdController,
                  hintText: "example@domain.com",
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'الايميل مطلوب';
                    }
                    return null;
                  },
                  onChanged: (_) => cubit.onAnyFieldChanged(),
                ),
                verticalSpacing(18),
                Text(
                  "صورة شخصية( 4x6)",
                  style: AppTextStyles.font18blackWight500,
                ),
                verticalSpacing(10),
                SelectImageContainer(
                  containerBorderColor: AppColorsManager.mainDarkBlue,
                  imagePath: "assets/images/photo_icon.png",
                  label: "ارفق صورة من الجهاز",
                  onTap: () async {
                    await showImagePicker(
                      context,
                      onImagePicked: (isImagePicked) async {},
                    );
                  },
                ),
                verticalSpacing(8),
                SelectImageContainer(
                  containerBorderColor: AppColorsManager.mainDarkBlue,
                  imagePath: "assets/images/camera_icon.png",
                  label: "التقاط صورة",
                  onTap: () async {
                    await showImagePicker(
                      context,
                      onImagePicked: (isImagePicked) async {},
                    );
                  },
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'الدولة',
                  containerHintText: state.selectedNationality ?? 'اختر دولتك',
                  options: ['الدولة 1', 'الدولة 2', 'الدولة 3'],
                  onOptionSelected: (val) {
                    cubit.updateNationality(val);
                  },
                  bottomSheetTitle: 'اختر دولتك',
                  searchHintText: 'ابحث عن دولتك',
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'المدينة',
                  containerHintText: state.selectedCity ?? 'اختر مدينتك',
                  options: ['المدينة 1', 'المدينة 2', 'المدينة 3'],
                  onOptionSelected: (val) {
                    cubit.updateCity(val);
                  },
                  bottomSheetTitle: 'اختر مدينتك',
                  searchHintText: 'ابحث عن مدينتك',
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'المنطقة',
                  containerHintText: state.selectedArea ?? 'اختر منطقتك',
                  options: ['المنطقة 1', 'المنطقة 2', 'المنطقة 3'],
                  onOptionSelected: (val) {
                    cubit.updateArea(val);
                  },
                  bottomSheetTitle: 'اختر منطقتك',
                  searchHintText: 'ابحث عن منطقتك',
                ),
                verticalSpacing(18),
                UserSelectionContainer(
                  categoryLabel: 'الحى /العزبة /الشياخة',
                  containerHintText: state.selectedNeighborhood ??
                      'اختر الحى /العزبة /الشياخة',
                  options: ['الحي 1', 'الحي 2', 'الحي 3'],
                  onOptionSelected: (val) {
                    cubit.updateNeighborhood(val);
                  },
                  bottomSheetTitle: 'اختر حيك',
                  searchHintText: 'ابحث عن حيك',
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
                      GenericQuestionWidget(
                  questionTitle: 'هل يوجد تأمين طبى؟',
                  initialValue: state.hasMedicalInsurance,
                  onAnswerChanged: (val) {
                    cubit.updateHasMedicalInsurance(val);
                  },
                ),
                verticalSpacing(12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.hasMedicalInsurance == true
                      ? Column(
                          key: const Key('insuranceFields'),
                          children: [
                            verticalSpacing(12),
                            UserSelectionContainer(
                              categoryLabel: "شركة التأمين",
                              containerHintText: state.selectedInsuranceType ??
                                  'اختر شركة التأمين',
                              options: cubit.insuranceTypes,
                              onOptionSelected: (val) {
                                cubit.updateInsuranceType(val);
                              },
                              bottomSheetTitle: 'اختر شركة التأمين',
                              searchHintText: 'ابحث عن شركة التأمين',
                            ),
                          
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
