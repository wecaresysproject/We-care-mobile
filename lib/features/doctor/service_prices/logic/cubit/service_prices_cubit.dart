import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';
import 'package:we_care/features/doctor/service_prices/data/repos/service_prices_repo.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'service_prices_state.dart';

class ServicePricesCubit extends Cubit<ServicePricesState>
    with SafeEmitMixin<ServicePricesState> {
  ServicePricesCubit(this._servicePricesRepo)
      : super(ServicePricesState.initial()) {
    examinationPriceInsideEgyptController.addListener(_updateHasChanges);
    examinationPriceOutsideEgyptController.addListener(_updateHasChanges);
  }

  final ServicePricesRepo _servicePricesRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  final examinationPriceInsideEgyptController = TextEditingController();
  final examinationPriceOutsideEgyptController = TextEditingController();

  static const followUpValidityOptionsDays = [3, 5, 7, 10, 14, 21, 30];

  /// Loads the doctor's saved service prices and fills the form with them.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    final response = await _servicePricesRepo.getServicePrices();
    response.when(
      success: (prices) {
        if (prices == null) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        examinationPriceInsideEgyptController.text =
            _formatAmount(prices.examinationPriceInsideEgypt);
        examinationPriceOutsideEgyptController.text =
            _formatAmount(prices.examinationPriceOutsideEgypt);
        final loaded = state.copyWith(
          offersFollowUpConsultation: prices.offersFollowUpConsultation,
          followUpConsultationValidityDays: () =>
              prices.offersFollowUpConsultation
                  ? prices.followUpConsultationValidityDays
                  : null,
        );
        _changesTracker.setBaseline(_buildRequestBody(loaded).toJson());
        safeEmit(loaded.copyWith(
          loadStatus: RequestStatus.success,
          isEditMode: true,
          hasChanges: false,
        ));
      },
      failure: (error) => safeEmit(state.copyWith(
        loadStatus: RequestStatus.failure,
        message: error.errors.first,
      )),
    );
  }

  /// Formats a saved amount for its text field so that parsing the untouched
  /// field gives the same number back: `500` instead of `500.0`.
  String _formatAmount(double value) => value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();

  ServicePricesRequestBodyModel _buildRequestBody(ServicePricesState form) =>
      ServicePricesRequestBodyModel(
        examinationPriceInsideEgypt:
            double.tryParse(examinationPriceInsideEgyptController.text) ?? 0,
        examinationPriceOutsideEgypt:
            double.tryParse(examinationPriceOutsideEgyptController.text) ?? 0,
        offersFollowUpConsultation: form.offersFollowUpConsultation,
        followUpConsultationValidityDays: form.offersFollowUpConsultation
            ? form.followUpConsultationValidityDays
            : 0,
      );

  void _updateHasChanges() {
    final hasChanges =
        _changesTracker.hasChanges(_buildRequestBody(state).toJson());
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
  }

  void updateOffersFollowUpConsultation(bool value) {
    safeEmit(
      state.copyWith(
        offersFollowUpConsultation: value,
        followUpConsultationValidityDays: () =>
            value ? state.followUpConsultationValidityDays ?? 7 : null,
      ),
    );
    _updateHasChanges();
  }

  void updateFollowUpConsultationValidityDays(int days) {
    safeEmit(state.copyWith(followUpConsultationValidityDays: () => days));
    _updateHasChanges();
  }

  Future<void> submitServicePrices() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state);

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
