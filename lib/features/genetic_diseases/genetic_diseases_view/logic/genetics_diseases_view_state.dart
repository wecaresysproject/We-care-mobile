import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/genetic_diseases/data/models/current_personal_genetic_diseases.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatic_disease_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_diseases_response_model.dart';

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
  final PersonalGeneticDiseasDetails? currentPersonalGeneticDiseaseDetails;
  final List<PersonalGenaticDisease>? expextedPersonalGeneticDiseases;
  final List<CurrentPersonalGeneticDiseasesResponseModel>?
      currentPersonalGeneticDiseases;

  const GeneticsDiseasesViewState(
      {this.requestStatus = RequestStatus.initial,
      this.message,
      this.isLoadingMore,
      this.hasMore,
      this.currentPage,
      this.isDeleteRequest = false,
      this.yearsFilter,
      this.familyMembersNames,
      this.currentPersonalGeneticDiseases,
      this.familyMemberGeneticDiseases,
      this.familyMemberGeneticDiseaseDetails,
      this.expextedPersonalGeneticDiseases,
      this.currentPersonalGeneticDiseaseDetails});
  const GeneticsDiseasesViewState.initial()
      : requestStatus = RequestStatus.initial,
        message = null,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 1,
        yearsFilter = null,
        familyMemberGeneticDiseases = null,
        familyMemberGeneticDiseaseDetails = null,
        currentPersonalGeneticDiseaseDetails = null,
        expextedPersonalGeneticDiseases = null,
        currentPersonalGeneticDiseases = null,
        familyMembersNames = null,
        isDeleteRequest = false;

  @override
  List<Object?> get props => [
        message,
        requestStatus,
        isLoadingMore,
        hasMore,
        currentPage,
        isDeleteRequest,
        yearsFilter,
        familyMembersNames,
        familyMemberGeneticDiseases,
        currentPersonalGeneticDiseases,
        familyMemberGeneticDiseaseDetails,
        currentPersonalGeneticDiseaseDetails,
        expextedPersonalGeneticDiseases,
      ];

  GeneticsDiseasesViewState copyWith(
      {String? message,
      RequestStatus? requestStatus,
      bool? isLoadingMore,
      bool? hasMore,
      int? currentPage,
      bool? isDeleteRequest,
      List<int>? yearsFilter,
      GetFamilyMembersNames? familyMembersNames,
      FamilyMemberGeneticsDiseasesResponseModel? familyMemberGeneticDiseases,
      List<CurrentPersonalGeneticDiseasesResponseModel>?
          currentPersonalGeneticDiseases,
      List<PersonalGenaticDisease>? personalGeneticDiseases,
      FamilyNameGeneticDiseaseDetialsResponseModel?
          familyMemberGeneticDiseaseDetails,
      PersonalGeneticDiseasDetails? personalGeneticDiseaseDetails}) {
    return GeneticsDiseasesViewState(
      message: message ?? this.message,
      requestStatus: requestStatus ?? this.requestStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      familyMemberGeneticDiseases:
          familyMemberGeneticDiseases ?? this.familyMemberGeneticDiseases,
      familyMembersNames: familyMembersNames ?? this.familyMembersNames,
      currentPersonalGeneticDiseaseDetails:
          personalGeneticDiseaseDetails ?? this.currentPersonalGeneticDiseaseDetails,
      familyMemberGeneticDiseaseDetails: familyMemberGeneticDiseaseDetails ??
          this.familyMemberGeneticDiseaseDetails,
      expextedPersonalGeneticDiseases:
          personalGeneticDiseases ?? this.expextedPersonalGeneticDiseases,
      currentPersonalGeneticDiseases:
          currentPersonalGeneticDiseases ?? this.currentPersonalGeneticDiseases,
    );
  }
}
