import 'package:json_annotation/json_annotation.dart';

part 'medical_report_response_model.g.dart';

@JsonSerializable()
class MedicalReportResponseModel {
  @JsonKey(name: 'data')
  final MedicalReportData data;
  final String message;
  final bool success;
  final String? userName;
  final String? imageUrl;

  MedicalReportResponseModel({
    required this.data,
    required this.message,
    required this.success,
    this.userName,
    this.imageUrl,
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
  final ComplaintsModule? complaintsModule;
  final MedicationsModule? medicationsModule;
  final List<MedicalTestModel>? medicalTests;
  final List<SurgeryEntry>? surgeryEntries;
  final List<RadiologyEntry>? radiology;

  MedicalReportData({
    this.basicInformation,
    this.vitalSigns,
    this.chronicDiseases,
    this.complaintsModule,
    this.medicationsModule,
    this.medicalTests,
    this.surgeryEntries,
    this.radiology,
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

@JsonSerializable()
class ComplaintsModule {
  final List<MainComplaint>? mainComplaints;
  final List<AdditionalComplaint>? additionalComplaints;

  ComplaintsModule({
    this.mainComplaints,
    this.additionalComplaints,
  });

  factory ComplaintsModule.fromJson(Map<String, dynamic> json) =>
      _$ComplaintsModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintsModuleToJson(this);
}

@JsonSerializable()
class MainComplaint {
  @JsonKey(name: "dateOfComplaintOnset")
  final String date;
  final String? complaintImage;
  @JsonKey(name: "partOfPlaceOfComplaints")
  final String organ;
  @JsonKey(name: "symptoms_Complaint")
  final String complaintTitle;
  @JsonKey(name: "natureOfComplaint")
  final String complaintNature;
  @JsonKey(name: "severityOfComplaint")
  final String severity;

  MainComplaint({
    required this.date,
    this.complaintImage,
    required this.organ,
    required this.complaintTitle,
    required this.complaintNature,
    required this.severity,
  });

  factory MainComplaint.fromJson(Map<String, dynamic> json) =>
      _$MainComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$MainComplaintToJson(this);
}

@JsonSerializable()
class AdditionalComplaint {
  @JsonKey(name: "dateOfComplaintOnset")
  final String date;

  @JsonKey(name: "complaintImage")
  final String? complaintImage;

  @JsonKey(name: "additionalMedicalComplains")
  final String complaintTitle;

  AdditionalComplaint({
    required this.date,
    this.complaintImage,
    required this.complaintTitle,
  });

  factory AdditionalComplaint.fromJson(Map<String, dynamic> json) =>
      _$AdditionalComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalComplaintToJson(this);
}

@JsonSerializable()
class MedicationsModule {
  final List<MedicationModel>? currentMedications;
  final List<MedicationModel>? expiredLast90Days;

  MedicationsModule({
    this.currentMedications,
    this.expiredLast90Days,
  });

  factory MedicationsModule.fromJson(Map<String, dynamic> json) =>
      _$MedicationsModuleFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsModuleToJson(this);
}

@JsonSerializable()
class MedicationModel {
  @JsonKey(name: "startDate")
  final String date;
  final String medicineName;
  final String? dosage;
  @JsonKey(name: "selectedDoseAmount")
  final String? doseAmount;
  final String? dosageFrequency;
  final String? timeDuration;

  MedicationModel({
    required this.date,
    required this.medicineName,
    this.dosage,
    this.doseAmount,
    this.dosageFrequency,
    this.timeDuration,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationModelToJson(this);
}

@JsonSerializable()
class MedicalTestModel {
  final String testName;
  final String? code;
  final String? group;
  final List<MedicalTestResultModel>? results;

  MedicalTestModel({
    required this.testName,
    this.code,
    this.group,
    this.results,
  });

  factory MedicalTestModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalTestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalTestModelToJson(this);
}

@JsonSerializable()
class MedicalTestResultModel {
  final double? value;
  final String? testDate;

  MedicalTestResultModel({
    this.value,
    this.testDate,
  });

  factory MedicalTestResultModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalTestResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalTestResultModelToJson(this);
}

@JsonSerializable()
class SurgeryEntry {
  final String surgeryName;
  final String surgeryDate;
  final String surgeryRegion;
  final String usedTechnique;
  final String surgeryStatus;
  final String surgeonName;
  final String hospitalCenter;
  final String country;
  final List<String>? medicalReportImage;

  SurgeryEntry({
    required this.surgeryName,
    required this.surgeryDate,
    required this.surgeryRegion,
    required this.usedTechnique,
    required this.surgeryStatus,
    required this.surgeonName,
    required this.hospitalCenter,
    required this.country,
    this.medicalReportImage,
  });

  factory SurgeryEntry.fromJson(Map<String, dynamic> json) =>
      _$SurgeryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$SurgeryEntryToJson(this);
}

@JsonSerializable()
class RadiologyEntry {
  final String radiologyDate;
  final String bodyPart;
  final String radioType;
  final List<String>? xrayImages;
  final List<String>? reportImages;
  final List<String>? periodicUsage;

  RadiologyEntry({
    required this.radiologyDate,
    required this.bodyPart,
    required this.radioType,
    this.xrayImages,
    this.reportImages,
    this.periodicUsage,
  });

  factory RadiologyEntry.fromJson(Map<String, dynamic> json) =>
      _$RadiologyEntryFromJson(json);

  Map<String, dynamic> toJson() => _$RadiologyEntryToJson(this);
}
