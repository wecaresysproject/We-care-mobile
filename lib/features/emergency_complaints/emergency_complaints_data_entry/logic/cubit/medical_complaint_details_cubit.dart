import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'medical_complaint_details_state.dart';

class MedicalComplaintDetailsCubit extends Cubit<MedicalComplaintDetailsState> {
  MedicalComplaintDetailsCubit()
      : super(MedicalComplaintDetailsState.initial());
  List<MedicalComplaint> medicalComplaints = [];

  void saveNewMedicalComplaint() {
    medicalComplaints.add(
      MedicalComplaint(
        symptomsRegion: state.symptomsDiseaseRegion!,
        sypmptomsComplaintIssue: state.medicalSymptomsIssue!,
        natureOfComplaint: state.natureOfComplaint!,
        severityOfComplaint: state.complaintDegree!,
      ),
    );
    emit(
      state.copyWith(
        isNewComplaintAddedSuccefully: true,
      ),
    );
  }

  void removeNewMedicalComplaint(int index) {
    medicalComplaints.removeAt(index);
    // emit(
    //   state.copyWith(
    //     isNewComplaintAddedSuccefully: false,
    //   ),
    // );
  }
}
