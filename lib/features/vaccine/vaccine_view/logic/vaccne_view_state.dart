import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';

class VaccineViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<UserVaccineModel> userVaccines;
  final List<int> yearsFilter;
  final List<String> vaccineTypesFilter;
  final UserVaccineModel? selectedVaccine;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const VaccineViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.userVaccines = const [],
    this.yearsFilter = const [],
    this.vaccineTypesFilter = const [],
    this.selectedVaccine,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  factory VaccineViewState.initial() {
    return VaccineViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      userVaccines: [],
      yearsFilter: [],
      vaccineTypesFilter: [],
      selectedVaccine: null,
      isDeleteRequest: false,
      isLoadingMore: false,
    );
  }

  VaccineViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<UserVaccineModel>? userVaccines,
    List<int>? yearsFilter,
    List<String>? vaccineTypesFilter,
    UserVaccineModel? selectedVaccine,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return VaccineViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      userVaccines: userVaccines ?? this.userVaccines,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      vaccineTypesFilter: vaccineTypesFilter ?? this.vaccineTypesFilter,
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        userVaccines,
        yearsFilter,
        vaccineTypesFilter,
        selectedVaccine,
        isDeleteRequest,
        isLoadingMore,
      ];
}
