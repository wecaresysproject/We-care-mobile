import 'package:flutter/material.dart';

//! Most of the color names in this class almost match those used in the Figma design file.
class AppColorsManager {
  static const Color mainDarkBlue = Color(0xff014C8A);
  static const Color secondaryColor = Color(0xffDAE9FA);
  static const Color scaffoldBackGroundColor = Color(0xffFEFEFE);
  static const Color textfieldInsideColor = Color(0xffECF5FF);
  static const Color textfieldOutsideBorderColor = Color(0xff555555);
  static Color disAbledTextFieldOutsideBorderColor =
      Color(0xff555555).withAlpha(40);
  static const Color disAbledIconColor = Color(0xff5688B1);
  static const Color warningColor = Color(0xffCE0000);
  static const Color doneColor = Color(0xff00B087);
  static const Color unselectedNavIconColor = Color(0xff909090);
  static const Color selectedNavIconColor = Color(0xffFEFEFE);
  static const Color placeHolderColor = Color(0xff777777);
  static const Color textColor = Color(0xff080808);
  static const Color backGroundColor = Color(0xffFEFEFE);
  static const Color babyBlueColor = Color(0xffDAE9FA);
  static const Color redBackgroundValidationColor = Color(0x19CE0000);

  /// Indicates a normal/healthy status
  static const Color safe = Color(0xff8BC84A); // طبيعي - Green

  /// Indicates a need for monitoring
  static const Color warning = Color(0xffF0F000); // مراقبة - Yellow

  /// Indicates a partial or potential risk
  static const Color elevatedRisk = Color(0xffFF8800); // خطر جزئي - Orange

  /// Indicates a confirmed or critical risk
  static const Color criticalRisk = Color(0xffED0202); // خطر مؤكد - Red

  //! Doctor module (lib/features/doctor)

  // Skeleton / shimmer (manual loading bones)

  /// Default shimmer sweep base color (AppShimmer).
  static const Color shimmerBase = Color(0xFFE7E9EC);

  /// Default shimmer sweep highlight color (AppShimmer).
  static const Color shimmerHighlight = Color(0xFFF6F7F8);

  /// Default bone fill color (AppShimmerBone).
  static const Color shimmerBoneFill = Color(0xFFE7E9EC);

  // Doctor home dashboard

  /// Bottom nav bar background.
  static const Color homeNavBarBackground = Color(0xffF1F3F6);

  /// "المحقق" (achieved) badge background.
  static const Color achievedBadgeColor = Color(0xff8DB600);

  /// "الكشوفات المستهدفة شهريا" (monthly target) badge background.
  static const Color monthlyTargetBadgeColor = Color(0xffF77F07);

  /// Quick-action tile background.
  static const Color quickActionTileBackground = Color(0xE8EDEFF1);

  /// Ratings bar gradient (left → right).
  static const Color ratingsBarGradientStart = Color(0xffECF5FF);
  static const Color ratingsBarGradientEnd = Color(0xffFBFDFF);

  /// Ad banner frame overlay.
  static const Color adBannerOverlay = Color(0xA8909090);

  /// Doctor mini-photo tint (next to the name in the header).
  static const Color doctorPhotoOverlay = Color(0x66777777);

  // Doctor home dashboard — redesign (soft blue/white cards)

  /// Screen-specific scaffold background — distinct from the app-wide
  /// [scaffoldBackGroundColor].
  static const Color homeScaffoldBackground = Color(0xffF3F8FE);

  /// Large section container background (summary row, monthly section).
  static const Color homeSectionSurface = Color(0xffF8FBFF);

  /// Dark navy heading/value text used across the redesigned dashboard.
  static const Color homeHeadingDarkBlue = Color(0xff123D78);

  /// Primary blue accent (icons, "الانتظار"/"المتابعات" values).
  static const Color homePrimaryBlue = Color(0xff1678C8);

  /// Low-contrast vertical/horizontal divider color.
  static const Color homeDividerColor = Color(0xffD7E6F5);

  /// "المحقق" (achieved) card — green identity.
  static const Color homeAchievedGreen = Color(0xff18B88C);
  static const Color homeAchievedGreenDark = Color(0xff087A68);
  static const Color homeAchievedGreenSurface = Color(0xffEAFBF5);

  /// "المستهدف" (target) card — orange identity.
  static const Color homeTargetOrange = Color(0xffF58213);
  static const Color homeTargetOrangeDark = Color(0xffB85B0B);
  static const Color homeTargetOrangeSurface = Color(0xffFFF3E7);

