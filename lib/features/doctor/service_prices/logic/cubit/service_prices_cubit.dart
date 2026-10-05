import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';
import 'package:we_care/features/doctor/service_prices/data/repos/service_prices_repo.dart';

part 'service_prices_state.dart';

class ServicePricesCubit extends Cubit<ServicePricesState>
    with SafeEmitMixin<ServicePricesState> {
  ServicePricesCubit(this._servicePricesRepo)
      : super(ServicePricesState.initial());

  final ServicePricesRepo _servicePricesRepo;

  final formKey = GlobalKey<FormState>();

  final examinationPriceInsideEgyptController = TextEditingController();
  final examinationPriceOutsideEgyptController = TextEditingController();

  static const followUpValidityOptionsDays = [3, 5, 7, 10, 14, 21, 30];

  void updateOffersFollowUpConsultation(bool value) => safeEmit(
        state.copyWith(
          offersFollowUpConsultation: value,
          followUpConsultationValidityDays: () =>
              value ? state.followUpConsultationValidityDays ?? 7 : null,
        ),
      );

  void updateFollowUpConsultationValidityDays(int days) =>
      safeEmit(state.copyWith(followUpConsultationValidityDays: () => days));

  Future<void> submitServicePrices() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = ServicePricesRequestBodyModel(
      examinationPriceInsideEgypt:
          double.tryParse(examinationPriceInsideEgyptController.text) ?? 0,
      examinationPriceOutsideEgypt:
          double.tryParse(examinationPriceOutsideEgyptController.text) ?? 0,
      offersFollowUpConsultation: state.offersFollowUpConsultation,
      followUpConsultationValidityDays: state.offersFollowUpConsultation
          ? state.followUpConsultationValidityDays
          : 0,
    );

    final response = await _servicePricesRepo.submitServicePrices(model);
    response.when(
      success: (message) => safeEmit(
        state.copyWith(
          message: message,
          submissionStatus: RequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          submissionStatus: RequestStatus.failure,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    examinationPriceInsideEgyptController.dispose();
    examinationPriceOutsideEgyptController.dispose();
    return super.close();
  }
}
