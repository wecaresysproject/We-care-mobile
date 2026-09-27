import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/dynamic_question_with_dynamic_answer_list_option.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/basic_data/logic/cubit/doctor_basic_data_cubit.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_languages_multi_select_widget.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_national_id_photo_section_widget.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_phone_with_country_code_field_widget.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_profile_photo_section_widget.dart';
import 'package:we_care/generated/l10n.dart';

class DoctorBasicDataFormFields extends StatelessWidget {
  const DoctorBasicDataFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBasicDataCubit, DoctorBasicDataState>(
      builder: (context, state) {
        final cubit = context.read<DoctorBasicDataCubit>();
        final localization = S.of(context);

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicDataProfilePhotoSection(),
              verticalSpacing(18),

              // Name (first / father / family)
              Text(
                localization.basicDataFormNameLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: cubit.firstNameController,
                      hintText: localization.basicDataFormEnterName,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? localization.pleaseEnterYourName
                          : null,
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    child: CustomTextField(
                      controller: cubit.fatherNameController,
                      hintText: localization.basicDataFormEnterName,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? localization.pleaseEnterYourName
                          : null,
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    child: CustomTextField(
                      controller: cubit.familyNameController,
                      hintText: localization.basicDataFormEnterName,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? localization.pleaseEnterYourName
                          : null,
                    ),
                  ),
                ],
              ),
              verticalSpacing(18),

              // Job grade (was "profession") — static list for now
              UserSelectionContainer(
                categoryLabel: localization.basicDataFormJobGradeLabel,
                containerHintText: state.selectedJobGrade ??
                    localization.basicDataFormChooseJobGrade,
                options: kJobGradeOptions,
                onOptionSelected: cubit.updateJobGrade,
                bottomSheetTitle: localization.basicDataFormChooseJobGrade,
                searchHintText: localization.basicDataFormChooseJobGrade,
              ),
              verticalSpacing(18),

              // Academic degree — new field, static list (no endpoint yet)
              UserSelectionContainer(
                categoryLabel: localization.basicDataFormAcademicDegreeLabel,
                containerHintText: state.selectedAcademicDegree ??
                    localization.basicDataFormChooseAcademicDegree,
                options: kAcademicDegreeOptions,
                onOptionSelected: cubit.updateAcademicDegree,
                bottomSheetTitle:
                    localization.basicDataFormChooseAcademicDegree,
                searchHintText: localization.basicDataFormChooseAcademicDegree,
              ),
              verticalSpacing(18),

              // Gender
              QuestionWithDynamicAnswerListOption(
                questionTitle: localization.basicDataFormGenderLabel,
                options: [
                  localization.basicDataFormMale,
                  localization.basicDataFormFemale,
                ],
                initialValue: state.selectedGender,
                onAnswerChanged: cubit.updateGender,
              ),
              verticalSpacing(18),

              // Birth date
              Text(
                localization.basicDataFormBirthDateLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              DateTimePickerContainer(
                placeholderText: state.birthDate ??
                    localization.basicDataFormBirthDatePlaceholder,
                onDateSelected: cubit.updateBirthDate,
              ),
              verticalSpacing(18),

              // Country / Governorate / City
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: UserSelectionContainer(
                      categoryLabel: localization.basicDataFormCountryLabel,
                      containerHintText: state.selectedCountry ??
                          localization.basicDataFormChooseCountry,
                      options: state.countriesNames,
                      onOptionSelected: (val) async {
                        cubit.updateCountry(val);
                        await cubit.emitCitiesData();
                      },
                      bottomSheetTitle: localization.basicDataFormChooseCountry,
                      searchHintText: localization.basicDataFormChooseCountry,
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    child: UserSelectionContainer(
                      categoryLabel: localization.basicDataFormGovernorateLabel,
                      containerHintText: state.selectedGovernorate ??
                          localization.basicDataFormChooseGovernorate,
                      options: const [],
                      allowManualEntry: true,
                      onOptionSelected: cubit.updateGovernorate,
                      bottomSheetTitle:
                          localization.basicDataFormChooseGovernorate,
                      searchHintText:
                          localization.basicDataFormChooseGovernorate,
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    child: UserSelectionContainer(
                      categoryLabel: localization.basicDataFormCityLabel,
                      containerHintText: state.selectedCity ??
                          localization.basicDataFormChooseCity,
                      options: state.citiesNames,
                      onOptionSelected: cubit.updateCity,
                      bottomSheetTitle: localization.basicDataFormChooseCity,
                      searchHintText: localization.basicDataFormChooseCity,
                    ),
                  ),
                ],
              ),
              verticalSpacing(18),

              // Professional mobile
              Text(
                localization.basicDataFormProfessionalMobileLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              BasicDataPhoneWithCountryCodeField(
                controller: cubit.professionalMobileController,
                onCountryCodeChanged: (code) {},
              ),
              verticalSpacing(18),

              // Contact mobile
              Text(
                localization.basicDataFormContactMobileLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              BasicDataPhoneWithCountryCodeField(
                controller: cubit.contactMobileController,
                onCountryCodeChanged: (code) {},
              ),
              verticalSpacing(18),

              // National ID / passport number
              Text(
                localization.basicDataFormNationalIdLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                controller: cubit.nationalIdController,
                hintText: localization.basicDataFormEnterNationalId,
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? localization.required_field
                    : null,
              ),
              verticalSpacing(18),

              // National ID / passport photo
              const BasicDataNationalIdPhotoSection(),
              verticalSpacing(18),

              // Spoken languages
              const BasicDataLanguagesMultiSelect(),
              verticalSpacing(18),

              // Short bio
              Text(
                localization.basicDataFormBioLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                controller: cubit.shortBioController,
                hintText: localization.basicDataFormEnterBio,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(500),
                ],
                validator: (_) => null,
              ),
              verticalSpacing(28),

              _SubmitButton(),
              verticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBasicDataCubit, DoctorBasicDataState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<DoctorBasicDataCubit>();
        return AppCustomButton(
          title: S.of(context).basicDataFormSubmit,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: () {
            if (cubit.formKey.currentState?.validate() ?? false) {
              cubit.submitBasicData();
            }
          },
        );
      },
    );
  }
}
