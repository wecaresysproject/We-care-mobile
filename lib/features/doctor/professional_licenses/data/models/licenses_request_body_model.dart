import 'package:we_care/features/doctor/professional_licenses/data/models/license_model.dart';

class LicensesRequestBodyModel {
  final List<LicenseModel> licenses;

  LicensesRequestBodyModel({required this.licenses});

  Map<String, dynamic> toJson() => {
        'licenses': licenses.map((license) => license.toJson()).toList(),
      };
}
