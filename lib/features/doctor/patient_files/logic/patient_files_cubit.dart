import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/debouncer.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/patient_files/data/models/patient_file_models.dart';
import 'package:we_care/features/doctor/patient_files/data/repos/patient_files_repo.dart';

enum PatientFilesTab { open, previous }

/// "ملفات المرضى": two tabs, each loaded the first time it shows. The name
/// search runs on the server, debounced while the doctor types; the filters
/// run on the loaded list.
class PatientFilesCubit extends Cubit<PatientFilesState> with SafeEmitMixin {
  PatientFilesCubit(this._repo) : super(const PatientFilesState());

  final PatientFilesRepo _repo;
  final _searchDebouncer = Debouncer(milliseconds: 500);

  /// The search each tab's list was loaded with — null until it loads.
  /// A tab reloads when it shows with a different search.
  String? _openLoadedQuery;
  String? _previousLoadedQuery;

  void init() => _loadTab(PatientFilesTab.open);

  void selectTab(PatientFilesTab tab) {
    if (tab == state.tab) return;
    safeEmit(state.copyWith(tab: tab));
    final loadedQuery =
        tab == PatientFilesTab.open ? _openLoadedQuery : _previousLoadedQuery;
    if (loadedQuery != state.query) _loadTab(tab);
  }

  /// Called on every keystroke; the request goes out once typing pauses.
  void search(String query) {
    final trimmed = query.trim();
    if (trimmed == state.query) return;
    safeEmit(state.copyWith(query: trimmed));
    _searchDebouncer(() => _loadTab(state.tab));
  }

  void filterStatus(PatientFileBookingStatus? status) =>
      safeEmit(state.copyWith(statusFilter: () => status));

  void filterType(AppointmentType? type) =>
      safeEmit(state.copyWith(typeFilter: () => type));

  Future<void> retry() => _loadTab(state.tab);

  Future<void> refresh() => _loadTab(state.tab);

  Future<void> _loadTab(PatientFilesTab tab) async {
    final query = state.query;
    final search = query.isEmpty ? null : query;

    if (tab == PatientFilesTab.open) {
      // A search over a loaded list keeps it on screen with a thin progress
      // bar instead of the full-screen loader.
      safeEmit(
        state.openStatus == RequestStatus.success
            ? state.copyWith(isOpenSearching: true)
            : state.copyWith(openStatus: RequestStatus.loading),
      );
      final result = await _repo.getOpenFiles(search: search);
      // A newer search started while this one was in flight — drop it.
      if (query != state.query) return;
      result.when(
        success: (files) {
          _openLoadedQuery = query;
          safeEmit(
            state.copyWith(
              openStatus: RequestStatus.success,
              openFiles: files,
              isOpenSearching: false,
            ),
          );
        },
        failure: (error) {
          _openLoadedQuery = null;
          safeEmit(
            state.copyWith(
              openStatus: RequestStatus.failure,
              openMessage: () => error.errors.firstOrNull,
              isOpenSearching: false,
            ),
          );
        },
      );
    } else {
      safeEmit(
        state.previousStatus == RequestStatus.success
            ? state.copyWith(isPreviousSearching: true)
            : state.copyWith(previousStatus: RequestStatus.loading),
      );
      final result = await _repo.getPreviousPatients(search: search);
      if (query != state.query) return;
      result.when(
        success: (patients) {
          _previousLoadedQuery = query;
          safeEmit(
            state.copyWith(
              previousStatus: RequestStatus.success,
              previousPatients: patients,
              isPreviousSearching: false,
            ),
          );
        },
        failure: (error) {
          _previousLoadedQuery = null;
          safeEmit(
            state.copyWith(
              previousStatus: RequestStatus.failure,
              previousMessage: () => error.errors.firstOrNull,
              isPreviousSearching: false,
            ),
          );
        },
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebouncer.reset();
    return super.close();
  }
}

@immutable
class PatientFilesState extends Equatable {
  const PatientFilesState({
    this.tab = PatientFilesTab.open,
    this.openStatus = RequestStatus.initial,
    this.openFiles = const [],
    this.openMessage,
    this.isOpenSearching = false,
    this.previousStatus = RequestStatus.initial,
    this.previousPatients = const [],
    this.previousMessage,
    this.isPreviousSearching = false,
    this.query = '',
    this.statusFilter,
    this.typeFilter,
  });

  final PatientFilesTab tab;

  final RequestStatus openStatus;
  final List<OpenPatientFileModel> openFiles;
  final String? openMessage;

  /// A search request is running over the loaded open files.
  final bool isOpenSearching;

  final RequestStatus previousStatus;
  final List<PreviousPatientModel> previousPatients;
  final String? previousMessage;

  /// A search request is running over the loaded previous patients.
  final bool isPreviousSearching;

  /// The search box — shared by both tabs, sent to the server.
  final String query;

  /// "حالة الكشف" on the open files; null = الكل.
  final PatientFileBookingStatus? statusFilter;

  /// "نوع الكشف" on the previous patients; null = الكل.
  final AppointmentType? typeFilter;

  List<OpenPatientFileModel> get visibleOpenFiles => [
        for (final file in openFiles)
          if (statusFilter == null || file.status == statusFilter) file,
      ];

  List<PreviousPatientModel> get visiblePreviousPatients => [
        for (final patient in previousPatients)
          if (typeFilter == null || patient.lastType == typeFilter) patient,
      ];

  PatientFilesState copyWith({
    PatientFilesTab? tab,
    RequestStatus? openStatus,
    List<OpenPatientFileModel>? openFiles,
    String? Function()? openMessage,
    bool? isOpenSearching,
    RequestStatus? previousStatus,
    List<PreviousPatientModel>? previousPatients,
    String? Function()? previousMessage,
    bool? isPreviousSearching,
    String? query,
    PatientFileBookingStatus? Function()? statusFilter,
    AppointmentType? Function()? typeFilter,
  }) =>
      PatientFilesState(
        tab: tab ?? this.tab,
        openStatus: openStatus ?? this.openStatus,
        openFiles: openFiles ?? this.openFiles,
        openMessage: openMessage != null ? openMessage() : this.openMessage,
        isOpenSearching: isOpenSearching ?? this.isOpenSearching,
        previousStatus: previousStatus ?? this.previousStatus,
        previousPatients: previousPatients ?? this.previousPatients,
        previousMessage:
            previousMessage != null ? previousMessage() : this.previousMessage,
        isPreviousSearching: isPreviousSearching ?? this.isPreviousSearching,
        query: query ?? this.query,
        statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
        typeFilter: typeFilter != null ? typeFilter() : this.typeFilter,
      );

  @override
  List<Object?> get props => [
        tab,
        openStatus,
        openFiles,
        openMessage,
        isOpenSearching,
        previousStatus,
        previousPatients,
        previousMessage,
        isPreviousSearching,
        query,
        statusFilter,
        typeFilter,
      ];
}
