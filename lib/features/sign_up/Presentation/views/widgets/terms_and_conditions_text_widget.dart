import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

import '../../../../../core/global/Helpers/bottom_sheet_child.dart';
import '../../../../../core/global/Helpers/extensions.dart';
import '../../../../../core/global/Helpers/font_weight_helper.dart';
import '../../../../../core/global/theming/app_text_styles.dart';
import '../../../../../core/global/theming/color_manager.dart';
import '../../../logic/sign_up_cubit.dart';

class TermsAndConditionsTextWidget extends StatelessWidget {
  final bool isAccepted;
  const TermsAndConditionsTextWidget({
    super.key,
    required this.isAccepted,
    required this.onAccepted,
  });
  final Function(bool) onAccepted;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            onAccepted(!isAccepted);
          },
          child: Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: isAccepted
                  ? AppColorsManager.mainDarkBlue
                  : Colors.transparent,
              border: Border.all(
                color: AppColorsManager.mainDarkBlue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Opacity(
              opacity: isAccepted ? 1 : 0,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 15.r,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 7),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.translate.by_creating_account_you_agree_to,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          builder: (context) => BlocProvider.value(
                            value: getIt<SignUpCubit>()
                              ..getTermsAndConditions(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: context.screenHeight * 0.7,
                              ),
                              child: const TermsAndConditionView(),
                            ),
                          ),
                        );
                      },
                    text: context.translate.conditionsOFUse,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontSize: 12.sp,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),
                ],
                style: AppTextStyles.font16DarkGreyWeight400,
              ),
            ),
          ),
        )
      ],
    ).paddingSymmetricHorizontal(20);
  }
}

class TermsAndConditionView extends StatelessWidget {
  const TermsAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        if (state.termsAndConditionsStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.termsAndConditionsStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.termsErrorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.font18blackWight500.copyWith(
                color: Colors.red,
              ),
            ),
          );
        } else if (state.termsAndConditionsStatus == RequestStatus.success &&
            state.termsAndConditions != null) {
          return BottomSheetChildWidget(
            title: context.translate.T_and_C,
            text: state.termsAndConditions!
                .map((e) => '• ${e.description}')
                .toList()
                .join('\n'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
