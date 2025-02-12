/// Helper Class for Date Validation
class DateValidator {
  static String? getErrorMessage(String input) {
    String text = input.replaceAll('/', ''); // Remove '/' for validation
    if (text.isEmpty) return null; // No error if empty

    if (text.length >= 2) {
      int? day = int.tryParse(text.substring(0, 2));
      if (day == null || day < 1 || day > 31) return "يوم غير صالح (1-31)";
    }

    if (text.length >= 4) {
      int? month = int.tryParse(text.substring(2, 4));
      if (month == null || month < 1 || month > 12) {
        return "شهر غير صالح (1-12)";
      }
    }

    if (text.length == 8) {
      int? year = int.tryParse(text.substring(4, 8));
      if (year == null || year < 1900 || year > DateTime.now().year) {
        return "السنة يجب أن تكون بين 1900 و ${DateTime.now().year}";
      }
    }

    return null; // No error
  }
}
