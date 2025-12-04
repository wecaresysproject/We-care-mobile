import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/home_tab/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  Future<void> getMessageNotifications() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    
    final result = await _homeRepository.getMessageNotifications();

    result.when(
      success: (notifications) {
        emit(state.copyWith(
          notifications: notifications,
          requestStatus: RequestStatus.success,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty 
              ? error.errors.first 
              : 'Failed to load notifications',
        ));
      },
    );
  }
}