  /// Bottom statistics card gradients (top-right → bottom-left) + the dark
  /// tint their metric rows use over the pale end of each gradient.
  static const List<Color> homeViewsCardGradient = [
    Color(0xff35B5B8),
    Color(0xffDDF8F2),
  ];
  static const Color homeViewsCardMetricText = Color(0xff0E6B6D);

  static const List<Color> homeSharesCardGradient = [
    Color(0xff4F9FE5),
    Color(0xffDDEEFF),
  ];
  static const Color homeSharesCardMetricText = Color(0xff1B5E96);

  static const List<Color> homeAppearancesCardGradient = [
    Color(0xff6F70D9),
    Color(0xffE2E3FF),
  ];
  static const Color homeAppearancesCardMetricText = Color(0xff3B3C96);

  // Bookings / online-session screen

  /// "كشف" (examination) type badge.
  static const Color examinationBadgeBackground = Color(0xffE3F0FF);
  static const Color examinationBadgeText = Color(0xff014C8A);

  /// "استشارة" (consultation) type badge.
  static const Color consultationBadgeBackground = Color(0xffEAE6FB);
  static const Color consultationBadgeText = Color(0xff5B3FD6);

  /// "N مرضى" today's-appointments count badge.
  static const Color todayCountBadgeBackground = Color(0xffEAE6FB);
  static const Color todayCountBadgeText = Color(0xff5B3FD6);

  /// "N مرضى" waiting-list count badge.
  static const Color waitingCountBadgeBackground = Color(0xffFCEADB);
  static const Color waitingCountBadgeText = Color(0xffF77F07);

  /// Appointment time-status text.
  static const Color appointmentDueColor = Color(0xff00B087);
  static const Color appointmentRemainingColor = Color(0xffF77F07);
  static const Color appointmentLateColor = Color(0xffED0202);

  /// "قبول" accept button.
  static const Color acceptButtonBackground = Color(0xffE3F8EC);
  static const Color acceptButtonText = Color(0xff00B087);
  static const Color acceptButtonBorder = Color(0xff00B087);

  /// "رفض" reject button.
  static const Color rejectButtonBackground = Color(0xffFCE7E7);
  static const Color rejectButtonText = Color(0xffED0202);
  static const Color rejectButtonBorder = Color(0xffED0202);

  /// Info banners under each bookings section.
  static const Color todayInfoBannerBackground = Color(0xffECF5FF);
  static const Color waitingInfoBannerBackground = Color(0xffFCEADB);

  // Basic data screen — menu icon badges (background + icon tint pairs)

  static const Color basicDataBlueBadgeBackground = Color(0xffE3F0FF);
  static const Color basicDataBlueBadgeIcon = Color(0xff0B6FB0);

  static const Color basicDataTealBadgeBackground = Color(0xffDFF5F7);
  static const Color basicDataTealBadgeIcon = Color(0xff189AB4);

  static const Color basicDataDarkBlueBadgeBackground = Color(0xffE3F0FF);

  static const Color basicDataPurpleBadgeBackground = Color(0xffEAE6FB);
  static const Color basicDataPurpleBadgeIcon = Color(0xff5B3FD6);

  static const Color basicDataGreenBadgeBackground = Color(0xffE3F8EC);
  static const Color basicDataGreenBadgeIcon = Color(0xff166534);

  static const Color basicDataOrangeBadgeBackground = Color(0xffFCEADB);
  static const Color basicDataOrangeBadgeIcon = Color(0xffC9821A);

  static const Color basicDataEmeraldBadgeBackground = Color(0xffDFF5F0);
  static const Color basicDataEmeraldBadgeIcon = Color(0xff0F766E);

  static const Color basicDataSkyBadgeBackground = Color(0xffE3F0FF);
  static const Color basicDataSkyBadgeIcon = Color(0xff0369A1);

  static const Color basicDataVioletBadgeBackground = Color(0xffEAE6FB);
  static const Color basicDataVioletBadgeIcon = Color(0xff6D28D9);

  static const Color basicDataAmberBadgeBackground = Color(0xffFCF3D8);
  static const Color basicDataAmberBadgeIcon = Color(0xffB8860B);

  static const Color basicDataIndigoBadgeBackground = Color(0xffE4E7FB);
  static const Color basicDataIndigoBadgeIcon = Color(0xff4338CA);

  static const Color basicDataRoseBadgeBackground = Color(0xffFBE4EA);
  static const Color basicDataRoseBadgeIcon = Color(0xffBE185D);

