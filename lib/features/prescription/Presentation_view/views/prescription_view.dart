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
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
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
        return MedicalItemGridView(
          items: state.userPrescriptions,
          onTap: (id) async {
            final result = await context
                .pushNamed(Routes.prescriptionDetailsView, arguments: {
              'id': id,
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
          titleBuilder: (item) =>
              item.doctorName, // Extract the title dynamically
          infoRowBuilder: (item) => [
            {"title": "التخصص:", "value": item.doctorSpecialty},
            {"title": "التاريخ:", "value": item.preDescriptionDate},
            {"title": "المرض:", "value": item.disease},
          ],
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
            print("Selected Filters: $selectedFilters");
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
