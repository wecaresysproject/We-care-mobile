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

  /// True once the medicine status API has answered at least once.
  /// Needed because [isActiveMedicine] defaults to false, so without this flag
  /// "status not loaded yet" and "medicine ended" are indistinguishable.
  final bool isStatusResolved;

  /// The medicine end date as 'yyyy-MM-dd'. Null means unknown (a legacy record,
  /// or a fresh launch before the backend returns it).
  ///
  /// Note: both this field and [isStatusResolved] only ever move forward
  /// (null -> date, false -> true) and there is no re-activation flow, so the
  /// `x ?? this.x` copyWith idiom below is intentional — a null-clearing
  /// sentinel is not needed. The cubit is a get_it factory, so every screen
  /// starts again from [MedicineViewState.initial].
  final String? medicineEndDate;
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
    this.isStatusResolved = false,
    this.medicineEndDate,
    this.isSwitchLoading = false,
    this.switchErrorMessage = '',
    this.moduleGuidanceData,
  });

  /// The medicine is ended only when the status API said so.
  bool get isMedicineEnded => isStatusResolved && !isActiveMedicine;

  /// Ending requires a resolved active status and a loaded medicine (its name is
  /// what the local alarms are keyed by).
  bool get canEndMedicine =>
      isStatusResolved &&
      isActiveMedicine &&
      !isSwitchLoading &&
      selectestMedicineDetails != null;

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
      isStatusResolved: false,
      medicineEndDate: null,
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
    bool? isStatusResolved,
    String? medicineEndDate,
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
      isStatusResolved: isStatusResolved ?? this.isStatusResolved,
      medicineEndDate: medicineEndDate ?? this.medicineEndDate,
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
        isStatusResolved,
        medicineEndDate,
        isSwitchLoading,
        switchErrorMessage,
        moduleGuidanceData,
      ];
}
