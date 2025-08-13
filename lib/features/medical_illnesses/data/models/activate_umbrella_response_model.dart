import 'package:json_annotation/json_annotation.dart';

part 'activate_umbrella_response_model.g.dart';

@JsonSerializable()
class ActivateUmbrellaResponse {
  final String message;
  final bool isActivated;

  ActivateUmbrellaResponse({
    required this.message,
    required this.isActivated,
  });

  factory ActivateUmbrellaResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivateUmbrellaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActivateUmbrellaResponseToJson(this);
}
