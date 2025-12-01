import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int selectedCount;

  const DeleteConfirmationDialog({
    super.key,
    required this.selectedCount,
  });

  static Future<void> show(BuildContext context) async {
    final cubit = context.read<MedicalNotesCubit>();
    final selectedCount = cubit.state.selectedCount;

    return showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        selectedCount: selectedCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'تأكيد الحذف',
        textAlign: TextAlign.right,
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'هل أنت متأكد من حذف $selectedCount ملاحظة؟',
        textAlign: TextAlign.right,
        style: AppTextStyles.font16DarkGreyWeight400,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.textColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<MedicalNotesCubit>().deleteSelectedNotes();
          },
          child: Text(
            'حذف',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.warningColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
