import 'package:json_annotation/json_annotation.dart';

part 'get_medicines_filters_response_model.g.dart';

@JsonSerializable()
class GetMedicinesFiltersResponseModel {
  List<int>? years;
  @JsonKey(name: 'medicineNamesf')
  List<String>? medicinesNames;

  GetMedicinesFiltersResponseModel({this.years, this.medicinesNames});

  factory GetMedicinesFiltersResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetMedicinesFiltersResponseModelFromJson(json);
}
