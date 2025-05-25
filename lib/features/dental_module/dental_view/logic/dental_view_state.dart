import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_documents_reponse_model.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';

class DentalViewState extends Equatable {
  final RequestStatus requestStatus;
  final String? message;
  final List<int>? defectedToothList;
  final List<ToothDocument>? selectedToothList;
  final bool? isLoadingMore;
  final bool? hasMore;
  final int? currentPage;
  final ToothOperationDetails ? selectedToothOperationDetails;
  final bool isDeleteRequest;

  const DentalViewState({
    this.requestStatus = RequestStatus.initial,
    this.message,
    this.defectedToothList,
    this.selectedToothList,
    this.isLoadingMore,
    this.hasMore,
    this.currentPage,
    this.selectedToothOperationDetails,
    this.isDeleteRequest = false,
  });
  const DentalViewState.initial()
      : requestStatus = RequestStatus.initial,
        message = null,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 1,
        selectedToothOperationDetails = null,
        isDeleteRequest = false,
        selectedToothList = null,
        defectedToothList = null;

        
  
  @override
  List<Object?> get props => [message, defectedToothList, requestStatus, selectedToothList, isLoadingMore,  
   hasMore, currentPage, selectedToothOperationDetails, isDeleteRequest];

  DentalViewState copyWith({
    String? message,
    List<int>? defectedToothList,
    RequestStatus? requestStatus,
    List<ToothDocument>? selectedToothList,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    ToothOperationDetails ? selectedToothOperationDetails,
    bool? isDeleteRequest,
  }) {
    return DentalViewState(
      message: message ?? this.message,
      defectedToothList: defectedToothList ?? this.defectedToothList,
      requestStatus: requestStatus ?? this.requestStatus,
      selectedToothList: selectedToothList ?? this.selectedToothList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      selectedToothOperationDetails: selectedToothOperationDetails ?? this.selectedToothOperationDetails,
    );
  }

} 