import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
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
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/gender_question_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class UserNutrationInfoDataEntryView extends StatefulWidget {
  const UserNutrationInfoDataEntryView({super.key});

  @override
  State<UserNutrationInfoDataEntryView> createState() =>
      _UserNutrationInfoDataEntryViewState();
}

class _UserNutrationInfoDataEntryViewState
    extends State<UserNutrationInfoDataEntryView> {
  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (context) => NutrationDataEntryCubit(
        getIt<NutrationDataEntryRepo>(),
        context,
      )..getAllChronicDiseases(),
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
                  CustomAppBarWidget(
                    haveBackArrow: true,
                  ),
                  verticalSpacing(24),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'من فضلك ادخل هذه البيانات\nلمتابعة نظامك الغذائى بدقة',
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
                        .read<NutrationDataEntryCubit>()
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
                        .read<NutrationDataEntryCubit>()
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
                    controller:
                        context.read<NutrationDataEntryCubit>().ageController,
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
                            .read<NutrationDataEntryCubit>()
                            .updateGenderType("ذكر");
                      } else {
                        context
                            .read<NutrationDataEntryCubit>()
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
                  BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
                    builder: (context, state) {
                      return UserSelectionContainer(
                        categoryLabel: 'النشاط البدنى',
                        containerBorderColor:
                            state.selectedPhysicalActivity == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.mainDarkBlue,
                        containerHintText: 'اختر معدل النشاط البدنى لديك',
                        options: [
                          'خامل',
                          'خفيف',
                          'متوسط',
                          'عالي',
                          'شاق جدا',
                        ],
                        initialValue: 'متوسط',
                        onOptionSelected: (value) {
                          context
                              .read<NutrationDataEntryCubit>()
                              .updateSelectedPhysicalActivity(value);
                        },
                        bottomSheetTitle: 'اختر معدل النشاط البدنى لديك',
                        searchHintText: "اختر معدل النشاط البدنى لديك",
                      );
                    },
                  ),

                  verticalSpacing(32),

                  ChronicDiseasesSelector(),
                  verticalSpacing(50),

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
  return BlocConsumer<NutrationDataEntryCubit, NutrationDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.submitNutrationDataStatus == RequestStatus.failure ||
        curr.submitNutrationDataStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.submitNutrationDataStatus != curr.submitNutrationDataStatus,
    listener: (context, state) async {
      if (state.submitNutrationDataStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        await context.pushReplacementNamed(Routes.followUpNutrationPlansView);
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.submitNutrationDataStatus == RequestStatus.loading,
        title: "اكمل",
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            // لو كل حاجة صح
            await context
                .read<NutrationDataEntryCubit>()
                .postPersonalUserInfoData();
            AppLogger.debug(
                "✅ البيانات صحيحة - ابعت للسيرفر أو روح للخطوة التالية");
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
  return Row(
    children: [
      // Icon
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

      horizontalSpacing(12),

      // Text field
      Expanded(
        child: CustomTextField(
          hintText: hintText,
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
        ),
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
  return Row(
    children: [
      // Icon
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

      horizontalSpacing(12),

      // Text field
      Expanded(
        child: GenderQuestionWidget(
          onAnswerChanged: onAnswerChanged,
          initialValue: true,
        ),
      ),
    ],
  );
}

class ChronicDiseasesSelector extends StatelessWidget {
  const ChronicDiseasesSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
      buildWhen: (prev, curr) =>
          prev.selectedChronicDiseases != curr.selectedChronicDiseases ||
          prev.chronicDiseases != curr.chronicDiseases,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserSelectionContainer(
              categoryLabel: 'الأمراض المزمنة',
              containerHintText: state.selectedChronicDiseases.isEmpty
                  ? 'اختر الأمراض المزمنة لديك'
                  : '${state.selectedChronicDiseases.length} أمراض محددة',
              options: state.chronicDiseases, //! من الباكيند
              onOptionSelected: (value) {
                context
                    .read<NutrationDataEntryCubit>()
                    .updateSelectedChronicDiseases(value);
              },
              bottomSheetTitle: 'اختر الأمراض المزمنة لديك',
              searchHintText: 'اختر الأمراض المزمنة لديك',
            ),
            if (state.selectedChronicDiseases.isNotEmpty) ...[
              verticalSpacing(8),
              Text(
                "الأمراض المحددة:",
                textAlign: TextAlign.start,
                style: AppTextStyles.font14blackWeight400,
              ),
              verticalSpacing(4),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.start,
                children: state.selectedChronicDiseases.map(
                  (cause) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cause,
                            style: AppTextStyles.font14blackWeight400,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<NutrationDataEntryCubit>()
                                  .removeChronicDisease(cause);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
