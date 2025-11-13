class EyeModuleValidations {
  static String? numericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال هذه القيمه';
    }
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة لـ $fieldName';
    }
    return null;
  }

  // static String? shortSightRangeValidator(String? value) {
  //   final numericError = numericValidator(value, "درجة قصر النظر");
  //   if (numericError != null) return numericError;
  //   final number = double.parse(value!);
  //   if (number > 0 || number < -20) {
  //     return 'من 0 إلى 20- فقط';
  //   }
  //   return null;
  // }

  // static String? longSightRangeValidator(String? value) {
  //   final numericError = numericValidator(value, "درجة طول النظر");
  //   if (numericError != null) return numericError;
  //   final number = double.parse(value!);
  //   if (number < 0 || number > 20) {
  //     return 'من 0 إلى 20 فقط';
  //   }
  //   return null;
  // }
  static String? shortSightValidator(String? value) {
    if (value == null || value.isEmpty) return null; // يسمح بالفاضي
    final number = double.tryParse(value);
    if (number == null) return 'الرجاء إدخال قيمة رقمية صحيحة';
    if (number > 0 || number < -20) return 'من 0 إلى 20- فقط';
    return null;
  }

  static String? longSightValidator(String? value) {
    if (value == null || value.isEmpty) return null; // يسمح بالفاضي
    final number = double.tryParse(value);
    if (number == null) return 'الرجاء إدخال قيمة رقمية صحيحة';
    if (number < 0 || number > 20) return 'من 0 إلى 20 فقط';
    return null;
  }

  static String? optionalNumericValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return 'الرجاء إدخال قيمة رقمية صحيحة لـ $fieldName';
    }
    return null;
  }

  static String? lensThicknessValidator(String? value) {
    return _validateOptionalNumericRange(value, "سُمك العدسة", 0.5, 8.0);
  }

  static String? astigmatismValidator(String? value) {
    return _validateOptionalNumericRange(value, "درجة الاستجماتزم", -6.0, 6.0);
  }

  static String? astigmatismAxisValidator(String? value) {
    return _validateOptionalNumericRange(value, "محور الاستجماتزم", 0.0, 180.0);
  }

  static String? focalAdditionValidator(String? value) {
    return _validateOptionalNumericRange(value, "الإضافة البؤرية", 0.75, 4.0);
  }

  static String? pupilDistanceValidator(String? value) {
    return _validateOptionalNumericRange(value, "تباعد الحدقتين", 48.0, 80.0);
  }

  static String? refractiveIndexValidator(String? value) {
    return _validateOptionalNumericRange(value, "معامل الانكسار", 1.5, 1.74);
  }

  static String? lensDiameterValidator(String? value) {
    return _validateOptionalNumericRange(value, "قطر العدسة", 55.0, 75.0);
  }

  static String? lensCenterValidator(String? value) {
    return _validateOptionalNumericRange(value, "المركز", 0.5, 8);
  }

  static String? pupilDiameterValidator(String? value) {
    return _validateOptionalNumericRange(value, "سمك الحافة", 0.5, 8);
  }

  static String? _validateOptionalNumericRange(
      String? value, String fieldName, double min, double max) {
    if (value == null || value.isEmpty) return null;

    final numError = optionalNumericValidator(value, fieldName);
    if (numError != null) return numError;

    final number = double.parse(value);
    if (number < min || number > max) {
      return 'القيمة بين $min و $max ';
    }
    return null;
  }
}
