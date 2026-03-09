import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';

part 'ai_consultation_state.dart';

class AIConsultationCubit extends Cubit<AIConsultationState> {
  final AppSharedRepo sharedRepo;

  AIConsultationCubit(this.sharedRepo) : super(const AIConsultationState());

  Future<void> emitModuleGuidanceData() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.aiConsult.name,
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            message:
                failure.errors.firstOrNull ?? "Error fetching module guidance",
          ),
        );
      },
    );
  }
}
