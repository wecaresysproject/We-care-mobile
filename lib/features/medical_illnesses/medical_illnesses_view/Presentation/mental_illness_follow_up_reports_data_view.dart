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
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_follow_up_report_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

//! looks like PrescriptionView file
class MentalIllnessFollowUpReports extends StatelessWidget {
  MentalIllnessFollowUpReports({super.key});
  final dummyPrescriptions = [
    MentalIllnessFollowUpReportModel(
      title: 'الأفكار السلبية والانتحارية',
      date: '22 /10 / 2024',
      reportType: 'مراقبة',
      id: '1',
    ),
    MentalIllnessFollowUpReportModel(
      title: 'الأفكار السلبية والانتحارية',
      date: '22 /10 / 2024',
      reportType: 'خطر جزئى',
      id: '2',
    ),
    MentalIllnessFollowUpReportModel(
      title: 'الأفكار السلبية والانتحارية',
      date: '22 /10 / 2024',
      reportType: 'طبيعى',
      id: '3',
    ),
    MentalIllnessFollowUpReportModel(
      date: '22 /10 / 2024',
      title: 'الأفكار السلبية والانتحارية',
      reportType: 'خطر مؤكد',
      id: '5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) => getIt<
          MentalIllnessDataViewCubit>(), //..initialRequestsForFollowUpView(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body:
            BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
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
                  if (state.requestStatus == RequestStatus.loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (state
                      .followUpRecords.isNotEmpty) //!chnage to  isEmpty
                    Center(
                      child: Text(
                        "لا يوجد بيانات",
                        style: AppTextStyles.font22MainBlueWeight700,
                      ),
                    )
                  else ...[
                    MedicalItemGridView(
                      items: dummyPrescriptions,
                      // isExpendingTileTitle: true,
                      onTap: (id) async {
                        // يمكن عرض SnackBar أو التنقل لصفحة التفاصيل
                        final result = await context.pushNamed(
                          Routes.mentalIllnessFollowUpReportDetailsView,
                          arguments: {
                            'docId': id,
                          },
                        );
                        if (result != null &&
                            result as bool &&
                            context.mounted) {
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
                        {'title': 'نوع التقرير:', 'value': item.reportType},
                      ],
                    ),
                  ],
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Static "Load More" Button
            ElevatedButton(
              onPressed: () {
                // You can handle static load action here
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(158.w, 32.h),
                backgroundColor: AppColorsManager.mainDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "عرض المزيد",
                    style: AppTextStyles.font14whiteWeight600,
                  ),
                  horizontalSpacing(8.w),
                  Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),

            // Static Items Count Badge
            Container(
              width: 47.w,
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(
                  color: const Color(0xFF014C8A),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  "+5", // Static value
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
