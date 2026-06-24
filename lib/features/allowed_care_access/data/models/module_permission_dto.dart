import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module_permission_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ModulePermissionDto extends Equatable {
  final String moduleName;
  final String permission;
  final bool isEnabledModule;

  const ModulePermissionDto({
    required this.moduleName,
    required this.permission,
    this.isEnabledModule = false,
  });

  factory ModulePermissionDto.fromJson(Map<String, dynamic> json) =>
      _$ModulePermissionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModulePermissionDtoToJson(this);

  @override
  List<Object?> get props => [moduleName, permission, isEnabledModule];
}
