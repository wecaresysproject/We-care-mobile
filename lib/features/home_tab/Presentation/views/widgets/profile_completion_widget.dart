import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/ essential_info_view_cubit.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';

class ProfileCompletionWidget extends StatelessWidget {
  const ProfileCompletionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EssentialInfoViewCubit>()..init(),
      child: BlocBuilder<EssentialInfoViewCubit, EssentialInfoViewState>(
        builder: (context, state) {
          final color =
              _getColorForPercentage(state.profileCompletionPercentage);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 5.w,
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: CircularProgressIndicator(
                      value: state.profileCompletionPercentage / 100,
                      strokeWidth: 5.w,
                      color: color,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    "${state.profileCompletionPercentage.toInt()}%",
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeightHelper.bold,
                      fontSize: 12.sp,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ),
                ],
              ),
              verticalSpacing(8),
              Text(
                'اكتمال البيانات',
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  fontWeight: FontWeightHelper.bold,
                  fontSize: 10.sp,
                  color: AppColorsManager.mainDarkBlue  ,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage < 40) {
      return const Color(0xFFE53935); // Light Red
    } else if (percentage < 65) {
      return const Color(0xFFFB8C00); // Light Orange
    } else if (percentage < 85) {
      return const Color(0xFFFDD835); // Light Yellow
    } else {
      return const Color(0xFF43A047); // Light Green
    }
  }
}
