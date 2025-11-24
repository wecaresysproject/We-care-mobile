import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class PrescriptionView extends StatelessWidget {
  const PrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrescriptionViewCubit>(
      create: (context) => getIt<PrescriptionViewCubit>()
        ..getPrescriptionFilters()
        ..getUserPrescriptionList(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              PrescriptionsViewFilersRow(),
              verticalSpacing(16),
              PrescriptionViewListBuilder(),
              verticalSpacing(16),
              PrescriptionViewFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionViewListBuilder extends StatelessWidget {
  const PrescriptionViewListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionViewCubit, PrescriptionViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading ||
            state.requestStatus == RequestStatus.initial) {
          return Expanded(
              child: const Center(child: CircularProgressIndicator()));
        } else if (state.userPrescriptions.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "لا يوجد بيانات",
                style: AppTextStyles.font22MainBlueWeight700,
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.userPrescriptions.length,
            itemBuilder: (context, index) {
              final doc = state.userPrescriptions[index];
              return PrescriptionCardITem(
                prescription: doc,
                onArrowTap: () async {
                  final result = await context
                      .pushNamed(Routes.prescriptionDetailsView, arguments: {
                    'id': doc.id,
                  });
                  if (result != null && result as bool && context.mounted) {
                    await context
                        .read<PrescriptionViewCubit>()
                        .getUserPrescriptionList();
                    await context
                        .read<PrescriptionViewCubit>()
                        .getPrescriptionFilters();
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

class PrescriptionsViewFilersRow extends StatelessWidget {
  const PrescriptionsViewFilersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionViewCubit, PrescriptionViewState>(
      buildWhen: (previous, current) {
        return previous.yearsFilter != current.yearsFilter ||
            previous.specificationsFilter != current.specificationsFilter ||
            previous.doctorNameFilter != current.doctorNameFilter;
      },
      builder: (context, state) {
        return DataViewFiltersRow(
          filters: [
            FilterConfig(
                title: 'السنة', options: state.yearsFilter, isYearFilter: true),
            FilterConfig(
              title: 'التخصص',
              options: state.specificationsFilter,
            ),
            FilterConfig(
              title: 'الطبيب',
              options: state.doctorNameFilter,
            ),
          ],
          onApply: (selectedFilters) async {
            AppLogger.debug("Selected Filters: $selectedFilters");
            await context
                .read<PrescriptionViewCubit>()
                .getFilteredPrescriptionList(
                    year: selectedFilters['السنة'],
                    specification: selectedFilters['التخصص'],
                    doctorName: selectedFilters['الطبيب']);
          },
        );
      },
    );
  }
}

class PrescriptionViewFooterRow extends StatelessWidget {
  const PrescriptionViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionViewCubit, PrescriptionViewState>(
      builder: (context, state) {
        final cubit = context.read<PrescriptionViewCubit>();
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

                // // Items Count Badge
                // !cubit.hasMore
                //     ? SizedBox.shrink()
                //     : Container(
                //         width: 47.w,
                //         height: 28.h,
                //         padding: EdgeInsets.symmetric(horizontal: 6.w),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(11.r),
                //           border: Border.all(
                //             color: Color(0xFF014C8A),
                //             width: 2,
                //           ),
                //         ),
                //         child: Center(
                //           child: Text(
                //             "+${cubit.pageSize}",
                //             style:
                //                 AppTextStyles.font16DarkGreyWeight400.copyWith(
                //               color: AppColorsManager.mainDarkBlue,
                //             ),
                //           ),
                //         ),
                //       ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PrescriptionCardITem extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback? onArrowTap;

  const PrescriptionCardITem({
    super.key,
    required this.prescription,
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
                prescription.doctorName,
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
                            'التخصص :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            prescription.doctorSpecialty,
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
                            'التاريخ :',
                            style: AppTextStyles.font14BlueWeight700
                                .copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            prescription.preDescriptionDate,
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
                            'المرض :',
                            style: AppTextStyles.font14BlueWeight700.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              prescription.disease,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
