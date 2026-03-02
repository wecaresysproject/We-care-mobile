import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
import 'package:we_care/features/allergy/allergy_view/views/widgets/allergy_horizental_card_widget.dart';

class AllergyFooterRow extends StatelessWidget {
  const AllergyFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllergyViewCubit, AllergyViewState>(
      builder: (context, state) {
        final cubit = context.read<AllergyViewCubit>();
        return Column(
          children: [
            // Loading indicator that appears above the footer when loading more items
            if (state.isLoadingMore)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: LinearProgressIndicator(
                  minHeight: 2.h,
                  color: AppColorsManager.mainDarkBlue,
                  backgroundColor:
                      AppColorsManager.mainDarkBlue.withOpacity(0.1),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Load More Button
                ElevatedButton(
                  onPressed: state.isLoadingMore || !cubit.hasMore
                      ? null
                      : () => cubit.loadMoreAllergyDiseases(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(158.w, 32.h),
                    backgroundColor: state.isLoadingMore || !cubit.hasMore
                        ? Colors.grey
                        : AppColorsManager.mainDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: state.isLoadingMore
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Text(
                              "جاري التحميل...",
                              style: AppTextStyles.font14whiteWeight600,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "عرض المزيد",
                              style:
                                  AppTextStyles.font14whiteWeight600.copyWith(
                                color: !cubit.hasMore
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            horizontalSpacing(8.w),
                            Icon(
                              Icons.expand_more,
                              color:
                                  !cubit.hasMore ? Colors.black : Colors.white,
                              size: 20.sp,
                            ),
                          ],
                        ),
                ),

                // Items Count Badge
                !cubit.hasMore
                    ? SizedBox.shrink()
                    : Container(
                        width: 47.w,
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.r),
                          border: Border.all(
                            color: Color(0xFF014C8A),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "+${cubit.pageSize}",
                            style:
                                AppTextStyles.font16DarkGreyWeight400.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AllergyDataView extends StatelessWidget {
  const AllergyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllergyViewCubit>(
      create: (context) => getIt<AllergyViewCubit>()..init(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Column(
            children: [
              BlocBuilder<AllergyViewCubit, AllergyViewState>(
                builder: (context, state) {
                  final guidance = state.moduleGuidanceData;
                  final hasVideo = guidance?.videoLink?.isNotEmpty == true;
                  final hasText =
                      guidance?.moduleGuidanceText?.isNotEmpty == true;

                  return SharedAppBar(
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color: hasVideo
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: hasVideo
                            ? () => launchYouTubeVideo(guidance!.videoLink)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color: hasText
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: hasText
                            ? () {
                                ModuleGuidanceAlertDialog.show(
                                  context,
                                  title: "الحساسية",
                                  description: guidance!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<AllergyViewCubit, AllergyViewState>(
                  buildWhen: (previous, current) =>
                      previous.userAllergies != current.userAllergies,
                  builder: (context, state) {
                    if (state.requestStatus == RequestStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.userAllergies.isEmpty &&
                        state.requestStatus == RequestStatus.success) {
                      return Center(
                        child: Text(
                          "لا يوجد بيانات",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.userAllergies.length,
                      separatorBuilder: (_, __) => verticalSpacing(12),
                      itemBuilder: (context, index) {
                        final item = state.userAllergies[index];
                        return AllergyHorizentalCardWidget(
                          item: item,
                          onArrowTap: () async {
                            await context.pushNamed(
                              Routes.allergyDocDetailsView,
                              arguments: {
                                'docId': item.id,
                              },
                            );
                            if (context.mounted) {
                              await context
                                  .read<AllergyViewCubit>()
                                  .getAllergyDiseases();
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              verticalSpacing(16),
              AllergyFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}
