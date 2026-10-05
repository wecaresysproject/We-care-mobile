import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/awards/logic/cubit/award_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One award's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: award name,
/// country, granting body, year.
class AwardCardWidget extends StatelessWidget {
  const AwardCardWidget({
    super.key,
    required this.entry,
    required this.countriesNames,
    required this.onCountryChanged,
    required this.onYearChanged,
    this.onRemove,
  });

  final AwardFormEntry entry;
  final List<String> countriesNames;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String> onYearChanged;
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

        // 1. Award name
        Text(
          localization.awardsFormAwardNameLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.awardNameController,
          hintText: localization.awardsFormEnterAwardName,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Country
        UserSelectionContainer(
          categoryLabel: localization.awardsFormCountryLabel,
          containerHintText:
              entry.selectedCountry ?? localization.awardsFormChooseCountry,
          options: countriesNames,
          onOptionSelected: onCountryChanged,
          bottomSheetTitle: localization.awardsFormChooseCountry,
          searchHintText: localization.awardsFormChooseCountry,
        ),
        verticalSpacing(18),

        // 3. Granting body
        Text(
          localization.awardsFormGrantingBodyLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.grantingBodyController,
          hintText: localization.awardsFormEnterGrantingBody,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 4. Year
        Text(
          localization.awardsFormYearLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          placeholderText: localization.awardsFormChooseYear,
          onDateSelected: onYearChanged,
        ),
      ],
    );
  }
}
