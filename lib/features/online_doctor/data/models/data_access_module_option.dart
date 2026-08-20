import 'package:we_care/core/models/medical_module_enum.dart';

/// موديول طبى المريض ممكن يسمح للطبيب بالوصول له أثناء الكشف.
class DataAccessModuleOption {
  const DataAccessModuleOption({
    required this.module,
    required this.label,
    this.isEnabled = true,
    this.iconOverride,
  });

  final MedicalModule module;

  /// الاسم المعروض على الكارت — مختصر عن [MedicalModuleExtension.nameAr]
  /// عشان يوصل فى سطرين على الأكتر جوه الكارت.
  final String label;

  /// الموديول لسه مش مفعّل فى فلو الحجز — بيظهر باهت ومش بيتضغط.
  final bool isEnabled;

  /// بديل لأيقونة شاشة "ملفاتى الطبية" لو الموديول مش من ضمن كروتها
  /// (زى القياسات الحيوية اللى ليها شاشة مستقلة).
  final String? iconOverride;
}
