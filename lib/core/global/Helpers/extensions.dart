import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';

import '../../../generated/l10n.dart';

extension BuildContextOperations on BuildContext {
  S get translate => S.of(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorSchemeTheme => Theme.of(this).colorScheme;

  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  ///Dont show bottom nav bar in the pushed page
  Future<dynamic> pushNamedWithSettingRootNavigator(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
      rootNavigator: true,
    ).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop({Object? result}) => Navigator.of(
        this,
      ).pop(result);

  /// Show a standard SnackBar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = Colors.black,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(this).textTheme.headlineMedium,
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

extension MedicalRangeParsing on String {
  double? get minValue {
    String value = trim();

    if (value.startsWith('<') || value.endsWith('>')) {
      return null; // No lower bound
    } else if (value.startsWith('>') || value.endsWith('<')) {
      return double.tryParse(
          value.replaceAll(RegExp(r'[<>]'), '').trim()); // Min value exists
    } else if (value.contains('-') || value.contains(':')) {
      return double.tryParse(value.split(RegExp(r'[-:]'))[0].trim());
    } else {
      return double.tryParse(value);
    }
  }

  double? get maxValue {
    String value = trim();

    if (value.startsWith('<') || value.endsWith('>')) {
      return double.tryParse(
          value.replaceAll(RegExp(r'[<>]'), '').trim()); // Max value exists
    } else if (value.startsWith('>') || value.endsWith('<')) {
      return null; // No upper bound
    } else if (value.contains('-') || value.contains(':')) {
      var parts = value.split(RegExp(r'[-:]')).map((e) => e.trim()).toList();
      return parts.length > 1 ? double.tryParse(parts[1]) : null;
    } else {
      return double.tryParse(value);
    }
  }
}

extension PaddingListOperations on List<Widget> {
  List<Widget> paddingFrom({
    double? top,
    double? bottom,
    double? right,
    double? left,
  }) {
    return map(
      (listOneChild) => Padding(
        padding: EdgeInsets.only(
          bottom: (bottom ?? 0).h,
          right: (right ?? 0).w,
          left: (left ?? 0).w,
          top: (top ?? 0).h,
        ),
        child: listOneChild,
      ),
    ).toList();
  }

  List<Widget> paddingFromSymmetric({double? vertical, double? horizontal}) {
    return map(
      (e) => Padding(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: (vertical ?? 0).h,
          horizontal: (horizontal ?? 0).w,
        ),
        child: e,
      ),
    ).toList();
  }
}

extension PaddingExtension on Widget {
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding.r),
      child: this,
    );
  }

  Widget paddingFrom({
    double? top,
    double? bottom,
    double? right,
    double? left,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: (top ?? 0).h,
        bottom: (bottom ?? 0).h,
        left: (left ?? 0).w,
        right: (right ?? 0).w,
      ),
      child: this,
    );
  }

  Widget paddingSymmetricHorizontal(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: this,
    );
  }

  Widget paddingSymmetricVertical(double verticalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
      child: this,
    );
  }

  Widget paddingLeft(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding.w),
      child: this,
    );
  }

  Widget paddingRight(double rightPadding) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding.w),
      child: this,
    );
  }

  Widget paddingTop(double topPadding) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding.h),
      child: this,
    );
  }

  Widget paddingBottom(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: this,
    );
  }
}

// check for nullabilty over all types
extension NullableExtension<T> on T? {
  bool get isNotNull => this != null;
  bool get isNull => this == null;
}

extension StringExtensions on String? {
  int get toInt => int.parse(this!);
  bool get isEmptyOrNull => this == '' || this == null;
  bool get isNotEmptyOrNull => this != '' && this != null;

  String get firstLetterToUpperCase =>
      this![0].toUpperCase() + this!.substring(1);
}

extension StringCheckExtension on String? {
  bool get isFilled {
    final trimmed = this?.trim() ?? '';

    return trimmed.isNotEmpty &&
        trimmed != '-' &&
        trimmed != '--' &&
        trimmed != 'لم يتم ادخال بيانات';
  }

  bool get isNotFilled => !isFilled;
}

extension NameExtensions on String {
  String get firstAndLastName {
    final cleaned = trim();

    final parts = cleaned.split(' ').where((word) => word.isNotEmpty).toList();

    if (parts.isEmpty) return 'user name';
    if (parts.length == 1) return parts.first;

    return '${parts.first} ${parts.last}';
  }
}

