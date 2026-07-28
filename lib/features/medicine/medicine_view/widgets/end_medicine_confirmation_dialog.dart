import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Confirms ending a medicine and collects the medicine end date.
///
/// Returns the picked date as 'yyyy-MM-dd', or null when the user cancels or
/// dismisses the dialog (in which case nothing should happen).
///
/// The end date cannot be in the future — [DateTimePickerContainer] already
/// clamps its `lastDate` to today — and cannot be before [medicineStartDate].
Future<String?> showEndMedicineConfirmationDialog({
  required BuildContext context,
  required String medicineName,
  String? medicineStartDate,
}) {
  String? pickedEndDate;
  String? validationError;

  //* startDate may hold the app's "لم يتم ادخال بيانات" sentinel instead of a date,
  //* in which case the "end >= start" rule is skipped rather than blocking the user.
  final hasValidStartDate = medicineStartDate != null &&
      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(medicineStartDate);

  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              "تأكيد إنهاء الدواء",
              textAlign: TextAlign.center,
              style: AppTextStyles.font18blackWight500,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سيتم إنهاء "$medicineName" وإلغاء التنبيهات الخاصة به.',
                    style: AppTextStyles.font14blackWeight400,
                  ),
                  verticalSpacing(16),
                  Text(
                    "تاريخ انتهاء الدواء",
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalSpacing(10),
                  DateTimePickerContainer(
                    placeholderText: pickedEndDate ?? "يوم / شهر / سنة",
                    //* deliberately Colors.red and not AppColorsManager.warningColor:
                    //* the picker appends its own "required field" text for that exact
                    //* color, which would duplicate the message shown below
                    containerBorderColor: validationError == null
                        ? AppColorsManager.textfieldOutsideBorderColor
                        : Colors.red,
                    onDateSelected: (date) {
                      setState(
                        () {
                          //* both dates are yyyy-MM-dd, so comparing the strings
                          //* is a correct chronological comparison
                          if (hasValidStartDate &&
                              date.compareTo(medicineStartDate) < 0) {
                            pickedEndDate = null;
                            validationError =
                                "تاريخ الانتهاء يجب ألا يكون قبل تاريخ بدء الدواء ($medicineStartDate)";
                          } else {
                            pickedEndDate = date;
                            validationError = null;
                          }
                        },
                      );
                    },
                  ),
                  if (validationError != null) ...[
                    verticalSpacing(8),
                    Text(
                      validationError!,
                      style: AppTextStyles.font14blackWeight400.copyWith(
                        color: AppColorsManager.warningColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "إلغاء",
                  style: AppTextStyles.font14blackWeight400
                      .copyWith(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsManager.mainDarkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: pickedEndDate == null
                    ? null
                    : () => Navigator.pop(dialogContext, pickedEndDate),
                child: Text(
                  "تأكيد",
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: Colors.white,
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
