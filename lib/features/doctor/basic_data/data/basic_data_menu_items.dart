import 'package:we_care/features/doctor/basic_data/data/models/basic_data_menu_item_model.dart';
import 'package:we_care/features/doctor/basic_data/data/models/basic_data_menu_item_type.dart';

/// Static menu content for the Basic Data screen — no backend involved.
/// Order matches the requested right-to-left reading order.
const List<BasicDataMenuItemModel> basicDataMenuItems = [
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.basicData,
    iconAssetPath: 'assets/svgs/doctor_icon_basic_data.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.medicalSpecialty,
    iconAssetPath: 'assets/svgs/doctor_icon_medical_specialty.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.certificates,
    iconAssetPath: 'assets/svgs/doctor_icon_certificates.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.membership,
    iconAssetPath: 'assets/svgs/doctor_icon_membership.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.experience,
    iconAssetPath: 'assets/svgs/doctor_icon_experience.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.professionalLicenses,
    iconAssetPath: 'assets/svgs/doctor_icon_professional_licenses.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.researchAndMessages,
    iconAssetPath: 'assets/svgs/doctor_icon_messages.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.awards,
    iconAssetPath: 'assets/svgs/doctor_icon_awards.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.mediaAndArticles,
    iconAssetPath: 'assets/svgs/doctor_icon_media_articles.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.bankInfo,
    iconAssetPath: 'assets/svgs/doctor_icon_bank_info.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.bookingSettings,
    iconAssetPath: 'assets/svgs/doctor_icon_booking_settings.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.servicePrices,
    iconAssetPath: 'assets/svgs/doctor_icon_service_prices.svg',
  ),
  BasicDataMenuItemModel(
    type: BasicDataMenuItemType.monthlyExaminationTarget,
    iconAssetPath: 'assets/svgs/doctor_icon_monthly_target.svg',
  ),
];
