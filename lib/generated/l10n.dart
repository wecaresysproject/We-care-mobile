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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `Medical Record`
  String get medical_recordTab {
    return Intl.message(
      'Medical Record',
      name: 'medical_recordTab',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get doctorsTab {
    return Intl.message('Doctors', name: 'doctorsTab', desc: '', args: []);
  }

  /// `Drug Interaction`
  String get pharmaInteractionTab {
    return Intl.message(
      'Drug Interaction',
      name: 'pharmaInteractionTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTab {
    return Intl.message('Settings', name: 'settingsTab', desc: '', args: []);
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
