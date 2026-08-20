/// مناطق الفم غير السنية فى مخطط الأسنان.
///
/// الأكواد دى **مش** أرقام أسنان FDI — دى أكواد متفق عليها للأزرار اللى
/// بتتضغط فى `ToothOverlay` (اللثة والفكين). أرقام الأسنان الحقيقية فى
/// التطبيق هى الدائمة بس (11-48)، فمفيش تعارض بينها وبين الأكواد دى.
///
/// المصدر الوحيد لأسماء المناطق — أى شاشة محتاجة تعرض اسم المنطقة بدل
/// "السن رقم كذا" لازم تعدى من هنا.
class DentalMouthRegions {
  const DentalMouthRegions._();

  static const Map<int, String> names = {
    55: 'اللثة العلوية يسار',
    66: 'اللثة العلوية يمين',
    77: 'اللثة السفلية يسار',
    88: 'اللثة السفلية يمين',
    99: 'الفك العلوي',
    100: 'الفك السفلي',
    111: 'اللثة العلوية',
    122: 'اللثة السفلية',
  };

  /// اسم المنطقة لو الكود بتاع منطقة، وnull لو رقم سن عادى.
  static String? nameOf(String? code) {
    final parsed = int.tryParse(code?.trim() ?? '');
    return parsed == null ? null : names[parsed];
  }

  static bool isRegion(String? code) => nameOf(code) != null;

  /// عنوان شاشة الإدخال/التفاصيل:
  /// للمناطق → "البيانات الخاصة باللثة العلوية يمين"
  /// وللأسنان → "البيانات الخاصة بالسن رقم 24"
  static String dataTitleFor(String? code) {
    final region = nameOf(code);
    return region != null
        ? 'البيانات الخاصة ب$region'
        : 'البيانات الخاصة بالسن رقم $code';
  }

  /// عنوان مختصر للكروت: اسم المنطقة، أو "السن 24".
  static String shortLabelFor(String? code) => nameOf(code) ?? 'السن $code';
}
