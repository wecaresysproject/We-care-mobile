import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_follow_up_report_model.dart';
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
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
                  options: [],
                ), // state.yearsFilter ?? []),
              ],
              onApply: (selectedOption) {
                // context.read<DentalViewCubit>().getFilteredToothDocuments(
                //       year: selectedOption['السنة'] as int?,
                //       procedureType:
                //           selectedOption["نوع الاجراء الطبي"] as String?,
                //       toothNumber: selectedOption['رقم السن'] as String?,
                //     );
              },
            ),
            verticalSpacing(16),
            MedicalItemGridView(
              items: dummyPrescriptions,
              // isExpendingTileTitle: true,
              onTap: (id) {
                // يمكن عرض SnackBar أو التنقل لصفحة التفاصيل
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم الضغط على العنصر برقم: $id')),
                );
              },
              titleBuilder: (item) => item.title,
              infoRowBuilder: (item) => [
                {'title': 'التاريخ:', 'value': item.date},
                {'title': 'نوع التقرير:', 'value': item.reportType},
              ],
            ),
            verticalSpacing(16),
            MentalIlnessFollowUpFooterRow(),
          ],
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
