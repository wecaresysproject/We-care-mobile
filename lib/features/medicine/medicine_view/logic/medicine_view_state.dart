import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
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
  final bool isActiveMedicine;
  final bool isSwitchLoading;
  final String switchErrorMessage;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const MedicineViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.medicineNameFilter = const [],
    this.userMedicines = const [],
    this.selectestMedicineDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
    this.isActiveMedicine = false,
    this.isSwitchLoading = false,
    this.switchErrorMessage = '',
    this.moduleGuidanceData,
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
      isActiveMedicine: false,
      isSwitchLoading: false,
      switchErrorMessage: '',
      moduleGuidanceData: null,
    );
  }

  MedicineViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? medicineNameFilter,
    List<MedicineModel>? userMedicines,
    MedicineModel? selectedMedicineDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
    bool? isActiveMedicine,
    bool? isSwitchLoading,
    String? switchErrorMessage,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return MedicineViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      medicineNameFilter: medicineNameFilter ?? this.medicineNameFilter,
      userMedicines: userMedicines ?? this.userMedicines,
      selectestMedicineDetails:
          selectedMedicineDetails ?? selectestMedicineDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isActiveMedicine: isActiveMedicine ?? this.isActiveMedicine,
      isSwitchLoading: isSwitchLoading ?? this.isSwitchLoading,
      switchErrorMessage: switchErrorMessage ?? this.switchErrorMessage,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
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
        isLoadingMore,
        isActiveMedicine,
        isSwitchLoading,
        switchErrorMessage,
        moduleGuidanceData,
      ];
}
