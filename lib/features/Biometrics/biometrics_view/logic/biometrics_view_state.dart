import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';

class MedicineViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<MedicineModel> userMedicines;
  final MedicineModel? selectestMedicineDetails;
  final List<int> yearsFilter;
  final List<String> medicineNameFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const MedicineViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.medicineNameFilter = const [],
    this.userMedicines = const [],
    this.selectestMedicineDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
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
      isLoadingMore: false,
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
    bool? isLoadingMore,
  }) {
    return MedicineViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      medicineNameFilter: medicineNameFilter ?? this.medicineNameFilter,
      userMedicines: userMedicines ?? this.userMedicines,
      selectestMedicineDetails: selectedSurgeryDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
        isLoadingMore
      ];
}
