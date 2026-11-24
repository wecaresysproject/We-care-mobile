import 'package:equatable/equatable.dart';

/// A medicine or examination the doctor wrote by hand as free text, with
/// none of the structured fields.
class PrescriptionManualEntryModel extends Equatable {
  const PrescriptionManualEntryModel({required this.details});

  /// The backend stores manual entries as plain strings.
  factory PrescriptionManualEntryModel.fromJson(Object? value) =>
      PrescriptionManualEntryModel(details: value?.toString() ?? '');

  String toJson() => details;

  /// تفاصيل الدواء / تفاصيل الفحص
  final String details;

  @override
  List<Object?> get props => [details];
}
