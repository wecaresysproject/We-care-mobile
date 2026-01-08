import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';

class DayCard extends StatelessWidget {
  final String day;
  final String date;
  final String? dietPlan;
  final bool haveAdocument;
  final Color backgroundColor;
  final Function(String date)? onDateSelected;
  final Function(String date)? onDelete;
  final Function(String date)? onViewReport;
  final VoidCallback onTap;
  final bool isSelectable;
  final String? dialogTitle;

  const DayCard({
    super.key,
    required this.day,
    required this.date,
    this.dietPlan,
    this.haveAdocument = false,
    required this.onTap,
    this.backgroundColor = const Color(0xffF1F3F6),
    this.isSelectable = true,
    this.onDateSelected,
    this.onDelete,
    this.onViewReport,
    this.dialogTitle,
  });

  const DayCard.planNotActivated({
    super.key,
    this.day = 'اليوم',
    this.date = '--/--/----',
    this.dietPlan = "",
    this.backgroundColor = const Color(0xffF1F3F6),
    required this.onTap,
    this.onDateSelected,
    this.onDelete,
    this.onViewReport,
    this.dialogTitle,
  })  : haveAdocument = false,
        isSelectable = true;

  const DayCard.planActivatedandHaveDocument({
    super.key,
    required this.day,
    required this.date,
    required this.dietPlan,
    required this.onTap,
    this.backgroundColor = const Color(0xffDAE9FA),
    this.onDateSelected,
    this.onDelete,
    this.onViewReport,
    this.dialogTitle,
  })  : haveAdocument = true,
        isSelectable = false;

  const DayCard.planActivatedandHaveNoDocument({
    super.key,
    required this.day,
    required this.date,
    this.dietPlan,
    required this.onTap,
    this.dialogTitle,
    this.backgroundColor = const Color(0xffF1F3F6),
    this.onDateSelected,
    this.onDelete,
    this.onViewReport,
  })  : haveAdocument = false,
        isSelectable = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!isSelectable && haveAdocument) {
          // إظهار رسالة تحذير للأيام التي لها تقرير بالفعل
          await showWarningDialog(
            context,
            message: dialogTitle ?? 'هذا اليوم مدخل فيه مكملاتك بالفعل',
            onConfirm: () async {
              if (onViewReport != null) {
                onViewReport!(date);
                return;
              }
              await context.pushNamed(
                Routes.supplementsReportTableView,
                arguments: {
                  "date": date,
                },
              );
            },
            confirmText: "الذهاب لمتابعة تقرير اليوم",
            hasDelete: true,
            onDelete: () {
              if (onDelete != null) {
                onDelete!(date);
                return;
              }
              context
                  .read<SupplementsDataEntryCubit>()
                  .deleteSubmittedSupplementOnSpecificDate(date)
                  .then(
                (result) {
                  showSuccess("تم حذف المكملات بنجاح");
                  if (!context.mounted) return;
                  context.read<SupplementsDataEntryCubit>().loadExistingPlans();
                },
              );
            },
          );

          return;
        }

        onTap();
        if (onDateSelected != null) {
          onDateSelected!(date);
        } else {
          // Fallback to Cubit if callback not provided, but wrap in try-catch or check
          try {
            context
                .read<NutrationDataEntryCubit>()
                .updateSelectedPlanDate(date);
          } catch (e) {
            // Ignore if Cubit not found (e.g. in Supplements view)
          }
        }
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            width: backgroundColor == Color(0xffDAE9FA) ? 1.5 : 1,
            color: backgroundColor == Color(0xffDAE9FA)
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            verticalSpacing(8),
            Text(
              date,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            //  verticalSpacing(6),
            haveAdocument
                ? Container(
                    width: 69.w,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsManager.mainDarkBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            AppLogger.debug(
                                'xxx: View Report tapped for date: $date');
                            // await context.pushNamed(
                            //   Routes.nutritionFollowUpReportTableView,
                            //   arguments: date,
                            // );
                          },
                          child: const Icon(
                            Icons.file_present,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        horizontalSpacing(4),
                        Text(
                          'التقرير',
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