extension PhoneValidation on String {
  String? validateEgyptPhone() {
    final trimmed = trim();

    if (trimmed.isEmpty) {
      return 'رقم التليفون مطلوب';
    }

    if (trimmed.length != 11) {
      return 'رقم التليفون يجب أن يكون 11 رقماً';
    }

    return null; // validation passed
  }
}

extension WidgetVisibility on Widget {
  Widget visible(bool isVisible) {
    return isVisible ? this : const SizedBox.shrink();
  }
}

extension ArabicTimeFormat on DateTime {
  String toArabicTime() {
    String time = DateFormat('h:mm a', 'ar').format(this);
    return time
        .replaceAll('AM', 'ص')
        .replaceAll('PM', 'م')
        .replaceAll('ص', 'ص')
        .replaceAll('م', 'م'); // extra safety
  }
}

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.normal:
        return 'طبيعي';
      case RiskLevel.underObservation:
        return 'مراقبة';
      case RiskLevel.partialRisk:
        return 'خطر جزئي';
      case RiskLevel.confirmedRisk:
        return 'خطر مؤكد';
    }
  }
}

extension NumberFormattingExtension on String {
  /// Converts numeric strings like "18000" → "18,000"
  /// If the string isn't a valid number, returns it unchanged.
  String get formattedWithCommas {
    final num? number = num.tryParse(replaceAll(',', '').trim());
    if (number == null) return this;
    return NumberFormat.decimalPattern('en').format(number);
  }

  /// Converts Arabic text to be safe for PDF generation
  /// example : "½" → "1/2", "¾" → "3/4"
  String toPdfSafeDosage() {
    return sanitizeDosageForPdf(this);
  }
}

extension WeCareMedicalModulesExtension on WeCareMedicalModules {
  String get titleEn {
    switch (this) {
      case WeCareMedicalModules.profile:
        return "Profile";
      case WeCareMedicalModules.vitalSigns:
        return "Vital Signs";
      case WeCareMedicalModules.medications:
        return "Medications";
      case WeCareMedicalModules.emergenciesComplaints:
        return "Emergencies Complaints";
      case WeCareMedicalModules.prescriptions:
        return "Prescriptions";
      case WeCareMedicalModules.labTests:
        return "Lab Tests";
      case WeCareMedicalModules.imagingAndRadiology:
        return "Imaging & Radiology";
      case WeCareMedicalModules.surgeries:
        return "Surgeries";
      case WeCareMedicalModules.chronicDiseases:
        return "Chronic Diseases";
      case WeCareMedicalModules.geneticDiseases:
        return "Genetic Diseases";
      case WeCareMedicalModules.allergies:
        return "Allergies";
      case WeCareMedicalModules.ophthalmology:
        return "Ophthalmology";
      case WeCareMedicalModules.dentistry:
        return "Dentistry";
      case WeCareMedicalModules.vaccinations:
        return "Vaccinations";
      case WeCareMedicalModules.mentalHealth:
        return "Mental Health";
      case WeCareMedicalModules.nutrition:
        return "Nutrition";
      case WeCareMedicalModules.physicalActivity:
        return "Physical Activity";
      case WeCareMedicalModules.vitaminsAndSupplements:
        return "Vitamins and Supplements";
      case WeCareMedicalModules.endoscopy:
        return "Endoscopy";
      case WeCareMedicalModules.oncology:
        return "Oncology";
      case WeCareMedicalModules.renalDialysis:
        return "Renal Dialysis";
      case WeCareMedicalModules.physicalTherapy:
        return "Physical Therapy";
      case WeCareMedicalModules.pregnancyMonitoring:
        return "Pregnancy Monitoring";
      case WeCareMedicalModules.infertility:
        return "Infertility";
      case WeCareMedicalModules.burns:
        return "Burns";
      case WeCareMedicalModules.cosmeticSurgery:
        return "Cosmetic Surgery";
      case WeCareMedicalModules.highRiskBehaviors:
        return "High-Risk Behaviors";
      case WeCareMedicalModules.publicHealth:
        return "Public Health";
      case WeCareMedicalModules.drugCheck:
        return "Drug Check";
      case WeCareMedicalModules.homeVisit:
        return "Home Visit";
      case WeCareMedicalModules.onlineDoctorConsultation:
        return "Online Doctor Consultation";
      case WeCareMedicalModules.aiConsult:
        return "AI Consult";
      case WeCareMedicalModules.myGenetics:
        return "My Genetics";
      case WeCareMedicalModules.patientSupport:
        return "Patient Support";
      case WeCareMedicalModules.myMedicalReports:
        return "My Medical Reports";
      case WeCareMedicalModules.lifeQuality:
        return "Life Quality";
      case WeCareMedicalModules.findADoctor:
        return "Find a Doctor";
      case WeCareMedicalModules.doctorRatings:
        return "Doctor Ratings";
      case WeCareMedicalModules.dataCompletion:
        return "Data Completion";
      case WeCareMedicalModules.healthRiskIndicators:
        return "Health Risk Indicators";
    }
  }

