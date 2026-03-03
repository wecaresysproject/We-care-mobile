import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/gender_question_widget.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_data_entry/logic/cubit/physical_activaty_data_entry_cubit.dart';

class UserPhysicalActivatyInfoDataEntryView extends StatefulWidget {
  const UserPhysicalActivatyInfoDataEntryView({super.key});

  @override
  State<UserPhysicalActivatyInfoDataEntryView> createState() =>
      _UserPhysicalActivatyInfoDataEntryViewState();
}

class _UserPhysicalActivatyInfoDataEntryViewState
    extends State<UserPhysicalActivatyInfoDataEntryView> {
  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhysicalActivatyDataEntryCubit>(
      create: (context) => getIt.get<PhysicalActivatyDataEntryCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey, // 🔑 هنا المفتاح
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWithImageAndActionButtons(
                    haveBackArrow: true,
                  ),
                  verticalSpacing(24),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'من فضلك ادخل هذه البيانات\nلمتابعة نشاطك البدني بدقة',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font22MainBlueWeight700.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColorsManager.textColor,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  verticalSpacing(40),

                  // الطول
                  buildInputField(
                    title: 'الطول',
                    imagePath: 'assets/images/measure_height.png',
                    hintText: "أدخل الطول بالسنتيمتر",
                    controller: context
                        .read<PhysicalActivatyDataEntryCubit>()
                        .heightController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل الطول';
                      }
                      final height = int.tryParse(value);
                      if (height == null) {
                        return 'الطول يجب أن يكون رقم صحيح';
                      }
                      if (height < 50 || height > 230) {
                        return 'الطول يجب أن يكون بين 50 و 230 سم';
                      }
                      return null;
                    },
                  ),

                  verticalSpacing(22),

                  // الوزن
                  buildInputField(
                    title: 'الوزن',
                    imagePath: 'assets/images/measure_body_weight.png',
                    hintText: "أدخل الوزن بالكيلو جرام",
                    controller: context
                        .read<PhysicalActivatyDataEntryCubit>()
                        .weightController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل الوزن';
                      }
                      final weight = int.tryParse(value);
                      if (weight == null) {
                        return 'الوزن يجب أن يكون رقم صحيح';
                      }
                      if (weight < 4 || weight > 350) {
                        return 'الوزن يجب أن يكون بين 4 و 350 كجم';
                      }
                      return null;
                    },
                  ),

                  verticalSpacing(22),

                  // السن
                  buildInputField(
                    title: 'السن',
                    hintText: "أدخل عمرك الحالي",
                    imagePath: 'assets/images/year_image.png',
                    controller: context
                        .read<PhysicalActivatyDataEntryCubit>()
                        .ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل السن';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'السن يجب أن يكون رقم صحيح';
                      }
                      if (age < 1 || age > 120) {
                        return 'السن يجب أن يكون بين 1 و 120 عام';
                      }
                      return null;
                    },
                  ),

                  verticalSpacing(22),

                  // النوع
                  buildGenderInputField(
                    onAnswerChanged: (type) {
                      //ذكر
                      if (type == true) {
                        context
                            .read<PhysicalActivatyDataEntryCubit>()
                            .updateGenderType("ذكر");
                      } else {
                        context
                            .read<PhysicalActivatyDataEntryCubit>()
                            .updateGenderType("انثى");
                      }
                    },
                    imagePath: 'assets/images/gender_image.png',
                    title: 'النوع',
                    validator: (p0) {
                      // تقدر تضيف هنا validation لو لازم
                    },
                    keyboardType: TextInputType.number,
                  ),

                  verticalSpacing(32),
                  // النشاط البدني
                  UserSelectionContainer(
                    categoryLabel: "كثافة الكتلة العضلية",
                    containerHintText: 'اختر معدل النشاط البدنى لديك',
                    options: [
                      'شخص قليل الكتلة العضلية',
                      'شخص متوسط الكتلة العضلية (عادي)',
                      'شخص رياضي ذو كتلة عضلية عالية',
                    ],
                    initialValue: 'شخص متوسط الكتلة العضلية (عادي)',
                    onOptionSelected: (value) {
                      context
                          .read<PhysicalActivatyDataEntryCubit>()
                          .updateSelectedMuscleDesity(value);
                    },
                    bottomSheetTitle: 'اختر كثافة الكتلة العضلية',
                    searchHintText: "ابحث عن الكثافة العضلية المناسبة",
                  ),

                  verticalSpacing(22),

                  // الوزن
                  buildInputField(
                    title: 'إجمالي السعرات المستهدفة',
                    imagePath: 'assets/images/measure_body_weight.png',
                    hintText: 'أدخل إجمالي السعرات المستهدفة',
                    controller: context
                        .read<PhysicalActivatyDataEntryCubit>()
                        .targetCaloriesController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل إجمالي السعرات المستهدفة';
                      }

                      final calories = int.tryParse(value);
                      if (calories == null) {
                        return 'القيمة يجب أن تكون رقمًا صحيحًا';
                      }
                      if (calories > 100000) {
                        return 'الحد الأقصى لإجمالي السعرات هو 100,000';
                      }
                      if (calories <= 0) {
                        return 'القيمة يجب أن تكون أكبر من صفر';
                      }

                      return null;
                    },
                  ),

                  verticalSpacing(32),

                  submitUserInfoEnteredButtonBlocConsumer(_formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget submitUserInfoEnteredButtonBlocConsumer(GlobalKey<FormState> formKey) {
  return BlocConsumer<PhysicalActivatyDataEntryCubit,
      PhysicalActivatyDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.submitPhysicalActivityDataStatus == RequestStatus.failure ||
        curr.submitPhysicalActivityDataStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.submitPhysicalActivityDataStatus !=
        curr.submitPhysicalActivityDataStatus,
    listener: (context, state) async {
      if (state.submitPhysicalActivityDataStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        await context
            .pushReplacementNamed(Routes.physicalActivatyPlansDataEntry);
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading:
            state.submitPhysicalActivityDataStatus == RequestStatus.loading,
        title: "اكمل",
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await context
                .read<PhysicalActivatyDataEntryCubit>()
                .postPersonalUserInfoData();
          }
        },
        isEnabled: true,
      );
    },
  );
}

Widget buildInputField({
  required String imagePath,
  required String title,
  required TextEditingController controller,
  required dynamic Function(String?) validator,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    children: [
      // Icon
      Row(
        children: [
          Image.asset(
            imagePath,
            color: AppColorsManager.mainDarkBlue,
            height: 23,
            width: 23,
          ),

          horizontalSpacing(8),
          // Label text
          Text(
            title,
            style: AppTextStyles.font18blackWight500,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),

      verticalSpacing(12),

      // Text field
      CustomTextField(
        hintText: hintText,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
      ),
    ],
  );
}

Widget buildGenderInputField({
  required String imagePath,
  required String title,
  required dynamic Function(String?) validator,
  required dynamic Function(bool?)? onAnswerChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    children: [
      // Icon
      Row(
        children: [
          Image.asset(
            imagePath,
            color: AppColorsManager.mainDarkBlue,
            height: 35,
            width: 35,
            fit: BoxFit.contain,
          ),
          horizontalSpacing(8),
          // Label text
          Text(
            title,
            style: AppTextStyles.font18blackWight500,
          ),
        ],
      ),

      verticalSpacing(12),

      // Text field
      GenderQuestionWidget(
        onAnswerChanged: onAnswerChanged,
        initialValue: true,
      ),
    ],
  );
}
