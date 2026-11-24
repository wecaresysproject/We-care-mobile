import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_add_entry_options_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_examination_type_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_lab_test_form_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_lab_tests_table_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_manual_entries_table_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_manual_entry_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_section_card_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_table_cells_widget.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_xray_form_sheet.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_xrays_table_widget.dart';

/// Section "2 الفحوصات": one table per examination kind — الأشعة (from the
/// lists or by hand, like the medicines), التحاليل (the same),
/// المناظير and فحوصات إضافية as text — and the total count.
class PrescriptionExaminationsSectionWidget extends StatelessWidget {
  const PrescriptionExaminationsSectionWidget({super.key});

  Future<PrescriptionManualEntryModel?> _showManualXRaySheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة أشعة يدويًا",
      editTitle: "تعديل الأشعة",
      fieldLabel: "تفاصيل الأشعة",
      hintText: "مثال: أشعة سينية على الصدر — وضع أمامي",
      initialEntry: initialEntry,
    );
  }

  /// Same question as the medicines: from the X-ray lists or by hand.
  Future<void> _addXRay(
    BuildContext context,
    DoctorPrescriptionCubit cubit,
  ) async {
    final entryType = await PrescriptionAddEntryOptionsSheet.show(
      context,
      title: "إضافة أشعة",
      fromListTitle: "اختيار من قائمة الأشعة",
      fromListSubtitle: "اختر منطقة الأشعة ونوعها ونوعية الاحتياج",
      manualSubtitle: "اكتب تفاصيل الأشعة بنفسك كنص",
    );
    if (entryType == null || !context.mounted) return;

    switch (entryType) {
      case PrescriptionEntryType.fromList:
        final xRay = await PrescriptionXRayFormSheet.show(context);
        if (xRay != null) cubit.addXRay(xRay);
      case PrescriptionEntryType.manual:
        final xRay = await _showManualXRaySheet(context);
        if (xRay != null) cubit.addManualXRay(xRay);
    }
  }

  Future<PrescriptionManualEntryModel?> _showManualLabTestSheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة تحليل يدويًا",
      editTitle: "تعديل التحليل",
      fieldLabel: "تفاصيل التحليل",
      hintText: "مثال: CBC (صورة دم كاملة) — صائم",
      initialEntry: initialEntry,
    );
  }

  /// Same question as the medicines: from the lab tests lists or by hand.
  Future<void> _addLabTest(
    BuildContext context,
    DoctorPrescriptionCubit cubit,
  ) async {
    final entryType = await PrescriptionAddEntryOptionsSheet.show(
      context,
      title: "إضافة تحليل",
      fromListTitle: "اختيار من قائمة التحاليل",
      fromListSubtitle: "اختر مجموعة التحاليل أو اسم التحليل",
      manualSubtitle: "اكتب تفاصيل التحليل بنفسك كنص",
    );
    if (entryType == null || !context.mounted) return;

    switch (entryType) {
      case PrescriptionEntryType.fromList:
        final labTest = await PrescriptionLabTestFormSheet.show(context);
        if (labTest != null) cubit.addLabTest(labTest);
      case PrescriptionEntryType.manual:
        final labTest = await _showManualLabTestSheet(context);
        if (labTest != null) cubit.addManualLabTest(labTest);
    }
  }

  Future<PrescriptionManualEntryModel?> _showEndoscopySheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة منظار",
      editTitle: "تعديل المنظار",
      fieldLabel: "تفاصيل المنظار",
      hintText: "مثال: منظار معدة علوي — صائم 8 ساعات",
      initialEntry: initialEntry,
    );
  }

  Future<PrescriptionManualEntryModel?> _showAdditionalSheet(
    BuildContext context, {
    PrescriptionManualEntryModel? initialEntry,
  }) {
    return PrescriptionManualEntrySheet.show(
      context,
      addTitle: "إضافة فحص إضافي",
      editTitle: "تعديل الفحص",
      fieldLabel: "تفاصيل الفحص",
      hintText: "مثال: رسم قلب ECG",
      initialEntry: initialEntry,
    );
  }

  /// Asks the examination kind first, then opens its sheet.
  Future<void> _addExamination(BuildContext context) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final type = await PrescriptionExaminationTypeSheet.show(context);
    if (type == null || !context.mounted) return;

    switch (type) {
      case PrescriptionExaminationType.xRay:
        await _addXRay(context, cubit);
      case PrescriptionExaminationType.labTest:
        await _addLabTest(context, cubit);
      case PrescriptionExaminationType.endoscopy:
        final endoscopy = await _showEndoscopySheet(context);
        if (endoscopy != null) cubit.addEndoscopy(endoscopy);
      case PrescriptionExaminationType.additional:
        final examination = await _showAdditionalSheet(context);
        if (examination != null) cubit.addAdditionalExamination(examination);
    }
  }

  Future<void> _editXRay(
    BuildContext context,
    int index,
    PrescriptionXRayModel xRay,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited =
        await PrescriptionXRayFormSheet.show(context, initialXRay: xRay);
    if (edited != null) cubit.updateXRay(index, edited);
  }

  Future<void> _editManualXRay(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel xRay,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await _showManualXRaySheet(context, initialEntry: xRay);
    if (edited != null) cubit.updateManualXRay(index, edited);
  }

  Future<void> _editLabTest(
    BuildContext context,
    int index,
    PrescriptionLabTestModel labTest,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await PrescriptionLabTestFormSheet.show(
      context,
      initialLabTest: labTest,
    );
    if (edited != null) cubit.updateLabTest(index, edited);
  }

  Future<void> _editManualLabTest(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel labTest,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited =
        await _showManualLabTestSheet(context, initialEntry: labTest);
    if (edited != null) cubit.updateManualLabTest(index, edited);
  }

  Future<void> _editEndoscopy(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel endoscopy,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited = await _showEndoscopySheet(context, initialEntry: endoscopy);
    if (edited != null) cubit.updateEndoscopy(index, edited);
  }

  Future<void> _editAdditional(
    BuildContext context,
    int index,
    PrescriptionManualEntryModel examination,
  ) async {
    final cubit = context.read<DoctorPrescriptionCubit>();
    final edited =
        await _showAdditionalSheet(context, initialEntry: examination);
    if (edited != null) cubit.updateAdditionalExamination(index, edited);
  }

  /// Confirms, then runs [onConfirmed].
  Future<void> _delete(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirmed,
  }) async {
    final isConfirmed = await confirmPrescriptionRowDelete(
      context,
      title: title,
      message: message,
    );
    if (isConfirmed) onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorPrescriptionCubit>();

    return BlocBuilder<DoctorPrescriptionCubit, DoctorPrescriptionState>(
      buildWhen: (previous, current) =>
          previous.xRays != current.xRays ||
          previous.manualXRays != current.manualXRays ||
          previous.labTests != current.labTests ||
          previous.manualLabTests != current.manualLabTests ||
          previous.endoscopies != current.endoscopies ||
          previous.additionalExaminations != current.additionalExaminations,
      builder: (context, state) {
        final tables = <Widget>[
          if (state.xRays.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.xRay,
              table: PrescriptionXRaysTableWidget(
                xRays: state.xRays,
                onEdit: (index, xRay) => _editXRay(context, index, xRay),
                onDelete: (index, xRay) => _delete(
                  context,
                  title: "حذف الأشعة",
                  message: "هل تريد حذف أشعة ${xRay.type} من الروشتة؟",
                  onConfirmed: () => cubit.removeXRay(index),
                ),
              ),
            ),
          if (state.manualXRays.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.xRay,
              title: "أشعة مكتوبة يدويًا",
              icon: Icons.edit_note_outlined,
              table: PrescriptionManualEntriesTableWidget(
                detailsLabel: "تفاصيل الأشعة",
                entries: state.manualXRays,
                onEdit: (index, xRay) => _editManualXRay(context, index, xRay),
                onDelete: (index, _) => _delete(
                  context,
                  title: "حذف الأشعة",
                  message: "هل تريد حذف هذه الأشعة من الروشتة؟",
                  onConfirmed: () => cubit.removeManualXRay(index),
                ),
              ),
            ),
          if (state.labTests.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.labTest,
              table: PrescriptionLabTestsTableWidget(
                labTests: state.labTests,
                onEdit: (index, labTest) =>
                    _editLabTest(context, index, labTest),
                onDelete: (index, _) => _delete(
                  context,
                  title: "حذف التحليل",
                  message: "هل تريد حذف هذا التحليل من الروشتة؟",
                  onConfirmed: () => cubit.removeLabTest(index),
                ),
              ),
            ),
          if (state.manualLabTests.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.labTest,
              title: "تحاليل مكتوبة يدويًا",
              icon: Icons.edit_note_outlined,
              table: PrescriptionManualEntriesTableWidget(
                detailsLabel: "تفاصيل التحليل",
                entries: state.manualLabTests,
                onEdit: (index, labTest) =>
                    _editManualLabTest(context, index, labTest),
                onDelete: (index, _) => _delete(
                  context,
                  title: "حذف التحليل",
                  message: "هل تريد حذف هذا التحليل من الروشتة؟",
                  onConfirmed: () => cubit.removeManualLabTest(index),
                ),
              ),
            ),
          if (state.endoscopies.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.endoscopy,
              table: PrescriptionManualEntriesTableWidget(
                detailsLabel: "تفاصيل المنظار",
                entries: state.endoscopies,
                onEdit: (index, endoscopy) =>
                    _editEndoscopy(context, index, endoscopy),
                onDelete: (index, _) => _delete(
                  context,
                  title: "حذف المنظار",
                  message: "هل تريد حذف هذا المنظار من الروشتة؟",
                  onConfirmed: () => cubit.removeEndoscopy(index),
                ),
              ),
            ),
          if (state.additionalExaminations.isNotEmpty)
            _ExaminationTable(
              type: PrescriptionExaminationType.additional,
              table: PrescriptionManualEntriesTableWidget(
                detailsLabel: "تفاصيل الفحص",
                entries: state.additionalExaminations,
                onEdit: (index, examination) =>
                    _editAdditional(context, index, examination),
                onDelete: (index, _) => _delete(
                  context,
                  title: "حذف الفحص",
                  message: "هل تريد حذف هذا الفحص من الروشتة؟",
                  onConfirmed: () => cubit.removeAdditionalExamination(index),
                ),
              ),
            ),
        ];

        return PrescriptionSectionCardWidget(
          number: 2,
          icon: Icons.science_outlined,
          title: "الفحوصات",
          accentColor: AppColorsManager.prescriptionExaminationsAccent,
          headerBackgroundColor:
              AppColorsManager.prescriptionExaminationsHeaderBackground,
          addLabel: "إضافة فحص",
          onAddPressed: () => _addExamination(context),
          footer: state.totalExaminations > 0
              ? "إجمالي الفحوصات: ${state.totalExaminations}"
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (tables.isEmpty)
                const PrescriptionEmptySectionWidget(
                  icon: Icons.science_outlined,
                  title: "لم تتم إضافة فحوصات بعد",
                  subtitle: "اضغط على \"إضافة فحص\" لإضافة أول فحص للروشتة",
                ),
              for (var i = 0; i < tables.length; i++) ...[
                if (i > 0) verticalSpacing(16),
                tables[i],
              ],
            ],
          ),
        );
      },
    );
  }
}

/// One examination kind's title above its table.
class _ExaminationTable extends StatelessWidget {
  const _ExaminationTable({
    required this.type,
    required this.table,
    this.title,
    this.icon,
  });

  final PrescriptionExaminationType type;
  final Widget table;

  /// Defaults to the kind's own title and icon.
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrescriptionSubTableTitle(
          title ?? type.title,
          icon: icon ?? type.icon,
        ),
        verticalSpacing(8),
        table,
      ],
    );
  }
}
