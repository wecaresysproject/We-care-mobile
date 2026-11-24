import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_multiline_text_field.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_sheet_header_widget.dart';

/// Bottom sheet where the doctor writes a medicine or an examination by
/// hand. Pops with the [PrescriptionManualEntryModel], or null when
/// dismissed.
class PrescriptionManualEntrySheet extends StatefulWidget {
  const PrescriptionManualEntrySheet({
    super.key,
    required this.addTitle,
    required this.editTitle,
    required this.fieldLabel,
    required this.hintText,
    this.initialEntry,
  });

  /// "إضافة دواء يدويًا" / "تعديل الدواء"
  final String addTitle;
  final String editTitle;

  /// "تفاصيل الدواء"
  final String fieldLabel;
  final String hintText;
  final PrescriptionManualEntryModel? initialEntry;

  static Future<PrescriptionManualEntryModel?> show(
    BuildContext context, {
    required String addTitle,
    required String editTitle,
    required String fieldLabel,
    required String hintText,
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return showModalBottomSheet<PrescriptionManualEntryModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => PrescriptionManualEntrySheet(
        addTitle: addTitle,
        editTitle: editTitle,
        fieldLabel: fieldLabel,
        hintText: hintText,
        initialEntry: initialEntry,
      ),
    );
  }

  @override
  State<PrescriptionManualEntrySheet> createState() =>
      _PrescriptionManualEntrySheetState();
}

class _PrescriptionManualEntrySheetState
    extends State<PrescriptionManualEntrySheet> {
  late final TextEditingController _detailsController =
      TextEditingController(text: widget.initialEntry?.details);

  bool get _isEditMode => widget.initialEntry != null;

  bool get _canSubmit => _detailsController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) return;
    Navigator.of(context).pop(
      PrescriptionManualEntryModel(details: _detailsController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrescriptionSheetHeaderWidget(
              title: _isEditMode ? widget.editTitle : widget.addTitle,
              icon: Icons.edit_note_outlined,
            ),
            verticalSpacing(20),
            Text(widget.fieldLabel, style: AppTextStyles.font18blackWight500),
            verticalSpacing(10),
            PrescriptionMultilineTextField(
              controller: _detailsController,
              hintText: widget.hintText,
              minLines: 4,
              maxLines: 8,
              onChanged: (_) => setState(() {}),
            ),
            verticalSpacing(28),
            AppCustomButton(
              title: _isEditMode ? "حفظ التعديلات" : "إضافة للروشتة",
              textFontSize: 18,
              isEnabled: _canSubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
