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
import 'package:we_care/features/doctor/service_prices/logic/cubit/service_prices_cubit.dart';
import 'package:we_care/features/doctor/service_prices/presentation/views/widgets/currency_amount_field_widget.dart';
import 'package:we_care/features/doctor/service_prices/presentation/views/widgets/follow_up_validity_selector_widget.dart';
import 'package:we_care/features/doctor/service_prices/presentation/views/widgets/service_prices_notes_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_section_container_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_yes_no_toggle_widget.dart';
import 'package:we_care/generated/l10n.dart';

class ServicePricesFormFields extends StatelessWidget {
  const ServicePricesFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicePricesCubit, ServicePricesState>(
      builder: (context, state) {
        final cubit = context.read<ServicePricesCubit>();
        final localization = S.of(context);

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionContainerWidget(
                icon: Icons.medical_services_outlined,
                title: localization.servicePricesFormExaminationSectionTitle,
                subtitle:
                    localization.servicePricesFormExaminationSectionSubtitle,
                badgeBackgroundColor:
                    AppColorsManager.basicDataEmeraldBadgeBackground,
                badgeIconColor: AppColorsManager.basicDataEmeraldBadgeIcon,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CurrencyAmountFieldWidget(
                        label: localization
                            .servicePricesFormExaminationPriceOutsideEgyptLabel,
                        currencyGlyph: Icon(
                          Icons.public,
                          size: 18.r,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                        currencyCode: 'USD',
                        controller:
                            cubit.examinationPriceOutsideEgyptController,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? localization.required_field
                                : null,
                      ),
                    ),
                    horizontalSpacing(12),
                    Expanded(
                      child: CurrencyAmountFieldWidget(
                        label: localization
                            .servicePricesFormExaminationPriceInsideEgyptLabel,
                        currencyGlyph: Text(
                          '🇪🇬',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        currencyCode: 'EGP',
                        controller: cubit.examinationPriceInsideEgyptController,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? localization.required_field
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(18),
              AppSectionContainerWidget(
                icon: Icons.forum_outlined,
                title: localization.servicePricesFormConsultationSectionTitle,
                subtitle:
                    localization.servicePricesFormConsultationSectionSubtitle,
                badgeBackgroundColor:
                    AppColorsManager.basicDataPurpleBadgeBackground,
                badgeIconColor: AppColorsManager.basicDataPurpleBadgeIcon,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            localization.servicePricesFormOffersFollowUpLabel,
                            style: AppTextStyles.font14blackWeight600,
                          ),
                        ),
                        AppYesNoToggleWidget(
                          value: state.offersFollowUpConsultation,
                          onChanged: cubit.updateOffersFollowUpConsultation,
                        ),
                      ],
                    ),
                    if (state.offersFollowUpConsultation) ...[
                      verticalSpacing(16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColorsManager.scaffoldBackGroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color:
                                AppColorsManager.placeHolderColor.withAlpha(60),
                            width: 1.3,
                          ),
                        ),
                        child: FollowUpValiditySelectorWidget(
                          title: localization.servicePricesFormValidityLabel,
                          hint: localization.servicePricesFormValidityHint,
                          valueLabel: state.followUpConsultationValidityDays !=
                                  null
                              ? localization.servicePricesFormValidityDaysValue(
                                  state.followUpConsultationValidityDays!,
                                )
                              : localization.servicePricesFormChooseValidity,
                          options:
                              ServicePricesCubit.followUpValidityOptionsDays
                                  .map(
                                    (days) => localization
                                        .servicePricesFormValidityDaysValue(
                                      days,
                                    ),
                                  )
                                  .toList(),
                          onOptionSelected: (selected) {
                            final days = int.parse(
                              RegExp(r'\d+').stringMatch(selected) ?? '0',
                            );
                            cubit.updateFollowUpConsultationValidityDays(days);
                          },
                          bottomSheetTitle:
                              localization.servicePricesFormChooseValidity,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              verticalSpacing(18),
              const ServicePricesNotesWidget(),
              verticalSpacing(28),
              _SubmitButton(),
              verticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicePricesCubit, ServicePricesState>(
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
        final cubit = context.read<ServicePricesCubit>();
        return AppCustomButton(
          title: S.of(context).servicePricesFormSaveSettings,
          icon: Icons.save_outlined,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: () {
            if (cubit.formKey.currentState?.validate() ?? false) {
              cubit.submitServicePrices();
            }
          },
        );
      },
    );
  }
}
