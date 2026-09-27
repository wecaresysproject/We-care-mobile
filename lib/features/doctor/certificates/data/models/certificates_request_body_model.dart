import 'package:we_care/features/doctor/certificates/data/models/certificate_model.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_section_type.dart';

class CertificatesRequestBodyModel {
  final Map<CertificateSectionType, List<CertificateModel>> sections;

  CertificatesRequestBodyModel({required this.sections});

  Map<String, dynamic> toJson() => sections.map(
        (section, certificates) => MapEntry(
          section.name,
          certificates.map((certificate) => certificate.toJson()).toList(),
        ),
      );
}
