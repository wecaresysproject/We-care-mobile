import 'package:json_annotation/json_annotation.dart';

part 'medical_category_model.g.dart';

/// =====================
/// 🔢 Selection Type Enum
/// =====================
@JsonEnum(alwaysCreate: true)
enum MedicalSelectionType {
  @JsonValue('selection')
  selection,

  @JsonValue('filters')
  filters,

  @JsonValue('selection_and_filters')
  selectionAndFilters,
}

/// =====================
/// 🧩 Medical Category
/// =====================
@JsonSerializable(explicitToJson: true)
class MedicalCategoryModel {
  final String title;
  final String image;
  final MedicalSelectionType selectionType;
  final List<String> radioOptions;
  final List<MedicalFilterSectionModel>? filterSections;

  const MedicalCategoryModel({
    required this.title,
    required this.image,
    this.selectionType = MedicalSelectionType.selection,
    this.radioOptions = const [],
    this.filterSections = const [],
  });

  factory MedicalCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalCategoryModelToJson(this);
}

/// =====================
/// 📂 Filter Section
/// =====================
@JsonSerializable(explicitToJson: true)
class MedicalFilterSectionModel {
  final String? title;
  final List<MedicalFilterModel> filters;

  const MedicalFilterSectionModel({
    this.title,
    required this.filters,
  });

  factory MedicalFilterSectionModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalFilterSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalFilterSectionModelToJson(this);
}

/// =====================
/// 🏷️ Filter Model
/// =====================
@JsonSerializable()
class MedicalFilterModel {
  final String title;
  final String? displayTitle;
  final List<String> values;

  const MedicalFilterModel({
    required this.title,
    this.displayTitle,
    this.values = const [],
  });

  factory MedicalFilterModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalFilterModelToJson(this);
}
