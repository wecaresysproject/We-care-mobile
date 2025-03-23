import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/emergency_%20complaints/data/models/get_single_complaint_response_model.dart';

class EmergencyComplaintViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<DetailedComplaintModel> emergencyComplaints;
  final DetailedComplaintModel? selectedEmergencyComplaint;
  final List<String> yearsFilter;
  final List<String> bodyPartFilter;
  final bool isDeleteRequest;

  const EmergencyComplaintViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.bodyPartFilter = const [],
    this.emergencyComplaints = const [],
    this.selectedEmergencyComplaint,
    this.isDeleteRequest = false,
  });

  factory EmergencyComplaintViewState.initial() {
    return EmergencyComplaintViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      bodyPartFilter: const ['الكل'],
      emergencyComplaints: const [],
      selectedEmergencyComplaint: null,
      isDeleteRequest: false,
    );
  }

  EmergencyComplaintViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<String>? yearsFilter,
    List<String>? bodyPartFilter,
    List<DetailedComplaintModel>? emergencyComplaints,
    DetailedComplaintModel? selectedEmergencyComplaint,
    bool? isDeleteRequest,
  }) {
    return EmergencyComplaintViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      bodyPartFilter: bodyPartFilter ?? this.bodyPartFilter,
      emergencyComplaints: emergencyComplaints ?? this.emergencyComplaints,
      selectedEmergencyComplaint:
          selectedEmergencyComplaint ?? this.selectedEmergencyComplaint,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        yearsFilter,
        bodyPartFilter,
        emergencyComplaints,
        selectedEmergencyComplaint,
        isDeleteRequest,
      ];
}
