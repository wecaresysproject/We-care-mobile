import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/user_type/Presentation/views/widgets/user_type_card.dart';

/// Entry point for logged-out users: the chosen account type drives the
/// shared auth flow (sent as `userType` on every auth call) and decides which
/// home opens after login.
class UserTypesView extends StatelessWidget {
  const UserTypesView({super.key});

  void _continueAs(BuildContext context, UserTypes userType) {
    //* Saved to disk only once the auth token is (see saveCurrentUserType).
    currentUserType = userType;
    context.pushNamed(Routes.loginView);
  }

  void _showComingSoon(BuildContext context) {
    context.showSnackBar(
      message: context.translate.userTypeComingSoon,
      backgroundColor: AppColorsManager.mainDarkBlue,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.userTypeScaffoldBackground,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              "assets/svgs/user_type_bottom_wave.svg",
              height: 90.h,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        verticalSpacing(36),
                        const _WeCareLogo(),
                        verticalSpacing(32),
                        Text(
                          context.translate.userTypeWelcomeTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColorsManager.userTypeHeadingColor,
                            height: 1.4,
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          context.translate.userTypeWelcomeSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColorsManager.userTypeSubtitleColor,
                          ),
                        ),
                        verticalSpacing(32),
                        UserTypeCard(
                          title: context.translate.userTypePatientTitle,
                          description:
                              context.translate.userTypePatientDescription,
                          illustrationPath: "assets/svgs/user_type_patient.svg",
                          gradientColors: const [
                            AppColorsManager.userTypePatientCardStart,
                            AppColorsManager.userTypePatientCardEnd,
                          ],
                          borderColor:
                              AppColorsManager.userTypePatientCardBorder,
                          arrowBackgroundColor:
                              AppColorsManager.userTypePatientArrowBackground,
                          onTap: () => _continueAs(context, UserTypes.patient),
                        ),
                        verticalSpacing(16),
                        UserTypeCard(
                          title: context.translate.userTypeDoctorTitle,
                          description:
                              context.translate.userTypeDoctorDescription,
                          illustrationPath: "assets/svgs/user_type_doctor.svg",
                          gradientColors: const [
                            AppColorsManager.userTypeDoctorCardStart,
                            AppColorsManager.userTypeDoctorCardEnd,
                          ],
                          borderColor:
                              AppColorsManager.userTypeDoctorCardBorder,
                          arrowBackgroundColor:
                              AppColorsManager.userTypeDoctorArrowBackground,
                          onTap: () => _continueAs(context, UserTypes.doctor),
                        ),
                        verticalSpacing(16),
                        UserTypeCard(
                          title: context.translate.userTypeProviderTitle,
                          description:
                              context.translate.userTypeProviderDescription,
                          illustrationPath:
                              "assets/svgs/user_type_provider.svg",
                          titleColor:
                              AppColorsManager.userTypeProviderTitleColor,
                          gradientColors: const [
                            AppColorsManager.userTypeProviderCardStart,
                            AppColorsManager.userTypeProviderCardEnd,
                          ],
                          borderColor:
                              AppColorsManager.userTypeProviderCardBorder,
                          arrowBackgroundColor:
                              AppColorsManager.userTypeProviderArrowBackground,
                          onTap: () => _showComingSoon(context),
                        ),
                        const Spacer(),
                        verticalSpacing(24),
                        const _Footer(),
                        verticalSpacing(36),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeCareLogo extends StatelessWidget {
  const _WeCareLogo();

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: AppStrings.rubikFontFamily,
      fontSize: 26.sp,
      letterSpacing: 0.2,
      height: 1.1,
    );

    return Column(
      children: [
        SvgPicture.asset(
          "assets/svgs/user_type_logo.svg",
          width: 74.w,
        ),
        verticalSpacing(6),
        //* Brand name is Latin in both locales, so keep it LTR.
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "WECARE ",
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColorsManager.userTypeHeadingColor,
                ),
              ),
              TextSpan(
                text: "SYS",
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColorsManager.userTypeLogoSysColor,
                ),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: 34.w,
      height: 1,
      color: AppColorsManager.userTypeFooterLineColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        line,
        horizontalSpacing(12),
        Text(
          context.translate.userTypeFooter,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColorsManager.userTypeFooterColor,
          ),
        ),
        horizontalSpacing(12),
        line,
      ],
    );
  }
}
