import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';

class VaccineViewState extends Equatable {
  final RequestStatus requestStatus;
  final String message;
  final List<UserVaccineModel> userVaccines;
  final List<int> yearsFilter;
  final List<String> vaccineTypesFilter;
  final UserVaccineModel? selectedVaccine;
  final bool isDeleteRequest;
  final bool isLoadingMore;
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final List<String> userSubmissionDates;
  final RequestStatus userSubmissionDatesStatus;
  final String? selectedDateFrom;
  final String? selectedDateTo;

  const VaccineViewState({
    this.message = '',
    this.requestStatus = RequestStatus.initial,
    this.userSubmissionDatesStatus = RequestStatus.initial,
    this.userVaccines = const [],
    this.yearsFilter = const [],
    this.vaccineTypesFilter = const [],
    this.userSubmissionDates = const [],
    this.selectedDateFrom,
    this.selectedDateTo,
    this.selectedVaccine,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
    this.moduleGuidanceData,
  });

  factory VaccineViewState.initial() {
    return VaccineViewState(
      message: '',
      requestStatus: RequestStatus.initial,
      userSubmissionDatesStatus: RequestStatus.initial,
      userVaccines: [],
      yearsFilter: [],
      vaccineTypesFilter: [],
      userSubmissionDates: [],
      selectedDateFrom: null,
      selectedDateTo: null,
      selectedVaccine: null,
      isDeleteRequest: false,
      isLoadingMore: false,
      moduleGuidanceData: null,
    );
  }

  VaccineViewState copyWith({
    String? message,
    RequestStatus? requestStatus,
    RequestStatus? userSubmissionDatesStatus,
    List<UserVaccineModel>? userVaccines,
    List<int>? yearsFilter,
    List<String>? vaccineTypesFilter,
    List<String>? userSubmissionDates,
    UserVaccineModel? selectedVaccine,
    String? selectedDateFrom,
    String? selectedDateTo,
    bool? isDeleteRequest,
    bool? isLoadingMore,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return VaccineViewState(
      message: message ?? this.message,
      requestStatus: requestStatus ?? this.requestStatus,
      userSubmissionDatesStatus:
          userSubmissionDatesStatus ?? this.userSubmissionDatesStatus,
      userVaccines: userVaccines ?? this.userVaccines,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      vaccineTypesFilter: vaccineTypesFilter ?? this.vaccineTypesFilter,
      userSubmissionDates: userSubmissionDates ?? this.userSubmissionDates,
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      selectedDateFrom: selectedDateFrom ?? this.selectedDateFrom,
      selectedDateTo: selectedDateTo ?? this.selectedDateTo,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        message,
        requestStatus,
        userSubmissionDatesStatus,
        userVaccines,
        yearsFilter,
        vaccineTypesFilter,
        userSubmissionDates,
        selectedDateFrom,
        selectedDateTo,
        selectedVaccine,
        isDeleteRequest,
        isLoadingMore,
        moduleGuidanceData,
      ];
}
