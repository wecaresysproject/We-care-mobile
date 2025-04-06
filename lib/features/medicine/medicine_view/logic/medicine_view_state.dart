import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';

class MedicineViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<MedicineModel> userMedicines;
  final MedicineModel? selectestMedicineDetails;
  final List<int> yearsFilter;
  final List<String> medicineNameFilter;
  final bool isDeleteRequest;

  const MedicineViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.medicineNameFilter = const [],
    this.userMedicines = const [],
    this.selectestMedicineDetails,
    this.isDeleteRequest = false,
  });

  factory MedicineViewState.initial() {
    return MedicineViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      medicineNameFilter: const [],
      userMedicines: const [],
      selectestMedicineDetails: null,
      isDeleteRequest: false,
    );
  }

  MedicineViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? medicineNameFilter,
    List<MedicineModel>? userMedicines,
    MedicineModel? selectedSurgeryDetails,
    bool? isDeleteRequest,
  }) {
    return MedicineViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      medicineNameFilter: medicineNameFilter ?? this.medicineNameFilter,
      userMedicines: userMedicines ?? this.userMedicines,
      selectestMedicineDetails: selectedSurgeryDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        yearsFilter,
        medicineNameFilter,
        userMedicines,
        selectestMedicineDetails,
        isDeleteRequest,
      ];
}
