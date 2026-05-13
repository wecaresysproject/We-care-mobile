import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nutration_facts_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NutrationFactsModel extends Equatable {
  @JsonKey(name: 'userDietplan')
  final String userDietplan;
  @JsonKey(name: 'foodItems')
  final List<FoodItemModel> foodItems;

  const NutrationFactsModel({
    required this.userDietplan,
    required this.foodItems,
  });

  NutrationFactsModel copyWith({
    String? userDietplan,
    List<FoodItemModel>? foodItems,
  }) {
    return NutrationFactsModel(
      userDietplan: userDietplan ?? this.userDietplan,
      foodItems: foodItems ?? this.foodItems,
    );
  }

  factory NutrationFactsModel.fromJson(Map<String, dynamic> json) =>
      _$NutrationFactsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutrationFactsModelToJson(this);

  @override
  List<Object?> get props => [userDietplan, foodItems];
}

@JsonSerializable(explicitToJson: true)
class FoodItemModel extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'extraction_method')
  final String extractionMethod;
  @JsonKey(name: 'amount')
  final double amount;
  @JsonKey(name: 'unit')
  final String unit;
  @JsonKey(name: 'keywords')
  final List<String> keywords;
  @JsonKey(name: 'filters')
  final FoodFiltersModel filters;
  @JsonKey(name: 'filters_alt')
  final FoodFiltersAltModel filtersAlt;

  const FoodItemModel({
    required this.name,
    required this.extractionMethod,
    required this.amount,
    required this.unit,
    required this.keywords,
    required this.filters,
    required this.filtersAlt,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) =>
      _$FoodItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemModelToJson(this);

  @override
  List<Object?> get props => [
        name,
        extractionMethod,
        amount,
        unit,
        keywords,
        filters,
        filtersAlt,
      ];
}

@JsonSerializable()
class FoodFiltersModel extends Equatable {
  @JsonKey(name: 'filter1')
  final String filter1;
  @JsonKey(name: 'filter2')
  final String filter2;
  @JsonKey(name: 'filter3')
  final String filter3;
  @JsonKey(name: 'filter4')
  final String filter4;
  @JsonKey(name: 'filter5')
  final String filter5;
  @JsonKey(name: 'filter6')
  final String filter6;
  @JsonKey(name: 'filter7')
  final String filter7;
  @JsonKey(name: 'filter8')
  final String filter8;

  const FoodFiltersModel({
    required this.filter1,
    required this.filter2,
    required this.filter3,
    required this.filter4,
    required this.filter5,
    required this.filter6,
    required this.filter7,
    required this.filter8,
  });

  factory FoodFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$FoodFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodFiltersModelToJson(this);

  @override
  List<Object?> get props => [
        filter1,
        filter2,
        filter3,
        filter4,
        filter5,
        filter6,
        filter7,
        filter8,
      ];
}

@JsonSerializable()
class FoodFiltersAltModel extends Equatable {
  @JsonKey(name: 'filter1_alt')
  final String filter1Alt;
  @JsonKey(name: 'filter2_alt')
  final String filter2Alt;
  @JsonKey(name: 'filter3_alt')
  final String filter3Alt;

  const FoodFiltersAltModel({
    required this.filter1Alt,
    required this.filter2Alt,
    required this.filter3Alt,
  });

  factory FoodFiltersAltModel.fromJson(Map<String, dynamic> json) =>
      _$FoodFiltersAltModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodFiltersAltModelToJson(this);

  @override
  List<Object?> get props => [filter1Alt, filter2Alt, filter3Alt];
}
