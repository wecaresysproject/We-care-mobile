import 'package:json_annotation/json_annotation.dart';

part 'medical_report_response_model.g.dart';

@JsonSerializable()
class MedicalReportResponseModel {
  @JsonKey(name: 'data')
  final MedicalReportData data;
  final String message;
  final bool success;

  MedicalReportResponseModel({
    required this.data,
    required this.message,
    required this.success,
  });

  factory MedicalReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportResponseModelToJson(this);
}

@JsonSerializable()
class MedicalReportData {
  @JsonKey(name: 'basicInformation')
  final List<BasicInformationData>? basicInformation;
  final List<VitalSignGroupModel>? vitalSigns;
  final List<ChronicDiseaseModel>? chronicDiseases;

  MedicalReportData({
    this.basicInformation,
    this.vitalSigns,
    this.chronicDiseases,
  });

  factory MedicalReportData.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportDataToJson(this);
}

@JsonSerializable()
class BasicInformationData {
  final String label;
  final dynamic value;

  BasicInformationData({
    required this.label,
    required this.value,
  });

  factory BasicInformationData.fromJson(Map<String, dynamic> json) =>
      _$BasicInformationDataFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInformationDataToJson(this);
}

extension BasicInfoLabelExtension on BasicInformationData {
  String get shortLabel {
    switch (label) {
      case "نوع العجز الجسدي":
        return "نوع العجز";
      default:
        return label;
    }
  }
}

@JsonSerializable()
class VitalSignGroupModel {
  final String categoryName;

  /// List of all readings for this category
  final List<VitalReadingModel> reading;

  VitalSignGroupModel({
    required this.categoryName,
    required this.reading,
  });

  factory VitalSignGroupModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignGroupModelToJson(this);
}

@JsonSerializable()
class VitalReadingModel {
  final String min;
  final String? max; //* needed in case there was pressure reading
  final String date;

  VitalReadingModel({
    required this.min,
    this.max,
    required this.date,
  });

  /// ✅ Always return date in DD/MM/YYYY format
  String get formattedDate {
    try {
      final parsed = DateTime.parse(date);

      return "${parsed.day.toString().padLeft(2, '0')} / "
          "${parsed.month.toString().padLeft(2, '0')} / "
          "${parsed.year}";
    } catch (_) {
      // Already formatted like "16 / 11 / 2025"
      return date;
    }
  }

  factory VitalReadingModel.fromJson(Map<String, dynamic> json) =>
      _$VitalReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalReadingModelToJson(this);
}

@JsonSerializable()
class ChronicDiseaseModel {
  final String diagnosisStartDate;
  final String diseaseName;
  final String diseaseStatus;

  ChronicDiseaseModel({
    required this.diagnosisStartDate,
    required this.diseaseName,
    required this.diseaseStatus,
  });

  String get formattedDate {
    try {
      final parsed = DateTime.parse(diagnosisStartDate);
      return "${parsed.day.toString().padLeft(2, '0')} / ${parsed.month.toString().padLeft(2, '0')} / ${parsed.year}";
    } catch (_) {
      return diagnosisStartDate;
    }
  }

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$ChronicDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChronicDiseaseModelToJson(this);
}
