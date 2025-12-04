class CrausalMessageModel {
  final String? message;

  CrausalMessageModel({
    this.message,
  });

  factory CrausalMessageModel.fromJson(Map<String, dynamic> json) {
    return CrausalMessageModel(
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
