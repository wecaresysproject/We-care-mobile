import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_info_request_body_model.dart';
import 'package:we_care/features/doctor/bank_info/data/repos/bank_info_repo.dart';
import 'package:we_care/features/doctor/bank_info/logic/cubit/bank_account_form_entry.dart';

part 'bank_info_state.dart';

class BankInfoCubit extends Cubit<BankInfoState>
    with SafeEmitMixin<BankInfoState> {
  BankInfoCubit(this._sharedRepo, this._bankInfoRepo)
      : super(BankInfoState.initial());

  final AppSharedRepo _sharedRepo;
  final BankInfoRepo _bankInfoRepo;

  final formKey = GlobalKey<FormState>();

  Future<void> loadInitialData() async {
    await emitCountriesData();
  }

  Future<void> emitCountriesData() async {
    final response = await _sharedRepo.getCountriesData(
      language: AppStrings.arabicLang,
      userType: UserTypes.doctor.name.firstLetterToUpperCase,
    );
    response.when(
      success: (countries) =>
          safeEmit(state.copyWith(countriesNames: countries)),
      failure: (error) => safeEmit(state.copyWith(message: error.errors.first)),
    );
  }

  void addBankAccount() {
    safeEmit(
      state.copyWith(accounts: [...state.accounts, BankAccountFormEntry()]),
    );
  }

  void removeBankAccount(Key entryKey) {
    if (state.accounts.length <= 1) return;
    final removed =
        state.accounts.firstWhere((account) => account.key == entryKey);
    removed.dispose();
    safeEmit(
      state.copyWith(
        accounts:
            state.accounts.where((account) => account.key != entryKey).toList(),
      ),
    );
  }

  void updateAccountCountry(Key entryKey, String? country) {
    final account =
        state.accounts.firstWhere((account) => account.key == entryKey);
    account.selectedCountry = country;
    safeEmit(state.copyWith(accounts: [...state.accounts]));
  }

  Future<void> submitBankInfo() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = BankInfoRequestBodyModel(
      bankAccounts: state.accounts.map((account) => account.toModel()).toList(),
    );

    final response = await _bankInfoRepo.submitBankInfo(model);
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
    for (final account in state.accounts) {
      account.dispose();
    }
    return super.close();
  }
}
