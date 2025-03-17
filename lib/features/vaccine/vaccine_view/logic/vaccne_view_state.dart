import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';

class VaccineViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<UserVaccineModel> userVaccines;
  final List<int> yearsFilter;
  final List<String> vaccineTypesFilter;

  const VaccineViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.userVaccines = const [],
    this.yearsFilter = const [],
    this.vaccineTypesFilter = const [],
  });

  factory VaccineViewState.initial() {
    return VaccineViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      userVaccines: [],
      yearsFilter: [],
      vaccineTypesFilter: [],
    );
  }

  VaccineViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<UserVaccineModel>? userVaccines,
    List<int>? yearsFilter,
    List<String>? vaccineTypesFilter,
  }) {
    return VaccineViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      userVaccines: userVaccines ?? this.userVaccines,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      vaccineTypesFilter: vaccineTypesFilter ?? this.vaccineTypesFilter,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        userVaccines,
        yearsFilter,
      ];
}
