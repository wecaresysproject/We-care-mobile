import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// How the doctor adds a row (medicine, examination) to the prescription.
enum PrescriptionEntryType {
  /// From the module's lists — e.g. medicine name, form, amount, ...
  fromList,

  /// Written by hand as free text.
  manual,
}

/// Asks the doctor how to add the row: from the lists or by hand. Pops with
/// the chosen [PrescriptionEntryType], or null when dismissed.
class PrescriptionAddEntryOptionsSheet extends StatelessWidget {
  const PrescriptionAddEntryOptionsSheet({
    super.key,
    required this.title,
    required this.fromListTitle,
    required this.fromListSubtitle,
    required this.manualSubtitle,
  });

  /// "إضافة دواء"
  final String title;

  /// "اختيار من قائمة الأدوية"
  final String fromListTitle;
  final String fromListSubtitle;

  /// "اكتب تفاصيل الدواء بنفسك كنص"
  final String manualSubtitle;

  static Future<PrescriptionEntryType?> show(
    BuildContext context, {
    required String title,
    required String fromListTitle,
    required String fromListSubtitle,
    required String manualSubtitle,
  }) {
    return showModalBottomSheet<PrescriptionEntryType>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => PrescriptionAddEntryOptionsSheet(
        title: title,
        fromListTitle: fromListTitle,
        fromListSubtitle: fromListSubtitle,
        manualSubtitle: manualSubtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrescriptionSheetHeaderWidget(title: title),
          verticalSpacing(16),
          PrescriptionOptionTileWidget(
            icon: Icons.list_alt_outlined,
            title: fromListTitle,
            subtitle: fromListSubtitle,
            onTap: () =>
                Navigator.of(context).pop(PrescriptionEntryType.fromList),
          ),
          verticalSpacing(12),
          PrescriptionOptionTileWidget(
            icon: Icons.edit_note_outlined,
            title: "كتابة يدوية",
            subtitle: manualSubtitle,
            onTap: () =>
                Navigator.of(context).pop(PrescriptionEntryType.manual),
          ),
        ],
      ),
    );
  }
}

/// A tappable option row: icon, title and subtitle.
class PrescriptionOptionTileWidget extends StatelessWidget {
  const PrescriptionOptionTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColorsManager.prescriptionCardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColorsManager.prescriptionEditActionBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 22.r,
                  color: AppColorsManager.prescriptionActionBlue,
                ),
              ),
              horizontalSpacing(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        color: AppColorsManager.prescriptionTitleColor,
                      ),
                    ),
                    verticalSpacing(2),
                    Text(
                      subtitle,
                      style: AppTextStyles.font13GreyWeight400.copyWith(
                        color: AppColorsManager.prescriptionSubtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.r,
                color: AppColorsManager.prescriptionSubtitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
