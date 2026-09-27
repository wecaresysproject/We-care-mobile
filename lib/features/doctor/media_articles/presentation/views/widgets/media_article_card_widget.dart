import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/media_articles/logic/cubit/media_article_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One media/article's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: title,
/// subject, media/articles link.
class MediaArticleCardWidget extends StatelessWidget {
  const MediaArticleCardWidget({
    super.key,
    required this.entry,
    this.onRemove,
  });

  final MediaArticleFormEntry entry;
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

        // 1. Title
        Text(
          localization.mediaArticlesFormTitleLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.titleController,
          hintText: localization.mediaArticlesFormEnterTitle,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Subject
        Text(
          localization.mediaArticlesFormSubjectLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.subjectController,
          hintText: localization.mediaArticlesFormEnterSubject,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 3. Media/articles link
        Text(
          localization.mediaArticlesFormLinkLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.mediaLinkController,
          hintText: localization.mediaArticlesFormEnterLink,
          keyboardType: TextInputType.url,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
      ],
    );
  }
}
