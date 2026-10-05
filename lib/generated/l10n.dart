// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Family Name`
  String get familyName {
    return Intl.message('Family Name', name: 'familyName', desc: '', args: []);
  }

  /// `Enter Your First Name`
  String get enterFirstName {
    return Intl.message(
      'Enter Your First Name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Last Name`
  String get enterLastName {
    return Intl.message(
      'Enter Your Last Name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Mobile Number`
  String get enterMobileNumber {
    return Intl.message(
      'Enter Mobile Number',
      name: 'enterMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password must contain`
  String get passwordHint {
    return Intl.message(
      'Your password must contain',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Name`
  String get pleaseEnterYourName {
    return Intl.message(
      'Please Enter Your Name',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Phone Number`
  String get pleaseEnterYourPhoneNum {
    return Intl.message(
      'Please Enter Your Phone Number',
      name: 'pleaseEnterYourPhoneNum',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Corrent Phone Number`
  String get pleaseEnterYourCorrentPhoneNum {
    return Intl.message(
      'Please Enter Your Corrent Phone Number',
      name: 'pleaseEnterYourCorrentPhoneNum',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Password`
  String get PleaseEnterYourPassword {
    return Intl.message(
      'Please Enter Your Password',
      name: 'PleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least one uppercase letter, one number, and one special character.`
  String get passwordMustContain {
    return Intl.message(
      'The password must contain at least one uppercase letter, one number, and one special character.',
      name: 'passwordMustContain',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Password`
  String get pleaseEnterYourPassword {
    return Intl.message(
      'Please Enter Your Password',
      name: 'pleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Between 8 and 15 characters`
  String get passwordHint1 {
    return Intl.message(
      'Between 8 and 15 characters',
      name: 'passwordHint1',
      desc: '',
      args: [],
    );
  }

  /// `1 or more special characters`
  String get passwordHint2 {
    return Intl.message(
      '1 or more special characters',
      name: 'passwordHint2',
      desc: '',
      args: [],
    );
  }

  /// `1 or more numbers`
  String get passwordHint3 {
    return Intl.message(
      '1 or more numbers',
      name: 'passwordHint3',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Number`
  String get verifyYourNumber {
    return Intl.message(
      'Verify Your Number',
      name: 'verifyYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code we sent to your number.`
  String get verifyYourNumberHint {
    return Intl.message(
      'Enter the verification code we sent to your number.',
      name: 'verifyYourNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Patient`
  String get patient {
    return Intl.message('Patient', name: 'patient', desc: '', args: []);
  }

  /// `Doctor / Specialist`
  String get doctorSpecialist {
    return Intl.message(
      'Doctor / Specialist',
      name: 'doctorSpecialist',
      desc: '',
      args: [],
    );
  }

  /// `Medical Service Providers`
  String get medicalServiceProviders {
    return Intl.message(
      'Medical Service Providers',
      name: 'medicalServiceProviders',
      desc: '',
      args: [],
    );
  }

  /// `Insurance Companies`
  String get insuranceCompanies {
    return Intl.message(
      'Insurance Companies',
      name: 'insuranceCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Supporting Entities`
  String get supportingEntities {
    return Intl.message(
      'Supporting Entities',
      name: 'supportingEntities',
      desc: '',
      args: [],
    );
  }

  /// `Choose what you want to do to manage your medical record.`
  String get medicalRecordManagement {
    return Intl.message(
      'Choose what you want to do to manage your medical record.',
      name: 'medicalRecordManagement',
      desc: '',
      args: [],
    );
  }

  /// `Enter your medical record\ndata`
  String get enter_medical_data {
    return Intl.message(
      'Enter your medical record\ndata',
      name: 'enter_medical_data',
      desc: '',
      args: [],
    );
  }

  /// `View your medical\nrecord`
  String get view_medical_record {
    return Intl.message(
      'View your medical\nrecord',
      name: 'view_medical_record',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed Mohamed`
  String get dummyUserName {
    return Intl.message(
      'Ahmed Mohamed',
      name: 'dummyUserName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeTab {
    return Intl.message('Home', name: 'homeTab', desc: '', args: []);
  }

  /// `Medical`
  String get medical_recordTab {
    return Intl.message(
      'Medical',
      name: 'medical_recordTab',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get doctorsTab {
    return Intl.message('Doctors', name: 'doctorsTab', desc: '', args: []);
  }

  /// `Interaction`
  String get pharmaInteractionTab {
    return Intl.message(
      'Interaction',
      name: 'pharmaInteractionTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTab {
    return Intl.message('Settings', name: 'settingsTab', desc: '', args: []);
  }

  /// `By creating an account, you agree to our `
  String get by_creating_account_you_agree_to {
    return Intl.message(
      'By creating an account, you agree to our ',
      name: 'by_creating_account_you_agree_to',
      desc: '',
      args: [],
    );
  }

  /// ` Terms and Conditions of us`
  String get conditionsOFUse {
    return Intl.message(
      ' Terms and Conditions of us',
      name: 'conditionsOFUse',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get ok {
    return Intl.message('Accept', name: 'ok', desc: '', args: []);
  }

  /// `Terms and Conditions`
  String get T_and_C {
    return Intl.message(
      'Terms and Conditions',
      name: 'T_and_C',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account ? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account ? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account ? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account ? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get Continue {
    return Intl.message('Continue', name: 'Continue', desc: '', args: []);
  }

  /// `Enter your phone number, and we will send you a code to reset your password.`
  String get reset_password_subtitle {
    return Intl.message(
      'Enter your phone number, and we will send you a code to reset your password.',
      name: 'reset_password_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verfication_code {
    return Intl.message(
      'Verification Code',
      name: 'verfication_code',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification code to your phone, please enter it.`
  String get we_have_send_code_to_ur_phone {
    return Intl.message(
      'We have sent a verification code to your phone, please enter it.',
      name: 'we_have_send_code_to_ur_phone',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Create a New Password`
  String get create_new_password {
    return Intl.message(
      'Create a New Password',
      name: 'create_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Current Password`
  String get enterCurrentPassword {
    return Intl.message(
      'Enter Current Password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Empty field`
  String get white_spaces_validation {
    return Intl.message(
      'Empty field',
      name: 'white_spaces_validation',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search_text {
    return Intl.message('Search', name: 'search_text', desc: '', args: []);
  }

  /// `Drug Interactions`
  String get medical_inter_cat1 {
    return Intl.message(
      'Drug Interactions',
      name: 'medical_inter_cat1',
      desc: '',
      args: [],
    );
  }

  /// `Medical Summary`
  String get medical_summary_cat2 {
    return Intl.message(
      'Medical Summary',
      name: 'medical_summary_cat2',
      desc: '',
      args: [],
    );
  }

  /// `Life Quality`
  String get life_quality_cat3 {
    return Intl.message(
      'Life Quality',
      name: 'life_quality_cat3',
      desc: '',
      args: [],
    );
  }

  /// `Genetic Tree`
  String get genetical_inheritance {
    return Intl.message(
      'Genetic Tree',
      name: 'genetical_inheritance',
      desc: '',
      args: [],
    );
  }

  /// `Artificial Intelligence`
  String get artificial_intelligence {
    return Intl.message(
      'Artificial Intelligence',
      name: 'artificial_intelligence',
      desc: '',
      args: [],
    );
  }

  /// `Medical Report Preparation`
  String get category_star_ratings {
    return Intl.message(
      'Medical Report Preparation',
      name: 'category_star_ratings',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Evaluations`
  String get category_notifications {
    return Intl.message(
      'Doctor Evaluations',
      name: 'category_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Support Rooms`
  String get supprting_rooms {
    return Intl.message(
      'Support Rooms',
      name: 'supprting_rooms',
      desc: '',
      args: [],
    );
  }

  /// `Home Visit`
  String get home_visit_service {
    return Intl.message(
      'Home Visit',
      name: 'home_visit_service',
      desc: '',
      args: [],
    );
  }

  /// `Medical File`
  String get medical_files {
    return Intl.message(
      'Medical File',
      name: 'medical_files',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Search`
  String get doctor_search_service {
    return Intl.message(
      'Doctor Search',
      name: 'doctor_search_service',
      desc: '',
      args: [],
    );
  }

  /// `Medical Consultations`
  String get medical_consultations {
    return Intl.message(
      'Medical Consultations',
      name: 'medical_consultations',
      desc: '',
      args: [],
    );
  }

  /// `Choose X-Ray Body Part`
  String get choose_X_ray_body_part {
    return Intl.message(
      'Choose X-Ray Body Part',
      name: 'choose_X_ray_body_part',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get required_field {
    return Intl.message(
      'This field is required',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `Word`
  String get word {
    return Intl.message('Word', name: 'word', desc: '', args: []);
  }

  /// `You have exceeded the limit of 100 words!`
  String get word_limit_exceeded {
    return Intl.message(
      'You have exceeded the limit of 100 words!',
      name: 'word_limit_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get no_data_entered {
    return Intl.message('No data', name: 'no_data_entered', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `The image is unclear, please try again.`
  String get image_not_clear {
    return Intl.message(
      'The image is unclear, please try again.',
      name: 'image_not_clear',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Medical File`
  String get medicalFileTab {
    return Intl.message(
      'Medical File',
      name: 'medicalFileTab',
      desc: '',
      args: [],
    );
  }

  /// `Medicine Interaction`
  String get medicineInteractionTab {
    return Intl.message(
      'Medicine Interaction',
      name: 'medicineInteractionTab',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waitingLabel {
    return Intl.message('Waiting', name: 'waitingLabel', desc: '', args: []);
  }

  /// `Follow-ups`
  String get followUpsLabel {
    return Intl.message(
      'Follow-ups',
      name: 'followUpsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentBookingsLabelLine1 {
    return Intl.message(
      'Current',
      name: 'currentBookingsLabelLine1',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get currentBookingsLabelLine2 {
    return Intl.message(
      'Bookings',
      name: 'currentBookingsLabelLine2',
      desc: '',
      args: [],
    );
  }

  /// `Allowed`
  String get allowedBookingsLabelLine1 {
    return Intl.message(
      'Allowed',
      name: 'allowedBookingsLabelLine1',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get allowedBookingsLabelLine2 {
    return Intl.message(
      'Bookings',
      name: 'allowedBookingsLabelLine2',
      desc: '',
      args: [],
    );
  }

  /// `Data Completion`
  String get dataCompletionLabel {
    return Intl.message(
      'Data Completion',
      name: 'dataCompletionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Achieved`
  String get achievedLabel {
    return Intl.message('Achieved', name: 'achievedLabel', desc: '', args: []);
  }

  /// `Monthly Target Examinations`
  String get monthlyTargetExaminationsLabel {
    return Intl.message(
      'Monthly Target Examinations',
      name: 'monthlyTargetExaminationsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Examinations`
  String get monthlyExaminationsSectionTitle {
    return Intl.message(
      'Monthly Examinations',
      name: 'monthlyExaminationsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Target`
  String get monthlyTargetLabel {
    return Intl.message(
      'Target',
      name: 'monthlyTargetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Exams out of {total}`
  String examinationsOutOfTotalLabel(Object total) {
    return Intl.message(
      'Exams out of $total',
      name: 'examinationsOutOfTotalLabel',
      desc: '',
      args: [total],
    );
  }

  /// `Achievement rate {rate}%`
  String achievementRateLabel(Object rate) {
    return Intl.message(
      'Achievement rate $rate%',
      name: 'achievementRateLabel',
      desc: '',
      args: [rate],
    );
  }

  /// `Appearances`
  String get appearancesLabel {
    return Intl.message(
      'Appearances',
      name: 'appearancesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Shares`
  String get sharesLabel {
    return Intl.message('Shares', name: 'sharesLabel', desc: '', args: []);
  }

  /// `Watches`
  String get watchesLabel {
    return Intl.message('Watches', name: 'watchesLabel', desc: '', args: []);
  }

  /// `Per Month`
  String get perMonthLabel {
    return Intl.message('Per Month', name: 'perMonthLabel', desc: '', args: []);
  }

  /// `Per Year`
  String get perYearLabel {
    return Intl.message('Per Year', name: 'perYearLabel', desc: '', args: []);
  }

  /// `Edit Examination Value`
  String get editExaminationValueAction {
    return Intl.message(
      'Edit Examination Value',
      name: 'editExaminationValueAction',
      desc: '',
      args: [],
    );
  }

  /// `Activate Online Session`
  String get activateOnlineSessionAction {
    return Intl.message(
      'Activate Online Session',
      name: 'activateOnlineSessionAction',
      desc: '',
      args: [],
    );
  }

  /// `Basic Data`
  String get basicDataAction {
    return Intl.message(
      'Basic Data',
      name: 'basicDataAction',
      desc: '',
      args: [],
    );
  }

  /// `Message to Doctor`
  String get messageToDoctorAction {
    return Intl.message(
      'Message to Doctor',
      name: 'messageToDoctorAction',
      desc: '',
      args: [],
    );
  }

  /// `Patient Files`
  String get patientFilesAction {
    return Intl.message(
      'Patient Files',
      name: 'patientFilesAction',
      desc: '',
      args: [],
    );
  }

  /// `Online Exam Statistics`
  String get onlineExamStatsAction {
    return Intl.message(
      'Online Exam Statistics',
      name: 'onlineExamStatsAction',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get commentsTitle {
    return Intl.message('Comments', name: 'commentsTitle', desc: '', args: []);
  }

  /// `View More`
  String get viewMore {
    return Intl.message('View More', name: 'viewMore', desc: '', args: []);
  }

  /// `Raters`
  String get ratersLabel {
    return Intl.message('Raters', name: 'ratersLabel', desc: '', args: []);
  }

  /// `Bookings`
  String get bookingsTitle {
    return Intl.message('Bookings', name: 'bookingsTitle', desc: '', args: []);
  }

  /// `Manage today's appointments and waiting patients`
  String get bookingsSubtitle {
    return Intl.message(
      'Manage today\'s appointments and waiting patients',
      name: 'bookingsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Today's Appointments`
  String get todayAppointmentsTitle {
    return Intl.message(
      'Today\'s Appointments',
      name: 'todayAppointmentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting List`
  String get waitingListTitle {
    return Intl.message(
      'Waiting List',
      name: 'waitingListTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count} patients`
  String patientsCountLabel(Object count) {
    return Intl.message(
      '$count patients',
      name: 'patientsCountLabel',
      desc: '',
      args: [count],
    );
  }

  /// `Exam`
  String get examinationBadgeLabel {
    return Intl.message(
      'Exam',
      name: 'examinationBadgeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Consultation`
  String get consultationBadgeLabel {
    return Intl.message(
      'Consultation',
      name: 'consultationBadgeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Time has come`
  String get appointmentDueLabel {
    return Intl.message(
      'Time has come',
      name: 'appointmentDueLabel',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} min remaining`
  String minutesRemainingLabel(Object minutes) {
    return Intl.message(
      '$minutes min remaining',
      name: 'minutesRemainingLabel',
      desc: '',
      args: [minutes],
    );
  }

  /// `{minutes} min late`
  String minutesLateLabel(Object minutes) {
    return Intl.message(
      '$minutes min late',
      name: 'minutesLateLabel',
      desc: '',
      args: [minutes],
    );
  }

  /// `{minutes} min ago`
  String minutesAgoLabel(Object minutes) {
    return Intl.message(
      '$minutes min ago',
      name: 'minutesAgoLabel',
      desc: '',
      args: [minutes],
    );
  }

  /// `Allow Entry`
  String get allowEntryAction {
    return Intl.message(
      'Allow Entry',
      name: 'allowEntryAction',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get acceptAction {
    return Intl.message('Accept', name: 'acceptAction', desc: '', args: []);
  }

  /// `Reject`
  String get rejectAction {
    return Intl.message('Reject', name: 'rejectAction', desc: '', args: []);
  }

  /// `Tap Allow Entry when you're ready to receive the patient`
  String get todayInfoBannerText {
    return Intl.message(
      'Tap Allow Entry when you\'re ready to receive the patient',
      name: 'todayInfoBannerText',
      desc: '',
      args: [],
    );
  }

  /// `Accepting a patient adds them to today's appointments, so you can allow them in when ready`
  String get waitingInfoBannerText {
    return Intl.message(
      'Accepting a patient adds them to today\'s appointments, so you can allow them in when ready',
      name: 'waitingInfoBannerText',
      desc: '',
      args: [],
    );
  }

  /// `Examination in progress`
  String get examinationInProgressLabel {
    return Intl.message(
      'Examination in progress',
      name: 'examinationInProgressLabel',
      desc: '',
      args: [],
    );
  }

  /// `Microphone`
  String get microphoneAction {
    return Intl.message(
      'Microphone',
      name: 'microphoneAction',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get cameraAction {
    return Intl.message('Camera', name: 'cameraAction', desc: '', args: []);
  }

  /// `End Examination`
  String get endExaminationAction {
    return Intl.message(
      'End Examination',
      name: 'endExaminationAction',
      desc: '',
      args: [],
    );
  }

  /// `Speaker`
  String get speakerAction {
    return Intl.message('Speaker', name: 'speakerAction', desc: '', args: []);
  }

  /// `All data is encrypted and secure`
  String get encryptedDataNoticeText {
    return Intl.message(
      'All data is encrypted and secure',
      name: 'encryptedDataNoticeText',
      desc: '',
      args: [],
    );
  }

  /// `New Medicine Approval`
  String get newMedicineApprovalAction {
    return Intl.message(
      'New Medicine Approval',
      name: 'newMedicineApprovalAction',
      desc: '',
      args: [],
    );
  }

  /// `My Medicines Approval`
  String get myMedicinesApprovalAction {
    return Intl.message(
      'My Medicines Approval',
      name: 'myMedicinesApprovalAction',
      desc: '',
      args: [],
    );
  }

  /// `Prepare Medical Report`
  String get prepareMedicalReportAction {
    return Intl.message(
      'Prepare Medical Report',
      name: 'prepareMedicalReportAction',
      desc: '',
      args: [],
    );
  }

  /// `Medical File`
  String get medicalFileAction {
    return Intl.message(
      'Medical File',
      name: 'medicalFileAction',
      desc: '',
      args: [],
    );
  }

  /// `Prescription`
  String get prescriptionAction {
    return Intl.message(
      'Prescription',
      name: 'prescriptionAction',
      desc: '',
      args: [],
    );
  }

  /// `Basic Data`
  String get basicDataTitle {
    return Intl.message(
      'Basic Data',
      name: 'basicDataTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bank Information`
  String get bankInfoAction {
    return Intl.message(
      'Bank Information',
      name: 'bankInfoAction',
      desc: '',
      args: [],
    );
  }

  /// `Medical Specialty`
  String get medicalSpecialtyAction {
    return Intl.message(
      'Medical Specialty',
      name: 'medicalSpecialtyAction',
      desc: '',
      args: [],
    );
  }

  /// `Basic Data`
  String get basicDataMenuAction {
    return Intl.message(
      'Basic Data',
      name: 'basicDataMenuAction',
      desc: '',
      args: [],
    );
  }

  /// `Medical Association Membership`
  String get membershipAction {
    return Intl.message(
      'Medical Association Membership',
      name: 'membershipAction',
      desc: '',
      args: [],
    );
  }

  /// `Professional Experience`
  String get experienceAction {
    return Intl.message(
      'Professional Experience',
      name: 'experienceAction',
      desc: '',
      args: [],
    );
  }

  /// `Awards & Honors`
  String get awardsAction {
    return Intl.message(
      'Awards & Honors',
      name: 'awardsAction',
      desc: '',
      args: [],
    );
  }

  /// `Legal References`
  String get legalReferencesAction {
    return Intl.message(
      'Legal References',
      name: 'legalReferencesAction',
      desc: '',
      args: [],
    );
  }

  /// `Research & Publications`
  String get researchAndMessagesAction {
    return Intl.message(
      'Research & Publications',
      name: 'researchAndMessagesAction',
      desc: '',
      args: [],
    );
  }

  /// `Booking & Contact`
  String get bookingAndContactAction {
    return Intl.message(
      'Booking & Contact',
      name: 'bookingAndContactAction',
      desc: '',
      args: [],
    );
  }

  /// `Booking Settings`
  String get bookingSettingsAction {
    return Intl.message(
      'Booking Settings',
      name: 'bookingSettingsAction',
      desc: '',
      args: [],
    );
  }

  /// `Service Prices`
  String get servicePricesAction {
    return Intl.message(
      'Service Prices',
      name: 'servicePricesAction',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Examination Target`
  String get monthlyExaminationTargetAction {
    return Intl.message(
      'Monthly Examination Target',
      name: 'monthlyExaminationTargetAction',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get certificatesAction {
    return Intl.message(
      'Certificates',
      name: 'certificatesAction',
      desc: '',
      args: [],
    );
  }

  /// `Professional Licenses`
  String get professionalLicensesAction {
    return Intl.message(
      'Professional Licenses',
      name: 'professionalLicensesAction',
      desc: '',
      args: [],
    );
  }

  /// `Media & Articles`
  String get mediaAndArticlesAction {
    return Intl.message(
      'Media & Articles',
      name: 'mediaAndArticlesAction',
      desc: '',
      args: [],
    );
  }

  /// `Account Statements`
  String get accountStatementsAction {
    return Intl.message(
      'Account Statements',
      name: 'accountStatementsAction',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutAction {
    return Intl.message('Logout', name: 'logoutAction', desc: '', args: []);
  }

  /// `Manage Your Medical Work Easily`
  String get manageMedicalWorkEasilyTitle {
    return Intl.message(
      'Manage Your Medical Work Easily',
      name: 'manageMedicalWorkEasilyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Everything You Need in One Place`
  String get everythingInOnePlaceSubtitle {
    return Intl.message(
      'Everything You Need in One Place',
      name: 'everythingInOnePlaceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get basicDataFormPhotoLabel {
    return Intl.message(
      'Photo',
      name: 'basicDataFormPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get basicDataFormNameLabel {
    return Intl.message(
      'Name',
      name: 'basicDataFormNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Father's Name`
  String get basicDataFormFatherNameLabel {
    return Intl.message(
      'Father\'s Name',
      name: 'basicDataFormFatherNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Family Name`
  String get basicDataFormFamilyNameLabel {
    return Intl.message(
      'Family Name',
      name: 'basicDataFormFamilyNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get basicDataFormEnterName {
    return Intl.message(
      'Enter your name',
      name: 'basicDataFormEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Job Grade`
  String get basicDataFormJobGradeLabel {
    return Intl.message(
      'Job Grade',
      name: 'basicDataFormJobGradeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose your job grade`
  String get basicDataFormChooseJobGrade {
    return Intl.message(
      'Choose your job grade',
      name: 'basicDataFormChooseJobGrade',
      desc: '',
      args: [],
    );
  }

  /// `Academic Degree`
  String get basicDataFormAcademicDegreeLabel {
    return Intl.message(
      'Academic Degree',
      name: 'basicDataFormAcademicDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose your academic degree`
  String get basicDataFormChooseAcademicDegree {
    return Intl.message(
      'Choose your academic degree',
      name: 'basicDataFormChooseAcademicDegree',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get basicDataFormGenderLabel {
    return Intl.message(
      'Gender',
      name: 'basicDataFormGenderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get basicDataFormMale {
    return Intl.message('Male', name: 'basicDataFormMale', desc: '', args: []);
  }

  /// `Female`
  String get basicDataFormFemale {
    return Intl.message(
      'Female',
      name: 'basicDataFormFemale',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get basicDataFormBirthDateLabel {
    return Intl.message(
      'Date of Birth',
      name: 'basicDataFormBirthDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Day / Month / Year`
  String get basicDataFormBirthDatePlaceholder {
    return Intl.message(
      'Day / Month / Year',
      name: 'basicDataFormBirthDatePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get basicDataFormCountryLabel {
    return Intl.message(
      'Country',
      name: 'basicDataFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get basicDataFormChooseCountry {
    return Intl.message(
      'Choose',
      name: 'basicDataFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Governorate`
  String get basicDataFormGovernorateLabel {
    return Intl.message(
      'Governorate',
      name: 'basicDataFormGovernorateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get basicDataFormChooseGovernorate {
    return Intl.message(
      'Choose',
      name: 'basicDataFormChooseGovernorate',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get basicDataFormCityLabel {
    return Intl.message(
      'City',
      name: 'basicDataFormCityLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get basicDataFormChooseCity {
    return Intl.message(
      'Choose',
      name: 'basicDataFormChooseCity',
      desc: '',
      args: [],
    );
  }

  /// `Professional Mobile Number`
  String get basicDataFormProfessionalMobileLabel {
    return Intl.message(
      'Professional Mobile Number',
      name: 'basicDataFormProfessionalMobileLabel',
      desc: '',
      args: [],
    );
  }

  /// `App Contact Mobile Number`
  String get basicDataFormContactMobileLabel {
    return Intl.message(
      'App Contact Mobile Number',
      name: 'basicDataFormContactMobileLabel',
      desc: '',
      args: [],
    );
  }

  /// `National ID / Passport Number`
  String get basicDataFormNationalIdLabel {
    return Intl.message(
      'National ID / Passport Number',
      name: 'basicDataFormNationalIdLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your national ID number`
  String get basicDataFormEnterNationalId {
    return Intl.message(
      'Enter your national ID number',
      name: 'basicDataFormEnterNationalId',
      desc: '',
      args: [],
    );
  }

  /// `National ID / Passport Photo`
  String get basicDataFormNationalIdPhotoLabel {
    return Intl.message(
      'National ID / Passport Photo',
      name: 'basicDataFormNationalIdPhotoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Spoken Languages`
  String get basicDataFormLanguagesLabel {
    return Intl.message(
      'Spoken Languages',
      name: 'basicDataFormLanguagesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose languages`
  String get basicDataFormChooseLanguages {
    return Intl.message(
      'Choose languages',
      name: 'basicDataFormChooseLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Search for a language`
  String get basicDataFormSearchLanguages {
    return Intl.message(
      'Search for a language',
      name: 'basicDataFormSearchLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Short Bio`
  String get basicDataFormBioLabel {
    return Intl.message(
      'Short Bio',
      name: 'basicDataFormBioLabel',
      desc: '',
      args: [],
    );
  }

  /// `Briefly write your bio`
  String get basicDataFormEnterBio {
    return Intl.message(
      'Briefly write your bio',
      name: 'basicDataFormEnterBio',
      desc: '',
      args: [],
    );
  }

  /// `{count}/500 characters`
  String basicDataFormBioCharCount(int count) {
    return Intl.message(
      '$count/500 characters',
      name: 'basicDataFormBioCharCount',
      desc: '',
      args: [count],
    );
  }

  /// `Submit`
  String get basicDataFormSubmit {
    return Intl.message(
      'Submit',
      name: 'basicDataFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Main Specialty`
  String get medicalSpecialtyFormMainSpecialtyLabel {
    return Intl.message(
      'Main Specialty',
      name: 'medicalSpecialtyFormMainSpecialtyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose your main specialty`
  String get medicalSpecialtyFormChooseMainSpecialty {
    return Intl.message(
      'Choose your main specialty',
      name: 'medicalSpecialtyFormChooseMainSpecialty',
      desc: '',
      args: [],
    );
  }

  /// `Sub-specialty`
  String get medicalSpecialtyFormSubSpecialtyLabel {
    return Intl.message(
      'Sub-specialty',
      name: 'medicalSpecialtyFormSubSpecialtyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your sub-specialty`
  String get medicalSpecialtyFormEnterSubSpecialty {
    return Intl.message(
      'Enter your sub-specialty',
      name: 'medicalSpecialtyFormEnterSubSpecialty',
      desc: '',
      args: [],
    );
  }

  /// `Clinical / Medical Interests`
  String get medicalSpecialtyFormInterestsLabel {
    return Intl.message(
      'Clinical / Medical Interests',
      name: 'medicalSpecialtyFormInterestsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your clinical / medical interests`
  String get medicalSpecialtyFormEnterInterests {
    return Intl.message(
      'Enter your clinical / medical interests',
      name: 'medicalSpecialtyFormEnterInterests',
      desc: '',
      args: [],
    );
  }

  /// `Country Name`
  String get bankInfoFormCountryLabel {
    return Intl.message(
      'Country Name',
      name: 'bankInfoFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get bankInfoFormChooseCountry {
    return Intl.message(
      'Choose',
      name: 'bankInfoFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get bankInfoFormUserNameLabel {
    return Intl.message(
      'User Name',
      name: 'bankInfoFormUserNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the user name`
  String get bankInfoFormEnterUserName {
    return Intl.message(
      'Enter the user name',
      name: 'bankInfoFormEnterUserName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankInfoFormBankNameLabel {
    return Intl.message(
      'Bank Name',
      name: 'bankInfoFormBankNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the bank name`
  String get bankInfoFormEnterBankName {
    return Intl.message(
      'Enter the bank name',
      name: 'bankInfoFormEnterBankName',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get bankInfoFormBranchNameLabel {
    return Intl.message(
      'Branch',
      name: 'bankInfoFormBranchNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the branch name`
  String get bankInfoFormEnterBranchName {
    return Intl.message(
      'Enter the branch name',
      name: 'bankInfoFormEnterBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get bankInfoFormAccountNumberLabel {
    return Intl.message(
      'Account Number',
      name: 'bankInfoFormAccountNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the account number`
  String get bankInfoFormEnterAccountNumber {
    return Intl.message(
      'Enter the account number',
      name: 'bankInfoFormEnterAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `IBAN`
  String get bankInfoFormIbanLabel {
    return Intl.message(
      'IBAN',
      name: 'bankInfoFormIbanLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the IBAN number`
  String get bankInfoFormEnterIban {
    return Intl.message(
      'Enter the IBAN number',
      name: 'bankInfoFormEnterIban',
      desc: '',
      args: [],
    );
  }

  /// `Add another bank account`
  String get bankInfoFormAddAnotherAccountAction {
    return Intl.message(
      'Add another bank account',
      name: 'bankInfoFormAddAnotherAccountAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get bankInfoFormSubmit {
    return Intl.message(
      'Submit',
      name: 'bankInfoFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Granting Body`
  String get certificatesFormGrantingBodyLabel {
    return Intl.message(
      'Granting Body',
      name: 'certificatesFormGrantingBodyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the granting body name`
  String get certificatesFormEnterGrantingBody {
    return Intl.message(
      'Enter the granting body name',
      name: 'certificatesFormEnterGrantingBody',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get certificatesFormCountryLabel {
    return Intl.message(
      'Country',
      name: 'certificatesFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the country`
  String get certificatesFormChooseCountry {
    return Intl.message(
      'Choose the country',
      name: 'certificatesFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Date Obtained`
  String get certificatesFormObtainedDateLabel {
    return Intl.message(
      'Date Obtained',
      name: 'certificatesFormObtainedDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the date you obtained the certificate`
  String get certificatesFormChooseObtainedDate {
    return Intl.message(
      'Enter the date you obtained the certificate',
      name: 'certificatesFormChooseObtainedDate',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get certificatesFormSubmit {
    return Intl.message(
      'Submit',
      name: 'certificatesFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor's Degree`
  String get certificatesFormBachelorSectionTitle {
    return Intl.message(
      'Bachelor\'s Degree',
      name: 'certificatesFormBachelorSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor's Degree`
  String get certificatesFormBachelorDegreeLabel {
    return Intl.message(
      'Bachelor\'s Degree',
      name: 'certificatesFormBachelorDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the degree name`
  String get certificatesFormEnterBachelorDegree {
    return Intl.message(
      'Enter the degree name',
      name: 'certificatesFormEnterBachelorDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another bachelor's degree if available`
  String get certificatesFormAddAnotherBachelorAction {
    return Intl.message(
      'Add another bachelor\'s degree if available',
      name: 'certificatesFormAddAnotherBachelorAction',
      desc: '',
      args: [],
    );
  }

  /// `Diploma`
  String get certificatesFormDiplomaSectionTitle {
    return Intl.message(
      'Diploma',
      name: 'certificatesFormDiplomaSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Diploma Degree`
  String get certificatesFormDiplomaDegreeLabel {
    return Intl.message(
      'Diploma Degree',
      name: 'certificatesFormDiplomaDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the degree name`
  String get certificatesFormEnterDiplomaDegree {
    return Intl.message(
      'Enter the degree name',
      name: 'certificatesFormEnterDiplomaDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another diploma if available`
  String get certificatesFormAddAnotherDiplomaAction {
    return Intl.message(
      'Add another diploma if available',
      name: 'certificatesFormAddAnotherDiplomaAction',
      desc: '',
      args: [],
    );
  }

  /// `Master's Degree`
  String get certificatesFormMasterSectionTitle {
    return Intl.message(
      'Master\'s Degree',
      name: 'certificatesFormMasterSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Master's Degree`
  String get certificatesFormMasterDegreeLabel {
    return Intl.message(
      'Master\'s Degree',
      name: 'certificatesFormMasterDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the degree name`
  String get certificatesFormEnterMasterDegree {
    return Intl.message(
      'Enter the degree name',
      name: 'certificatesFormEnterMasterDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another master's degree if available`
  String get certificatesFormAddAnotherMasterAction {
    return Intl.message(
      'Add another master\'s degree if available',
      name: 'certificatesFormAddAnotherMasterAction',
      desc: '',
      args: [],
    );
  }

  /// `Doctorate`
  String get certificatesFormDoctorateSectionTitle {
    return Intl.message(
      'Doctorate',
      name: 'certificatesFormDoctorateSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Doctorate Degree`
  String get certificatesFormDoctorateDegreeLabel {
    return Intl.message(
      'Doctorate Degree',
      name: 'certificatesFormDoctorateDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the degree name`
  String get certificatesFormEnterDoctorateDegree {
    return Intl.message(
      'Enter the degree name',
      name: 'certificatesFormEnterDoctorateDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another doctorate if available`
  String get certificatesFormAddAnotherDoctorateAction {
    return Intl.message(
      'Add another doctorate if available',
      name: 'certificatesFormAddAnotherDoctorateAction',
      desc: '',
      args: [],
    );
  }

  /// `Fellowship`
  String get certificatesFormFellowshipSectionTitle {
    return Intl.message(
      'Fellowship',
      name: 'certificatesFormFellowshipSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fellowship Degree`
  String get certificatesFormFellowshipDegreeLabel {
    return Intl.message(
      'Fellowship Degree',
      name: 'certificatesFormFellowshipDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the degree name`
  String get certificatesFormEnterFellowshipDegree {
    return Intl.message(
      'Enter the degree name',
      name: 'certificatesFormEnterFellowshipDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another fellowship if available`
  String get certificatesFormAddAnotherFellowshipAction {
    return Intl.message(
      'Add another fellowship if available',
      name: 'certificatesFormAddAnotherFellowshipAction',
      desc: '',
      args: [],
    );
  }

  /// `Board Certifications / Professional Courses`
  String get certificatesFormBoardCertificationSectionTitle {
    return Intl.message(
      'Board Certifications / Professional Courses',
      name: 'certificatesFormBoardCertificationSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Course Name / Professional Certificate`
  String get certificatesFormBoardCertificationDegreeLabel {
    return Intl.message(
      'Course Name / Professional Certificate',
      name: 'certificatesFormBoardCertificationDegreeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the course / specialized certificate name`
  String get certificatesFormEnterBoardCertificationDegree {
    return Intl.message(
      'Enter the course / specialized certificate name',
      name: 'certificatesFormEnterBoardCertificationDegree',
      desc: '',
      args: [],
    );
  }

  /// `Add another course / certificate if available`
  String get certificatesFormAddAnotherBoardCertificationAction {
    return Intl.message(
      'Add another course / certificate if available',
      name: 'certificatesFormAddAnotherBoardCertificationAction',
      desc: '',
      args: [],
    );
  }

  /// `Media & Articles`
  String get mediaArticlesFormSectionTitle {
    return Intl.message(
      'Media & Articles',
      name: 'mediaArticlesFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get mediaArticlesFormTitleLabel {
    return Intl.message(
      'Title',
      name: 'mediaArticlesFormTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the title`
  String get mediaArticlesFormEnterTitle {
    return Intl.message(
      'Enter the title',
      name: 'mediaArticlesFormEnterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get mediaArticlesFormSubjectLabel {
    return Intl.message(
      'Subject',
      name: 'mediaArticlesFormSubjectLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the subject`
  String get mediaArticlesFormEnterSubject {
    return Intl.message(
      'Enter the subject',
      name: 'mediaArticlesFormEnterSubject',
      desc: '',
      args: [],
    );
  }

  /// `Media & Articles Link`
  String get mediaArticlesFormLinkLabel {
    return Intl.message(
      'Media & Articles Link',
      name: 'mediaArticlesFormLinkLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the media/articles link`
  String get mediaArticlesFormEnterLink {
    return Intl.message(
      'Enter the media/articles link',
      name: 'mediaArticlesFormEnterLink',
      desc: '',
      args: [],
    );
  }

  /// `Add another if available`
  String get mediaArticlesFormAddAnotherAction {
    return Intl.message(
      'Add another if available',
      name: 'mediaArticlesFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get mediaArticlesFormSubmit {
    return Intl.message(
      'Submit',
      name: 'mediaArticlesFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Research & Papers`
  String get researchAndPapersFormSectionTitle {
    return Intl.message(
      'Research & Papers',
      name: 'researchAndPapersFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Research & Papers`
  String get researchAndPapersFormTitleLabel {
    return Intl.message(
      'Your Research & Papers',
      name: 'researchAndPapersFormTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your research & papers`
  String get researchAndPapersFormEnterTitle {
    return Intl.message(
      'Enter your research & papers',
      name: 'researchAndPapersFormEnterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get researchAndPapersFormYearLabel {
    return Intl.message(
      'Year',
      name: 'researchAndPapersFormYearLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the year`
  String get researchAndPapersFormChooseYear {
    return Intl.message(
      'Choose the year',
      name: 'researchAndPapersFormChooseYear',
      desc: '',
      args: [],
    );
  }

  /// `Research Link / DOI / PMID`
  String get researchAndPapersFormLinkLabel {
    return Intl.message(
      'Research Link / DOI / PMID',
      name: 'researchAndPapersFormLinkLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the research link or Digital Object Identifier`
  String get researchAndPapersFormEnterLink {
    return Intl.message(
      'Enter the research link or Digital Object Identifier',
      name: 'researchAndPapersFormEnterLink',
      desc: '',
      args: [],
    );
  }

  /// `Add another research if available`
  String get researchAndPapersFormAddAnotherAction {
    return Intl.message(
      'Add another research if available',
      name: 'researchAndPapersFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get researchAndPapersFormSubmit {
    return Intl.message(
      'Submit',
      name: 'researchAndPapersFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Professional Experience`
  String get experienceFormSectionTitle {
    return Intl.message(
      'Professional Experience',
      name: 'experienceFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get experienceFormPositionLabel {
    return Intl.message(
      'Position',
      name: 'experienceFormPositionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the position name`
  String get experienceFormEnterPosition {
    return Intl.message(
      'Enter the position name',
      name: 'experienceFormEnterPosition',
      desc: '',
      args: [],
    );
  }

  /// `Work Place`
  String get experienceFormWorkPlaceLabel {
    return Intl.message(
      'Work Place',
      name: 'experienceFormWorkPlaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the work place`
  String get experienceFormEnterWorkPlace {
    return Intl.message(
      'Enter the work place',
      name: 'experienceFormEnterWorkPlace',
      desc: '',
      args: [],
    );
  }

  /// `Work Duration`
  String get experienceFormDurationLabel {
    return Intl.message(
      'Work Duration',
      name: 'experienceFormDurationLabel',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get experienceFormFromLabel {
    return Intl.message(
      'From',
      name: 'experienceFormFromLabel',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get experienceFormToLabel {
    return Intl.message(
      'To',
      name: 'experienceFormToLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the date`
  String get experienceFormChooseDate {
    return Intl.message(
      'Enter the date',
      name: 'experienceFormChooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get experienceFormCountryLabel {
    return Intl.message(
      'Country',
      name: 'experienceFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the country name`
  String get experienceFormChooseCountry {
    return Intl.message(
      'Choose the country name',
      name: 'experienceFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Add another experience if available`
  String get experienceFormAddAnotherAction {
    return Intl.message(
      'Add another experience if available',
      name: 'experienceFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get experienceFormSubmit {
    return Intl.message(
      'Submit',
      name: 'experienceFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Professional Licenses`
  String get professionalLicensesFormSectionTitle {
    return Intl.message(
      'Professional Licenses',
      name: 'professionalLicensesFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Doctor's Syndicate Registration Number`
  String get professionalLicensesFormLicenseNumberLabel {
    return Intl.message(
      'Doctor\'s Syndicate Registration Number',
      name: 'professionalLicensesFormLicenseNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the registration number`
  String get professionalLicensesFormEnterLicenseNumber {
    return Intl.message(
      'Enter the registration number',
      name: 'professionalLicensesFormEnterLicenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `License Country`
  String get professionalLicensesFormCountryLabel {
    return Intl.message(
      'License Country',
      name: 'professionalLicensesFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the license country`
  String get professionalLicensesFormChooseCountry {
    return Intl.message(
      'Choose the license country',
      name: 'professionalLicensesFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Licensing Authority`
  String get professionalLicensesFormLicensingAuthorityLabel {
    return Intl.message(
      'Licensing Authority',
      name: 'professionalLicensesFormLicensingAuthorityLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the licensing authority name`
  String get professionalLicensesFormEnterLicensingAuthority {
    return Intl.message(
      'Enter the licensing authority name',
      name: 'professionalLicensesFormEnterLicensingAuthority',
      desc: '',
      args: [],
    );
  }

  /// `License Number`
  String get professionalLicensesFormRegistrationNumberLabel {
    return Intl.message(
      'License Number',
      name: 'professionalLicensesFormRegistrationNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the license number`
  String get professionalLicensesFormEnterRegistrationNumber {
    return Intl.message(
      'Enter the license number',
      name: 'professionalLicensesFormEnterRegistrationNumber',
      desc: '',
      args: [],
    );
  }

  /// `License Date`
  String get professionalLicensesFormLicenseDateLabel {
    return Intl.message(
      'License Date',
      name: 'professionalLicensesFormLicenseDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Day/ Month / Year`
  String get professionalLicensesFormChooseDate {
    return Intl.message(
      'Day/ Month / Year',
      name: 'professionalLicensesFormChooseDate',
      desc: '',
      args: [],
    );
  }

  /// `License Valid Until`
  String get professionalLicensesFormExpiryDateLabel {
    return Intl.message(
      'License Valid Until',
      name: 'professionalLicensesFormExpiryDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `License`
  String get professionalLicensesFormLicenseImageLabel {
    return Intl.message(
      'License',
      name: 'professionalLicensesFormLicenseImageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Attach a photo from device`
  String get professionalLicensesFormAttachImageAction {
    return Intl.message(
      'Attach a photo from device',
      name: 'professionalLicensesFormAttachImageAction',
      desc: '',
      args: [],
    );
  }

  /// `Add another license if available`
  String get professionalLicensesFormAddAnotherAction {
    return Intl.message(
      'Add another license if available',
      name: 'professionalLicensesFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get professionalLicensesFormSubmit {
    return Intl.message(
      'Submit',
      name: 'professionalLicensesFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Medical Association Membership`
  String get membershipFormSectionTitle {
    return Intl.message(
      'Medical Association Membership',
      name: 'membershipFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get membershipFormCountryLabel {
    return Intl.message(
      'Country',
      name: 'membershipFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the country name`
  String get membershipFormChooseCountry {
    return Intl.message(
      'Choose the country name',
      name: 'membershipFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Association`
  String get membershipFormAssociationNameLabel {
    return Intl.message(
      'Association',
      name: 'membershipFormAssociationNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the association name`
  String get membershipFormEnterAssociationName {
    return Intl.message(
      'Enter the association name',
      name: 'membershipFormEnterAssociationName',
      desc: '',
      args: [],
    );
  }

  /// `Membership Number`
  String get membershipFormNumberLabel {
    return Intl.message(
      'Membership Number',
      name: 'membershipFormNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the membership number`
  String get membershipFormEnterNumber {
    return Intl.message(
      'Enter the membership number',
      name: 'membershipFormEnterNumber',
      desc: '',
      args: [],
    );
  }

  /// `Membership Level`
  String get membershipFormLevelLabel {
    return Intl.message(
      'Membership Level',
      name: 'membershipFormLevelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the membership level`
  String get membershipFormChooseLevel {
    return Intl.message(
      'Choose the membership level',
      name: 'membershipFormChooseLevel',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get membershipFormYearLabel {
    return Intl.message(
      'Year',
      name: 'membershipFormYearLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the year`
  String get membershipFormChooseYear {
    return Intl.message(
      'Choose the year',
      name: 'membershipFormChooseYear',
      desc: '',
      args: [],
    );
  }

  /// `Add another membership if available`
  String get membershipFormAddAnotherAction {
    return Intl.message(
      'Add another membership if available',
      name: 'membershipFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get membershipFormSubmit {
    return Intl.message(
      'Submit',
      name: 'membershipFormSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Awards & Honors`
  String get awardsFormSectionTitle {
    return Intl.message(
      'Awards & Honors',
      name: 'awardsFormSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Awards & Honors`
  String get awardsFormAwardNameLabel {
    return Intl.message(
      'Awards & Honors',
      name: 'awardsFormAwardNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your awards & honors`
  String get awardsFormEnterAwardName {
    return Intl.message(
      'Enter your awards & honors',
      name: 'awardsFormEnterAwardName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get awardsFormCountryLabel {
    return Intl.message(
      'Country',
      name: 'awardsFormCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the country name`
  String get awardsFormChooseCountry {
    return Intl.message(
      'Choose the country name',
      name: 'awardsFormChooseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Granting Body`
  String get awardsFormGrantingBodyLabel {
    return Intl.message(
      'Granting Body',
      name: 'awardsFormGrantingBodyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the granting body name`
  String get awardsFormEnterGrantingBody {
    return Intl.message(
      'Enter the granting body name',
      name: 'awardsFormEnterGrantingBody',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get awardsFormYearLabel {
    return Intl.message(
      'Year',
      name: 'awardsFormYearLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose the year`
  String get awardsFormChooseYear {
    return Intl.message(
      'Choose the year',
      name: 'awardsFormChooseYear',
      desc: '',
      args: [],
    );
  }

  /// `Add another award if available`
  String get awardsFormAddAnotherAction {
    return Intl.message(
      'Add another award if available',
      name: 'awardsFormAddAnotherAction',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get awardsFormSubmit {
    return Intl.message('Submit', name: 'awardsFormSubmit', desc: '', args: []);
  }

  /// `Set your examination and consultation prices based on the patient's location and service type`
  String get servicePricesFormBannerSubtitle {
    return Intl.message(
      'Set your examination and consultation prices based on the patient\'s location and service type',
      name: 'servicePricesFormBannerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Examination`
  String get servicePricesFormExaminationSectionTitle {
    return Intl.message(
      'Examination',
      name: 'servicePricesFormExaminationSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set the examination price for patients inside and outside Egypt`
  String get servicePricesFormExaminationSectionSubtitle {
    return Intl.message(
      'Set the examination price for patients inside and outside Egypt',
      name: 'servicePricesFormExaminationSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Examination price inside Egypt`
  String get servicePricesFormExaminationPriceInsideEgyptLabel {
    return Intl.message(
      'Examination price inside Egypt',
      name: 'servicePricesFormExaminationPriceInsideEgyptLabel',
      desc: '',
      args: [],
    );
  }

  /// `Examination price outside Egypt`
  String get servicePricesFormExaminationPriceOutsideEgyptLabel {
    return Intl.message(
      'Examination price outside Egypt',
      name: 'servicePricesFormExaminationPriceOutsideEgyptLabel',
      desc: '',
      args: [],
    );
  }

  /// `Consultation`
  String get servicePricesFormConsultationSectionTitle {
    return Intl.message(
      'Consultation',
      name: 'servicePricesFormConsultationSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set whether you offer a follow-up consultation after the examination`
  String get servicePricesFormConsultationSectionSubtitle {
    return Intl.message(
      'Set whether you offer a follow-up consultation after the examination',
      name: 'servicePricesFormConsultationSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you offer a follow-up consultation?`
  String get servicePricesFormOffersFollowUpLabel {
    return Intl.message(
      'Do you offer a follow-up consultation?',
      name: 'servicePricesFormOffersFollowUpLabel',
      desc: '',
      args: [],
    );
  }

  /// `Follow-up consultation validity`
  String get servicePricesFormValidityLabel {
    return Intl.message(
      'Follow-up consultation validity',
      name: 'servicePricesFormValidityLabel',
      desc: '',
      args: [],
    );
  }

  /// `The number of days a patient can book a follow-up consultation after the examination`
  String get servicePricesFormValidityHint {
    return Intl.message(
      'The number of days a patient can book a follow-up consultation after the examination',
      name: 'servicePricesFormValidityHint',
      desc: '',
      args: [],
    );
  }

  /// `Choose the number of days`
  String get servicePricesFormChooseValidity {
    return Intl.message(
      'Choose the number of days',
      name: 'servicePricesFormChooseValidity',
      desc: '',
      args: [],
    );
  }

  /// `{days} days`
  String servicePricesFormValidityDaysValue(int days) {
    return Intl.message(
      '$days days',
      name: 'servicePricesFormValidityDaysValue',
      desc: '',
      args: [days],
    );
  }

  /// `Important notes`
  String get servicePricesFormNotesTitle {
    return Intl.message(
      'Important notes',
      name: 'servicePricesFormNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `The examination is a paid service and its price is set per country.`
  String get servicePricesFormNoteExaminationPaid {
    return Intl.message(
      'The examination is a paid service and its price is set per country.',
      name: 'servicePricesFormNoteExaminationPaid',
      desc: '',
      args: [],
    );
  }

  /// `The follow-up consultation (if offered) is usually free, according to the doctor's policy.`
  String get servicePricesFormNoteConsultationFree {
    return Intl.message(
      'The follow-up consultation (if offered) is usually free, according to the doctor\'s policy.',
      name: 'servicePricesFormNoteConsultationFree',
      desc: '',
      args: [],
    );
  }

  /// `Once the follow-up consultation validity period ends, the patient can no longer book a new follow-up consultation.`
  String get servicePricesFormNoteValidityExpiry {
    return Intl.message(
      'Once the follow-up consultation validity period ends, the patient can no longer book a new follow-up consultation.',
      name: 'servicePricesFormNoteValidityExpiry',
      desc: '',
      args: [],
    );
  }

  /// `Save Settings`
  String get servicePricesFormSaveSettings {
    return Intl.message(
      'Save Settings',
      name: 'servicePricesFormSaveSettings',
      desc: '',
      args: [],
    );
  }

  /// `Set your booking and appointment details according to your schedule and preferences`
  String get bookingSettingsFormBannerSubtitle {
    return Intl.message(
      'Set your booking and appointment details according to your schedule and preferences',
      name: 'bookingSettingsFormBannerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Daily Bookings`
  String get bookingSettingsFormDailyLimitTitle {
    return Intl.message(
      'Daily Bookings',
      name: 'bookingSettingsFormDailyLimitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Allowed daily bookings`
  String get bookingSettingsFormDailyLimitLabel {
    return Intl.message(
      'Allowed daily bookings',
      name: 'bookingSettingsFormDailyLimitLabel',
      desc: '',
      args: [],
    );
  }

  /// `The maximum number of bookings patients can make in a single day`
  String get bookingSettingsFormDailyLimitHint {
    return Intl.message(
      'The maximum number of bookings patients can make in a single day',
      name: 'bookingSettingsFormDailyLimitHint',
      desc: '',
      args: [],
    );
  }

  /// `bookings/day`
  String get bookingSettingsFormDailyLimitUnit {
    return Intl.message(
      'bookings/day',
      name: 'bookingSettingsFormDailyLimitUnit',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Booking Days`
  String get bookingSettingsFormWeeklyDaysTitle {
    return Intl.message(
      'Weekly Booking Days',
      name: 'bookingSettingsFormWeeklyDaysTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose the days you accept bookings`
  String get bookingSettingsFormWeeklyDaysSubtitle {
    return Intl.message(
      'Choose the days you accept bookings',
      name: 'bookingSettingsFormWeeklyDaysSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Booking Times`
  String get bookingSettingsFormWeeklyTimesTitle {
    return Intl.message(
      'Weekly Booking Times',
      name: 'bookingSettingsFormWeeklyTimesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set the booking time ranges for each day of the week`
  String get bookingSettingsFormWeeklyTimesSubtitle {
    return Intl.message(
      'Set the booking time ranges for each day of the week',
      name: 'bookingSettingsFormWeeklyTimesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get bookingSettingsFormNotAvailable {
    return Intl.message(
      'Not available',
      name: 'bookingSettingsFormNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add a time range`
  String get bookingSettingsFormAddTimeRange {
    return Intl.message(
      'Add a time range',
      name: 'bookingSettingsFormAddTimeRange',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Interval`
  String get bookingSettingsFormIntervalTitle {
    return Intl.message(
      'Appointment Interval',
      name: 'bookingSettingsFormIntervalTitle',
      desc: '',
      args: [],
    );
  }

  /// `The time gap between the appointment slots shown to patients for booking..`
  String get bookingSettingsFormIntervalSubtitle {
    return Intl.message(
      'The time gap between the appointment slots shown to patients for booking..',
      name: 'bookingSettingsFormIntervalSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get bookingSettingsFormIntervalUnit {
    return Intl.message(
      'minutes',
      name: 'bookingSettingsFormIntervalUnit',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get bookingSettingsFormNotesTitle {
    return Intl.message(
      'Notes',
      name: 'bookingSettingsFormNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `These settings are used to display appointments to patients and to control your daily booking count and monthly targets.`
  String get bookingSettingsFormNoteUsage {
    return Intl.message(
      'These settings are used to display appointments to patients and to control your daily booking count and monthly targets.',
      name: 'bookingSettingsFormNoteUsage',
      desc: '',
      args: [],
    );
  }

  /// `Save Settings`
  String get bookingSettingsFormSaveSettings {
    return Intl.message(
      'Save Settings',
      name: 'bookingSettingsFormSaveSettings',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get bookingSettingsFormStartTimeSheetTitle {
    return Intl.message(
      'Start time',
      name: 'bookingSettingsFormStartTimeSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `End time`
  String get bookingSettingsFormEndTimeSheetTitle {
    return Intl.message(
      'End time',
      name: 'bookingSettingsFormEndTimeSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set the target number of examinations for the month`
  String get monthlyExaminationTargetFormBannerSubtitle {
    return Intl.message(
      'Set the target number of examinations for the month',
      name: 'monthlyExaminationTargetFormBannerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Goal`
  String get monthlyExaminationTargetFormGoalSectionTitle {
    return Intl.message(
      'Monthly Goal',
      name: 'monthlyExaminationTargetFormGoalSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `The target number of examinations for a single month`
  String get monthlyExaminationTargetFormGoalSectionSubtitle {
    return Intl.message(
      'The target number of examinations for a single month',
      name: 'monthlyExaminationTargetFormGoalSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `exams`
  String get monthlyExaminationTargetFormGoalUnit {
    return Intl.message(
      'exams',
      name: 'monthlyExaminationTargetFormGoalUnit',
      desc: '',
      args: [],
    );
  }

  /// `Choose the target count`
  String get monthlyExaminationTargetFormChooseGoal {
    return Intl.message(
      'Choose the target count',
      name: 'monthlyExaminationTargetFormChooseGoal',
      desc: '',
      args: [],
    );
  }

  /// `of target`
  String get monthlyExaminationTargetFormOfTarget {
    return Intl.message(
      'of target',
      name: 'monthlyExaminationTargetFormOfTarget',
      desc: '',
      args: [],
    );
  }

  /// `Current Achievement`
  String get monthlyExaminationTargetFormCurrentAchievementTitle {
    return Intl.message(
      'Current Achievement',
      name: 'monthlyExaminationTargetFormCurrentAchievementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Achieved exams`
  String get monthlyExaminationTargetFormAchievedCaption {
    return Intl.message(
      'Achieved exams',
      name: 'monthlyExaminationTargetFormAchievedCaption',
      desc: '',
      args: [],
    );
  }

  /// `Monthly goal`
  String get monthlyExaminationTargetFormGoalCaption {
    return Intl.message(
      'Monthly goal',
      name: 'monthlyExaminationTargetFormGoalCaption',
      desc: '',
      args: [],
    );
  }

  /// `The completion percentage will be shown on the home page so you can track your monthly performance instantly and automatically.`
  String get monthlyExaminationTargetFormInfoBanner {
    return Intl.message(
      'The completion percentage will be shown on the home page so you can track your monthly performance instantly and automatically.',
      name: 'monthlyExaminationTargetFormInfoBanner',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Target History`
  String get monthlyExaminationTargetFormHistoryTitle {
    return Intl.message(
      'Monthly Target History',
      name: 'monthlyExaminationTargetFormHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get monthlyExaminationTargetFormHistoryColumnMonth {
    return Intl.message(
      'Month',
      name: 'monthlyExaminationTargetFormHistoryColumnMonth',
      desc: '',
      args: [],
    );
  }

  /// `Goal`
  String get monthlyExaminationTargetFormHistoryColumnGoal {
    return Intl.message(
      'Goal',
      name: 'monthlyExaminationTargetFormHistoryColumnGoal',
      desc: '',
      args: [],
    );
  }

  /// `Achieved`
  String get monthlyExaminationTargetFormHistoryColumnAchieved {
    return Intl.message(
      'Achieved',
      name: 'monthlyExaminationTargetFormHistoryColumnAchieved',
      desc: '',
      args: [],
    );
  }

  /// `Completion`
  String get monthlyExaminationTargetFormHistoryColumnCompletion {
    return Intl.message(
      'Completion',
      name: 'monthlyExaminationTargetFormHistoryColumnCompletion',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get monthlyExaminationTargetFormRetry {
    return Intl.message(
      'Retry',
      name: 'monthlyExaminationTargetFormRetry',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get daySaturday {
    return Intl.message('Saturday', name: 'daySaturday', desc: '', args: []);
  }

  /// `Sunday`
  String get daySunday {
    return Intl.message('Sunday', name: 'daySunday', desc: '', args: []);
  }

  /// `Monday`
  String get dayMonday {
    return Intl.message('Monday', name: 'dayMonday', desc: '', args: []);
  }

  /// `Tuesday`
  String get dayTuesday {
    return Intl.message('Tuesday', name: 'dayTuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get dayWednesday {
    return Intl.message('Wednesday', name: 'dayWednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get dayThursday {
    return Intl.message('Thursday', name: 'dayThursday', desc: '', args: []);
  }

  /// `Friday`
  String get dayFriday {
    return Intl.message('Friday', name: 'dayFriday', desc: '', args: []);
  }

  /// `This account type is coming soon`
  String get userTypeComingSoon {
    return Intl.message(
      'This account type is coming soon',
      name: 'userTypeComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to WeCare`
  String get userTypeWelcomeTitle {
    return Intl.message(
      'Welcome to WeCare',
      name: 'userTypeWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose your account type to continue`
  String get userTypeWelcomeSubtitle {
    return Intl.message(
      'Choose your account type to continue',
      name: 'userTypeWelcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Patient`
  String get userTypePatientTitle {
    return Intl.message(
      'Patient',
      name: 'userTypePatientTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage your medical records and follow up on your health better`
  String get userTypePatientDescription {
    return Intl.message(
      'Manage your medical records and follow up on your health better',
      name: 'userTypePatientDescription',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get userTypeDoctorTitle {
    return Intl.message(
      'Doctor',
      name: 'userTypeDoctorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage your appointments and patient files easily and securely`
  String get userTypeDoctorDescription {
    return Intl.message(
      'Manage your appointments and patient files easily and securely',
      name: 'userTypeDoctorDescription',
      desc: '',
      args: [],
    );
  }

  /// `Medical Service Provider`
  String get userTypeProviderTitle {
    return Intl.message(
      'Medical Service Provider',
      name: 'userTypeProviderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage your services such as speech therapy, physiotherapy, nursing, radiology and lab tests`
  String get userTypeProviderDescription {
    return Intl.message(
      'Manage your services such as speech therapy, physiotherapy, nursing, radiology and lab tests',
      name: 'userTypeProviderDescription',
      desc: '',
      args: [],
    );
  }

  /// `Together towards better healthcare`
  String get userTypeFooter {
    return Intl.message(
      'Together towards better healthcare',
      name: 'userTypeFooter',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
