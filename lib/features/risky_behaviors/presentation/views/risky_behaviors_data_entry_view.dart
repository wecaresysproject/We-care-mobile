import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/logic/cubit/risky_behaviors_cubit.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/Presentation/views/widgets/risky_behaviors_form_fields_widget.dart';

class RiskyBehaviorsDataEntryView extends StatelessWidget {
  const RiskyBehaviorsDataEntryView({
    super.key,
    this.existingData,
  });

  final RiskyBehaviorDetailsModel? existingData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RiskyBehaviorsCubit>(
      create: (context) {
        final cubit = getIt<RiskyBehaviorsCubit>();
        if (existingData != null) {
          cubit.loadExistingData(existingData!);
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWithCenteredTitleWithGuidance(
                title: "السلوكيات الخطرة",
                onbackArrowPress: () {},
              ),
              // AppBarWithImageAndActionButtons(
              //             haveBackArrow: true,
              //             trailingActions: [
              //               CircleIconButton(
              //                 icon: Icons.play_arrow,
              //                 color: state.moduleGuidanceData?.videoLink
              //                             ?.isNotEmpty ==
              //                         true
              //                     ? AppColorsManager.mainDarkBlue
              //                     : Colors.grey,
              //                 onTap: state.moduleGuidanceData?.videoLink
              //                             ?.isNotEmpty ==
              //                         true
              //                     ? () => launchYouTubeVideo(
              //                         state.moduleGuidanceData!.videoLink)
              //                     : null,
              //               ),
              //               SizedBox(width: 8.w),
              //               CircleIconButton(
              //                 icon: Icons.menu_book_outlined,
              //                 color: state.moduleGuidanceData
              //                             ?.moduleGuidanceText?.isNotEmpty ==
              //                         true
              //                     ? AppColorsManager.mainDarkBlue
              //                     : Colors.grey,
              //                 onTap: state.moduleGuidanceData
              //                             ?.moduleGuidanceText?.isNotEmpty ==
              //                         true
              //                     ? () {
              //                         ModuleGuidanceAlertDialog.show(
              //                           context,
              //                           title: "الحساسية",
              //                           description: state.moduleGuidanceData!
              //                               .moduleGuidanceText!,
              //                         );
              //                       }
              //                     : null,
              //               ),
              //             ],
              //           );
              verticalSpacing(24),
              const RiskyBehaviorsFormFieldsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
