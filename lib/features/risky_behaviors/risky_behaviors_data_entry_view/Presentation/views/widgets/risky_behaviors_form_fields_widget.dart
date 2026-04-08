import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/logic/cubit/risky_behaviors_state.dart';

import '../../../../logic/cubit/risky_behaviors_cubit.dart';

class RiskyBehaviorsFormFieldsWidget extends StatelessWidget {
  const RiskyBehaviorsFormFieldsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskyBehaviorsCubit, RiskyBehaviorsState>(
      builder: (context, state) {
        final cubit = context.read<RiskyBehaviorsCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Selection
            verticalSpacing(20),
            UserSelectionContainer(
              containerBorderColor: state.selectedSection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "القسم",
              containerHintText: state.selectedSection ?? "اختر القسم",
              options: cubit.sections,
              onOptionSelected: (value) {
                cubit.updateSection(value);
              },
              bottomSheetTitle: 'اختر القسم',
              searchHintText: 'ابحث عن القسم',
            ),
            verticalSpacing(16),

            // Type Selection
            UserSelectionContainer(
              containerBorderColor: state.selectedType == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "النوع",
              containerHintText: state.selectedType ?? "اختر النوع",
              options: cubit.getAvailableTypes(),
              onOptionSelected: (value) {
                cubit.updateType(value);
              },
              bottomSheetTitle: 'اختر النوع',
              searchHintText: 'ابحث عن النوع',
            ),
            verticalSpacing(24),

            // Registered Records Section
            Text(
              "الحالات المسجلة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            if (state.records.isNotEmpty) ...[
              ...state.records.asMap().entries.map((entry) {
                final index = entry.key;
                final record = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color:
                        AppColorsManager.textfieldInsideColor.withOpacity(0.3),
                    border: Border.all(
                        color: AppColorsManager.textfieldOutsideBorderColor),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          record.option,
                          style: AppTextStyles.font14BlueWeight700
                              .copyWith(fontSize: 12.sp),
                        ),
                      ),
                      horizontalSpacing(12),
                      Expanded(
                        child: Text(
                          "${record.period.fromDate} ${record.period.toDate != null ? "→ ${record.period.toDate}" : "(مستمر)"}",
                          style: AppTextStyles.font14blackWeight400,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => cubit.removeRecord(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),
              verticalSpacing(8),
            ],

            // Add New Record Button
            if (state.records.length < 3 && state.selectedType != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: InkWell(
                  onTap: () async {
                    await _showAddRecordDialog(context, cubit);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: AppColorsManager.mainDarkBlue),
                        horizontalSpacing(8),
                        Text(
                          "إضافة حالة جديدة",
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            color: AppColorsManager.mainDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            verticalSpacing(16),

            // Drug Interaction Integration Checkbox
            InkWell(
              onTap: () {
                cubit.toggleAttachToDrugInteractionModules(
                    !state.attachToDrugInteractionModules);
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Checkbox(
                      value: state.attachToDrugInteractionModules,
                      onChanged: (value) {
                        cubit.toggleAttachToDrugInteractionModules(value);
                      },
                      activeColor: AppColorsManager.mainDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  horizontalSpacing(10),
                  Expanded(
                    child: Text(
                      "هل تريد إضافة البيانات المدخلة لموديولز توافق أدويتي وتوافق دواء جديد؟",
                      style: AppTextStyles.font14blackWeight400,
                    ),
                  ),
                ],
              ),
            ),

            verticalSpacing(40),

            // Submit Button
            _buildSubmitButton(),
          ],
        );
      },
    );
  }

  Future<void> _showAddRecordDialog(
      BuildContext context, RiskyBehaviorsCubit cubit) async {
    String? selectedOption;
    String? fromDate;
    String? toDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              title: Text(
                "إضافة حالة جديدة",
                textAlign: TextAlign.center,
                style: AppTextStyles.font18blackWight500,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "معدل الإستخدام",
                      style: AppTextStyles.font14blackWeight400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpacing(10),
                    OptionSelectorWidget(
                      answersFontSize: 11.sp,
                      options: cubit.getAvailableOptions(),
                      initialSelectedOption: selectedOption,
                      onOptionSelected: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    verticalSpacing(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الفترة الزمنية",
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: toDate == null,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    toDate = null;
                                  } else {
                                    // Set a default if unchecking "Currently"
                                    toDate = DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0];
                                  }
                                });
                              },
                              activeColor: AppColorsManager.mainDarkBlue,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Text(
                              "مستمر",
                              style: AppTextStyles.font14blackWeight400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpacing(10),
                    DateTimePickerContainer(
                      placeholderText: fromDate ?? "تاريخ البدء",
                      onDateSelected: (date) {
                        setState(() {
                          fromDate = date;
                        });
                      },
                    ),
                    if (toDate != null ||
                        (toDate == null &&
                            false)) // Logic to show if not "currently"
                      verticalSpacing(10),
                    if (toDate != null)
                      DateTimePickerContainer(
                        placeholderText: toDate ?? "تاريخ الانتهاء",
                        onDateSelected: (date) {
                          setState(() {
                            toDate = date;
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إلغاء",
                    style: AppTextStyles.font14blackWeight400
                        .copyWith(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: (selectedOption == null || fromDate == null)
                      ? null
                      : () {
                          cubit.addRecord(
                            BehaviorRecord(
                              option: selectedOption!,
                              period: RiskyBehaviorPeriod(
                                fromDate: fromDate!,
                                toDate: toDate,
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        },
                  child: Text(
                    "إضافة",
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: (selectedOption == null || fromDate == null)
                          ? Colors.grey
                          : AppColorsManager.mainDarkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<RiskyBehaviorsCubit, RiskyBehaviorsState>(
      listener: (context, state) {
        if (state.status == RequestStatus.success) {
          showSuccess(state.message);
          context.pop(result: true);
        } else if (state.status == RequestStatus.failure) {
          showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.status == RequestStatus.loading,
          isEnabled: state.isFormValidated,
          title: state.isEditMode ? "تحديث البيانات" : "حفظ",
          onPressed: () => context.read<RiskyBehaviorsCubit>().submit(),
        );
      },
    );
  }
}
