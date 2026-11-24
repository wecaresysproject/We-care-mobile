import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_add_entry_options_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// The kinds of examination the doctor can add.
enum PrescriptionExaminationType {
  xRay(
    title: "أشعة",
    subtitle: "من قائمة الأشعة أو كتابة يدوية",
    icon: Icons.medical_information_outlined,
  ),
  labTest(
    title: "تحاليل",
    subtitle: "من قائمة التحاليل أو كتابة يدوية",
    icon: Icons.bloodtype_outlined,
  ),
  endoscopy(
    title: "مناظير",
    subtitle: "اكتب تفاصيل المنظار كنص",
    icon: Icons.edit_note_outlined,
  ),
  additional(
    title: "فحوصات إضافية",
    subtitle: "اكتب تفاصيل الفحص كنص",
    icon: Icons.note_add_outlined,
  );

  const PrescriptionExaminationType({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

/// Asks the doctor which kind of examination to add. Pops with the chosen
/// [PrescriptionExaminationType], or null when dismissed.
class PrescriptionExaminationTypeSheet extends StatelessWidget {
  const PrescriptionExaminationTypeSheet({super.key});

  static Future<PrescriptionExaminationType?> show(BuildContext context) {
    return showModalBottomSheet<PrescriptionExaminationType>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => const PrescriptionExaminationTypeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PrescriptionSheetHeaderWidget(
            title: "إضافة فحص",
            icon: Icons.science_outlined,
          ),
          verticalSpacing(16),
          for (final type in PrescriptionExaminationType.values) ...[
            PrescriptionOptionTileWidget(
              icon: type.icon,
              title: type.title,
              subtitle: type.subtitle,
              onTap: () => Navigator.of(context).pop(type),
            ),
            if (type != PrescriptionExaminationType.values.last)
              verticalSpacing(12),
          ],
        ],
      ),
    );
  }
}
