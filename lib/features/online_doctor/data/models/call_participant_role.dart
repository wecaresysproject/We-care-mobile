/// دور الشخص فى مكالمة الكشف — بيتكتب جنب اسمه جوه Jitsi
/// ("محمد أحمد · المريض") عشان كل طرف يعرف مين اللى دخل الغرفة.
enum CallParticipantRole {
  doctor('الطبيب'),
  patient('المريض'),
  participant('مشارك');

  const CallParticipantRole(this.label);

  final String label;

  /// قيمة `role` من `GET /Video` — `null` لو مش معروفة.
  static CallParticipantRole? fromApi(String? value) {
    for (final role in values) {
      if (role.name == value?.toLowerCase()) return role;
    }
    return null;
  }

  /// الاسم اللى بيظهر جوه Jitsi — الدور لوحده لو الاسم فاضى.
  String displayNameFor(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? label : "$trimmed · $label";
  }

  /// الدور من اسم الشخص جوه Jitsi — `null` لو الاسم مفيهوش دور.
  static CallParticipantRole? ofDisplayName(String displayName) {
    final trimmed = displayName.trim();
    for (final role in values) {
      if (trimmed == role.label || trimmed.endsWith(" · ${role.label}")) {
        return role;
      }
    }
    return null;
  }
}
