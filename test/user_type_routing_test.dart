import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/routes.dart';

/// The account type picked on the user-type screen decides which home a
/// logged-in user lands on after login, OTP verification and app restart.
void main() {
  tearDown(() => currentUserType = UserTypes.patient);

  test('patients land on the patient bottom nav bar', () {
    currentUserType = UserTypes.patient;

    expect(homeRouteForCurrentUser, Routes.bottomNavBar);
  });

  test('doctors land on the doctor home shell', () {
    currentUserType = UserTypes.doctor;

    expect(homeRouteForCurrentUser, Routes.doctorHomeView);
  });
}
