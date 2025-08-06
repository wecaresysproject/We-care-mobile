import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/custom_image_with_text_medical_illnesses_module_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';

class MedicalIllnessOrMindUmbrellaView extends StatelessWidget {
  const MedicalIllnessOrMindUmbrellaView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) => getIt<MentalIllnessDataViewCubit>(),
      //!..getIsUmbrellaMentalIllnessButtonActivated(),
      child:
          BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomAppBarWidget(
                        haveBackArrow: true,
                      ),
                      verticalSpacing(113),
                      if (state.requestStatus == RequestStatus.loading) ...[
                        SizedBox(
                          height: context.screenHeight * .25,
                        ),
                        const CircularProgressIndicator(),
                      ] else ...[
                        CustomImageWithTextMedicalIllnessModuleWidget(
                          onTap: () async {
                            await context
                                .pushNamed(Routes.mentalIllnessesRecordsView);
                          },
                          imagePath: "assets/images/medical_illnesses_icon.png",
                          text: "الأمراض النفسية",
                          textStyle:
                              AppTextStyles.font22WhiteWeight600.copyWith(
                            fontSize: 24.sp,
                          ),
                          isTextFirst: false,
                        ),
                        verticalSpacing(88),
                        CustomImageWithTextMedicalIllnessModuleWidget(
                          onTap: () async {
                            await context
                                .pushNamed(Routes.mentalIlnesssUmbrellaView);
                          },
                          imagePath:
                              "assets/images/medical_illnesses_umbrella_icon.png", // assets/images/un_activated_umbrella.png
                          text: "المظلة النفسية",
                          textStyle:
                              AppTextStyles.font22WhiteWeight600.copyWith(
                            fontSize: 24.sp,
                          ),
                          containerColor:
                              state.isUmbrellaMentalIllnessButtonActivated
                                  ? AppColorsManager.mainDarkBlue
                                  : null,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
