import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/research_and_papers/logic/cubit/research_paper_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One research/paper's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: research
/// title, year, DOI/PMID link.
class ResearchPaperCardWidget extends StatelessWidget {
  const ResearchPaperCardWidget({
    super.key,
    required this.entry,
    this.onRemove,
  });

  final ResearchPaperFormEntry entry;
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

        // 1. Research/paper title
        Text(
          localization.researchAndPapersFormTitleLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.titleController,
          hintText: localization.researchAndPapersFormEnterTitle,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Year
        Text(
          localization.researchAndPapersFormYearLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.yearController,
          hintText: localization.researchAndPapersFormEnterYear,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 3. DOI / PMID link
        Text(
          localization.researchAndPapersFormLinkLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.doiOrLinkController,
          hintText: localization.researchAndPapersFormEnterLink,
          keyboardType: TextInputType.url,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
      ],
    );
  }
}
