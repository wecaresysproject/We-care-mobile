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
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'bank_info_state.dart';

class BankInfoCubit extends Cubit<BankInfoState>
    with SafeEmitMixin<BankInfoState> {
  BankInfoCubit(this._sharedRepo, this._bankInfoRepo)
      : super(BankInfoState.initial());

  final AppSharedRepo _sharedRepo;
  final BankInfoRepo _bankInfoRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the dropdown options and the doctor's saved bank accounts together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitCountriesData(), _loadSavedBankAccounts()]);
  }

  Future<void> _loadSavedBankAccounts() async {
    final response = await _bankInfoRepo.getBankInfo();
    response.when(
      success: (bankAccounts) {
        if (bankAccounts.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final account in state.accounts) {
          account.dispose();
        }
        final accounts =
            bankAccounts.map(BankAccountFormEntry.fromModel).toList();
        for (final account in accounts) {
          account.addTextListener(_updateHasChanges);
        }
        _changesTracker.setBaseline(_buildRequestBody(accounts).toJson());
        safeEmit(state.copyWith(
          accounts: accounts,
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

  BankInfoRequestBodyModel _buildRequestBody(
    List<BankAccountFormEntry> accounts,
  ) =>
      BankInfoRequestBodyModel(
        bankAccounts: accounts.map((account) => account.toModel()).toList(),
      );

  void _updateHasChanges() {
    final hasChanges =
        _changesTracker.hasChanges(_buildRequestBody(state.accounts).toJson());
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
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
    final account = BankAccountFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(accounts: [...state.accounts, account]));
    _updateHasChanges();
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
    _updateHasChanges();
  }

  void updateAccountCountry(Key entryKey, String? country) {
    final account =
        state.accounts.firstWhere((account) => account.key == entryKey);
    account.selectedCountry = country;
    safeEmit(state.copyWith(accounts: [...state.accounts]));
    _updateHasChanges();
  }

  Future<void> submitBankInfo() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.accounts);

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
