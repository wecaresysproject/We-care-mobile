import 'package:equatable/equatable.dart';

/// One X-ray requested in the prescription — the X-ray module's fields,
/// without its date and images.
class PrescriptionXRayModel extends Equatable {
  const PrescriptionXRayModel({
    required this.bodyPart,
    required this.type,
    this.purposes = const [],
  });

  factory PrescriptionXRayModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionXRayModel(
        bodyPart: json['bodyPart']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        purposes: [
          for (final purpose in json['purposes'] as List<dynamic>? ?? const [])
            purpose.toString(),
        ],
      );

  Map<String, dynamic> toJson() => {
        'bodyPart': bodyPart,
        'type': type,
        'purposes': purposes,
      };

  /// منطقة الأشعة
  final String bodyPart;

  /// النوع
  final String type;

  /// نوعية الاحتياج للأشعة — optional, can be several.
  final List<String> purposes;

  @override
  List<Object?> get props => [bodyPart, type, purposes];
}
