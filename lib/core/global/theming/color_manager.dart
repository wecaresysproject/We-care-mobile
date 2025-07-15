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
}
