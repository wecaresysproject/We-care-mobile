import 'package:we_care/features/doctor/professional_licenses/data/models/license_model.dart';

class LicensesRequestBodyModel {
  final List<LicenseModel> licenses;

  LicensesRequestBodyModel({required this.licenses});

  factory LicensesRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      LicensesRequestBodyModel(
        licenses: (json['licenses'] as List? ?? const [])
            .map((e) => LicenseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'licenses': licenses.map((license) => license.toJson()).toList(),
      };
}
