import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart'; // Ensure this path is correct
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart'; // Ensure this path is correct
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart'; // Ensure this path is correct
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/glasses_data_entry_cubit.dart'; // Ensure this path is correct

class RightAndLeftLensTabBarView extends StatefulWidget {
  const RightAndLeftLensTabBarView({super.key});

  @override
  State<RightAndLeftLensTabBarView> createState() =>
      _RightAndLeftLensTabBarViewState();
}

class _RightAndLeftLensTabBarViewState
    extends State<RightAndLeftLensTabBarView> {
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
      return 'من 0 إلى 20- فقط';
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
      return 'من 0 إلى 20 فقط';
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
    return BlocBuilder<GlassesDataEntryCubit, GlassesDataEntryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(bottom: 52.h),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: context.read<GlassesDataEntryCubit>().formKey,
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
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightShortSightController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftShortSightController,
                  hintText: "اختر الدرجة",
                  validator: (value) => _shortSightRangeValidator(
                    value,
                  ),
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "طول النظر",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightLongSightController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftLongSightController,
                  hintText: "اختر الدرجة",
                  validator: (value) => _longSightRangeValidator(
                    value,
                  ),
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "الاستجماتزم",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightAstigmatismController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftAstigmatismController,
                  hintText: "اختر الدرجة",
                  validator: (value) => _astigmatismValidator(value),
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "محور الاستجماتزم",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightAstigmatismAxisController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftAstigmatismAxisController,
                  hintText: "اختر الدرجة",
                  validator: (value) => _astigmatismAxisValidator(value),
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "الاضافة البؤرية",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightFocalAdditionController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftFocalAdditionController,
                  hintText: "اختر الدرجة",
                  validator: _focalAdditionValidator,
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "تباعد الحدقتين",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightPupilDistanceController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftPupilDistanceController,
                  hintText: "اختر الدرجة",
                  validator: _pupilDistanceValidator,
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "معامل الانكسار",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightRefractiveIndexController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftRefractiveIndexController,
                  hintText: "اختر الدرجة",
                  validator: _refractiveIndexValidator,
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "قطر العدسة",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightLensDiameterController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftLensDiameterController,
                  hintText: "اختر الدرجة",
                  validator: _lensDiameterValidator,
                  keyboardType: TextInputType.number,
                ),
                _buildLensInputSection(
                  title: "المركز",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightCenterController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftCenterController,
                  hintText: "اختر الدرجة",
                  validator: _lensCenterValidator,
                ),
                _buildLensInputSection(
                  title: "الحواف",
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightEdgesController,
                  leftController:
                      context.read<GlassesDataEntryCubit>().leftEdgesController,
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
                        containerHintText:
                            state.rightlensSurfaceType ?? "اخترالدرجة",
                        options: [],
                        onOptionSelected: (value) {
                          context
                              .read<GlassesDataEntryCubit>()
                              .updateRightlensSurfaceType(value);
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
                        containerHintText:
                            state.leftLensSurfaceType ?? "اخترالدرجة",
                        options: [],
                        onOptionSelected: (value) {
                          context
                              .read<GlassesDataEntryCubit>()
                              .updateLeftlensSurfaceType(value);
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
                  rightController: context
                      .read<GlassesDataEntryCubit>()
                      .rightLensThicknessController,
                  leftController: context
                      .read<GlassesDataEntryCubit>()
                      .leftLensThicknessController,
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
                        containerHintText: state.rightLensType ?? "اخترالدرجة",
                        options: [],
                        onOptionSelected: (value) {
                          context
                              .read<GlassesDataEntryCubit>()
                              .updateRightLensType(value);
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
                        containerHintText: state.leftLensType ?? "اخترالدرجة",
                        options: [],
                        onOptionSelected: (value) {
                          context
                              .read<GlassesDataEntryCubit>()
                              .updateLeftLensType(value);
                        },
                        // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                        bottomSheetTitle: "اخترالدرجة ",
                        searchHintText: "اخترالدرجة ",
                      ),
                    ),
                  ],
                ),

                verticalSpacing(32.h),

                submitDataEnteredButtonBlocConsumer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget submitDataEnteredButtonBlocConsumer() {
  return BlocConsumer<GlassesDataEntryCubit, GlassesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.submitGlassesLensDataEntryStatus == RequestStatus.failure ||
        curr.submitGlassesLensDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.submitGlassesLensDataEntryStatus !=
            curr.submitGlassesLensDataEntryStatus,
    listener: (context, state) async {
      if (state.submitGlassesLensDataEntryStatus == RequestStatus.success) {
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
            state.submitGlassesLensDataEntryStatus == RequestStatus.loading,
        title: context.translate.send,
        onPressed: () async {
          if (context
              .read<GlassesDataEntryCubit>()
              .formKey
              .currentState!
              .validate()) {
            await context
                .read<GlassesDataEntryCubit>()
                .submitGlassesLensDataEntered();
          } else {
            await showError(
                "يرجى ملء الحقول الأساسية المطلوبة لإتمام العملية.");
          }
        },
        isEnabled: true,
      );
    },
  );
}
