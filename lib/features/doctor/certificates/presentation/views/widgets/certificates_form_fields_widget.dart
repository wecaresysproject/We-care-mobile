import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_section_type.dart';
import 'package:we_care/features/doctor/certificates/logic/cubit/certificates_cubit.dart';
import 'package:we_care/features/doctor/certificates/presentation/views/widgets/certificate_card_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_section_container_widget.dart';
import 'package:we_care/generated/l10n.dart';

class CertificatesFormFields extends StatelessWidget {
  const CertificatesFormFields({super.key});

  String _sectionTitle(S localization, CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        localization.certificatesFormBachelorSectionTitle,
      CertificateSectionType.diploma =>
        localization.certificatesFormDiplomaSectionTitle,
      CertificateSectionType.master =>
        localization.certificatesFormMasterSectionTitle,
      CertificateSectionType.doctorate =>
        localization.certificatesFormDoctorateSectionTitle,
      CertificateSectionType.fellowship =>
        localization.certificatesFormFellowshipSectionTitle,
      CertificateSectionType.boardCertification =>
        localization.certificatesFormBoardCertificationSectionTitle,
    };
  }

  String _entryTitleLabel(S localization, CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        localization.certificatesFormBachelorDegreeLabel,
      CertificateSectionType.diploma =>
        localization.certificatesFormDiplomaDegreeLabel,
      CertificateSectionType.master =>
        localization.certificatesFormMasterDegreeLabel,
      CertificateSectionType.doctorate =>
        localization.certificatesFormDoctorateDegreeLabel,
      CertificateSectionType.fellowship =>
        localization.certificatesFormFellowshipDegreeLabel,
      CertificateSectionType.boardCertification =>
        localization.certificatesFormBoardCertificationDegreeLabel,
    };
  }

  String _entryTitleHint(S localization, CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        localization.certificatesFormChooseBachelorDegree,
      CertificateSectionType.diploma =>
        localization.certificatesFormChooseDiplomaDegree,
      CertificateSectionType.master =>
        localization.certificatesFormChooseMasterDegree,
      CertificateSectionType.doctorate =>
        localization.certificatesFormChooseDoctorateDegree,
      CertificateSectionType.fellowship =>
        localization.certificatesFormChooseFellowshipDegree,
      CertificateSectionType.boardCertification =>
        localization.certificatesFormEnterBoardCertificationDegree,
    };
  }

  String _addAnotherLabel(S localization, CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        localization.certificatesFormAddAnotherBachelorAction,
      CertificateSectionType.diploma =>
        localization.certificatesFormAddAnotherDiplomaAction,
      CertificateSectionType.master =>
        localization.certificatesFormAddAnotherMasterAction,
      CertificateSectionType.doctorate =>
        localization.certificatesFormAddAnotherDoctorateAction,
      CertificateSectionType.fellowship =>
        localization.certificatesFormAddAnotherFellowshipAction,
      CertificateSectionType.boardCertification =>
        localization.certificatesFormAddAnotherBoardCertificationAction,
    };
  }

  IconData _sectionIcon(CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor => Icons.school_outlined,
      CertificateSectionType.diploma => Icons.workspace_premium_outlined,
      CertificateSectionType.master => Icons.auto_stories_outlined,
      CertificateSectionType.doctorate => Icons.psychology_alt_outlined,
      CertificateSectionType.fellowship => Icons.military_tech_outlined,
      CertificateSectionType.boardCertification => Icons.description_outlined,
    };
  }

  Color _sectionBadgeBackground(CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        AppColorsManager.basicDataTealBadgeBackground,
      CertificateSectionType.diploma =>
        AppColorsManager.basicDataPurpleBadgeBackground,
      CertificateSectionType.master =>
        AppColorsManager.basicDataGreenBadgeBackground,
      CertificateSectionType.doctorate =>
        AppColorsManager.basicDataIndigoBadgeBackground,
      CertificateSectionType.fellowship =>
        AppColorsManager.basicDataSkyBadgeBackground,
      CertificateSectionType.boardCertification =>
        AppColorsManager.basicDataRoseBadgeBackground,
    };
  }

  Color _sectionBadgeIcon(CertificateSectionType section) {
    return switch (section) {
      CertificateSectionType.bachelor =>
        AppColorsManager.basicDataTealBadgeIcon,
      CertificateSectionType.diploma =>
        AppColorsManager.basicDataPurpleBadgeIcon,
      CertificateSectionType.master => AppColorsManager.basicDataGreenBadgeIcon,
      CertificateSectionType.doctorate =>
        AppColorsManager.basicDataIndigoBadgeIcon,
      CertificateSectionType.fellowship =>
        AppColorsManager.basicDataSkyBadgeIcon,
      CertificateSectionType.boardCertification =>
        AppColorsManager.basicDataRoseBadgeIcon,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CertificatesCubit, CertificatesState>(
      builder: (context, state) {
        final cubit = context.read<CertificatesCubit>();
        final localization = S.of(context);

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final section in CertificateSectionType.values) ...[
                AppSectionContainerWidget(
                  icon: _sectionIcon(section),
                  title: _sectionTitle(localization, section),
                  badgeBackgroundColor: _sectionBadgeBackground(section),
                  badgeIconColor: _sectionBadgeIcon(section),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final entry in state.sections[section]!) ...[
                        if (entry != state.sections[section]!.first) ...[
                          Divider(
                            color:
                                AppColorsManager.placeHolderColor.withAlpha(60),
                          ),
                          verticalSpacing(4),
                        ],
                        CertificateCardWidget(
                          key: entry.key,
                          entry: entry,
                          titleLabel: _entryTitleLabel(localization, section),
                          titleHint: _entryTitleHint(localization, section),
                          countriesNames: state.countriesNames,
                          onCountryChanged: (country) =>
                              cubit.updateCertificateCountry(
                                  section, entry.key, country),
                          onDateChanged: (date) => cubit.updateCertificateDate(
                              section, entry.key, date),
                          onRemove: state.sections[section]!.length > 1
                              ? () =>
                                  cubit.removeCertificate(section, entry.key)
                              : null,
                        ),
                        verticalSpacing(16),
                      ],
                      _AddAnotherCertificateButton(
                        label: _addAnotherLabel(localization, section),
                        onTap: () => cubit.addCertificate(section),
                      ),
                    ],
                  ),
                ),
                verticalSpacing(20),
              ],
              _SubmitButton(),
              verticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}

class _AddAnotherCertificateButton extends StatelessWidget {
  const _AddAnotherCertificateButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorsManager.mainDarkBlue.withAlpha(15),
      borderRadius: BorderRadius.circular(15.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border:
                Border.all(color: AppColorsManager.mainDarkBlue, width: 1.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColorsManager.mainDarkBlue, size: 20.r),
              horizontalSpacing(6),
              Text(
                label,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CertificatesCubit, CertificatesState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CertificatesCubit>();
        return AppCustomButton(
          title: S.of(context).certificatesFormSubmit,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: () {
            if (cubit.formKey.currentState?.validate() ?? false) {
              cubit.submitCertificates();
            }
          },
        );
      },
    );
  }
}
