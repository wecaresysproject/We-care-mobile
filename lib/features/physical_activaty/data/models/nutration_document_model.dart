import 'package:json_annotation/json_annotation.dart';

part 'nutration_document_model.g.dart';

@JsonSerializable()
class NutrationDocument {
  final String nutrient; // البروتين
  final double accumulativeActual; // الكمية التراكمية الفعلية
  final double accumulativeStandard; // الكمية التراكمية المعيارية
  final double difference; // الفرق
  final double percentage; // النسبة
  final bool hasPercentage; // هل يحتوي على نسبة

  NutrationDocument({
    required this.nutrient,
    required this.accumulativeActual,
    required this.accumulativeStandard,
    required this.difference,
    required this.percentage,
    required this.hasPercentage,
  });

  factory NutrationDocument.fromJson(Map<String, dynamic> json) =>
      _$NutrationDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$NutrationDocumentToJson(this);
}
