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

            verticalSpacing(10),
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
            // if (state.selectedSection != null) ...[
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
            verticalSpacing(16),
            // ],

            // Frequency Option
            if (state.selectedType != null) ...[
              Text(
                "معدل الإستخدام",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              OptionSelectorWidget(
                answersFontSize: 11.5.sp,
                options: cubit.getAvailableOptions(),
                initialSelectedOption: state.selectedOption,
                onOptionSelected: (value) {
                  cubit.updateOption(value);
                },
              ),
              verticalSpacing(16),
            ],

            // Periods List
            Text(
              "الفترات الزمنية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            if (state.periods.isNotEmpty) ...[
              ...state.periods.asMap().entries.map((entry) {
                final index = entry.key;
                final period = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColorsManager.textfieldOutsideBorderColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "من: ${period.fromDate} ${period.toDate != null ? "إلى: ${period.toDate}" : "(مستمر)"}",
                          style: AppTextStyles.font14blackWeight400,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => cubit.removePeriod(index),
                      ),
                    ],
                  ),
                );
              }),
              verticalSpacing(8),
            ],

            // Add Period Button
            if (state.periods.length < 3)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: InkWell(
                  onTap: () async {
                    await _showAddPeriodDialog(context, cubit);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColorsManager.mainDarkBlue),
                        horizontalSpacing(8),
                        Text(
                          "إضافة فترة زمنية",
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

  Future<void> _showAddPeriodDialog(
      BuildContext context, RiskyBehaviorsCubit cubit) async {
    String? fromDate;
    String? toDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("إضافة فترة زمنية"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DateTimePickerContainer(
                    placeholderText: fromDate ?? "تاريخ البدء",
                    onDateSelected: (date) {
                      setState(() {
                        fromDate = date;
                      });
                    },
                  ),
                  verticalSpacing(10),
                  DateTimePickerContainer(
                    placeholderText: toDate ?? "تاريخ الانتهاء (اختياري)",
                    onDateSelected: (date) {
                      setState(() {
                        toDate = date;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
                ),
                TextButton(
                  onPressed: fromDate == null
                      ? null
                      : () {
                          cubit.addPeriod(RiskyBehaviorPeriod(
                            fromDate: fromDate!,
                            toDate: toDate,
                          ));
                          Navigator.pop(context);
                        },
                  child: const Text("إضافة"),
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
