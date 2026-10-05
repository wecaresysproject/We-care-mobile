import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/membership/logic/cubit/membership_cubit.dart';
import 'package:we_care/features/doctor/membership/presentation/views/widgets/membership_card_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_section_container_widget.dart';
import 'package:we_care/generated/l10n.dart';

class MembershipFormFields extends StatelessWidget {
  const MembershipFormFields({super.key});

  static const _membershipLevels = [
    'عضو',
    'عضو مؤسس',
    'زميل',
    'مستشار',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembershipCubit, MembershipState>(
      builder: (context, state) {
        final cubit = context.read<MembershipCubit>();
        final localization = S.of(context);

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionContainerWidget(
                icon: Icons.groups_outlined,
                title: localization.membershipFormSectionTitle,
                badgeBackgroundColor:
                    AppColorsManager.basicDataPurpleBadgeBackground,
                badgeIconColor: AppColorsManager.basicDataPurpleBadgeIcon,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in state.entries) ...[
                      if (entry != state.entries.first) ...[
                        Divider(
                          color:
                              AppColorsManager.placeHolderColor.withAlpha(60),
                        ),
                        verticalSpacing(4),
                      ],
                      MembershipCardWidget(
                        key: entry.key,
                        entry: entry,
                        countriesNames: state.countriesNames,
                        membershipLevels: _membershipLevels,
                        onCountryChanged: (country) =>
                            cubit.updateMembershipCountry(entry.key, country),
                        onMembershipLevelChanged: (level) =>
                            cubit.updateMembershipLevel(entry.key, level),
                        onYearChanged: (date) =>
                            cubit.updateMembershipYear(entry.key, date),
                        onRemove: state.entries.length > 1
                            ? () => cubit.removeMembership(entry.key)
                            : null,
                      ),
                      verticalSpacing(16),
                    ],
                    _AddAnotherMembershipButton(
                      label: localization.membershipFormAddAnotherAction,
                      onTap: cubit.addMembership,
                    ),
                  ],
                ),
              ),
              verticalSpacing(20),
              _SubmitButton(),
              verticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}

class _AddAnotherMembershipButton extends StatelessWidget {
  const _AddAnotherMembershipButton({
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
    return BlocConsumer<MembershipCubit, MembershipState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
          if (!context.mounted) return;
          context.pop(result: true);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MembershipCubit>();
        return AppCustomButton(
          title: S.of(context).membershipFormSubmit,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: () {
            if (cubit.formKey.currentState?.validate() ?? false) {
              cubit.submitMemberships();
            }
          },
        );
      },
    );
  }
}
