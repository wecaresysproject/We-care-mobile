import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/patient_files/data/repos/patient_files_repo.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/patient_files/data/models/patient_file_models.dart';
import 'package:we_care/features/doctor/patient_files/logic/patient_files_cubit.dart';
import 'package:we_care/features/doctor/patient_files/presentation/views/widgets/patient_file_cards.dart';

void main() {
  test('parses open files and previous patients', () {
    final open = OpenPatientFileModel.listFromJson([
      {
        'bookingId': 'b1',
        'patient': {'name': 'أحمد', 'profileImage': ' ', 'age': 45},
        'examinationDate': '2026-11-23T10:00:00+02:00',
        'status': 'completed',
        'accessExpiresAt': '2026-11-26T10:00:00+02:00',
      },
      {'bookingId': ''},
    ]);
    expect(open, hasLength(1));
    expect(open.single.status, PatientFileBookingStatus.completed);
    expect(open.single.patient.photoUrl, isNull);

    final previous = PreviousPatientModel.listFromJson([
      {
        'patientId': 'p1',
        'patient': {'name': 'محمد', 'country': 'مصر'},
        'lastType': 'freeFollowUpConsultation',
      },
    ]);
    expect(previous.single.lastType, AppointmentType.consultation);
    expect(previous.single.patient.age, isNull);
  });

  test('remaining access label', () {
    final now = DateTime(2026, 11, 22, 12);
    expect(
        remainingAccessLabel(now.add(const Duration(days: 3)), now), '3 أيام');
    expect(
        remainingAccessLabel(now.add(const Duration(hours: 30)), now), '2 يوم');
    expect(
        remainingAccessLabel(now.add(const Duration(hours: 5)), now), '5 ساعة');
    expect(remainingAccessLabel(now.subtract(const Duration(hours: 1)), now),
        'انتهت');
  });

  test('filters run on the loaded list', () {
    final state = PatientFilesState(
      openFiles: [
        for (final (name, status) in [
          ('أحمد علي', PatientFileBookingStatus.scheduled),
          ('خالد حسن', PatientFileBookingStatus.completed),
        ])
          OpenPatientFileModel(
            bookingId: name,
            patient:
                PatientFilePatientModel(name: name, photoUrl: null, age: null),
            examinationDate: null,
            status: status,
            accessExpiresAt: null,
          ),
      ],
    );
    expect(state.visibleOpenFiles, hasLength(2));
    expect(
      state
          .copyWith(statusFilter: () => PatientFileBookingStatus.scheduled)
          .visibleOpenFiles
          .single
          .bookingId,
      'أحمد علي',
    );
  });

  test('typing sends one debounced search request', () async {
    final repo = _RecordingRepo();
    final cubit = PatientFilesCubit(repo)..init();
    await Future<void>.delayed(Duration.zero);
    cubit
      ..search('م')
      ..search('مح')
      ..search(' محمد ');
    expect(repo.openSearches, [null]);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(repo.openSearches, [null, 'محمد']);

    // The other tab loads with the same search when it opens.
    cubit.selectTab(PatientFilesTab.previous);
    await Future<void>.delayed(Duration.zero);
    expect(repo.previousSearches, ['محمد']);
    await cubit.close();
  });
}

class _RecordingRepo extends PatientFilesRepo {
  _RecordingRepo() : super(DoctorServices(Dio()));

  final openSearches = <String?>[];
  final previousSearches = <String?>[];

  @override
  Future<ApiResult<List<OpenPatientFileModel>>> getOpenFiles({
    String? search,
  }) async {
    openSearches.add(search);
    return const ApiResult.success([]);
  }

  @override
  Future<ApiResult<List<PreviousPatientModel>>> getPreviousPatients({
    String? search,
  }) async {
    previousSearches.add(search);
    return const ApiResult.success([]);
  }
}
