class OnlineDoctorApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  /// قايمة الأطباء حسب التخصص — `?specialty=`.
  static const getDoctorsBySpecialty = "/OnlineDoctor";

  /// ملف طبيب واحد — `?doctorId=`.
  static const getDoctorProfile = "/OnlineDoctor/profile";

  /// إضافة/إزالة طبيب من المفضلة — `POST` / `DELETE` بنفس المسار و`?doctorId=`.
  static const favoriteDoctor = "/OnlineDoctor/favorite";
}
