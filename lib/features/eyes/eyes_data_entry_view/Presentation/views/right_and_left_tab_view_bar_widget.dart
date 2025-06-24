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

  String? _numericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة لـ $fieldName';
    }
    return null;
  }

  // New validator for Short Sight (قصر النظر): 0 to -20
  String? _shortSightRangeValidator(String? value) {
    final numericError = _numericValidator(value, "درجة قصر النظر");
    if (numericError != null) {
      return numericError;
    }
    final number = double.parse(value!);
    if (number > 0 || number < -20) {
      return 'الرقم خارج النطاق (0 إلى -20)';
    }
    return null;
  }

  // New validator for Long Sight (طول النظر): 0 to 20
  String? _longSightRangeValidator(String? value) {
    final numericError = _numericValidator(value, "درجة طول النظر");
    if (numericError != null) {
      return numericError;
    }
    final number = double.parse(value!);
    if (number < 0 || number > 20) {
      return 'الرقم خارج النطاق (0 إلى 20)';
    }
    return null;
  }

  // --- General Validation Functions for OPTIONAL fields ---
  // This validator is for numeric fields that are NOT required.
  // If a value is entered, it must be numeric. Returns null if empty (optional).
  String? _optionalNumericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Field is optional, so empty is allowed
    }
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة لـ $fieldName';
    }
    return null;
  }

  // NEW VALIDATOR FOR LENS THICKNESS (سُمك العدسة)
  String? _lensThicknessValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "سُمك العدسة", 0.5, 8.0); // New range: 0.5 to 8.0
  }

  // Validator for Astigmatism (الاستجماتزم)
  String? _astigmatismValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "درجة الاستجماتزم", -6.0, 6.0); // Range: -6.00 D to +6.00 D
  }

  // Validator for Astigmatism Axis (محور الاستجماتزم)
  String? _astigmatismAxisValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "محور الاستجماتزم", 0.0, 180.0); // Range: 0° to 180°
  }

  // Validator for Focal Addition (الاضافة البؤرية)
  String? _focalAdditionValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "الإضافة البؤرية", 0.75, 4.0); // Range: +0.75 D to +4.00 D
  }

  // Validator for Pupil Distance (تباعد الحدقتين)
  String? _pupilDistanceValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "تباعد الحدقتين", 48.0, 80.0); // Range: 48 mm to 80 mm
  }

  // Validator for Refractive Index (معامل الانكسار)
  String? _refractiveIndexValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "معامل الانكسار", 1.5, 1.74); // Range: 1.5 to 1.74
  }

  // Validator for Lens Diameter (قطر العدسة)
  String? _lensDiameterValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "قطر العدسة", 55.0, 75.0); // Range: 55 mm to 75 mm
  }

  // General helper for optional numeric fields with a range
  String? _validateOptionalNumericRange(
      String? value, String fieldName, double min, double max) {
    if (value == null || value.isEmpty) {
      return null; // Optional, so empty is fine
    }
    final numError =
        _optionalNumericValidator(value, fieldName); // Checks if it's a number
    if (numError != null) return numError;

    final number = double.parse(value);
    if (number < min || number > max) {
      return 'القيمة بين $min و $max ';
    }
    return null;
  }

  // Validator for Lens Center (المركز )
  String? _lensCenterValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "المركز", 0.5, 8); // Range: 0 mm to 20 mm
  }

  // Validator for Pupil Diameter  (سمك الحافة )
  String? _pupilDiameterValidator(String? value) {
    return _validateOptionalNumericRange(
        value, "سمك الحافة", 0.5, 8); // Range: 0 mm to 20 mm
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
                      "العدسة اليمنى",
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
              validator: (value) => _shortSightRangeValidator(
                value,
              ),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "طول النظر",
              rightController: _rightLongSightController,
              leftController: _leftLongSightController,
              hintText: "اختر الدرجة",
              validator: (value) => _longSightRangeValidator(
                value,
              ),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "الاستجماتزم",
              rightController: _rightAstigmatismController,
              leftController: _leftAstigmatismController,
              hintText: "اختر الدرجة",
              validator: (value) => _astigmatismValidator(value),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "محور الاستجماتزم",
              rightController: _rightAstigmatismAxisController,
              leftController: _leftAstigmatismAxisController,
              hintText: "اختر الدرجة",
              validator: (value) => _astigmatismAxisValidator(value),
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "الاضافة البؤرية",
              rightController: _rightFocalAdditionController,
              leftController: _leftFocalAdditionController,
              hintText: "اختر الدرجة",
              validator: _focalAdditionValidator,
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "تباعد الحدقتين",
              rightController: _rightPupilDistanceController,
              leftController: _leftPupilDistanceController,
              hintText: "اختر الدرجة",
              validator: _pupilDistanceValidator,
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "معامل الانكسار",
              rightController: _rightRefractiveIndexController,
              leftController: _leftRefractiveIndexController,
              hintText: "اختر الدرجة",
              validator: _refractiveIndexValidator,
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "قطر العدسة",
              rightController: _rightLensDiameterController,
              leftController: _leftLensDiameterController,
              hintText: "اختر الدرجة",
              validator: _lensDiameterValidator,
              keyboardType: TextInputType.number,
            ),
            _buildLensInputSection(
              title: "المركز",
              rightController: _rightCenterController,
              leftController: _leftCenterController,
              hintText: "اختر الدرجة",
              validator: _lensCenterValidator,
            ),
            _buildLensInputSection(
              title: "الحواف",
              rightController: _rightEdgesController,
              leftController: _leftEdgesController,
              hintText: "اختر الدرجة",
              validator: _pupilDiameterValidator,
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
              validator: _lensThicknessValidator,
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
                    options: [],
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
                    options: [],
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
                  // Access your data like: _rightShortSightController.text
                } else {}
              },
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
