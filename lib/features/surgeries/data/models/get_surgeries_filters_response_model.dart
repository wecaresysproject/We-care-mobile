import 'package:json_annotation/json_annotation.dart';

part 'get_surgeries_filters_response_model.g.dart';

@JsonSerializable()
class GetSurgeriesFiltersResponseModel {
  List<int>? years;
  List<String>? surgeryRegion;

  GetSurgeriesFiltersResponseModel({
    this.years,
    this.surgeryRegion,
  });

  factory GetSurgeriesFiltersResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetSurgeriesFiltersResponseModelFromJson(json);
}
