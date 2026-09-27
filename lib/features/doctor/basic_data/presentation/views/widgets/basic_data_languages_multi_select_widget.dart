import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/basic_data/logic/cubit/doctor_basic_data_cubit.dart';
import 'package:we_care/generated/l10n.dart';

/// Reuses [UserSelectionContainer]'s single-pick bottom sheet: each tap adds
/// one more language to the cubit's selection list, which renders below as
/// removable chips — the same "fake multi-select" pattern used for purposes
/// in the patient modules.
const List<String> kSpokenLanguageOptions = [
  'العربية',
  'الإنجليزية',
  'الفرنسية',
  'الألمانية',
  'الإيطالية',
  'الإسبانية',
];

class BasicDataLanguagesMultiSelect extends StatelessWidget {
  const BasicDataLanguagesMultiSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBasicDataCubit, DoctorBasicDataState>(
      buildWhen: (prev, curr) =>
          prev.selectedLanguages != curr.selectedLanguages,
      builder: (context, state) {
        final cubit = context.read<DoctorBasicDataCubit>();
        final localization = S.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserSelectionContainer(
              categoryLabel: localization.basicDataFormLanguagesLabel,
              containerHintText: state.selectedLanguages.isEmpty
                  ? localization.basicDataFormChooseLanguages
                  : '${state.selectedLanguages.length} ${localization.basicDataFormChooseLanguages}',
              options: kSpokenLanguageOptions,
              onOptionSelected: cubit.toggleSpokenLanguage,
              bottomSheetTitle: localization.basicDataFormChooseLanguages,
              searchHintText: localization.basicDataFormSearchLanguages,
            ),
            if (state.selectedLanguages.isNotEmpty) ...[
              verticalSpacing(10),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: state.selectedLanguages
                    .map(
                      (language) => Chip(
                        label: Text(
                          language,
                          style: AppTextStyles.font14blackWeight400,
                        ),
                        backgroundColor: AppColorsManager.textfieldInsideColor,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => cubit.removeSpokenLanguage(language),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
