import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/eyes_module_validator_class.dart';
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
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/glasses.png",
                    height: 100.h,
                  ),
                  verticalSpacing(16.h),

                  // Header
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

                  verticalSpacing(16.h),
                  Form(
                    key: cubit.formKey,
                    child: Column(
                      children: [
                        // Input Sections
                        LeftAndRightLensRowDataSection(
                          title: "قصر النظر",
                          rightController: cubit.rightShortSightController,
                          leftController: cubit.leftShortSightController,
                          hintText: "اختر الدرجة",
                          validator: EyeModuleValidations.shortSightValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "طول النظر",
                          rightController: cubit.rightLongSightController,
                          leftController: cubit.leftLongSightController,
                          hintText: "اختر الدرجة",
                          validator: EyeModuleValidations.longSightValidator,
                          keyboardType: TextInputType.number,
                        ),

                        LeftAndRightLensRowDataSection(
                          title: "الاستجماتزم",
                          rightController: cubit.rightAstigmatismController,
                          leftController: cubit.leftAstigmatismController,
                          hintText: "اختر الدرجة",
                          validator: EyeModuleValidations.astigmatismValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "محور الاستجماتزم",
                          rightController: cubit.rightAstigmatismAxisController,
                          leftController: cubit.leftAstigmatismAxisController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.astigmatismAxisValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "الاضافة البؤرية",
                          rightController: cubit.rightFocalAdditionController,
                          leftController: cubit.leftFocalAdditionController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.focalAdditionValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "تباعد الحدقتين",
                          rightController: cubit.rightPupilDistanceController,
                          leftController: cubit.leftPupilDistanceController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.pupilDistanceValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "معامل الانكسار",
                          rightController: cubit.rightRefractiveIndexController,
                          leftController: cubit.leftRefractiveIndexController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.refractiveIndexValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "قطر العدسة",
                          rightController: cubit.rightLensDiameterController,
                          leftController: cubit.leftLensDiameterController,
                          hintText: "اختر الدرجة",
                          validator: EyeModuleValidations.lensDiameterValidator,
                          keyboardType: TextInputType.number,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "المركز",
                          rightController: cubit.rightCenterController,
                          leftController: cubit.leftCenterController,
                          hintText: "اختر الدرجة",
                          validator: EyeModuleValidations.lensCenterValidator,
                        ),
                        LeftAndRightLensRowDataSection(
                          title: "الحواف",
                          rightController: cubit.rightEdgesController,
                          leftController: cubit.leftEdgesController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.pupilDiameterValidator,
                        ),

                        // Surface Type Selectors
                        Row(
                          children: [
                            // الجزء الايمن
                            Expanded(
                              child: UserSelectionContainer(
                                categoryLabel: "سطح العدسة",
                                containerHintText:
                                    state.rightlensSurfaceType ?? "اخترالدرجة",
                                options: state.lensSurfcacesTypes,
                                onOptionSelected: (value) {
                                  context
                                      .read<GlassesDataEntryCubit>()
                                      .updateRightlensSurfaceType(value);
                                },
                                bottomSheetTitle: "اخترالدرجة ",
                                searchHintText: "اخترالدرجة ",
                              ),
                            ),
                            horizontalSpacing(16),
                            // الجزء الايسر

                            Expanded(
                              child: UserSelectionContainer(
                                categoryLabel: "سطح العدسة",
                                containerHintText:
                                    state.leftLensSurfaceType ?? "اخترالدرجة",
                                options: state.lensSurfcacesTypes,
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
                        verticalSpacing(16.h),

                        LeftAndRightLensRowDataSection(
                          title: "سُمك العدسة",
                          rightController: cubit.rightLensThicknessController,
                          leftController: cubit.leftLensThicknessController,
                          hintText: "اختر الدرجة",
                          validator:
                              EyeModuleValidations.lensThicknessValidator,
                          keyboardType: TextInputType.number,
                        ),

                        Row(
                          children: [
                            // الجزء الايمن
                            Expanded(
                              child: UserSelectionContainer(
                                categoryLabel: "نوع العدسة",
                                containerHintText:
                                    state.rightLensType ?? "اخترالدرجة",
                                options: state.lensTypes,
                                onOptionSelected: (value) {
                                  context
                                      .read<GlassesDataEntryCubit>()
                                      .updateRightLensType(value);
                                },
                                bottomSheetTitle: "اخترالدرجة ",
                                searchHintText: "اخترالدرجة ",
                              ),
                            ),
                            horizontalSpacing(16),
                            // الجزء الايسر

                            Expanded(
                              child: UserSelectionContainer(
                                categoryLabel: "نوع العدسة",
                                containerHintText:
                                    state.leftLensType ?? "اخترالدرجة",
                                options: state.lensTypes,
                                onOptionSelected: (value) {
                                  context
                                      .read<GlassesDataEntryCubit>()
                                      .updateLeftLensType(value);
                                },
                                bottomSheetTitle: "اخترالدرجة ",
                                searchHintText: "اخترالدرجة ",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  verticalSpacing(32.h),

                  submitDataEnteredButtonBlocConsumer(),
                ],
              ),
            ),
          ],
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
              if (state.isEditMode) {
                await context
                    .read<GlassesDataEntryCubit>()
                    .submitEditGlassesDataEntered(
                      context.translate,
                    );
                return;
              }
              await context
                  .read<GlassesDataEntryCubit>()
                  .submitGlassesLensDataEntered(
                    locale: context.translate,
                  );
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
}
