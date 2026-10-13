/// طبيب واحد فى قايمة فلتر "إسم الطبيب" — الاسم بيتعرض والـ `id` بيتبعت.
class BookingHistoryFilterDoctor {
  const BookingHistoryFilterDoctor({required this.id, required this.name});

  factory BookingHistoryFilterDoctor.fromJson(Map<String, dynamic> json) =>
      BookingHistoryFilterDoctor(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
      );

  final String id;
  final String name;
}

/// قيم فلترين شاشة "السجل السابق" — من سجل المريض نفسه مش كل أطباء النظام.
class BookingHistoryFiltersModel {
  const BookingHistoryFiltersModel({
    this.doctors = const [],
    this.specialties = const [],
  });

  factory BookingHistoryFiltersModel.fromJson(Map<String, dynamic> json) =>
      BookingHistoryFiltersModel(
        doctors: (json['doctors'] as List? ?? const [])
            .map((e) =>
                BookingHistoryFilterDoctor.fromJson(e as Map<String, dynamic>))
            .toList(),
        specialties:
            (json['specialties'] as List? ?? const []).cast<String>().toList(),
      );

  final List<BookingHistoryFilterDoctor> doctors;
  final List<String> specialties;
}
