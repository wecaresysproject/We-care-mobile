import 'package:json_annotation/json_annotation.dart';

part 'matched_medicines_model.g.dart';

@JsonSerializable()
class MatchedMedicineModel {
  final String id;
   @JsonKey(name: 'tradeName')
  final String medicineName;

  MatchedMedicineModel({
    required this.id,
    required this.medicineName,
  });

  factory MatchedMedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MatchedMedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchedMedicineModelToJson(this);
}