  String get titleAr {
    switch (this) {
      case WeCareMedicalModules.profile:
        return "البيانات الأساسية";
      case WeCareMedicalModules.vitalSigns:
        return "القياسات الحيوية";
      case WeCareMedicalModules.medications:
        return "الأدوية";
      case WeCareMedicalModules.emergenciesComplaints:
        return "الشكاوى الطارئة";
      case WeCareMedicalModules.prescriptions:
        return "روشتة الأطباء";
      case WeCareMedicalModules.labTests:
        return "التحاليل الطبية";
      case WeCareMedicalModules.imagingAndRadiology:
        return "الأشعة";
      case WeCareMedicalModules.surgeries:
        return "العمليات الجراحية";
      case WeCareMedicalModules.chronicDiseases:
        return "الأمراض المزمنة";
      case WeCareMedicalModules.geneticDiseases:
        return "الأمراض الوراثية";
      case WeCareMedicalModules.allergies:
        return "الحساسية";
      case WeCareMedicalModules.ophthalmology:
        return "العيون";
      case WeCareMedicalModules.dentistry:
        return "الأسنان";
      case WeCareMedicalModules.vaccinations:
        return "التطعيمات";
      case WeCareMedicalModules.mentalHealth:
        return "الأمراض النفسية";
      case WeCareMedicalModules.nutrition:
        return "المتابعة الغذائية";
      case WeCareMedicalModules.physicalActivity:
        return "النشاط الرياضي";
      case WeCareMedicalModules.vitaminsAndSupplements:
        return "الفيتامينات و المكملات الغذائية";
      case WeCareMedicalModules.endoscopy:
        return "المناظير الطبية";
      case WeCareMedicalModules.oncology:
        return "الأورام";
      case WeCareMedicalModules.renalDialysis:
        return "الغسيل الكلوي";
      case WeCareMedicalModules.physicalTherapy:
        return "العلاج الطبيعي";
      case WeCareMedicalModules.pregnancyMonitoring:
        return "متابعة الحمل";
      case WeCareMedicalModules.infertility:
        return "علاج مشاكل الإنجاب";
      case WeCareMedicalModules.burns:
        return "الحروق";
      case WeCareMedicalModules.cosmeticSurgery:
        return "الجراحات التجميلية";
      case WeCareMedicalModules.highRiskBehaviors:
        return "السلوكيات الخطرة";
      case WeCareMedicalModules.publicHealth:
        return "الصحة العامة";
      case WeCareMedicalModules.drugCheck:
        return "اختبار توافق ادويتي";
      case WeCareMedicalModules.homeVisit:
        return "زيارة طبية للمنزل";
      case WeCareMedicalModules.onlineDoctorConsultation:
        return "طبيبك أونلاين";
      case WeCareMedicalModules.aiConsult:
        return "استشر الـ AI";
      case WeCareMedicalModules.myGenetics:
        return "أمراضي الوراثية";
      case WeCareMedicalModules.patientSupport:
        return "لست وحدك";
      case WeCareMedicalModules.myMedicalReports:
        return "تقاريري الطبية";
      case WeCareMedicalModules.lifeQuality:
        return "جودة الحياة";
      case WeCareMedicalModules.findADoctor:
        return "بحث عن طبيب";
      case WeCareMedicalModules.doctorRatings:
        return "تقييم الأطباء";
      case WeCareMedicalModules.dataCompletion:
        return "اكتمال البيانات";
      case WeCareMedicalModules.healthRiskIndicators:
        return "مؤشرات المخاطر الصحية";
    }
  }
}
