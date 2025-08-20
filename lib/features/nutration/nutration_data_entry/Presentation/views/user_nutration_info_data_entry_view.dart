import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/gender_question_widget.dart';

class UserNutrationInfoDataEntryView extends StatefulWidget {
  const UserNutrationInfoDataEntryView({super.key});

  @override
  State<UserNutrationInfoDataEntryView> createState() =>
      _UserNutrationInfoDataEntryViewState();
}

class _UserNutrationInfoDataEntryViewState
    extends State<UserNutrationInfoDataEntryView> {
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _heightController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ),
            verticalSpacing(24),
            Text(
              'من فضلك ادخل هذه البيانات\nلمتابعة نظامك الغذائى بدقة',
              textAlign: TextAlign.center,
              style: AppTextStyles.font22MainBlueWeight700.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColorsManager.textColor,
                fontSize: 20.sp,
              ),
            ),
            verticalSpacing(40),
            buildInputField(
              title: 'الطول',
              imagePath: 'assets/images/measure_height.png',
              controller: _heightController,
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
            buildInputField(
              title: 'الوزن',
              imagePath: 'assets/images/measure_body_weight.png',
              controller: _weightController,
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

            buildInputField(
              title: 'السن',
              imagePath: 'assets/images/year_image.png',
              controller: _ageController,
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
            buildGenderInputField(
              imagePath: 'assets/images/gender_image.png',
              title: 'النوع',
              validator: (p0) {},
              controller: _ageController,
              keyboardType: TextInputType.number,
            ),
            verticalSpacing(32),

            // iconWithTextInRow(
            //   title: ' النشاط البدنى',
            //   imagePath: 'assets/images/man_running.png',
            // ),
            UserSelectionContainer(
              categoryLabel: ' النشاط البدنى',
              containerHintText: 'اختر معدل النشاط البدنى لديك',
              // state.selectedsocialSupport ?? "اختر الدعم الاجتماعى",
              options: [
                'خامل',
                'بسيط',
                'متوسط',
                'قوي',
                'مجهذ',
              ],
              onOptionSelected: (value) {
                // context
                //     .read<MedicalIllnessesDataEntryCubit>()
                //     .updateSelectedSocialSupport(value);
              },
              bottomSheetTitle: 'اختر معدل النشاط البدنى لديك',
              searchHintText: "اختر معدل النشاط البدنى لديك",
            ),
            verticalSpacing(32),

            UserSelectionContainer(
              categoryLabel: 'الأمراض المزمنة',
              containerHintText: 'اختر الأمراض المزمنة لديك',
              // state.selectedsocialSupport ?? "اختر الدعم الاجتماعى",
              options: [],
              onOptionSelected: (value) {
                // context
                //     .read<MedicalIllnessesDataEntryCubit>()
                //     .updateSelectedSocialSupport(value);
              },
              bottomSheetTitle: 'اختر الأمراض المزمنة لديك',
              searchHintText: 'اختر الأمراض المزمنة لديك',
            ),
            verticalSpacing(50),

            AppCustomButton(
              isLoading: false,
              title: 'اكمل',
              onPressed: () async {
                // if (state.isFormValidated) {
                //   state.isEditMode
                //       ? await context
                //           .read<DentalDataEntryCubit>()
                //           .submitEditedOneTeethReportDetails(
                //             context.translate,
                //             state.updatedTeethId,
                //             toothNumber,
                //           )
                //       : await context
                //           .read<DentalDataEntryCubit>()
                //           .postOneTeethReportDetails(
                //             context.translate,
                //             toothNumber,
                //           );
                //   log("xxx:Save Data Entry");
                // }
              },
              isEnabled: true, // state.isFormValidated ? true : false,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildInputField({
  required String imagePath,
  required String title,
  required TextEditingController controller,
  required dynamic Function(String?) validator,
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
          hintText: '',
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ),
    ],
  );
}

Widget iconWithTextInRow({required String imagePath, required String title}) {
  return Row(
    children: [
      // Icon
      Image.asset(
        imagePath,
        color: AppColorsManager.mainDarkBlue,
        height: 20,
        width: 20,
      ),
      horizontalSpacing(8),
      // Label text
      Text(
        title,
        style: AppTextStyles.font18blackWight500,
        textDirection: TextDirection.rtl,
      ),
    ],
  );
}

Widget buildGenderInputField({
  required String imagePath,
  required String title,
  required TextEditingController controller,
  required dynamic Function(String?) validator,
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
          onAnswerChanged: (p0) {},
          initialValue: true,
        ),
      ),
    ],
  );
}
