import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';

@immutable
class GeneticsDiseasesViewState extends Equatable {
  final RequestStatus requestStatus;
  final String? message;
  final bool? isLoadingMore;
  final bool? hasMore;
  final int? currentPage;
  final bool isDeleteRequest;
  final List<int>? yearsFilter;
  final GetFamilyMembersNames? familyMembersNames;

  const GeneticsDiseasesViewState({
    this.requestStatus = RequestStatus.initial,
    this.message,
    this.isLoadingMore,
    this.hasMore,
    this.currentPage,
    this.isDeleteRequest = false,
    this.yearsFilter,
    this.familyMembersNames,
  });
  const GeneticsDiseasesViewState.initial()
      : requestStatus = RequestStatus.initial,
        message = null,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 1,
        yearsFilter = null,
        familyMembersNames = null,
        isDeleteRequest = false;

        
  
  @override
  List<Object?> get props => [message, requestStatus, isLoadingMore,  
   hasMore, currentPage, isDeleteRequest, yearsFilter, familyMembersNames];

  GeneticsDiseasesViewState copyWith({
    String? message,
    RequestStatus? requestStatus,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    bool? isDeleteRequest,
    List<int>? yearsFilter,
    GetFamilyMembersNames? familyMembersNames,
  }) {
    return GeneticsDiseasesViewState(
      message: message ?? this.message,
      requestStatus: requestStatus ?? this.requestStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      familyMembersNames: familyMembersNames ?? this.familyMembersNames,
    );
  }

} 