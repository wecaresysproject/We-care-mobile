import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

import 'widgets/mental_illness_grid_view_widget.dart';

class MentalIllnessFollowUpReports extends StatelessWidget {
  const MentalIllnessFollowUpReports({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) =>
          getIt<MentalIllnessDataViewCubit>()..initialRequestsForFollowUpView(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body:
            BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColorsManager.mainDarkBlue,
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  ViewAppBar(),
                  DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                        title: "السنة",
                        options: state.yearsFilter,
                      ),
                    ],
                    onApply: (selectedOption) async {
                      await context
                          .read<MentalIllnessDataViewCubit>()
                          .getFilteredFollowUpReports(
                            year: selectedOption['السنة'],
                          );
                    },
                  ),
                  verticalSpacing(16),
                  MentalIllnessGridViewWidget(
                    items: state.followUpRecords,
                    onTap: (id) async {
                      final result = await context.pushNamed(
                        Routes.mentalIllnessFollowUpReportDetailsView,
                        arguments: {'docId': id},
                      );
                      if (result != null && result as bool && context.mounted) {
                        await context
                            .read<MentalIllnessDataViewCubit>()
                            .getAllFollowUpReportsRecords();
                        await context
                            .read<MentalIllnessDataViewCubit>()
                            .getFollowUpReportsAvailableYears();
                      }
                    },
                    titleBuilder: (item) => item.title,
                    infoRowBuilder: (item) => [
                      {'title': 'التاريخ:', 'value': item.date},
                      {
                        'title': 'نوع التقرير:',
                        'value': (item.riskLevel as RiskLevel).displayName
                      },
                    ],
                  ),
                  verticalSpacing(16),
                  MentalIlnessFollowUpFooterRow(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MentalIlnessFollowUpFooterRow extends StatelessWidget {
  const MentalIlnessFollowUpFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
      builder: (context, state) {
        final cubit = context.read<MentalIllnessDataViewCubit>();
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
                      : () => cubit.loadMoreFollowUpRecords(),
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
