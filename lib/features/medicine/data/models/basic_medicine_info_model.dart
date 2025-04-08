import 'package:json_annotation/json_annotation.dart';

part 'basic_medicine_info_model.g.dart';

@JsonSerializable()
class MedicineBasicInfoModel {
  final String id;
  final String tradeName;

  MedicineBasicInfoModel({
    required this.id,
    required this.tradeName,
  });

  factory MedicineBasicInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineBasicInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineBasicInfoModelToJson(this);
}
