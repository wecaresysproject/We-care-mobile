import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';

class AddNoteFabWidget extends StatelessWidget {
  const AddNoteFabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await context.pushNamed(
          Routes.createEditMedicalNote,
          arguments: null,
        );
        if (context.mounted) {
          await context.read<MedicalNotesCubit>().loadNotes();
        }
      },
      backgroundColor: AppColorsManager.mainDarkBlue,
      elevation: 4,
      icon: Icon(Icons.add, color: Colors.white, size: 20.sp),
      label: Text(
        'أضف ملاحظة',
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
