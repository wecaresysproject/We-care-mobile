import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/functions.dart'; // Ensure this path is correct
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart'; // Ensure this path is correct
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart'; // Ensure this path is correct
import 'package:we_care/core/global/theming/color_manager.dart'; // Ensure this path is correct

class RightAndLeftLensTabBarView extends StatefulWidget {
  const RightAndLeftLensTabBarView({super.key});

  @override
  State<RightAndLeftLensTabBarView> createState() =>
      _RightAndLeftLensTabBarViewState();
}

class _RightAndLeftLensTabBarViewState
    extends State<RightAndLeftLensTabBarView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Right Lens
  final TextEditingController _rightShortSightController =
      TextEditingController(); // قصر النظر للعدسة اليمنى
  final TextEditingController _rightLongSightController =
      TextEditingController(); // طول النظر للعدسة اليمنى
  final TextEditingController _rightAstigmatismController =
      TextEditingController(); // الاستجماتزم للعدسة اليمنى
  final TextEditingController _rightAstigmatismAxisController =
      TextEditingController(); // محور الاستجماتزم للعدسة اليمنى
  final TextEditingController _rightFocalAdditionController =
      TextEditingController(); // الاضافة البؤرية للعدسة اليمنى
  final TextEditingController _rightPupilDistanceController =
      TextEditingController(); // تباعد الحدقتين للعدسة اليمنى
  final TextEditingController _rightRefractiveIndexController =
      TextEditingController(); // معامل الانكسار للعدسة اليمنى
  final TextEditingController _rightLensDiameterController =
      TextEditingController(); // قطر العدسة للعدسة اليمنى
  final TextEditingController _rightCenterController =
      TextEditingController(); // المركز للعدسة اليمنى
  final TextEditingController _rightEdgesController =
      TextEditingController(); // الحواف للعدسة اليمنى
  final TextEditingController _rightLensSurfaceController =
      TextEditingController(); // سطح العدسة للعدسة اليمنى
  final TextEditingController _rightLensThicknessController =
      TextEditingController(); // سُمك العدسة للعدسة اليمنى
  final TextEditingController _rightLensTypeController =
      TextEditingController(); // نوع العدسة للعدسة اليمنى

  // Controllers for Left Lens
  final TextEditingController _leftShortSightController =
      TextEditingController(); // قصر النظر للعدسة اليسرى
  final TextEditingController _leftLongSightController =
      TextEditingController(); // طول النظر للعدسة اليسرى
  final TextEditingController _leftAstigmatismController =
      TextEditingController(); // الاستجماتزم للعدسة اليسرى
  final TextEditingController _leftAstigmatismAxisController =
      TextEditingController(); // محور الاستجماتزم للعدسة اليسرى
  final TextEditingController _leftFocalAdditionController =
      TextEditingController(); // الاضافة البؤرية للعدسة اليسرى
  final TextEditingController _leftPupilDistanceController =
      TextEditingController(); // تباعد الحدقتين للعدسة اليسرى
  final TextEditingController _leftRefractiveIndexController =
      TextEditingController(); // معامل الانكسار للعدسة اليسرى
  final TextEditingController _leftLensDiameterController =
      TextEditingController(); // قطر العدسة للعدسة اليسرى
  final TextEditingController _leftCenterController =
      TextEditingController(); // المركز للعدسة اليسرى
  final TextEditingController _leftEdgesController =
      TextEditingController(); // الحواف للعدسة اليسرى
  final TextEditingController _leftLensSurfaceController =
      TextEditingController(); // سطح العدسة للعدسة اليسرى
  final TextEditingController _leftLensThicknessController =
      TextEditingController(); // سُمك العدسة للعدسة اليسرى
  final TextEditingController _leftLensTypeController =
      TextEditingController(); // نوع العدسة للعدسة اليسرى

  @override
  void dispose() {
    _rightShortSightController.dispose();
    _rightLongSightController.dispose();
    _rightAstigmatismController.dispose();
    _rightAstigmatismAxisController.dispose();
    _rightFocalAdditionController.dispose();
    _rightPupilDistanceController.dispose();
    _rightRefractiveIndexController.dispose();
    _rightLensDiameterController.dispose();
    _rightCenterController.dispose();
    _rightEdgesController.dispose();
    _rightLensSurfaceController.dispose();
    _rightLensThicknessController.dispose();
    _rightLensTypeController.dispose();

    _leftShortSightController.dispose();
    _leftLongSightController.dispose();
    _leftAstigmatismController.dispose();
    _leftAstigmatismAxisController.dispose();
    _leftFocalAdditionController.dispose();
    _leftPupilDistanceController.dispose();
    _leftRefractiveIndexController.dispose();
    _leftLensDiameterController.dispose();
    _leftCenterController.dispose();
    _leftEdgesController.dispose();
    _leftLensSurfaceController.dispose();
    _leftLensThicknessController.dispose();
    _leftLensTypeController.dispose();
    super.dispose();
  }

  // --- Validation Functions ---
  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    return null;
  }

  String? _numericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة لـ $fieldName';
    }
    return null;
  }

  String? _axisValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال المحور';
    }
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة للمحور';
    }
    // Add specific axis range validation here if needed, e.g., between 0 and 180.
    // double? axis = double.tryParse(value);
    // if (axis != null && (axis < 0 || axis > 180)) {
    //   return 'المحور يجب أن يكون بين 0 و 180';
    // }
    return null;
  }

  // Helper widget to reduce code duplication for each section
  Widget _buildLensInputSection({
    required String title,
    required TextEditingController rightController,
    required TextEditingController leftController,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align titles to the start of their column
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                    ), // Or your preferred style
                  ),
                  verticalSpacing(10),
                  CustomTextField(
                    controller: rightController,
                    hintText: hintText,
                    validator: validator,
                    keyboardType: keyboardType,
                  ),
                ],
              ),
            ),
            horizontalSpacing(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                    ), // Or your preferred style, // Or your preferred style
                  ),
                  verticalSpacing(10),
                  CustomTextField(
                    controller: leftController,
                    hintText: hintText,
                    validator: validator,
                    keyboardType: keyboardType,
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpacing(16.h), // Spacing after each full section
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 52.h),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/glasses.png",
              height: 100.h,
            ),
            verticalSpacing(16.h),

            // Main headers for "العدسة اليمنية" and "العدسة اليسارية"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "العدسة اليمنية",
                      style: AppTextStyles.font18blackWight500.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                  horizontalSpacing(16.w),
                  Expanded(
                    child: Text(
                      "العدسة اليسارية",
                      style: AppTextStyles.font18blackWight500.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(16.h), // Spacing after the main eye headers

            // Using the helper function for each section
            _buildLensInputSection(
              title: "قصر النظر",
              rightController: _rightShortSightController,
              leftController: _leftShortSightController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "درجة قصر النظر"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "طول النظر",
              rightController: _rightLongSightController,
              leftController: _leftLongSightController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "درجة طول النظر"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "الاستجماتزم",
              rightController: _rightAstigmatismController,
              leftController: _leftAstigmatismController,
              hintText: "اختر الدرجة",
              validator: (value) =>
                  _numericValidator(value, "درجة الاستجماتزم"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "محور الاستجماتزم",
              rightController: _rightAstigmatismAxisController,
              leftController: _leftAstigmatismAxisController,
              hintText: "اختر الدرجة",
              validator: _axisValidator,
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "الاضافة البؤرية",
              rightController: _rightFocalAdditionController,
              leftController: _leftFocalAdditionController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "الإضافة البؤرية"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "تباعد الحدقتين",
              rightController: _rightPupilDistanceController,
              leftController: _leftPupilDistanceController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "تباعد الحدقتين"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "معامل الانكسار",
              rightController: _rightRefractiveIndexController,
              leftController: _leftRefractiveIndexController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "معامل الانكسار"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "قطر العدسة",
              rightController: _rightLensDiameterController,
              leftController: _leftLensDiameterController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "قطر العدسة"),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "المركز",
              rightController: _rightCenterController,
              leftController: _leftCenterController,
              hintText: "اختر الدرجة",
              validator: (value) => _requiredValidator(value, "المركز"),
            ),
            _buildLensInputSection(
              title: "الحواف",
              rightController: _rightEdgesController,
              leftController: _leftEdgesController,
              hintText: "اختر الدرجة",
              validator: (value) => _requiredValidator(value, "الحواف"),
            ),

            Row(
              children: [
                // الجزء الايمن
                Expanded(
                  child: UserSelectionContainer(
                    // containerBorderColor: state.syptomTypeSelection == null
                    //     ? AppColorsManager.warningColor
                    //     : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "سطح العدسة",
                    // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                    containerHintText: "اخترالدرجة",
                    options: doctorsList,
                    onOptionSelected: (value) {
                      // log("xxx:Selected: $value");
                      // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                    },
                    // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                    bottomSheetTitle: "اخترالدرجة ",
                    searchHintText: "اخترالدرجة ",
                  ),
                ),
                horizontalSpacing(16),
                // الجزء الايسر

                Expanded(
                  child: UserSelectionContainer(
                    // containerBorderColor: state.syptomTypeSelection == null
                    //     ? AppColorsManager.warningColor
                    //     : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "سطح العدسة",
                    // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                    containerHintText: "اخترالدرجة",
                    options: doctorsList,
                    onOptionSelected: (value) {
                      // log("xxx:Selected: $value");
                      // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                    },
                    // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                    bottomSheetTitle: "اخترالدرجة ",
                    searchHintText: "اخترالدرجة ",
                  ),
                ),
              ],
            ),
            verticalSpacing(16),
            _buildLensInputSection(
              title: "سُمك العدسة",
              rightController: _rightLensThicknessController,
              leftController: _leftLensThicknessController,
              hintText: "اختر الدرجة",
              validator: (value) => _numericValidator(value, "سُمك العدسة"),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                // الجزء الايمن
                Expanded(
                  child: UserSelectionContainer(
                    // containerBorderColor: state.syptomTypeSelection == null
                    //     ? AppColorsManager.warningColor
                    //     : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "نوع العدسة",
                    // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                    containerHintText: "اخترالدرجة",
                    options: doctorsList,
                    onOptionSelected: (value) {
                      // log("xxx:Selected: $value");
                      // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                    },
                    // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                    bottomSheetTitle: "اخترالدرجة ",
                    searchHintText: "اخترالدرجة ",
                  ),
                ),
                horizontalSpacing(16),
                // الجزء الايسر

                Expanded(
                  child: UserSelectionContainer(
                    // containerBorderColor: state.syptomTypeSelection == null
                    //     ? AppColorsManager.warningColor
                    //     : AppColorsManager.textfieldOutsideBorderColor,
                    categoryLabel: "نوع العدسة",
                    // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                    containerHintText: "اخترالدرجة",
                    options: doctorsList,
                    onOptionSelected: (value) {
                      // log("xxx:Selected: $value");
                      // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                    },
                    // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                    bottomSheetTitle: "اخترالدرجة ",
                    searchHintText: "اخترالدرجة ",
                  ),
                ),
              ],
            ),

            verticalSpacing(32.h),

            AppCustomButton(
              isLoading: false,
              title: "ارسال",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print("Form is valid!");
                  // Access your data like: _rightShortSightController.text
                } else {
                  print("Form is invalid!");
                }
              },
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
