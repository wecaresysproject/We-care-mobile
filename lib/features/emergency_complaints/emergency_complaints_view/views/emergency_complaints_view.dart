import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaints_view_cubit.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class EmergencyComplaintsView extends StatelessWidget {
  const EmergencyComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmergencyComplaintsViewCubit>()
        ..getUserEmergencyComplaintsList()
        ..getFilters(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              EmergencyComplaintsFiltersRow(),
              verticalSpacing(16),
              EmergencyComplaintsViewListBuilder(),
              verticalSpacing(16),
              EmergencyComplaintsFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyComplaintsViewListBuilder extends StatelessWidget {
  const EmergencyComplaintsViewListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsViewCubit,
        EmergencyComplaintViewState>(
      builder: (context, state) {
        final cubit = context.read<EmergencyComplaintsViewCubit>();

        if (state.requestStatus == RequestStatus.loading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.emergencyComplaints.isEmpty &&
            state.requestStatus == RequestStatus.success) {
          return Expanded(
            child: Center(
                child: Text(
              "لا يوجد بيانات",
              style: AppTextStyles.font22MainBlueWeight700,
            )),
          );
        }
        return MedicalItemGridView(
          items: state.emergencyComplaints,
          onTap: (id) async {
            final result =
                await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return EmergencyComplaintsDetailsView(
                documentId: id,
              );
            }));
            if (context.mounted && result as bool && result == true) {
              await cubit.intialRequests();
            }
          },
          titleBuilder: (item) =>
              item.mainSymptoms.first.symptomsRegion.substring(2),
          isExpendingTileTitle: true,
          infoRowBuilder: (item) => [
            {"title": "التاريخ:", "value": item.date},
            {
              "title": "العرض الرئيسي:",
              "value": item.mainSymptoms.first.sypmptomsComplaintIssue
            },
          ],
        );
      },
    );
  }
}

class EmergencyComplaintsFiltersRow extends StatelessWidget {
  const EmergencyComplaintsFiltersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsViewCubit,
        EmergencyComplaintViewState>(
      buildWhen: (previous, current) =>
          previous.yearsFilter != current.yearsFilter ||
          previous.bodyPartFilter != current.bodyPartFilter,
      builder: (context, state) {
        return DataViewFiltersRow(
          filters: [
            FilterConfig(
                title: 'السنة', options: state.yearsFilter, isYearFilter: true),
            FilterConfig(
              title: 'مكان الشكوى',
              options: state.bodyPartFilter,
            ),
          ],
          onApply: (selectedFilters) async {
            print("Selected Filters: $selectedFilters");
            await context
                .read<EmergencyComplaintsViewCubit>()
                .getFilteredEmergencyComplaintList(
                    year: selectedFilters['السنة'],
                    placeOfComplaint: selectedFilters['مكان الشكوى']);
          },
        );
      },
    );
  }
}

class XRayDataViewFooterRow extends StatelessWidget {
  const XRayDataViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(158, 32),
            backgroundColor: AppColorsManager.mainDarkBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.zero, // No default padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "عرض المزيد",
                style: AppTextStyles.font14whiteWeight600,
              ),
              horizontalSpacing(8),
              Icon(
                Icons.expand_more,
                color: Colors.white,
                weight: 100,
                size: 24.sp,
              ),
            ],
          ),
        ),
        Container(
          width: 47.w,
          height: 28.h,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(color: Color(0xFF014C8A), width: 2),
          ),
          child: Center(
            child: Text(
              "+10",
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmergencyComplaintsFooterRow extends StatelessWidget {
  const EmergencyComplaintsFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsViewCubit,
        EmergencyComplaintViewState>(
      builder: (context, state) {
        final cubit = context.read<EmergencyComplaintsViewCubit>();
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
