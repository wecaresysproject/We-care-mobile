import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/basic_data/data/models/basic_data_menu_item_model.dart';
import 'package:we_care/features/doctor/basic_data/data/models/basic_data_menu_item_type.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_menu_tile_widget.dart';
import 'package:we_care/generated/l10n.dart';

class BasicDataMenuGridWidget extends StatelessWidget {
  const BasicDataMenuGridWidget({super.key, required this.menuItems});

  final List<BasicDataMenuItemModel> menuItems;

  String _labelFor(BuildContext context, BasicDataMenuItemType type) {
    return switch (type) {
      BasicDataMenuItemType.bankInfo => S.of(context).bankInfoAction,
      BasicDataMenuItemType.medicalSpecialty =>
        S.of(context).medicalSpecialtyAction,
      BasicDataMenuItemType.basicData => S.of(context).basicDataMenuAction,
      BasicDataMenuItemType.membership => S.of(context).membershipAction,
      BasicDataMenuItemType.experience => S.of(context).experienceAction,
      BasicDataMenuItemType.awards => S.of(context).awardsAction,
      BasicDataMenuItemType.legalReferences =>
        S.of(context).legalReferencesAction,
      BasicDataMenuItemType.researchAndMessages =>
        S.of(context).researchAndMessagesAction,
      BasicDataMenuItemType.bookingAndContact =>
        S.of(context).bookingAndContactAction,
      BasicDataMenuItemType.bookingSettings =>
        S.of(context).bookingSettingsAction,
      BasicDataMenuItemType.servicePrices => S.of(context).servicePricesAction,
      BasicDataMenuItemType.monthlyExaminationTarget =>
        S.of(context).monthlyExaminationTargetAction,
      BasicDataMenuItemType.certificates => S.of(context).certificatesAction,
      BasicDataMenuItemType.professionalLicenses =>
        S.of(context).professionalLicensesAction,
      BasicDataMenuItemType.mediaAndArticles =>
        S.of(context).mediaAndArticlesAction,
    };
  }

  Color _badgeBackgroundFor(BasicDataMenuItemType type) {
    return switch (type) {
      BasicDataMenuItemType.bankInfo =>
        AppColorsManager.basicDataBlueBadgeBackground,
      BasicDataMenuItemType.medicalSpecialty =>
        AppColorsManager.basicDataTealBadgeBackground,
      BasicDataMenuItemType.basicData =>
        AppColorsManager.basicDataDarkBlueBadgeBackground,
      BasicDataMenuItemType.membership =>
        AppColorsManager.basicDataPurpleBadgeBackground,
      BasicDataMenuItemType.experience =>
        AppColorsManager.basicDataGreenBadgeBackground,
      BasicDataMenuItemType.awards =>
        AppColorsManager.basicDataOrangeBadgeBackground,
      BasicDataMenuItemType.legalReferences =>
        AppColorsManager.basicDataEmeraldBadgeBackground,
      BasicDataMenuItemType.researchAndMessages =>
        AppColorsManager.basicDataSkyBadgeBackground,
      BasicDataMenuItemType.bookingAndContact =>
        AppColorsManager.basicDataBlueBadgeBackground,
      BasicDataMenuItemType.bookingSettings =>
        AppColorsManager.basicDataGreenBadgeBackground,
      BasicDataMenuItemType.servicePrices =>
        AppColorsManager.basicDataEmeraldBadgeBackground,
      BasicDataMenuItemType.monthlyExaminationTarget =>
        AppColorsManager.basicDataVioletBadgeBackground,
      BasicDataMenuItemType.certificates =>
        AppColorsManager.basicDataAmberBadgeBackground,
      BasicDataMenuItemType.professionalLicenses =>
        AppColorsManager.basicDataIndigoBadgeBackground,
      BasicDataMenuItemType.mediaAndArticles =>
        AppColorsManager.basicDataRoseBadgeBackground,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return BasicDataMenuTileWidget(
          iconAssetPath: item.iconAssetPath,
          label: _labelFor(context, item.type),
          badgeBackgroundColor: _badgeBackgroundFor(item.type),
          onTap: switch (item.type) {
            BasicDataMenuItemType.basicData => () =>
                context.pushNamed(Routes.doctorBasicDataFormView),
            BasicDataMenuItemType.medicalSpecialty => () =>
                context.pushNamed(Routes.medicalSpecialtyFormView),
            BasicDataMenuItemType.bankInfo => () =>
                context.pushNamed(Routes.bankInfoFormView),
            BasicDataMenuItemType.certificates => () =>
                context.pushNamed(Routes.certificatesFormView),
            BasicDataMenuItemType.mediaAndArticles => () =>
                context.pushNamed(Routes.mediaArticlesFormView),
            BasicDataMenuItemType.experience => () =>
                context.pushNamed(Routes.experienceFormView),
            BasicDataMenuItemType.researchAndMessages => () =>
                context.pushNamed(Routes.researchAndPapersFormView),
            BasicDataMenuItemType.membership => () =>
                context.pushNamed(Routes.membershipFormView),
            BasicDataMenuItemType.professionalLicenses => () =>
                context.pushNamed(Routes.professionalLicensesFormView),
            BasicDataMenuItemType.awards => () =>
                context.pushNamed(Routes.awardsFormView),
            BasicDataMenuItemType.servicePrices => () =>
                context.pushNamed(Routes.servicePricesFormView),
            BasicDataMenuItemType.bookingSettings => () =>
                context.pushNamed(Routes.bookingSettingsFormView),
            BasicDataMenuItemType.monthlyExaminationTarget => () =>
                context.pushNamed(Routes.monthlyExaminationTargetFormView),
            _ => null,
          },
        );
      },
    );
  }
}
