import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/membership/logic/cubit/membership_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One membership's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: country,
/// association name, membership number, membership level, year.
class MembershipCardWidget extends StatelessWidget {
  const MembershipCardWidget({
    super.key,
    required this.entry,
    required this.countriesNames,
    required this.membershipLevels,
    required this.onCountryChanged,
    required this.onMembershipLevelChanged,
    required this.onYearChanged,
    this.onRemove,
  });

  final MembershipFormEntry entry;
  final List<String> countriesNames;
  final List<String> membershipLevels;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onMembershipLevelChanged;
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

        // 1. Country
        UserSelectionContainer(
          categoryLabel: localization.membershipFormCountryLabel,
          containerHintText:
              entry.selectedCountry ?? localization.membershipFormChooseCountry,
          options: countriesNames,
          onOptionSelected: onCountryChanged,
          bottomSheetTitle: localization.membershipFormChooseCountry,
          searchHintText: localization.membershipFormChooseCountry,
        ),
        verticalSpacing(18),

        // 2. Association name
        Text(
          localization.membershipFormAssociationNameLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.associationNameController,
          hintText: localization.membershipFormEnterAssociationName,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 3. Membership number
        Text(
          localization.membershipFormNumberLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.membershipNumberController,
          hintText: localization.membershipFormEnterNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 4. Membership level
        UserSelectionContainer(
          categoryLabel: localization.membershipFormLevelLabel,
          containerHintText: entry.selectedMembershipLevel ??
              localization.membershipFormChooseLevel,
          options: membershipLevels,
          onOptionSelected: onMembershipLevelChanged,
          bottomSheetTitle: localization.membershipFormChooseLevel,
          searchHintText: localization.membershipFormChooseLevel,
        ),
        verticalSpacing(18),

        // 5. Year
        Text(
          localization.membershipFormYearLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          placeholderText: localization.membershipFormChooseYear,
          onDateSelected: onYearChanged,
        ),
      ],
    );
  }
}
