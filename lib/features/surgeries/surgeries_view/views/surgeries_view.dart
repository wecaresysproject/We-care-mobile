import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgery_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class SurgeriesView extends StatelessWidget {
  const SurgeriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SurgeriesViewCubit>(
      create: (context) => getIt<SurgeriesViewCubit>()
        ..getUserSurgeriesList()
        ..getSurgeriesFilters(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
                buildWhen: (previous, current) =>
                    previous.yearsFilter != current.yearsFilter ||
                    previous.surgeryNameFilter != current.surgeryNameFilter,
                builder: (context, state) {
                  return DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                          title: 'السنة',
                          options: state.yearsFilter,
                          isYearFilter: true),
                      FilterConfig(
                        title: 'اسم العملية',
                        options: state.surgeryNameFilter,
                      ),
                    ],
                    onApply: (selectedFilters) {
                      AppLogger.debug("Selected Filters: $selectedFilters");
                      if (selectedFilters['السنة'] == null) {
                        BlocProvider.of<SurgeriesViewCubit>(context)
                            .getFilteredSurgeryList(
                                surgeryName: selectedFilters['اسم العملية']);
                      }
                      BlocProvider.of<SurgeriesViewCubit>(context)
                          .getFilteredSurgeryList(
                              year: selectedFilters['السنة'],
                              surgeryName: selectedFilters['اسم العملية']);
                    },
                  );
                },
              ),
              verticalSpacing(16),
              BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
                buildWhen: (previous, current) =>
                    previous.userSurgeries != current.userSurgeries,
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Expanded(
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (state.userSurgeries.isEmpty &&
                      state.requestStatus == RequestStatus.success) {
                    return Expanded(
                      child: Center(
                          child: Text(
                        "لا يوجد بيانات",
                        style: AppTextStyles.font22MainBlueWeight700,
                      )),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.userSurgeries.length,
                      itemBuilder: (context, index) {
                        final doc = state.userSurgeries[index];
                        return SurgeryCardITem(
                          surgery: doc,
                          onArrowTap: () async {
                            final result = await Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return SurgeryDetailsView(
                                documentId: doc.id,
                              );
                            }));
                            if (context.mounted) {
                              await context
                                  .read<SurgeriesViewCubit>()
                                  .getUserSurgeriesList();
                              if (!context.mounted) return;
                              await context
                                  .read<SurgeriesViewCubit>()
                                  .getSurgeriesFilters();
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              verticalSpacing(16),
              SurgeriesFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class SurgeriesFooterRow extends StatelessWidget {
  const SurgeriesFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
      builder: (context, state) {
        final cubit = context.read<SurgeriesViewCubit>();
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
                      : () => cubit.loadMoreMedicines(),
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

class SurgeryCardITem extends StatelessWidget {
  final SurgeryModel surgery;
  final VoidCallback? onArrowTap;

  const SurgeryCardITem({
    super.key,
    required this.surgery,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onArrowTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
            )
          ],
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Column(
          children: [
            /// Header with title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                    width: 1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                surgery.surgeryName,
                style: AppTextStyles.font14BlueWeight700
                    .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                /// Content Column - Right side
                Expanded(
                  child: Column(
                    children: [
                      /// Date
                      Row(
                        children: [
                          Text(
                            'التاريخ :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            surgery.surgeryDate,
                            style: AppTextStyles.font14blackWeight400
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Duration
                      Row(
                        children: [
                          Text(
                            'منطقة العملية :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            surgery.subSurgeryRegion,
                            style: AppTextStyles.font14blackWeight400
                                .copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// Severity
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالة العملية:',
                            style: AppTextStyles.font14BlueWeight700.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // 🔥Expanded علشان ياخد باقي المساحة
                          Expanded(
                            child: Text(
                              surgery.surgeryStatus,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontSize: 14.sp,
                              ),
                              maxLines: 1, // ← أو خليه null لو عايز يلف براحتو
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          Text(
                            'ملاحظات:',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              surgery.additionalNotes,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                /// Arrow Icon
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: onArrowTap,
                    icon: Image.asset(
                      'assets/images/side_arrow_filled.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
