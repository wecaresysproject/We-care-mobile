import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatic_disease_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/personal_genatic_diseases_details_view.dart';

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
  final FamilyMemberGeneticsDiseasesResponseModel? familyMemberGeneticDiseases;
  final FamilyNameGeneticDiseaseDetialsResponseModel?
      familyMemberGeneticDiseaseDetails;
  final PersonalGeneticDiseasDetails?     personalGeneticDiseaseDetails;

  const GeneticsDiseasesViewState({
    this.requestStatus = RequestStatus.initial,
    this.message,
    this.isLoadingMore,
    this.hasMore,
    this.currentPage,
    this.isDeleteRequest = false,
    this.yearsFilter,
    this.familyMembersNames,
    this.familyMemberGeneticDiseases,
    this.familyMemberGeneticDiseaseDetails,
    this.personalGeneticDiseaseDetails
  });
  const GeneticsDiseasesViewState.initial()
      : requestStatus = RequestStatus.initial,
        message = null,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 1,
        yearsFilter = null,
        familyMemberGeneticDiseases = null,
        familyMemberGeneticDiseaseDetails = null,
        personalGeneticDiseaseDetails = null,
        familyMembersNames = null,
        isDeleteRequest = false;

        
  
  @override
  List<Object?> get props => [message, requestStatus, isLoadingMore,  
   hasMore, currentPage, isDeleteRequest, yearsFilter, familyMembersNames,familyMemberGeneticDiseases, familyMemberGeneticDiseaseDetails, personalGeneticDiseaseDetails];

  GeneticsDiseasesViewState copyWith({
    String? message,
    RequestStatus? requestStatus,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    bool? isDeleteRequest,
    List<int>? yearsFilter,
    GetFamilyMembersNames? familyMembersNames,
    FamilyMemberGeneticsDiseasesResponseModel? familyMemberGeneticDiseases,
    FamilyNameGeneticDiseaseDetialsResponseModel?
        familyMemberGeneticDiseaseDetails,
        PersonalGeneticDiseasDetails? personalGeneticDiseaseDetails
  }) {
    return GeneticsDiseasesViewState(
      message: message ?? this.message,
      requestStatus: requestStatus ?? this.requestStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      familyMemberGeneticDiseases: familyMemberGeneticDiseases ?? this.familyMemberGeneticDiseases,
      familyMembersNames: familyMembersNames ?? this.familyMembersNames,
      personalGeneticDiseaseDetails: personalGeneticDiseaseDetails ?? this.personalGeneticDiseaseDetails,
      familyMemberGeneticDiseaseDetails: familyMemberGeneticDiseaseDetails ?? this.familyMemberGeneticDiseaseDetails,
    );
  }

} 