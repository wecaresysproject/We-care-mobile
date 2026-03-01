import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module_guidance_response_model.g.dart';

@JsonSerializable()
class ModuleGuidanceResponseModel extends Equatable {
  final bool success;
  final ModuleGuidanceDataModel? data;

  const ModuleGuidanceResponseModel({
    required this.success,
    this.data,
  });

  factory ModuleGuidanceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleGuidanceResponseModelFromJson(json);

  @override
  List<Object?> get props => [success, data];
}

@JsonSerializable()
class ModuleGuidanceDataModel extends Equatable {
  final String? videoLink;
  final String? moduleGuidanceText;

  const ModuleGuidanceDataModel({
    this.videoLink,
    this.moduleGuidanceText,
  });

  factory ModuleGuidanceDataModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleGuidanceDataModelFromJson(json);

  @override
  List<Object?> get props => [videoLink, moduleGuidanceText];
}
