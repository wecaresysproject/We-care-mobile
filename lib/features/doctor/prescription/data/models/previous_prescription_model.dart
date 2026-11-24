/// "الروشتات القديمة": the prescriptions the calling doctor wrote for this
/// booking's patient in earlier bookings
/// (`GET /DoctorBookings/bookings/previous-prescriptions`).
class PreviousPrescriptionsModel {
  const PreviousPrescriptionsModel({
    required this.patient,
    required this.prescriptions,
  });

  final PrescriptionPatientModel patient;

  /// Newest first.
  final List<PreviousPrescriptionModel> prescriptions;

  factory PreviousPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'];
    final prescriptions = json['prescriptions'];
    return PreviousPrescriptionsModel(
      patient: PrescriptionPatientModel.fromJson(
        patient is Map ? Map<String, dynamic>.from(patient) : const {},
      ),
      prescriptions: (prescriptions is List ? prescriptions : const [])
          .whereType<Map>()
          .map((e) =>
              PreviousPrescriptionModel.fromJson(Map<String, dynamic>.from(e)))
          // A prescription with no page images has nothing to show.
          .where((prescription) => prescription.images.isNotEmpty)
          .toList(),
    );
  }
}

/// The patient card at the top of "روشتات المريض".
class PrescriptionPatientModel {
  const PrescriptionPatientModel({
    required this.name,
    required this.age,
    required this.country,
  });

  final String name;

  /// In years; null when the patient has no birth date.
  final int? age;
  final String country;

  factory PrescriptionPatientModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionPatientModel(
        name: json['name']?.toString().trim() ?? '',
        age: (json['age'] as num?)?.toInt(),
        country: json['country']?.toString().trim() ?? '',
      );
}

/// One row of "روشتات المريض".
class PreviousPrescriptionModel {
  const PreviousPrescriptionModel({
    required this.bookingId,
    required this.date,
    required this.diagnosis,
    required this.images,
  });

  final String bookingId;

  /// The booking date (the date printed on the prescription).
  final DateTime? date;

  /// Empty when the doctor wrote no diagnosis.
  final String diagnosis;

  /// The prescription pages, page 1 first.
  final List<String> images;

  factory PreviousPrescriptionModel.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    final images = json['images'];
    return PreviousPrescriptionModel(
      bookingId: json['bookingId']?.toString() ?? '',
      date: date is String ? DateTime.tryParse(date) : null,
      diagnosis: json['diagnosis']?.toString().trim() ?? '',
      images: (images is List ? images : const [])
          .map((e) => e?.toString().trim() ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
    );
  }
}
