import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_documents_reponse_model.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';

@immutable
class DentalViewState extends Equatable {
  final RequestStatus requestStatus;
  final String? message;
  final List<int>? defectedToothList;
  final List<int>? filteredDefectedToothList;
  final List<ToothDocument>? selectedToothList;
  final bool? isLoadingMore;
  final bool? hasMore;
  final int? currentPage;
  final ToothOperationDetails ? selectedToothOperationDetails;
  final bool isDeleteRequest;
  final List<int>? yearsFilter;
  final List<String>? toothNumberFilter;
  final List<String>? procedureTypeFilter;

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
    this.yearsFilter,
    this.toothNumberFilter,
    this.procedureTypeFilter,
    this.filteredDefectedToothList,
  });
  const DentalViewState.initial()
      : requestStatus = RequestStatus.initial,
        message = null,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 1,
        selectedToothOperationDetails = null,
        yearsFilter = null,
        toothNumberFilter = null,
        procedureTypeFilter = null,
        isDeleteRequest = false,
        selectedToothList = null,
        filteredDefectedToothList = null,
        defectedToothList = null;

        
  
  @override
  List<Object?> get props => [message, defectedToothList, requestStatus, selectedToothList, isLoadingMore,  
   hasMore, currentPage, selectedToothOperationDetails, isDeleteRequest, yearsFilter, toothNumberFilter, procedureTypeFilter];

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
    List<int>? yearsFilter,
    List<String>? toothNumberFilter,
    List<int>? filteredDefectedToothList,
    List<String>? procedureTypeFilter,
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
      yearsFilter: yearsFilter ?? this.yearsFilter,
      toothNumberFilter: toothNumberFilter ?? this.toothNumberFilter,
      procedureTypeFilter: procedureTypeFilter ?? this.procedureTypeFilter,
      filteredDefectedToothList: filteredDefectedToothList?? this.filteredDefectedToothList,
    );
  }

} 