import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_view_repo.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XRayViewCubit extends Cubit<XRayViewState> {
  XRayViewCubit(this._xRayRepo) : super(XRayViewState.initial());
  final XRayViewRepo _xRayRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

    Future<void> init()async{
    await emitUserRadiologyData();
    await emitFilters();
  }

    Future<void> emitUserRadiologyData({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _xRayRepo.getUserRadiologyData(
      userType: 'Patient',
      language: AppStrings.arabicLang,
      page: page ?? currentPage, 
      pageSize: pageSize ?? this.pageSize
    );

    result.when(success: (response) {
      final newXrayList = response.radiologyData;
      
      // Update hasMore based on whether we got a full page of results
      hasMore = newXrayList.length >= (pageSize ?? this.pageSize);
      
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userRadiologyData: page == 1 || page == null 
          ? newXrayList 
          : [...state.userRadiologyData, ...newXrayList],
        isLoadingMore: false,
      ));
      
      if (page == null || page == 1) {
        currentPage = 1;
      } else {
        currentPage = page;
      }
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        isLoadingMore: false,
      ));
    });
  }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;
    
    await emitUserRadiologyData(page: currentPage + 1);
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
