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
import 'package:we_care/features/chronic_disease/chronic_disease_view/logic/chronic_disease_view_cubit.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/views/widgets/chronic_disease_item_card_widget.dart';

class ChronicDiseaseView extends StatelessWidget {
  const ChronicDiseaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChronicDiseaseViewCubit>(
      create: (context) => getIt<ChronicDiseaseViewCubit>()..init(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Column(
            children: [
              BlocBuilder<ChronicDiseaseViewCubit, ChronicDiseaseViewState>(
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
                                  title: "الأمراض المزمنة",
                                  description: guidance!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                },
              ),
              ChronicDiseaseViewListBuilder(),
              verticalSpacing(16),
              ChronicDiseaseViewFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChronicDiseaseViewListBuilder extends StatelessWidget {
  const ChronicDiseaseViewListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChronicDiseaseViewCubit, ChronicDiseaseViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading ||
            state.requestStatus == RequestStatus.initial) {
          return Expanded(
              child: const Center(child: CircularProgressIndicator()));
        } else if (state.userChronicDisease.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "لا يوجد بيانات",
                style: AppTextStyles.font22MainBlueWeight700,
              ),
            ),
          );
        }
        final cubit = context.read<ChronicDiseaseViewCubit>();
        return Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.userChronicDisease.length,
            itemBuilder: (context, index) {
              final doc = state.userChronicDisease[index];
              return ChronicDiseaseItemCardHorizontalWidget(
                item: doc,
                onArrowTap: () async {
                  await context.pushNamed(
                    Routes.chronicDiseaseDetailsView,
                    arguments: {
                      'docId': doc.id,
                    },
                  );
                  if (context.mounted) {
                    await cubit.getAllChronicDiseasesDocuments();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ChronicDiseaseViewFooterRow extends StatelessWidget {
  const ChronicDiseaseViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChronicDiseaseViewCubit, ChronicDiseaseViewState>(
      builder: (context, state) {
        final cubit = context.read<ChronicDiseaseViewCubit>();
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
                      : () => cubit.loadMoreChronicDiseases(),
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
              ],
            ),
          ],
        );
      },
    );
  }
}
