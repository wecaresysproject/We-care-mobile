import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/image_preview_item_with_cancel.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/professional_licenses/logic/cubit/license_form_entry.dart';
import 'package:we_care/features/doctor/professional_licenses/logic/cubit/professional_licenses_cubit.dart';
import 'package:we_care/generated/l10n.dart';

/// One license's fields. Rendered directly inside the section's
/// [AppSectionContainerWidget] — no border/background of its own — so the
/// whole section reads as a single bordered block. Field order: license
/// number, country, licensing authority, registration number, license date,
/// expiry date, license image (camera/gallery).
class LicenseCardWidget extends StatelessWidget {
  const LicenseCardWidget({
    super.key,
    required this.entry,
    required this.countriesNames,
    required this.onCountryChanged,
    required this.onLicenseDateChanged,
    required this.onExpiryDateChanged,
    this.onRemove,
  });

  final LicenseFormEntry entry;
  final List<String> countriesNames;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String> onLicenseDateChanged;
  final ValueChanged<String> onExpiryDateChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final cubit = context.read<ProfessionalLicensesCubit>();

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

        // 1. License number
        Text(
          localization.professionalLicensesFormLicenseNumberLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.licenseNumberController,
          hintText: localization.professionalLicensesFormEnterLicenseNumber,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 2. Country
        UserSelectionContainer(
          categoryLabel: localization.professionalLicensesFormCountryLabel,
          containerHintText: entry.selectedCountry ??
              localization.professionalLicensesFormChooseCountry,
          options: countriesNames,
          onOptionSelected: onCountryChanged,
          bottomSheetTitle: localization.professionalLicensesFormChooseCountry,
          searchHintText: localization.professionalLicensesFormChooseCountry,
        ),
        verticalSpacing(18),

        // 3. Licensing authority
        Text(
          localization.professionalLicensesFormLicensingAuthorityLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.licensingAuthorityController,
          hintText:
              localization.professionalLicensesFormEnterLicensingAuthority,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 4. Registration number (below licensing authority)
        Text(
          localization.professionalLicensesFormRegistrationNumberLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          controller: entry.registrationNumberController,
          hintText:
              localization.professionalLicensesFormEnterRegistrationNumber,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.required_field
              : null,
        ),
        verticalSpacing(18),

        // 5. License date
        Text(
          localization.professionalLicensesFormLicenseDateLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          placeholderText: localization.professionalLicensesFormChooseDate,
          onDateSelected: onLicenseDateChanged,
        ),
        verticalSpacing(18),

        // 6. Expiry date — "الترخيص ساري حتى تاريخ" (below license date)
        Text(
          localization.professionalLicensesFormExpiryDateLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          placeholderText: localization.professionalLicensesFormChooseDate,
          isForInsuranceExpiry: true,
          onDateSelected: onExpiryDateChanged,
        ),
        verticalSpacing(18),

        // 7. License image — camera or gallery
        Text(
          localization.professionalLicensesFormLicenseImageLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        if (entry.licenseImageUrl.isNotEmptyOrNull) ...[
          ImageViewerWithCancel(
            imageUrl: entry.licenseImageUrl!,
            onRemove: () => cubit.removeLicenseImage(entry.key),
          ),
          verticalSpacing(10),
        ],
        BlocListener<ProfessionalLicensesCubit, ProfessionalLicensesState>(
          listenWhen: (prev, curr) =>
              _statusFor(prev, entry.key) != _statusFor(curr, entry.key),
          listener: (context, state) async {
            final status = _statusFor(state, entry.key);
            if (status == UploadImageRequestStatus.success) {
              await showSuccess(state.message!);
            } else if (status == UploadImageRequestStatus.failure) {
              await showError(state.message!);
            }
          },
          child: SelectImageContainer(
            imagePath: "assets/images/photo_icon.png",
            label: localization.professionalLicensesFormAttachImageAction,
            onTap: () async {
              await showImagePicker(
                context,
                onImagePicked: (isPicked) async {
                  final picker = getIt.get<ImagePickerService>();
                  if (isPicked && picker.isImagePickedAccepted) {
                    await cubit.uploadLicenseImage(
                      entry.key,
                      imagePath: picker.pickedImage!.path,
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  UploadImageRequestStatus? _statusFor(
    ProfessionalLicensesState state,
    Key entryKey,
  ) {
    for (final entry in state.entries) {
      if (entry.key == entryKey) return entry.licenseImageUploadStatus;
    }
    return null;
  }
}
