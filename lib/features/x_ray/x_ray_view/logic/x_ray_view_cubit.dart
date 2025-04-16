import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_view_repo.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XRayViewCubit extends Cubit<XRayViewState> {
  XRayViewCubit(this._xRayRepo) : super(XRayViewState.initial());
  final XRayViewRepo _xRayRepo;


  Future<void> init()async{
    await emitUserRadiologyData();
    await emitFilters();
  }

  Future<void> emitUserRadiologyData() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await _xRayRepo.getUserRadiologyData(
        language: AppStrings.arabicLang, userType: 'Patient');

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userRadiologyData: response.radiologyData,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitspecificUserRadiologyDocument(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await _xRayRepo.getSpecificUserRadiologyDocument(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedRadiologyDocument: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
    return null;
  }

  Future<void> emitFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await _xRayRepo.gettFilters(language: AppStrings.arabicLang);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response.years,
        xrayTypeFilter: response.radioTypes,
        bodyPartFilter: response.bodyParts,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitFilteredData(
      String? year, String? radioType, String? bodyPart) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    // Ensure `year` is converted to int if not null
    final int? parsedYear =
        (year != null && year.isNotEmpty) ? int.tryParse(year) : null;

    final response = await _xRayRepo.getFilteredData(
      language: AppStrings.arabicLang,
      year: parsedYear,
      radioType: radioType?.isNotEmpty == true ? radioType : null,
      bodyPart: bodyPart?.isNotEmpty == true ? bodyPart : null,
    );

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userRadiologyData: response.radiologyData,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> deleteMedicineById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _xRayRepo.deleteRadiologyDocumentById(
      id: id,
      language: AppStrings.arabicLang,
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        responseMessage: response,
        isDeleteRequest: true,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
          isDeleteRequest: true));
    });
  }
}
