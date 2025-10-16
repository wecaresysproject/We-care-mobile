import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';

class OrganAffectedDetailsView extends StatelessWidget {
  final String organName;

  const OrganAffectedDetailsView({
    super.key,
    required this.organName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NutrationViewCubit>()
        ..getOrganNutritionalEffects(
          organName: organName,
        ),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: BlocBuilder<NutrationViewCubit, NutrationViewState>(
          builder: (context, state) {
            final effects = state.organNutritionalEffectsData?.effects ?? [];

            if (state.requestStatus == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (effects.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد بيانات متاحة لهذا العضو حاليًا.",
                  style: AppTextStyles.font22MainBlueWeight700,
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: "التأثير على $organName",
                    showActionButtons: false,
                    fontSize: 14,
                  ),
                  verticalSpacing(10),
                  ...effects.map((effect) => HeaderSectionWithContent(
                        text: effect.elementName,
                        isHighRisk: effect.impactType.toLowerCase() == "high",
                        content: effect.description.trim(),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeaderSectionWithContent extends StatelessWidget {
  final String text;
  final String content;
  final bool isHighRisk;

  const HeaderSectionWithContent({
    super.key,
    required this.text,
    required this.isHighRisk,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5998CD),
                  Color(0xFF03508F),
                  Color(0xff2B2B2B),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 25.h,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: isHighRisk
                        ? AppColorsManager.criticalRisk
                        : AppColorsManager.doneColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHighRisk ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      AutoSizeText(
                        isHighRisk ? "التأثير بالارتفاع" : "التأثير بالانخفاض",
                        style: AppTextStyles.font14whiteWeight600,
                        minFontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpacing(10),
          Text(
            content,
            style: AppTextStyles.font12blackWeight400.copyWith(fontSize: 16.sp),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
