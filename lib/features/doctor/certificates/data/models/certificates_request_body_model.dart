import 'package:we_care/features/doctor/certificates/data/models/certificate_model.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_section_type.dart';

class CertificatesRequestBodyModel {
  final Map<CertificateSectionType, List<CertificateModel>> sections;

  CertificatesRequestBodyModel({required this.sections});

  /// Reads all six section keys; a missing key counts as an empty section.
  factory CertificatesRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      CertificatesRequestBodyModel(
        sections: {
          for (final section in CertificateSectionType.values)
            section: (json[section.name] as List? ?? const [])
                .map(
                  (e) => CertificateModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
        },
      );

  Map<String, dynamic> toJson() => sections.map(
        (section, certificates) => MapEntry(
          section.name,
          certificates.map((certificate) => certificate.toJson()).toList(),
        ),
      );
}
