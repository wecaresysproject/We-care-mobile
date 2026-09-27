import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// The "important notes" info box at the bottom of the Service Prices form.
class ServicePricesNotesWidget extends StatelessWidget {
  const ServicePricesNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final notes = [
      localization.servicePricesFormNoteExaminationPaid,
      localization.servicePricesFormNoteConsultationFree,
      localization.servicePricesFormNoteValidityExpiry,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataScaffoldBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18.r,
                color: AppColorsManager.mainDarkBlue,
              ),
              horizontalSpacing(8),
              Text(
                localization.servicePricesFormNotesTitle,
                style: AppTextStyles.font16BlackSemiBold,
              ),
            ],
          ),
          verticalSpacing(12),
          for (final note in notes)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: AppTextStyles.font14blackWeight400),
                  Expanded(
                    child: Text(
                      note,
                      style: AppTextStyles.font14blackWeight400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
