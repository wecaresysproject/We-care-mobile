import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/certificates/logic/cubit/certificate_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One certificate's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: degree/course
/// title, granting body, country, obtained date.
class CertificateCardWidget extends StatelessWidget {
  const CertificateCardWidget({
    super.key,
    required this.entry,
    required this.titleLabel,
    required this.titleHint,
    required this.countriesNames,
    required this.onCountryChanged,
    required this.onDateChanged,
    this.onRemove,
  });

  final CertificateFormEntry entry;
  final String titleLabel;
  final String titleHint;
  final List<String> countriesNames;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String> onDateChanged;
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

        // 1. Degree / course title
        Text(titleLabel, style: AppTextStyles.font18blackWight500),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.degreeTitleController,
          hintText: titleHint,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Granting body
        Text(
          localization.certificatesFormGrantingBodyLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.grantingBodyController,
          hintText: localization.certificatesFormEnterGrantingBody,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 3. Country
        UserSelectionContainer(
          categoryLabel: localization.certificatesFormCountryLabel,
          containerHintText: entry.selectedCountry ??
              localization.certificatesFormChooseCountry,
          options: countriesNames,
          onOptionSelected: onCountryChanged,
          bottomSheetTitle: localization.certificatesFormChooseCountry,
          searchHintText: localization.certificatesFormChooseCountry,
        ),
        verticalSpacing(18),

        // 4. Obtained date
        Text(
          localization.certificatesFormObtainedDateLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          placeholderText: localization.certificatesFormChooseObtainedDate,
          onDateSelected: onDateChanged,
        ),
      ],
    );
  }
}
