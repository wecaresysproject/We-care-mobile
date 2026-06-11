import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_care_access_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateCareAccessResponse extends Equatable {
  final String requestId;
  final String status;
  final String message;

  const CreateCareAccessResponse({
    required this.requestId,
    required this.status,
    required this.message,
  });

  factory CreateCareAccessResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCareAccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCareAccessResponseToJson(this);

  @override
  List<Object?> get props => [
        requestId,
        status,
        message,
      ];
}
