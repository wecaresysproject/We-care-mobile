import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart'; // Ensure this path is correct
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart'; // Ensure this path is correct
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/right_and_left_lens_row_data_section_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/glasses_data_entry_cubit.dart'; // Ensure this path is correct

class RightAndLeftLensTabBarView extends StatelessWidget {
  const RightAndLeftLensTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlassesDataEntryCubit, GlassesDataEntryState>(
      builder: (context, state) {
        final cubit = context.read<GlassesDataEntryCubit>();
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 52.h),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/glasses.png", height: 100.h),
                verticalSpacing(16.h),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("العدسة اليمنى",
                            style: AppTextStyles.font18blackWight500.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                            )),
                      ),
                      horizontalSpacing(16.w),
                      Expanded(
                        child: Text("العدسة اليسارية",
                            textAlign: TextAlign.end,
                            style: AppTextStyles.font18blackWight500.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                            )),
                      ),
                    ],
                  ),
                ),

                verticalSpacing(16.h),

                // Input Sections
                LeftAndRightLensRowDataSection(
                  title: "قصر النظر",
                  rightController: cubit.rightShortSightController,
                  leftController: cubit.leftShortSightController,
                  hintText: "اختر الدرجة",
                  validator: _shortSightRangeValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "طول النظر",
                  rightController: cubit.rightLongSightController,
                  leftController: cubit.leftLongSightController,
                  hintText: "اختر الدرجة",
                  validator: _longSightRangeValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "الاستجماتزم",
                  rightController: cubit.rightAstigmatismController,
                  leftController: cubit.leftAstigmatismController,
                  hintText: "اختر الدرجة",
                  validator: _astigmatismValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "محور الاستجماتزم",
                  rightController: cubit.rightAstigmatismAxisController,
                  leftController: cubit.leftAstigmatismAxisController,
                  hintText: "اختر الدرجة",
                  validator: _astigmatismAxisValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "الاضافة البؤرية",
                  rightController: cubit.rightFocalAdditionController,
                  leftController: cubit.leftFocalAdditionController,
                  hintText: "اختر الدرجة",
                  validator: _focalAdditionValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "تباعد الحدقتين",
                  rightController: cubit.rightPupilDistanceController,
                  leftController: cubit.leftPupilDistanceController,
                  hintText: "اختر الدرجة",
                  validator: _pupilDistanceValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "معامل الانكسار",
                  rightController: cubit.rightRefractiveIndexController,
                  leftController: cubit.leftRefractiveIndexController,
                  hintText: "اختر الدرجة",
                  validator: _refractiveIndexValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "قطر العدسة",
                  rightController: cubit.rightLensDiameterController,
                  leftController: cubit.leftLensDiameterController,
                  hintText: "اختر الدرجة",
                  validator: _lensDiameterValidator,
                  keyboardType: TextInputType.number,
                ),
                LeftAndRightLensRowDataSection(
                  title: "المركز",
                  rightController: cubit.rightCenterController,
                  leftController: cubit.leftCenterController,
                  hintText: "اختر الدرجة",
                  validator: _lensCenterValidator,
                ),
                LeftAndRightLensRowDataSection(
                  title: "الحواف",
                  rightController: cubit.rightEdgesController,
                  leftController: cubit.leftEdgesController,
                  hintText: "اختر الدرجة",
                  validator: _pupilDiameterValidator,
                ),

                // Surface Type Selectors
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

                LeftAndRightLensRowDataSection(
                  title: "سُمك العدسة",
                  rightController: cubit.rightLensThicknessController,
                  leftController: cubit.leftLensThicknessController,
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

  String? _numericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال هذه القيمه';
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
}
