import 'package:flutter/material.dart';

/// ألوان شاشة "طبيبك أون لاين" المأخوذة من ملف التصميم.
class OnlineDoctorTheme {
  const OnlineDoctorTheme._();

  static const Color headingColor = Color(0xFF0A3D6B);
  static const Color bodyColor = Color(0xFF7A8B9C);
  static const Color iconTint = Color(0xFFE8F2FC);
  static const Color cardSurface = Color(0xFFF7FAFD);
  static const Color cardBorder = Color(0xFFE3EDF7);

  /// خلفية كارت الطبيب فى شاشة "البحث عن طبيب".
  static const Color doctorCardSurface = Color(0xFFE9F1FB);

  /// حدود عناصر الترتيب وحقل البحث فى نفس الشاشة.
  static const Color fieldBorder = Color(0xFFE2EAF3);

  /// الفاصل الرأسى بين التقييم والإعجابات والتعليقات.
  static const Color statsDivider = Color(0xFFBACFE6);

  /// النص الرمادى الصغير — جهة العمل والتنويه أسفل الشاشة.
  static const Color mutedText = Color(0xFF6B7F94);

  static const Color onlineGreen = Colors.green;
  static const Color offlineRed = Color(0xFFE02B2B);
  static const Color likesBlue = Color(0xFF1A73E8);
  static const Color ratingAmber = Color(0xFFF8B912);

  /// الأزرق الفاتح المستخدم فى أيقونات وقيم ملف الطبيب.
  static const Color accentBlue = Color(0xFF2563EB);

  /// خلفية كروت الأقسام القابلة للطى فى ملف الطبيب.
  static const Color sectionSurface = Color(0xFFF7FAFD);

  /// حدود كروت ملف الطبيب.
  static const Color sectionBorder = Color(0xFFE7EDF5);

  /// خلفية كارت "معلومات الحجز".
  static const Color bookingSurface = Color(0xFFF2F7FE);

  /// خلفية الدائرة اللى ورا أيقونات "معلومات الحجز".
  static const Color iconBadgeSurface = Color(0xFFE3EDFB);

  /// نص الفقرات داخل أقسام ملف الطبيب.
  static const Color sectionBodyText = Color(0xFF44566C);

  /// خلفية الشيبس — زى شيبس اللغات فى ملف الطبيب.
  static const Color chipSurface = Color(0xFFEFF4FA);

  /// الخط الفاصل بين أعمدة "معلومات الحجز".
  static const Color columnDivider = Color(0xFFCFDDEE);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFF3F8FD), Color(0xFFE3F0FC)],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [Color(0xFF0C4A80), Color(0xFF04203D)],
  );

  static const LinearGradient shieldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6FAEE8), Color(0xFF014C8A)],
  );

  /// خلفية عناوين الأقسام فى شاشة "حجز موعد".
  static const LinearGradient sectionHeaderGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
  );

  /// خلفية الكروت الزجاجية — كروت المواعيد ومدة الوصول وكروت الموديولات.
  static const LinearGradient glassCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x73AACFF8), Color(0x4FF0EFEF)],
  );

  /// حدود الكارت الزجاجى وهو غير مختار.
  static const Color glassCardBorder = Color(0x80FBFBFB);

  /// أخضر الاستشارة — بادچ وزرار الدخول فى كروت "استشارة المتابعة" بشاشة "حجوزاتى".
  static const Color consultationGreen = Color(0xFF16A34A);

  /// خلفية بادچ الاستشارة الفاتحة.
  static const Color consultationSurface = Color(0xFFE7F6EC);

  /// خلفية شيب العد التنازلى "متبقى على الكشف".
  static const Color countdownSurface = Color(0xFFFBF4DD);

  /// حدود شيب العد التنازلى.
  static const Color countdownBorder = Color(0xFFF0E3BC);

  /// لون أيقونة الساعة الرملية فى شيب العد التنازلى.
  static const Color countdownAmber = Color(0xFFD8A511);

  /// نص العد التنازلى الغامق جوه الشيب.
  static const Color countdownText = Color(0xFF2D2D2D);

  /// الخط الفاصل فوق وبين أزرار "إلغاء الموعد" و"تعديل الموعد".
  static const Color footerDivider = Color(0xFFEDF2F8);

  /// خلفية كارت "أسئلتى للطبيب" فى شاشة غرفة الكشف — أصفر أفتح من شيب العد.
  static const Color questionsSurface = Color(0xFFFDF9EC);

  /// حدود كارت "أسئلتى للطبيب".
  static const Color questionsBorder = Color(0xFFF3E9C8);
}