  /// Menu tile card background.
  static const Color basicDataTileBackground = Color(0xffF8FCFF);

  /// Scaffold background — this screen only, distinct from the app-wide
  /// [scaffoldBackGroundColor].
  static const Color basicDataScaffoldBackground = Color(0xffEAF4FD);

  /// Promo banner gradient (top-left → bottom-right) + text colors.
  static const Color basicDataBannerGradientStart = Color(0xffDCEBFB);
  static const Color basicDataBannerGradientEnd = Color(0xffEFF6FD);
  static const Color basicDataBannerTitleColor = Color(0xff0B3C6B);
  static const Color basicDataBannerSubtitleColor = Color(0xff2E6DA4);
  static const Color basicDataBannerBorderColor = Color(0xffBFDCF5);

  // Video call / online examination screen

  /// Patient (main) and doctor (self-view) camera surface background —
  /// shown as a tinted placeholder since there is no live camera feed yet.
  static const Color videoCallPatientSurface = Color(0xffB9C6CE);
  static const Color videoCallDoctorSurface = Color(0xff1F2A33);

  /// Top status pill ("الكشف جاري | 00:00") background + live dot.
  static const Color videoCallStatusPillBackground = Color(0xE5000000);
  static const Color videoCallLiveDotColor = Color(0xff17C964);

  /// Circular icon buttons (shield / more) over the video surface.
  static const Color videoCallOverlayIconBackground = Color(0xB3000000);

  /// Encryption note pill ("جميع البيانات مشفرة وآمنة").
  static const Color videoCallEncryptionPillBackground = Color(0x99000000);

  /// Bottom in-call control buttons (mic / camera / speaker) circle.
  static const Color videoCallControlButtonBackground = Color(0xffFFFFFF);
  static const Color videoCallControlIconColor = Color(0xff1F2A33);

  /// "إنهاء الكشف" end-call button.
  static const Color videoCallEndButtonBackground = Color(0xffED0202);

  /// Bottom sheet holding the quick-action grid.
  static const Color videoCallSheetBackground = Color(0xffFEFEFE);

  /// Quick-action tile backgrounds + icon badge tints (bottom sheet grid).
  static const Color videoCallNewMedicineTileBackground = Color(0xffE3F0FF);
  static const Color videoCallMyMedicinesTileBackground = Color(0xffFFF3E7);
  static const Color videoCallMedicalReportTileBackground = Color(0xffEAE6FB);
  static const Color videoCallMedicalFileTileBackground = Color(0xffE3F8EC);
  static const Color videoCallBookingsTileBackground = Color(0xffDFF5F7);
  static const Color videoCallPrescriptionTileBackground = Color(0xffFBE4EA);

  // ---------------------------------------------------------------------------
  // User type (account picker) screen.
  // ---------------------------------------------------------------------------

  static const Color userTypeScaffoldBackground = Color(0xffF5F9FE);
  static const Color userTypeHeadingColor = Color(0xff0E2A5E);
  static const Color userTypeSubtitleColor = Color(0xff6B7A90);
  static const Color userTypeDescriptionColor = Color(0xff5E6E88);
  static const Color userTypeLogoSysColor = Color(0xff3AA8EC);
  static const Color userTypeFooterColor = Color(0xff3A8DDC);
  static const Color userTypeFooterLineColor = Color(0xffA9CCF0);

  /// "مريض" card.
  static const Color userTypePatientCardStart = Color(0xffECF4FD);
  static const Color userTypePatientCardEnd = Color(0xffF7FAFE);
  static const Color userTypePatientCardBorder = Color(0xffD5E5F6);
  static const Color userTypePatientArrowBackground = Color(0xffDCEAF9);

  /// "طبيب" card.
  static const Color userTypeDoctorCardStart = Color(0xffE7F7F2);
  static const Color userTypeDoctorCardEnd = Color(0xffF4FBF9);
  static const Color userTypeDoctorCardBorder = Color(0xffCDEBE1);
  static const Color userTypeDoctorArrowBackground = Color(0xffD4F0E7);

  /// "مقدم خدمة طبية" card.
  static const Color userTypeProviderCardStart = Color(0xffEFEEFC);
  static const Color userTypeProviderCardEnd = Color(0xffF8F7FE);
  static const Color userTypeProviderCardBorder = Color(0xffDFDDF4);
  static const Color userTypeProviderArrowBackground = Color(0xffE4E1F8);
  static const Color userTypeProviderTitleColor = Color(0xff3A2A93);
}
