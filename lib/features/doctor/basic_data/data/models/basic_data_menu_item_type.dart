import 'package:json_annotation/json_annotation.dart';

/// One tile in the Basic Data menu grid.
enum BasicDataMenuItemType {
  @JsonValue('bank_info')
  bankInfo,
  @JsonValue('medical_specialty')
  medicalSpecialty,
  @JsonValue('basic_data')
  basicData,
  @JsonValue('membership')
  membership,
  @JsonValue('experience')
  experience,
  @JsonValue('awards')
  awards,
  @JsonValue('legal_references')
  legalReferences,
  @JsonValue('research_and_messages')
  researchAndMessages,
  @JsonValue('booking_and_contact')
  bookingAndContact,
  @JsonValue('booking_settings')
  bookingSettings,
  @JsonValue('service_prices')
  servicePrices,
  @JsonValue('monthly_examination_target')
  monthlyExaminationTarget,
  @JsonValue('certificates')
  certificates,
  @JsonValue('professional_licenses')
  professionalLicenses,
  @JsonValue('media_and_articles')
  mediaAndArticles,
}
