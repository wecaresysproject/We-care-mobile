import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/experience/logic/cubit/experience_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One experience's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: position,
/// work place, from/to duration, country.
class ExperienceCardWidget extends StatelessWidget {
  const ExperienceCardWidget({
    super.key,
    required this.entry,
    required this.countriesNames,
    required this.onCountryChanged,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    this.onRemove,
  });

  final ExperienceFormEntry entry;
  final List<String> countriesNames;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String> onFromDateChanged;
  final ValueChanged<String> onToDateChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onRemove != null)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 20.r,
                color: AppColorsManager.warningColor,
              ),
            ),
          ),

        // 1. Position
        Text(
          localization.experienceFormPositionLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.positionController,
          hintText: localization.experienceFormEnterPosition,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Work place
        Text(
          localization.experienceFormWorkPlaceLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.workPlaceController,
          hintText: localization.experienceFormEnterWorkPlace,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 3. Work duration — from / to
        Text(
          localization.experienceFormDurationLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.experienceFormFromLabel,
                    style: AppTextStyles.font16DarkGreyWeight400,
                  ),
                  verticalSpacing(6),
                  DateTimePickerContainer(
                    placeholderText: localization.experienceFormChooseDate,
                    onDateSelected: onFromDateChanged,
                  ),
                ],
              ),
            ),
            horizontalSpacing(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.experienceFormToLabel,
                    style: AppTextStyles.font16DarkGreyWeight400,
                  ),
                  verticalSpacing(6),
                  DateTimePickerContainer(
                    placeholderText: localization.experienceFormChooseDate,
                    onDateSelected: onToDateChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpacing(18),

        // 4. Country
        UserSelectionContainer(
          categoryLabel: localization.experienceFormCountryLabel,
          containerHintText:
              entry.selectedCountry ?? localization.experienceFormChooseCountry,
          options: countriesNames,
          onOptionSelected: onCountryChanged,
          bottomSheetTitle: localization.experienceFormChooseCountry,
          searchHintText: localization.experienceFormChooseCountry,
        ),
      ],
    );
  }
}
